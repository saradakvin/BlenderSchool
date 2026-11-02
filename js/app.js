// ===================================================================
// BlenderSchool – spletna aplikacija (GitHub Pages različica)
// Strani se izrisujejo glede na naslov za # (npr. #/lekcija/3).
// ===================================================================

const vsebina = () => document.getElementById('aplikacija');

// Slike modulov (upodobljene v Blenderju)
const SLIKE_MODULOV = {
    1: 'img/lekcije/zacetna_scena.jpg',
    2: 'img/lekcije/modeliranje.jpg',
    3: 'img/lekcije/teksturiranje.jpg',
    4: 'img/lekcije/materiali.jpg',
    5: 'img/lekcije/kiparjenje.jpg',
    6: 'img/lekcije/projekt_scena.jpg',
};

// --- Pomožne funkcije ---
function e(besedilo) { // varen izpis (zaščita pred XSS)
    const d = document.createElement('div');
    d.textContent = besedilo ?? '';
    return d.innerHTML;
}
function datum(niz, zUro = false) {
    const d = new Date(niz.replace(' ', 'T') + 'Z');
    const s = d.toLocaleDateString('sl-SI');
    return zUro ? s + ' ' + d.toLocaleTimeString('sl-SI', { hour: '2-digit', minute: '2-digit' }) : s;
}
function prijavljen() {
    const id = Number(localStorage.getItem('uporabnik_id'));
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
        ${povezava('lekcija', 'Lekcije')}
        ${povezava('bliznjice', 'Bližnjice')}
        ${povezava('galerija', 'Galerija')}
        ${povezava('baza', 'SQL baza')}
        ${u ? `${povezava('profil', `👤 ${e(u.uporabnisko_ime)}`)}
               <a href="#/odjava" class="gumb-mali">Odjava</a>`
            : `${povezava('prijava', 'Prijava')}
               <a href="#/registracija" class="gumb-mali">Registracija</a>`}`;
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
                <span class="znacka"><i></i> Brezplačno za začetnike</span>
                <h1>Nauči se <span class="poudarek">Blenderja</span><br>korak za korakom</h1>
                <p>Kratke in jasne lekcije v stilu W3Schools, cheat sheet bližnjic in trije vodeni projekti. Tvoj napredek se sproti shranjuje v SQL bazo.</p>
                <div class="hero-gumbi">
                    <a href="#/lekcija" class="gumb gumb-velik">Začni z učenjem »</a>
                    ${u ? '<a href="#/profil" class="gumb gumb-velik gumb-obroba">Moj napredek</a>'
                        : '<a href="#/registracija" class="gumb gumb-velik gumb-obroba">Ustvari račun</a>'}
                </div>
                <div class="statistika">
                    <div><b data-stevec="${st.moduli}">0</b><span>modulov</span></div>
                    <div><b data-stevec="${st.lekcije}">0</b><span>lekcij</span></div>
                    <div><b data-stevec="${st.bliznjice}">0</b><span>bližnjic</span></div>
                    <div><b data-stevec="3">0</b><span>projekti</span></div>
                </div>
            </div>
            <div class="hero-slika">
                <img src="img/hero.jpg" alt="Scena s hišo in drevesi, upodobljena v Blenderju">
                <div class="lebdeca-oznaka l1">✔ Lekcija dokončana · <b style="color:#22c55e">+7 %</b></div>
                <div class="lebdeca-oznaka l2"><kbd>G</kbd> <kbd>R</kbd> <kbd>S</kbd> premik · vrtenje · velikost</div>
            </div>
        </section>
    </div>
    <main class="vsebina-siroka">
        <div class="naslov-sekcije razkrij"><h2>Moduli</h2><p>Izberi temo ali pojdi lepo po vrsti.</p></div>
        <div class="mreza-kartic">
        ${moduli.map((m, i) => {
            const p = u ? odstotekNapredka(u.id, m.id) : null;
            return `<a class="kartica razkrij" style="--i:${i}" href="#/modul/${m.id}">
                <div class="kartica-slika"><img src="${SLIKE_MODULOV[m.id] || 'img/hero.jpg'}" alt="" loading="lazy">
                    <span class="stevilka">${m.st_lekcij} lekcij</span></div>
                <div class="kartica-telo">
                    <h3>${e(m.naslov)}</h3><p>${e(m.opis)}</p>
                    ${u ? vrstica(p) + `<small>${p} % dokončano</small>` : ''}
                </div>
            </a>`;
        }).join('')}
        </div>

        <div class="naslov-sekcije razkrij"><h2>Kako poteka učenje</h2><p>Trije preprosti koraki do tvojega prvega 3D izdelka.</p></div>
        <div class="koraki">
            <div class="korak razkrij" style="--i:0"><div class="ikona">📖</div><h3>Preberi lekcijo</h3><p>Kratka razlaga z animacijo, ki pokaže točno, kaj narediš v Blenderju.</p></div>
            <div class="korak razkrij" style="--i:1"><div class="ikona">✅</div><h3>Označi kot dokončano</h3><p>Napredek se shrani v SQL bazo in vidiš ga na svojem profilu.</p></div>
            <div class="korak razkrij" style="--i:2"><div class="ikona">🏆</div><h3>Pokaži svoj izdelek</h3><p>Ko končaš modul, naloži sliko v galerijo in dobi komentarje.</p></div>
        </div>

        <div class="naslov-sekcije razkrij"><h2>Vodeni projekti</h2><p>Od prazne scene do končne slike.</p></div>
        <div class="mreza-kartic">
        ${projekti.map((pr, i) => `<a class="kartica razkrij" style="--i:${i}" href="#/lekcija/${pr.id}">
            <div class="kartica-slika"><img src="${e(pr.slika_gif || 'img/hero.jpg')}" alt="" loading="lazy"><span class="stevilka">Projekt ${i + 1}</span></div>
            <div class="kartica-telo"><h3>${e(pr.naslov.replace(/^Projekt \d: /, ''))}</h3></div></a>`).join('')}
        </div>

        <div class="poziv razkrij">
            <h2>Pripravljen na prvi render?</h2>
            <p>Začni z modulom Osnove vmesnika. Traja manj kot 15 minut.</p>
            <a href="#/modul/1" class="gumb gumb-velik">Začni zdaj »</a>
        </div>
    </main>`;
}

function stranRegistracija() {
    vsebina().innerHTML = `
    <main class="obrazec-okvir">
        <h1>Registracija</h1>
        <div id="napake"></div>
        <form id="obrazec">
            <label>Uporabniško ime <input type="text" name="ime" required></label>
            <label>E-pošta <input type="email" name="email" required></label>
            <label>Geslo <input type="password" name="geslo" required minlength="6"></label>
            <label>Ponovi geslo <input type="password" name="geslo2" required minlength="6"></label>
            <button type="submit" class="gumb">Ustvari račun</button>
        </form>
        <p>Že imaš račun? <a href="#/prijava">Prijavi se</a>.</p>
    </main>`;
    document.getElementById('obrazec').onsubmit = async (ev) => {
        ev.preventDefault();
        const f = new FormData(ev.target);
        const ime = f.get('ime').trim(), email = f.get('email').trim(), geslo = f.get('geslo');
        const napake = [];
        if (ime.length < 3) napake.push('Uporabniško ime mora imeti vsaj 3 znake.');
        if (!/^[^@\s]+@[^@\s]+\.[^@\s]+$/.test(email)) napake.push('E-poštni naslov ni veljaven.');
        if (geslo.length < 6) napake.push('Geslo mora imeti vsaj 6 znakov.');
        if (geslo !== f.get('geslo2')) napake.push('Gesli se ne ujemata.');
        if (!napake.length && vrednost('SELECT COUNT(*) FROM uporabnik WHERE uporabnisko_ime = ? OR email = ?', [ime, email]) > 0)
            napake.push('Uporabniško ime ali e-pošta že obstaja.');
        if (napake.length) {
            document.getElementById('napake').innerHTML = napake.map((n) => `<div class="napaka">${e(n)}</div>`).join('');
            return;
        }
        const id = await izvedi('INSERT INTO uporabnik (uporabnisko_ime, email, geslo_hash) VALUES (?, ?, ?)',
            [ime, email, await zgostiGeslo(geslo)]);
        localStorage.setItem('uporabnik_id', id);
        obvestilo(`👋 Dobrodošel/a, <b>${e(ime)}</b>! Začniva s prvo lekcijo.`);
        pojdi('lekcija');
    };
}

function stranPrijava() {
    vsebina().innerHTML = `
    <main class="obrazec-okvir">
        <h1>Prijava</h1>
        <div id="napake"></div>
        <form id="obrazec">
            <label>Uporabniško ime ali e-pošta <input type="text" name="ime" required></label>
            <label>Geslo <input type="password" name="geslo" required></label>
            <button type="submit" class="gumb">Prijava</button>
        </form>
        <p>Nimaš računa? <a href="#/registracija">Registriraj se</a>.</p>
        <p class="nasvet">Testni račun: <b>luka17</b> / <b>demo123</b></p>
    </main>`;
    document.getElementById('obrazec').onsubmit = async (ev) => {
        ev.preventDefault();
        const f = new FormData(ev.target);
        const ime = f.get('ime').trim();
        const u = ena('SELECT * FROM uporabnik WHERE uporabnisko_ime = ? OR email = ?', [ime, ime]);
        if (u && await preveriGeslo(f.get('geslo'), u.geslo_hash)) {
            localStorage.setItem('uporabnik_id', u.id);
            obvestilo(`👋 Pozdravljen/a nazaj, <b>${e(u.uporabnisko_ime)}</b>!`);
            pojdi('lekcija');
        } else {
            document.getElementById('napake').innerHTML = '<div class="napaka">Napačno uporabniško ime ali geslo.</div>';
        }
    };
}

function stranLekcija(idLekcije, idModula) {
    let lekcija;
    if (idLekcije) lekcija = ena('SELECT * FROM lekcija WHERE id = ?', [idLekcije]);
    else if (idModula) lekcija = ena('SELECT * FROM lekcija WHERE id_modula = ? ORDER BY vrstni_red LIMIT 1', [idModula]);
    else lekcija = ena('SELECT l.* FROM lekcija l JOIN modul m ON m.id = l.id_modula ORDER BY m.vrstni_red, l.vrstni_red LIMIT 1');
    if (!lekcija) { vsebina().innerHTML = '<main class="vsebina-siroka"><h1>Lekcija ne obstaja.</h1></main>'; return; }

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
        ${prejsnja ? `<a class="gumb gumb-obroba" href="#/lekcija/${prejsnja}">« Prejšnja</a>` : ''}
        ${naslednja ? `<a class="gumb desno" href="#/lekcija/${naslednja}">Naslednja »</a>` : ''}</div>`;
    const skupaj = u ? odstotekNapredka(u.id) : 0;

    vsebina().innerHTML = `
    <div class="postavitev">
        <aside class="levi-meni">
        ${moduli.map((m) => `<h4>${e(m.naslov)}</h4>` + lekcije.filter((l) => l.id_modula === m.id).map((l) =>
            `<a href="#/lekcija/${l.id}" class="${l.id === lekcija.id ? 'aktivna' : ''}" data-id="${l.id}">
                ${dokoncane.includes(l.id) ? '<span class="kljukica">✔</span>' : ''}<span>${e(l.naslov)}</span></a>`).join('')).join('')}
        </aside>
        <main class="lekcija">
            ${u ? `<div class="napredek-glava">Napredek tečaja: <b id="odstotek">${skupaj}</b> %${vrstica(skupaj, 'vrstica')}</div>` : ''}
            <div class="drobtine">${e(modul.naslov)} · lekcija ${poz + 1} od ${vrsta.length}</div>
            <h1>${e(lekcija.naslov)}</h1>
            ${lekcija.slika_gif
                ? `<img class="gif" src="${e(lekcija.slika_gif)}" alt="${e(lekcija.naslov)}">`
                : '<div class="gif-prostor">Prostor za GIF / sliko (stolpec slika_gif v tabeli lekcija)</div>'}
            <div class="besedilo">${lekcija.vsebina.replaceAll('galerija.php', '#/galerija')}</div>
            ${u ? `<button id="gumb-dokoncaj" class="gumb gumb-velik ${jeDokoncana ? 'dokoncano' : ''}">
                    ${jeDokoncana ? '✔ Dokončano' : 'Označi kot dokončano'}</button>`
                : '<p class="nasvet"><a href="#/prijava">Prijavi se</a>, da se tvoj napredek shranjuje.</p>'}
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
        gumb.textContent = zdaj ? 'Označi kot dokončano' : '✔ Dokončano';
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
                obvestilo(`🏆 <b>Bravo!</b> Dokončal/a si modul »${e(modul.naslov)}«. V <a href="#/galerija">galeriji</a> lahko zdaj naložiš svoj izdelek.`, 6000);
            } else {
                obvestilo(`✔ Lekcija dokončana. Skupni napredek: <b>${p} %</b>`);
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
            <div><h1>${e(u.uporabnisko_ime)}</h1><p>${e(u.email)} · član od ${datum(u.datum_registracije)}</p></div>
            <div class="krog-napredka">
                <svg viewBox="0 0 130 130"><circle class="ozadje-kroga" cx="65" cy="65" r="55"/>
                <circle class="polnilo" cx="65" cy="65" r="55" data-odstotek="${skupaj}"/></svg>
                <b><span data-stevec="${skupaj}">0</span>%</b>
            </div>
        </div>
        <h2>Napredek po modulih</h2>
        <table class="tabela"><tr><th>Modul</th><th>Napredek</th><th></th></tr>
        ${moduli.map((m) => {
            const p = odstotekNapredka(u.id, m.id);
            return `<tr><td><a href="#/modul/${m.id}">${e(m.naslov)}</a></td>
                <td style="width:50%">${vrstica(p)}</td><td>${p} %${p === 100 ? ' 🏆' : ''}</td></tr>`;
        }).join('')}
        </table>
        <h2>Nazadnje dokončano</h2>
        ${zadnje.length ? `<ul>${zadnje.map((z) => `<li><a href="#/lekcija/${z.id}">${e(z.naslov)}</a>
            <small style="color:var(--sivo)">(${datum(z.datum_dokoncanja, true)})</small></li>`).join('')}</ul>`
            : '<p>Še nisi dokončal/a nobene lekcije. <a href="#/lekcija">Začni zdaj!</a></p>'}
        <h2>Moje objave</h2>
        ${objave.length ? `<div class="mreza-kartic">${objave.map((o, i) => `<a class="kartica razkrij" style="--i:${i}" href="#/objava/${o.id}">
            <div class="kartica-slika"><img src="${e(o.pot_do_slike)}" alt=""></div>
            <div class="kartica-telo"><p>${e(o.besedilo)}</p></div></a>`).join('')}</div>`
            : '<p>Ko dokončaš modul, lahko v <a href="#/galerija">galerijo</a> naložiš sliko svojega izdelka.</p>'}
    </main>`;
}

function stranBliznjice() {
    const b = poizvedba('SELECT * FROM bliznjica ORDER BY kategorija, id');
    const kategorije = [...new Set(b.map((x) => x.kategorija))];
    vsebina().innerHTML = `
    <main class="vsebina-siroka">
        <div class="naslov-sekcije"><h2>Cheat sheet: Blender bližnjice</h2><p>Vpiši tipko ali opis, ali izberi kategorijo.</p></div>
        <input type="search" id="iskalnik" class="iskalnik" placeholder="Išči, npr. extrude ali Ctrl …">
        <div class="filtri"><button class="aktiven" data-kat="">Vse</button>
            ${kategorije.map((k) => `<button data-kat="${e(k)}">${e(k)}</button>`).join('')}</div>
        <div class="mreza-bliznjic">
        ${b.map((x, i) => `<div class="bliznjica razkrij" style="--i:${i % 9}" data-kat="${e(x.kategorija)}">
            <div class="tipke">${x.tipka.split(' + ').map((t) => `<kbd>${e(t)}</kbd>`).join(' + ')}</div>
            <p>${e(x.opis)}</p><span><span class="oznaka">${e(x.kategorija)}</span></span></div>`).join('')}
        </div>
        <p id="ni-zadetkov" hidden>Ni zadetkov.</p>
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
    if (!u) obrazec = '<p class="nasvet"><a href="#/prijava">Prijavi se</a> in dokončaj modul, da lahko naložiš svoj izdelek.</p>';
    else if (!dokoncaniModuli.length) obrazec = '<p class="nasvet">🔒 Nalaganje slike se odklene, ko dokončaš vse lekcije v vsaj enem modulu.</p>';
    else obrazec = `
        <div class="obrazec-okvir levo">
            <h2 style="margin-top:0">Naloži svoj izdelek</h2><div id="napake"></div>
            <form id="obrazec">
                <label>Modul <select name="modul">${dokoncaniModuli.map((m) => `<option value="${m.id}">${e(m.naslov)}</option>`).join('')}</select></label>
                <label>Slika (JPG ali PNG, največ 5 MB) <input type="file" name="slika" accept="image/jpeg,image/png" required></label>
                <label>Opis <textarea name="besedilo" rows="3"></textarea></label>
                <button type="submit" class="gumb">Objavi</button>
            </form>
        </div>`;
    vsebina().innerHTML = `
    <main class="vsebina-siroka">
        <div class="naslov-sekcije"><h2>Galerija izdelkov</h2><p>Izdelki uporabnikov, ki so dokončali modul.</p></div>
        ${obrazec}
        <div class="mreza-kartic">
        ${objave.map((o, i) => `<a class="kartica razkrij" style="--i:${i}" href="#/objava/${o.id}">
            <div class="kartica-slika"><img src="${e(o.pot_do_slike)}" alt="Izdelek uporabnika ${e(o.uporabnisko_ime)}" loading="lazy"></div>
            <div class="kartica-telo">
                <div>${avatar(o.uporabnisko_ime)}<b>${e(o.uporabnisko_ime)}</b> · <span class="oznaka">${e(o.modul)}</span></div>
                <p>${e(o.besedilo)}</p><small>💬 ${o.st_komentarjev}</small></div></a>`).join('') || '<p>Ni še objav. Bodi prvi!</p>'}
        </div>
    </main>`;
    const f = document.getElementById('obrazec');
    if (f) f.onsubmit = async (ev) => {
        ev.preventDefault();
        const podatki = new FormData(f);
        const datoteka = podatki.get('slika');
        const napaka = (t) => document.getElementById('napake').innerHTML = `<div class="napaka">${e(t)}</div>`;
        const idModula = Number(podatki.get('modul'));
        if (!dokoncaniModuli.some((m) => m.id === idModula)) return napaka('Sliko lahko oddaš samo za modul, ki si ga dokončal/a 100 %.');
        if (datoteka.size > 5 * 1024 * 1024) return napaka('Slika je prevelika (največ 5 MB).');
        const tip = await vrstaSlike(datoteka);
        if (!tip) return napaka('Dovoljeni so samo JPG in PNG.');
        // Slika se shrani v bazo kot data URL (na GitHub Pages ni strežnika za datoteke)
        const url = await new Promise((ok) => { const r = new FileReader(); r.onload = () => ok(r.result); r.readAsDataURL(datoteka); });
        const id = await izvedi('INSERT INTO objava (id_uporabnika, id_modula, pot_do_slike, besedilo) VALUES (?, ?, ?, ?)',
            [u.id, idModula, url, podatki.get('besedilo').trim()]);
        obvestilo('📸 Tvoj izdelek je objavljen!');
        pojdi('objava/' + id);
    };
}

function stranObjava(id) {
    const o = ena(`SELECT o.*, u.uporabnisko_ime, m.naslov AS modul FROM objava o
        JOIN uporabnik u ON u.id = o.id_uporabnika JOIN modul m ON m.id = o.id_modula WHERE o.id = ?`, [id]);
    if (!o) { vsebina().innerHTML = '<main class="vsebina-siroka"><h1>Objava ne obstaja.</h1></main>'; return; }
    const komentarji = poizvedba(`SELECT k.*, u.uporabnisko_ime FROM komentar k JOIN uporabnik u ON u.id = k.id_uporabnika
        WHERE k.id_objave = ? ORDER BY k.datum, k.id`, [id]);
    const u = prijavljen();
    vsebina().innerHTML = `
    <main class="vsebina-siroka ozka">
        <p><a href="#/galerija">« Nazaj na galerijo</a></p>
        <img class="velika-slika" src="${e(o.pot_do_slike)}" alt="">
        <p>${avatar(o.uporabnisko_ime)}<b>${e(o.uporabnisko_ime)}</b> · <span class="oznaka">${e(o.modul)}</span> · <small style="color:var(--sivo)">${datum(o.datum)}</small></p>
        <p>${e(o.besedilo).replaceAll('\n', '<br>')}</p>
        <h2>Komentarji (${komentarji.length})</h2>
        ${komentarji.map((k, i) => `<div class="komentar" style="animation-delay:${i * 80}ms">${avatar(k.uporabnisko_ime)}<b>${e(k.uporabnisko_ime)}</b> <small>${datum(k.datum, true)}</small>
            <p>${e(k.besedilo).replaceAll('\n', '<br>')}</p></div>`).join('')}
        ${u ? `<form id="obrazec" class="obrazec-komentar">
                <textarea name="besedilo" rows="3" placeholder="Napiši komentar …" required></textarea>
                <button type="submit" class="gumb">Objavi komentar</button></form>`
            : '<p><a href="#/prijava">Prijavi se</a> za komentiranje.</p>'}
    </main>`;
    const f = document.getElementById('obrazec');
    if (f) f.onsubmit = async (ev) => {
        ev.preventDefault();
        const besedilo = new FormData(f).get('besedilo').trim();
        if (besedilo) await izvedi('INSERT INTO komentar (id_objave, id_uporabnika, besedilo) VALUES (?, ?, ?)', [id, u.id, besedilo]);
        stranObjava(id);
        poIzrisu();
        obvestilo('💬 Komentar objavljen.');
    };
}

// Pregled baze: dokaz, da aplikacija uporablja pravo SQL bazo
function stranBaza() {
    const tabele = poizvedba("SELECT name FROM sqlite_master WHERE type = 'table' AND name NOT LIKE 'sqlite_%' ORDER BY name");
    vsebina().innerHTML = `
    <main class="vsebina-siroka">
        <div class="naslov-sekcije"><h2>SQL baza</h2><p>Aplikacija uporablja SQLite bazo, ki teče v tvojem brskalniku (sql.js). Tu lahko izvedeš SELECT poizvedbo.</p></div>
        <table class="tabela"><tr><th>Tabela</th><th>Število vrstic</th></tr>
        ${tabele.map((t) => `<tr><td><a href="#" data-tabela="${t.name}">${t.name}</a></td>
            <td>${vrednost(`SELECT COUNT(*) FROM ${t.name}`)}</td></tr>`).join('')}
        </table>
        <textarea id="sql" rows="4" class="sql-polje">SELECT u.uporabnisko_ime, COUNT(n.id_lekcije) AS dokoncanih
FROM uporabnik u LEFT JOIN napredek n ON n.id_uporabnika = u.id
GROUP BY u.id;</textarea>
        <button id="izvedi" class="gumb">Izvedi poizvedbo</button>
        <div id="rezultat"></div>
        <p style="margin-top:40px"><button id="ponastavi" class="gumb-mali">Ponastavi bazo na začetno stanje</button></p>
    </main>`;
    const zazeni = () => {
        const sql = document.getElementById('sql').value.trim();
        const r = document.getElementById('rezultat');
        if (!/^select\b/i.test(sql)) { r.innerHTML = '<div class="napaka">Tu so dovoljene samo SELECT poizvedbe.</div>'; return; }
        try {
            const vrstice = poizvedba(sql);
            if (!vrstice.length) { r.innerHTML = '<p>Ni rezultatov.</p>'; return; }
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
    document.getElementById('ponastavi').onclick = () => {
        if (confirm('Res želiš izbrisati vse račune in napredek v tem brskalniku?')) ponastaviBazo();
    };
}

// =================== USMERJANJE ===================
function usmeri() {
    const [stran, id] = location.hash.replace(/^#\/?/, '').split('/');
    if (stran === 'odjava') {
        localStorage.removeItem('uporabnik_id');
        obvestilo('Odjavljen/a si. Se vidiva!');
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
    vsebina().innerHTML = `<main class="vsebina-siroka"><div class="napaka">Napaka pri zagonu baze: ${e(err.message)}</div></main>`;
});
