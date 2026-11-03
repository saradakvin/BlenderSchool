// ===================================================================
// Podatkovna baza: SQLite (sql.js), ki teče kar v brskalniku.
// Ob prvem obisku izvede db/database.sql, nato bazo shranjuje v
// IndexedDB, da napredek ostane tudi po zaprtju brskalnika.
// ===================================================================

const DB_KLJUC = 'blenderschool-db-v4';
let db = null;

// --- IndexedDB: shranjevanje celotne baze kot binarne datoteke ---
function odpriShrambo() {
    return new Promise((ok, napaka) => {
        const zahteva = indexedDB.open('blenderschool', 1);
        zahteva.onupgradeneeded = () => zahteva.result.createObjectStore('baza');
        zahteva.onsuccess = () => ok(zahteva.result);
        zahteva.onerror = () => napaka(zahteva.error);
    });
}

// Če brskalnik shranjevanja ne dovoli (npr. zasebno okno), baza deluje samo v pomnilniku.
async function preberiShranjeno() {
    try {
        const s = await odpriShrambo();
        return await new Promise((ok) => {
            const z = s.transaction('baza').objectStore('baza').get(DB_KLJUC);
            z.onsuccess = () => ok(z.result || null);
            z.onerror = () => ok(null);
        });
    } catch {
        return null;
    }
}

async function shraniBazo() {
    try {
        const s = await odpriShrambo();
        const podatki = db.export();
        await new Promise((ok) => {
            const t = s.transaction('baza', 'readwrite');
            t.objectStore('baza').put(podatki, DB_KLJUC);
            t.oncomplete = ok;
            t.onerror = ok;
        });
    } catch {
        // shranjevanje ni na voljo
    }
}

// Prijavljeni uporabnik (localStorage z rezervo v pomnilniku)
const seja = {
    rezerva: {},
    get(k) { try { return localStorage.getItem(k); } catch { return this.rezerva[k] ?? null; } },
    set(k, v) { try { localStorage.setItem(k, v); } catch { this.rezerva[k] = String(v); } },
    remove(k) { try { localStorage.removeItem(k); } catch { delete this.rezerva[k]; } },
};

// --- Zagon baze ---
async function zazeniBazo() {
    const SQL = await initSqlJs({ locateFile: (f) => 'js/vendor/' + f });
    const shranjeno = await preberiShranjeno();
    if (shranjeno) {
        db = new SQL.Database(shranjeno);
    } else {
        db = new SQL.Database();
        const skripta = await (await fetch('db/database.sql')).text();
        db.exec(skripta);
        await vstaviPrimerneObjave();
        await shraniBazo();
    }
    db.exec('PRAGMA foreign_keys = ON;');
}

async function ponastaviBazo() {
    try {
        const s = await odpriShrambo();
        await new Promise((ok) => {
            const t = s.transaction('baza', 'readwrite');
            t.objectStore('baza').delete(DB_KLJUC);
            t.oncomplete = ok;
        });
    } catch {
        // shranjevanje ni na voljo
    }
    seja.remove('uporabnik_id');
    location.hash = '#/';
    location.reload();
}

// --- Pomožne funkcije za SQL poizvedbe (pripravljeni stavki) ---

// Vrne vse vrstice kot seznam objektov
function poizvedba(sql, parametri = []) {
    const stmt = db.prepare(sql);
    stmt.bind(parametri);
    const vrstice = [];
    while (stmt.step()) vrstice.push(stmt.getAsObject());
    stmt.free();
    return vrstice;
}

// Vrne prvo vrstico ali null
function ena(sql, parametri = []) {
    return poizvedba(sql, parametri)[0] || null;
}

// Vrne eno vrednost (npr. COUNT(*))
function vrednost(sql, parametri = []) {
    const v = ena(sql, parametri);
    return v ? Object.values(v)[0] : null;
}

// INSERT / UPDATE / DELETE, nato shrani bazo
async function izvedi(sql, parametri = []) {
    db.run(sql, parametri);
    const id = vrednost('SELECT last_insert_rowid()');
    await shraniBazo();
    return id;
}

// --- Gesla: PBKDF2 z naključno soljo (Web Crypto API) ---
// Na strežniku (PHP različica) se uporablja bcrypt, v brskalniku PBKDF2.
function vHex(buf) {
    return [...new Uint8Array(buf)].map((b) => b.toString(16).padStart(2, '0')).join('');
}

async function izracunajHash(geslo, solHex) {
    const sol = new Uint8Array(solHex.match(/../g).map((h) => parseInt(h, 16)));
    const kljuc = await crypto.subtle.importKey('raw', new TextEncoder().encode(geslo), 'PBKDF2', false, ['deriveBits']);
    const bits = await crypto.subtle.deriveBits({ name: 'PBKDF2', salt: sol, iterations: 100000, hash: 'SHA-256' }, kljuc, 256);
    return vHex(bits);
}

async function zgostiGeslo(geslo) {
    const sol = vHex(crypto.getRandomValues(new Uint8Array(16)));
    return `pbkdf2$${sol}$${await izracunajHash(geslo, sol)}`;
}

async function preveriGeslo(geslo, shranjeno) {
    const [, sol, hash] = shranjeno.split('$');
    return (await izracunajHash(geslo, sol)) === hash;
}

// --- Primer objave, da galerija ob prvem obisku ni prazna ---
async function vstaviPrimerneObjave() {
    db.run('INSERT INTO uporabnik (uporabnisko_ime, email, geslo_hash) VALUES (?, ?, ?)',
        ['marko', 'marko@example.com', await zgostiGeslo('demo123')]);
    db.run('INSERT INTO uporabnik (uporabnisko_ime, email, geslo_hash) VALUES (?, ?, ?)',
        ['luka17', 'luka@example.com', await zgostiGeslo('demo123')]);
    db.run('INSERT INTO objava (id_uporabnika, id_modula, pot_do_slike, besedilo) VALUES (1, 1, ?, ?)',
        ['img/hisa.jpg', 'My first house in Blender!']);
    db.run('INSERT INTO komentar (id_objave, id_uporabnika, besedilo) VALUES (1, 2, ?)',
        ['Looks great! How did you make the roof?']);
    db.run('INSERT INTO komentar (id_objave, id_uporabnika, besedilo) VALUES (1, 1, ?)',
        ['Thanks! I extruded the top face and scaled it to zero on Y (S Y 0).']);
}
