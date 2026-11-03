// ===================================================================
// BlenderSchool – spletna aplikacija (GitHub Pages različica)
// Strani se izrisujejo glede na naslov za # (npr. #/lekcija/3).
// ===================================================================

const vsebina = () => document.getElementById('aplikacija');

// Slike modulov (upodobljene v Blenderju)
const SLIKE_MODULOV = {
    1: 'img/moduli/cover_1.jpg',
    2: 'img/moduli/cover_2.jpg',
    3: 'img/moduli/cover_3.jpg',
    4: 'img/moduli/cover_4.jpg',
    5: 'img/moduli/cover_5.jpg',
    6: 'img/moduli/cover_6.jpg',
    7: 'img/moduli/cover_7.jpg',
};

// --- Pomožne funkcije ---
function e(besedilo) { // varen izpis (zaščita pred XSS)
    const d = document.createElement('div');
    d.textContent = besedilo ?? '';
    return d.innerHTML;
}
function datum(niz, zUro = false) {
    const d = new Date(niz.replace(' ', 'T') + 'Z');
    const s = d.toLocaleDateString('en-GB');
    return zUro ? s + ' ' + d.toLocaleTimeString('en-GB', { hour: '2-digit', minute: '2-digit' }) : s;
}
function prijavljen() {
    const id = Number(seja.get('uporabnik_id'));
    return id ? ena('SELECT id, uporabnisko_ime, email, datum_registracije FROM uporabnik WHERE id = ?', [id]) : null;
}
function pojdi(pot) { location.hash = '#/' + pot; }
function zahtevajPrijavo() {
    if (!prijavljen()) { pojdi('prijava'); return false; }
    return true;
}
function avatar(ime) { return `<span class="avatar">${e(ime.charAt(0).toUpperCase())}</span>`; }

function odstotekNapredka(idUporabnika, idModula = null) {
    let vse, dokoncane;
    if (idModula === null) {
        vse = vrednost('SELECT COUNT(*) FROM lekcija');
        dokoncane = vrednost('SELECT COUNT(*) FROM napredek WHERE id_uporabnika = ?', [idUporabnika]);
    } else {
        vse = vrednost('SELECT COUNT(*) FROM lekcija WHERE id_modula = ?', [idModula]);
        dokoncane = vrednost(
            `SELECT COUNT(*) FROM napredek n JOIN lekcija l ON l.id = n.id_lekcije
             WHERE n.id_uporabnika = ? AND l.id_modula = ?`, [idUporabnika, idModula]);
    }
    return vse > 0 ? Math.round(dokoncane / vse * 100) : 0;
}
function dokoncaneLekcije(idUporabnika) {
    return poizvedba('SELECT id_lekcije FROM napredek WHERE id_uporabnika = ?', [idUporabnika]).map((v) => v.id_lekcije);
}
function vrstica(p, id = '') {
    return `<div class="vrstica-napredka"><div ${id ? `id="${id}"` : ''} data-sirina="${p}" style="width:${p}%"></div></div>`;
}

// --- Glava ---
function izrisiGlavo(stran) {
    const u = prijavljen();
    const povezava = (pot, ime) => `<a href="#/${pot}" class="${stran === pot ? 'aktivna-povezava' : ''}">${ime}</a>`;
    document.getElementById('meni').innerHTML = `
        ${povezava('lekcija', 'Lessons')}
        ${povezava('bliznjice', 'Shortcuts')}
        ${povezava('galerija', 'Gallery')}
        ${povezava('baza', 'SQL database')}
        ${u ? `${povezava('profil', `👤 ${e(u.uporabnisko_ime)}`)}
               <a href="#/odjava" class="gumb-mali">Log out</a>`
            : `${povezava('prijava', 'Log in')}
               <a href="#/registracija" class="gumb-mali">Sign up</a>`}`;
}

// =================== STRANI ===================

function stranDomov() {
    const u = prijavljen();
    const moduli = poizvedba(`SELECT m.*, (SELECT COUNT(*) FROM lekcija l WHERE l.id_modula = m.id) AS st_lekcij
                              FROM modul m ORDER BY vrstni_red`);
    const projekti = poizvedba('SELECT * FROM lekcija WHERE id_modula = 6 ORDER BY vrstni_red');
    const st = {
        moduli: moduli.length,
        lekcije: vrednost('SELECT COUNT(*) FROM lekcija'),
        bliznjice: vrednost('SELECT COUNT(*) FROM bliznjica'),
    };
    vsebina().innerHTML = `
    <div class="hero-ovoj">
        <div class="hero-ozadje"><div class="krog k1"></div><div class="krog k2"></div><div class="krog k3"></div></div>
        <section class="hero">
            <div>
                <span class="znacka"><i></i> Free for beginners</span>
                <h1>Learn <span class="poudarek">Blender</span><br>step by step</h1>
                <p>Clear lessons in the style of W3Schools that show you exactly which tools to use, a shortcut cheat sheet and guided projects you build click by click. Your progress is saved in an SQL database.</p>
                <div class="hero-gumbi">
                    <a href="#/lekcija" class="gumb gumb-velik">Start learning »</a>
                    ${u ? '<a href="#/profil" class="gumb gumb-velik gumb-obroba">My progress</a>'
                        : '<a href="#/registracija" class="gumb gumb-velik gumb-obroba">Create account</a>'}
                </div>
                <div class="statistika">
                    <div><b data-stevec="${st.moduli}">0</b><span>modules</span></div>
                    <div><b data-stevec="${st.lekcije}">0</b><span>lessons</span></div>
                    <div><b data-stevec="${st.bliznjice}">0</b><span>shortcuts</span></div>
                    <div><b data-stevec="${vrednost('SELECT COUNT(*) FROM lekcija WHERE id_modula = 6')}">0</b><span>projects</span></div>
                </div>
            </div>
            <div class="hero-slika">
                <img src="img/hero.jpg" alt="The cute cottage and the low-poly character from the courses, rendered in Blender">
                <div class="lebdeca-oznaka l1">✔ Lesson complete · <b style="color:#22c55e">+6%</b></div>
                <div class="lebdeca-oznaka l2"><kbd>G</kbd> <kbd>R</kbd> <kbd>S</kbd> move · rotate · scale</div>
            </div>
        </section>
    </div>
    <main class="vsebina-siroka">
        <div class="naslov-sekcije razkrij"><h2>Modules</h2><p>Pick a topic or go through them in order.</p></div>
        <div class="mreza-kartic">
        ${moduli.map((m, i) => {
            const p = u ? odstotekNapredka(u.id, m.id) : null;
            return `<a class="kartica razkrij" style="--i:${i}" href="#/modul/${m.id}">
                <div class="kartica-slika"><img src="${SLIKE_MODULOV[m.id] || 'img/hero.jpg'}" alt="" loading="lazy">
                    <span class="stevilka">${m.st_lekcij} lessons</span></div>
                <div class="kartica-telo">
                    <h3>${e(m.naslov)}</h3><p>${e(m.opis)}</p>
                    ${u ? vrstica(p) + `<small>${p}% complete</small>` : ''}
                </div>
            </a>`;
        }).join('')}
        </div>

        <div class="naslov-sekcije razkrij"><h2>How it works</h2><p>Three simple steps to your first 3D model.</p></div>
        <div class="koraki">
            <div class="korak razkrij" style="--i:0"><div class="ikona">📖</div><h3>Read a lesson</h3><p>Every lesson explains which tools to use and how, with exact keys, settings and a short exercise.</p></div>
            <div class="korak razkrij" style="--i:1"><div class="ikona">✅</div><h3>Mark it as done</h3><p>Your progress is saved in the SQL database and shown on your profile.</p></div>
            <div class="korak razkrij" style="--i:2"><div class="ikona">🏆</div><h3>Show your work</h3><p>Finish a module, upload your render to the gallery and get comments.</p></div>
        </div>

        <div class="naslov-sekcije razkrij"><h2>Guided projects</h2><p>Build a real model yourself, step by step, with a picture for every step.</p></div>
        <div class="mreza-kartic">
        ${projekti.map((pr, i) => `<a class="kartica razkrij" style="--i:${i}" href="#/lekcija/${pr.id}">
            <div class="kartica-slika"><img src="${e(pr.slika_gif || 'img/hero.jpg')}" alt="" loading="lazy"><span class="stevilka">Project ${i + 1}</span></div>
            <div class="kartica-telo"><h3>${e(pr.naslov.replace(/^Project \d: /, ''))}</h3></div></a>`).join('')}
        </div>

        <div class="poziv razkrij">
            <h2>Ready for your first render?</h2>
            <p>Start with Interface Basics, or jump straight into the snowman project.</p>
            <a href="#/modul/1" class="gumb gumb-velik">Start now »</a>
        </div>
    </main>`;
}

function stranRegistracija() {
    vsebina().innerHTML = `
    <main class="obrazec-okvir">
        <h1>Sign up</h1>
        <div id="napake"></div>
        <form id="obrazec">
            <label>Username <input type="text" name="ime" required></label>
            <label>Email <input type="email" name="email" required></label>
            <label>Password <input type="password" name="geslo" required minlength="6"></label>
            <label>Repeat password <input type="password" name="geslo2" required minlength="6"></label>
            <button type="submit" class="gumb">Create account</button>
        </form>
        <p>Already have an account? <a href="#/prijava">Log in</a>.</p>
    </main>`;
    document.getElementById('obrazec').onsubmit = async (ev) => {
        ev.preventDefault();
        const f = new FormData(ev.target);
        const ime = f.get('ime').trim(), email = f.get('email').trim(), geslo = f.get('geslo');
        const napake = [];
        if (ime.length < 3) napake.push('The username must have at least 3 characters.');
        if (!/^[^@\s]+@[^@\s]+\.[^@\s]+$/.test(email)) napake.push('The email address is not valid.');
        if (geslo.length < 6) napake.push('The password must have at least 6 characters.');
        if (geslo !== f.get('geslo2')) napake.push('The passwords do not match.');
        if (!napake.length && vrednost('SELECT COUNT(*) FROM uporabnik WHERE uporabnisko_ime = ? OR email = ?', [ime, email]) > 0)
            napake.push('This username or email already exists.');
        if (napake.length) {
            document.getElementById('napake').innerHTML = napake.map((n) => `<div class="napaka">${e(n)}</div>`).join('');
            return;
        }
        const id = await izvedi('INSERT INTO uporabnik (uporabnisko_ime, email, geslo_hash) VALUES (?, ?, ?)',
            [ime, email, await zgostiGeslo(geslo)]);
        seja.set('uporabnik_id', id);
        obvestilo(`👋 Welcome, <b>${e(ime)}</b>! Let's start with the first lesson.`);
        pojdi('lekcija');
    };
}

function stranPrijava() {
    vsebina().innerHTML = `
    <main class="obrazec-okvir">
        <h1>Log in</h1>
        <div id="napake"></div>
        <form id="obrazec">
            <label>Username or email <input type="text" name="ime" required></label>
            <label>Password <input type="password" name="geslo" required></label>
            <button type="submit" class="gumb">Log in</button>
        </form>
        <p>No account yet? <a href="#/registracija">Sign up</a>.</p>
        <p class="nasvet">Test account: <b>luka17</b> / <b>demo123</b></p>
    </main>`;
    document.getElementById('obrazec').onsubmit = async (ev) => {
        ev.preventDefault();
        const f = new FormData(ev.target);
        const ime = f.get('ime').trim();
        const u = ena('SELECT * FROM uporabnik WHERE uporabnisko_ime = ? OR email = ?', [ime, ime]);
        if (u && await preveriGeslo(f.get('geslo'), u.geslo_hash)) {
            seja.set('uporabnik_id', u.id);
            obvestilo(`👋 Welcome back, <b>${e(u.uporabnisko_ime)}</b>!`);
            pojdi('lekcija');
        } else {
            document.getElementById('napake').innerHTML = '<div class="napaka">Wrong username or password.</div>';
        }
    };
}

function stranLekcija(idLekcije, idModula) {
    let lekcija;
    if (idLekcije) lekcija = ena('SELECT * FROM lekcija WHERE id = ?', [idLekcije]);
    else if (idModula) lekcija = ena('SELECT * FROM lekcija WHERE id_modula = ? ORDER BY vrstni_red LIMIT 1', [idModula]);
    else lekcija = ena('SELECT l.* FROM lekcija l JOIN modul m ON m.id = l.id_modula ORDER BY m.vrstni_red, l.vrstni_red LIMIT 1');
    if (!lekcija) { vsebina().innerHTML = '<main class="vsebina-siroka"><h1>This lesson does not exist.</h1></main>'; return; }

    const u = prijavljen();
    const moduli = poizvedba('SELECT * FROM modul ORDER BY vrstni_red');
    const lekcije = poizvedba('SELECT id, id_modula, naslov FROM lekcija ORDER BY vrstni_red');
    const vrsta = moduli.flatMap((m) => lekcije.filter((l) => l.id_modula === m.id).map((l) => l.id));
    const poz = vrsta.indexOf(lekcija.id);
    const prejsnja = vrsta[poz - 1], naslednja = vrsta[poz + 1];
    const modul = moduli.find((m) => m.id === lekcija.id_modula);
    const dokoncane = u ? dokoncaneLekcije(u.id) : [];
    const jeDokoncana = dokoncane.includes(lekcija.id);
    const navigacija = `<div class="navigacija-lekcij">
        ${prejsnja ? `<a class="gumb gumb-obroba" href="#/lekcija/${prejsnja}">« Previous</a>` : ''}
        ${naslednja ? `<a class="gumb desno" href="#/lekcija/${naslednja}">Next »</a>` : ''}</div>`;
    const skupaj = u ? odstotekNapredka(u.id) : 0;

    vsebina().innerHTML = `
    <div class="postavitev">
        <aside class="levi-meni">
        ${moduli.map((m) => `<h4>${e(m.naslov)}</h4>` + lekcije.filter((l) => l.id_modula === m.id).map((l) =>
            `<a href="#/lekcija/${l.id}" class="${l.id === lekcija.id ? 'aktivna' : ''}" data-id="${l.id}">
                ${dokoncane.includes(l.id) ? '<span class="kljukica">✔</span>' : ''}<span>${e(l.naslov)}</span></a>`).join('')).join('')}
        </aside>
        <main class="lekcija">
            ${u ? `<div class="napredek-glava">Course progress: <b id="odstotek">${skupaj}</b>%${vrstica(skupaj, 'vrstica')}</div>` : ''}
            <div class="drobtine">${e(modul.naslov)} · lesson ${poz + 1} of ${vrsta.length}</div>
            <h1>${e(lekcija.naslov)}</h1>
            ${lekcija.slika_gif
                ? `<img class="gif" src="${e(lekcija.slika_gif)}" alt="${e(lekcija.naslov)}">`
                : '<div class="gif-prostor">Image or GIF goes here (column slika_gif in table lekcija)</div>'}
            <div class="besedilo">${lekcija.vsebina.replaceAll('galerija.php', '#/galerija')}</div>
            ${u ? `<button id="gumb-dokoncaj" class="gumb gumb-velik ${jeDokoncana ? 'dokoncano' : ''}">
                    ${jeDokoncana ? '✔ Completed' : 'Mark as complete'}</button>`
                : '<p class="nasvet"><a href="#/prijava">Log in</a> to save your progress.</p>'}
            ${navigacija}
        </main>
    </div>`;

    const aktivna = document.querySelector('.levi-meni a.aktivna');
    if (aktivna) aktivna.scrollIntoView({ block: 'center' });

    const gumb = document.getElementById('gumb-dokoncaj');
    if (gumb) gumb.onclick = async () => {
        gumb.disabled = true;
        const zdaj = dokoncaneLekcije(u.id).includes(lekcija.id);
        if (zdaj) await izvedi('DELETE FROM napredek WHERE id_uporabnika = ? AND id_lekcije = ?', [u.id, lekcija.id]);
        else await izvedi('INSERT INTO napredek (id_uporabnika, id_lekcije) VALUES (?, ?)', [u.id, lekcija.id]);
        const p = odstotekNapredka(u.id);
        gumb.textContent = zdaj ? 'Mark as complete' : '✔ Completed';
        gumb.classList.toggle('dokoncano', !zdaj);
        gumb.classList.remove('pop'); void gumb.offsetWidth; gumb.classList.add('pop');
        gumb.disabled = false;
        document.getElementById('odstotek').textContent = p;
        document.getElementById('vrstica').style.width = p + '%';
        const povezava = document.querySelector(`.levi-meni a[data-id="${lekcija.id}"]`);
        povezava.innerHTML = (zdaj ? '' : '<span class="kljukica nova">✔</span>') + `<span>${e(lekcija.naslov)}</span>`;
        if (!zdaj) {
            if (odstotekNapredka(u.id, lekcija.id_modula) === 100) {
                konfeti();
                obvestilo(`🏆 <b>Well done!</b> You finished the module “${e(modul.naslov)}”. You can now upload your work to the <a href="#/galerija">gallery</a>.`, 6000);
            } else {
                obvestilo(`✔ Lesson complete. Total progress: <b>${p}%</b>`);
            }
        }
    };
}

function stranProfil() {
    if (!zahtevajPrijavo()) return;
    const u = prijavljen();
    const moduli = poizvedba('SELECT * FROM modul ORDER BY vrstni_red');
    const skupaj = odstotekNapredka(u.id);
    const zadnje = poizvedba(
        `SELECT l.id, l.naslov, n.datum_dokoncanja FROM napredek n JOIN lekcija l ON l.id = n.id_lekcije
         WHERE n.id_uporabnika = ? ORDER BY n.datum_dokoncanja DESC, n.rowid DESC LIMIT 5`, [u.id]);
    const objave = poizvedba('SELECT * FROM objava WHERE id_uporabnika = ? ORDER BY datum DESC', [u.id]);
    vsebina().innerHTML = `
    <main class="vsebina-siroka">
        <div class="profil-glava">
            ${avatar(u.uporabnisko_ime)}
            <div><h1>${e(u.uporabnisko_ime)}</h1><p>${e(u.email)} · member since ${datum(u.datum_registracije)}</p></div>
            <div class="krog-napredka">
                <svg viewBox="0 0 130 130"><circle class="ozadje-kroga" cx="65" cy="65" r="55"/>
                <circle class="polnilo" cx="65" cy="65" r="55" data-odstotek="${skupaj}"/></svg>
                <b><span data-stevec="${skupaj}">0</span>%</b>
            </div>
        </div>
        <h2>Progress by module</h2>
        <table class="tabela"><tr><th>Module</th><th>Progress</th><th></th></tr>
        ${moduli.map((m) => {
            const p = odstotekNapredka(u.id, m.id);
            return `<tr><td><a href="#/modul/${m.id}">${e(m.naslov)}</a></td>
                <td style="width:50%">${vrstica(p)}</td><td>${p}%${p === 100 ? ' 🏆' : ''}</td></tr>`;
        }).join('')}
        </table>
        <h2>Recently completed</h2>
        ${zadnje.length ? `<ul>${zadnje.map((z) => `<li><a href="#/lekcija/${z.id}">${e(z.naslov)}</a>
            <small style="color:var(--sivo)">(${datum(z.datum_dokoncanja, true)})</small></li>`).join('')}</ul>`
            : '<p>You have not completed any lessons yet. <a href="#/lekcija">Start now!</a></p>'}
        <h2>My posts</h2>
        ${objave.length ? `<div class="mreza-kartic">${objave.map((o, i) => `<a class="kartica razkrij" style="--i:${i}" href="#/objava/${o.id}">
            <div class="kartica-slika"><img src="${e(o.pot_do_slike)}" alt=""></div>
            <div class="kartica-telo"><p>${e(o.besedilo)}</p></div></a>`).join('')}</div>`
            : '<p>When you finish a module you can upload a picture of your work to the <a href="#/galerija">gallery</a>.</p>'}
    </main>`;
}

function stranBliznjice() {
    const b = poizvedba('SELECT * FROM bliznjica ORDER BY kategorija, id');
    const kategorije = [...new Set(b.map((x) => x.kategorija))];
    vsebina().innerHTML = `
    <main class="vsebina-siroka">
        <div class="naslov-sekcije"><h2>Cheat sheet: Blender shortcuts</h2><p>Type a key or a description, or pick a category.</p></div>
        <input type="search" id="iskalnik" class="iskalnik" placeholder="Search, e.g. extrude or Ctrl …">
        <div class="filtri"><button class="aktiven" data-kat="">All</button>
            ${kategorije.map((k) => `<button data-kat="${e(k)}">${e(k)}</button>`).join('')}</div>
        <div class="mreza-bliznjic">
        ${b.map((x, i) => `<div class="bliznjica razkrij" style="--i:${i % 9}" data-kat="${e(x.kategorija)}">
            <div class="tipke">${x.tipka.split(' + ').map((t) => `<kbd>${e(t)}</kbd>`).join(' + ')}</div>
            <p>${e(x.opis)}</p><span><span class="oznaka">${e(x.kategorija)}</span></span></div>`).join('')}
        </div>
        <p id="ni-zadetkov" hidden>No results.</p>
    </main>`;
    const isk = document.getElementById('iskalnik');
    let kategorija = '';
    const filtriraj = () => {
        const iskano = isk.value.toLowerCase();
        let zadetki = 0;
        document.querySelectorAll('.bliznjica').forEach((v) => {
            const ujema = v.textContent.toLowerCase().includes(iskano) && (!kategorija || v.dataset.kat === kategorija);
            v.hidden = !ujema;
            if (ujema) { zadetki++; v.classList.add('vidno'); }
        });
        document.getElementById('ni-zadetkov').hidden = zadetki > 0;
    };
    isk.focus();
    isk.oninput = filtriraj;
    document.querySelectorAll('.filtri button').forEach((g) => g.onclick = () => {
        document.querySelectorAll('.filtri button').forEach((x) => x.classList.remove('aktiven'));
        g.classList.add('aktiven');
        kategorija = g.dataset.kat;
        filtriraj();
    });
}

// Preveri prve bajte datoteke: ali je res JPG ali PNG?
async function vrstaSlike(datoteka) {
    const b = new Uint8Array(await datoteka.slice(0, 8).arrayBuffer());
    if (b[0] === 0xFF && b[1] === 0xD8 && b[2] === 0xFF) return 'image/jpeg';
    if (b[0] === 0x89 && b[1] === 0x50 && b[2] === 0x4E && b[3] === 0x47) return 'image/png';
    return null;
}

function stranGalerija() {
    const u = prijavljen();
    const moduli = poizvedba('SELECT * FROM modul ORDER BY vrstni_red');
    const dokoncaniModuli = u ? moduli.filter((m) => odstotekNapredka(u.id, m.id) === 100) : [];
    const objave = poizvedba(
        `SELECT o.*, u.uporabnisko_ime, m.naslov AS modul,
                (SELECT COUNT(*) FROM komentar k WHERE k.id_objave = o.id) AS st_komentarjev
         FROM objava o JOIN uporabnik u ON u.id = o.id_uporabnika JOIN modul m ON m.id = o.id_modula
         ORDER BY o.datum DESC, o.id DESC`);
    let obrazec;
    if (!u) obrazec = '<p class="nasvet"><a href="#/prijava">Log in</a> and finish a module to upload your work.</p>';
    else if (!dokoncaniModuli.length) obrazec = '<p class="nasvet">🔒 Uploading unlocks when you complete all lessons in at least one module.</p>';
    else obrazec = `
        <div class="obrazec-okvir levo">
            <h2 style="margin-top:0">Upload your work</h2><div id="napake"></div>
            <form id="obrazec">
                <label>Module <select name="modul">${dokoncaniModuli.map((m) => `<option value="${m.id}">${e(m.naslov)}</option>`).join('')}</select></label>
                <label>Image (JPG or PNG, max 5 MB) <input type="file" name="slika" accept="image/jpeg,image/png" required></label>
                <label>Description <textarea name="besedilo" rows="3"></textarea></label>
                <button type="submit" class="gumb">Publish</button>
            </form>
        </div>`;
    vsebina().innerHTML = `
    <main class="vsebina-siroka">
        <div class="naslov-sekcije"><h2>Gallery</h2><p>Work by learners who finished a module.</p></div>
        ${obrazec}
        <div class="mreza-kartic">
        ${objave.map((o, i) => `<a class="kartica razkrij" style="--i:${i}" href="#/objava/${o.id}">
            <div class="kartica-slika"><img src="${e(o.pot_do_slike)}" alt="Work by ${e(o.uporabnisko_ime)}" loading="lazy"></div>
            <div class="kartica-telo">
                <div>${avatar(o.uporabnisko_ime)}<b>${e(o.uporabnisko_ime)}</b> · <span class="oznaka">${e(o.modul)}</span></div>
                <p>${e(o.besedilo)}</p><small>💬 ${o.st_komentarjev}</small></div></a>`).join('') || '<p>No posts yet. Be the first!</p>'}
        </div>
    </main>`;
    const f = document.getElementById('obrazec');
    if (f) f.onsubmit = async (ev) => {
        ev.preventDefault();
        const podatki = new FormData(f);
        const datoteka = podatki.get('slika');
        const napaka = (t) => document.getElementById('napake').innerHTML = `<div class="napaka">${e(t)}</div>`;
        const idModula = Number(podatki.get('modul'));
        if (!dokoncaniModuli.some((m) => m.id === idModula)) return napaka('You can only post for a module you completed 100%.');
        if (datoteka.size > 5 * 1024 * 1024) return napaka('The image is too large (max 5 MB).');
        const tip = await vrstaSlike(datoteka);
        if (!tip) return napaka('Only JPG and PNG files are allowed.');
        // Slika se shrani v bazo kot data URL (na GitHub Pages ni strežnika za datoteke)
        const url = await new Promise((ok) => { const r = new FileReader(); r.onload = () => ok(r.result); r.readAsDataURL(datoteka); });
        const id = await izvedi('INSERT INTO objava (id_uporabnika, id_modula, pot_do_slike, besedilo) VALUES (?, ?, ?, ?)',
            [u.id, idModula, url, podatki.get('besedilo').trim()]);
        obvestilo('📸 Your work is published!');
        pojdi('objava/' + id);
    };
}

function stranObjava(id) {
    const o = ena(`SELECT o.*, u.uporabnisko_ime, m.naslov AS modul FROM objava o
        JOIN uporabnik u ON u.id = o.id_uporabnika JOIN modul m ON m.id = o.id_modula WHERE o.id = ?`, [id]);
    if (!o) { vsebina().innerHTML = '<main class="vsebina-siroka"><h1>This post does not exist.</h1></main>'; return; }
    const komentarji = poizvedba(`SELECT k.*, u.uporabnisko_ime FROM komentar k JOIN uporabnik u ON u.id = k.id_uporabnika
        WHERE k.id_objave = ? ORDER BY k.datum, k.id`, [id]);
    const u = prijavljen();
    vsebina().innerHTML = `
    <main class="vsebina-siroka ozka">
        <p><a href="#/galerija">« Back to the gallery</a></p>
        <img class="velika-slika" src="${e(o.pot_do_slike)}" alt="">
        <p>${avatar(o.uporabnisko_ime)}<b>${e(o.uporabnisko_ime)}</b> · <span class="oznaka">${e(o.modul)}</span> · <small style="color:var(--sivo)">${datum(o.datum)}</small></p>
        <p>${e(o.besedilo).replaceAll('\n', '<br>')}</p>
        <h2>Comments (${komentarji.length})</h2>
        ${komentarji.map((k, i) => `<div class="komentar" style="animation-delay:${i * 80}ms">${avatar(k.uporabnisko_ime)}<b>${e(k.uporabnisko_ime)}</b> <small>${datum(k.datum, true)}</small>
            <p>${e(k.besedilo).replaceAll('\n', '<br>')}</p></div>`).join('')}
        ${u ? `<form id="obrazec" class="obrazec-komentar">
                <textarea name="besedilo" rows="3" placeholder="Write a comment …" required></textarea>
                <button type="submit" class="gumb">Post comment</button></form>`
            : '<p><a href="#/prijava">Log in</a> to comment.</p>'}
    </main>`;
    const f = document.getElementById('obrazec');
    if (f) f.onsubmit = async (ev) => {
        ev.preventDefault();
        const besedilo = new FormData(f).get('besedilo').trim();
        if (besedilo) await izvedi('INSERT INTO komentar (id_objave, id_uporabnika, besedilo) VALUES (?, ?, ?)', [id, u.id, besedilo]);
        stranObjava(id);
        poIzrisu();
        obvestilo('💬 Comment posted.');
    };
}

// Pregled baze: dokaz, da aplikacija uporablja pravo SQL bazo
function stranBaza() {
    const tabele = poizvedba("SELECT name FROM sqlite_master WHERE type = 'table' AND name NOT LIKE 'sqlite_%' ORDER BY name");
    vsebina().innerHTML = `
    <main class="vsebina-siroka">
        <div class="naslov-sekcije"><h2>SQL database</h2><p>The app uses an SQLite database that runs in your browser (sql.js). You can run a SELECT query here.</p></div>
        <table class="tabela"><tr><th>Table</th><th>Rows</th></tr>
        ${tabele.map((t) => `<tr><td><a href="#" data-tabela="${t.name}">${t.name}</a></td>
            <td>${vrednost(`SELECT COUNT(*) FROM ${t.name}`)}</td></tr>`).join('')}
        </table>
        <textarea id="sql" rows="4" class="sql-polje">SELECT u.uporabnisko_ime, COUNT(n.id_lekcije) AS dokoncanih
FROM uporabnik u LEFT JOIN napredek n ON n.id_uporabnika = u.id
GROUP BY u.id;</textarea>
        <button id="izvedi" class="gumb">Run query</button>
        <div id="rezultat"></div>
        <p style="margin-top:40px"><button id="ponastavi" class="gumb-mali">Reset the database to its starting state</button></p>
    </main>`;
    const zazeni = () => {
        const sql = document.getElementById('sql').value.trim();
        const r = document.getElementById('rezultat');
        if (!/^select\b/i.test(sql)) { r.innerHTML = '<div class="napaka">Only SELECT queries are allowed here.</div>'; return; }
        try {
            const vrstice = poizvedba(sql);
            if (!vrstice.length) { r.innerHTML = '<p>No results.</p>'; return; }
            const stolpci = Object.keys(vrstice[0]);
            r.innerHTML = `<table class="tabela stran-vstop"><tr>${stolpci.map((s) => `<th>${e(s)}</th>`).join('')}</tr>
                ${vrstice.slice(0, 100).map((v) => `<tr>${stolpci.map((s) => `<td>${e(String(v[s] ?? '').slice(0, 80))}</td>`).join('')}</tr>`).join('')}</table>`;
        } catch (err) {
            r.innerHTML = `<div class="napaka">${e(err.message)}</div>`;
        }
    };
    document.getElementById('izvedi').onclick = zazeni;
    document.querySelectorAll('[data-tabela]').forEach((a) => a.onclick = (ev) => {
        ev.preventDefault();
        document.getElementById('sql').value = `SELECT * FROM ${a.dataset.tabela} LIMIT 20;`;
        zazeni();
    });
    // Two clicks instead of confirm(), which some embedded previews block
    const ponastavi = document.getElementById('ponastavi');
    ponastavi.onclick = () => {
        if (ponastavi.dataset.potrdi) { ponastaviBazo(); return; }
        ponastavi.dataset.potrdi = '1';
        ponastavi.textContent = 'Click again to delete all accounts and progress in this browser';
    };
}

// =================== USMERJANJE ===================
function usmeri() {
    const [stran, id] = location.hash.replace(/^#\/?/, '').split('/');
    if (stran === 'odjava') {
        seja.remove('uporabnik_id');
        obvestilo('You are logged out. See you soon!');
        pojdi('');
        return;
    }
    izrisiGlavo(stran === 'modul' || stran === 'objava' ? (stran === 'modul' ? 'lekcija' : 'galerija') : stran);
    window.scrollTo({ top: 0 });
    switch (stran) {
        case 'registracija': stranRegistracija(); break;
        case 'prijava': stranPrijava(); break;
        case 'lekcija': stranLekcija(Number(id) || null, null); break;
        case 'modul': stranLekcija(null, Number(id)); break;
        case 'profil': stranProfil(); break;
        case 'bliznjice': stranBliznjice(); break;
        case 'galerija': stranGalerija(); break;
        case 'objava': stranObjava(Number(id)); break;
        case 'baza': stranBaza(); break;
        default: stranDomov();
    }
    poIzrisu();
}

zazeniBazo().then(() => {
    window.addEventListener('hashchange', usmeri);
    usmeri();
}).catch((err) => {
    vsebina().innerHTML = `<main class="vsebina-siroka"><div class="napaka">Could not start the database: ${e(err.message)}</div></main>`;
});
