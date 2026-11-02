PRAGMA foreign_keys = ON;
-- =====================================================
-- BlenderSchool – SQL podatkovna baza (SQLite, teče v brskalniku)
-- To datoteko ob prvem obisku izvede js/db.js. MySQL različica: php/database.sql
-- =====================================================



DROP TABLE IF EXISTS komentar;
DROP TABLE IF EXISTS objava;
DROP TABLE IF EXISTS napredek;
DROP TABLE IF EXISTS lekcija;
DROP TABLE IF EXISTS modul;
DROP TABLE IF EXISTS bliznjica;
DROP TABLE IF EXISTS uporabnik;

-- Uporabniki (geslo je shranjeno kot bcrypt hash, nikoli v odkritem besedilu)
CREATE TABLE uporabnik (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    uporabnisko_ime VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    geslo_hash VARCHAR(255) NOT NULL,
    datum_registracije DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Moduli (sklopi lekcij)
CREATE TABLE modul (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    naslov VARCHAR(100) NOT NULL,
    opis TEXT,
    vrstni_red INT NOT NULL DEFAULT 0
);

-- Lekcije znotraj modula
CREATE TABLE lekcija (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    id_modula INT NOT NULL,
    naslov VARCHAR(150) NOT NULL,
    vsebina TEXT NOT NULL,
    slika_gif VARCHAR(255) NULL,
    vrstni_red INT NOT NULL DEFAULT 0,
    FOREIGN KEY (id_modula) REFERENCES modul(id) ON DELETE CASCADE
);

-- Napredek: ena vrstica = ena dokončana lekcija
CREATE TABLE napredek (
    id_uporabnika INT NOT NULL,
    id_lekcije INT NOT NULL,
    datum_dokoncanja DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_uporabnika, id_lekcije),
    FOREIGN KEY (id_uporabnika) REFERENCES uporabnik(id) ON DELETE CASCADE,
    FOREIGN KEY (id_lekcije) REFERENCES lekcija(id) ON DELETE CASCADE
);

-- Bližnjice za cheat sheet
CREATE TABLE bliznjica (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    tipka VARCHAR(50) NOT NULL,
    opis VARCHAR(255) NOT NULL,
    kategorija VARCHAR(50) NOT NULL
);

-- Objave (slike končnih izdelkov)
CREATE TABLE objava (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    id_uporabnika INT NOT NULL,
    id_modula INT NOT NULL,
    pot_do_slike VARCHAR(255) NOT NULL,
    besedilo TEXT,
    datum DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_uporabnika) REFERENCES uporabnik(id) ON DELETE CASCADE,
    FOREIGN KEY (id_modula) REFERENCES modul(id) ON DELETE CASCADE
);

-- Komentarji pod objavami
CREATE TABLE komentar (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    id_objave INT NOT NULL,
    id_uporabnika INT NOT NULL,
    besedilo TEXT NOT NULL,
    datum DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_objave) REFERENCES objava(id) ON DELETE CASCADE,
    FOREIGN KEY (id_uporabnika) REFERENCES uporabnik(id) ON DELETE CASCADE
);

-- =====================================================
-- VZOREC PODATKOV
-- =====================================================

INSERT INTO modul (id, naslov, opis, vrstni_red) VALUES
(1, 'Osnove vmesnika', 'Spoznaj Blenderjev vmesnik, premikanje po sceni in osnovne načine dela.', 1),
(2, 'Modeliranje', 'Ustvarjanje in urejanje 3D objektov v načinu Edit Mode.', 2),
(3, 'Teksturiranje', 'UV razpiranje in barvanje tekstur (Texture Painting).', 3),
(4, 'Senčenje in materiali', 'Materiali, Shader Editor, svetloba in upodabljanje (render).', 4),
(5, 'Kiparjenje', 'Sculpt Mode – oblikovanje organskih oblik s čopiči.', 5),
(6, 'Vodeni projekti', 'Trije praktični projekti od začetka do konca.', 6);

INSERT INTO lekcija (id_modula, naslov, vsebina, vrstni_red) VALUES
(1, 'Prvi zagon in deli vmesnika',
'<p>Ko prvič odpreš Blender, vidiš privzeto sceno: <b>kocko</b>, <b>kamero</b> in <b>luč</b>.</p>
<h3>Glavni deli vmesnika</h3>
<ul>
<li><b>3D Viewport</b> – osrednje okno, kjer vidiš in urejaš sceno.</li>
<li><b>Outliner</b> (zgoraj desno) – seznam vseh objektov v sceni.</li>
<li><b>Properties</b> (spodaj desno) – nastavitve objekta, materiala, upodabljanja …</li>
<li><b>Timeline</b> (spodaj) – časovnica za animacijo.</li>
</ul>
<div class="nasvet">Nasvet: s tipko <kbd>N</kbd> odpreš stranski panel, s <kbd>T</kbd> orodno vrstico.</div>', 1),

(1, 'Premikanje po sceni',
'<p>Za delo v 3D moraš znati gledati sceno z vseh strani.</p>
<table class="tabela">
<tr><th>Dejanje</th><th>Bližnjica</th></tr>
<tr><td>Vrtenje pogleda</td><td><kbd>srednji gumb miške</kbd> + vleka</td></tr>
<tr><td>Premik pogleda</td><td><kbd>Shift</kbd> + <kbd>srednji gumb</kbd></td></tr>
<tr><td>Približanje</td><td>kolesce miške</td></tr>
<tr><td>Pogled spredaj / desno / zgoraj</td><td><kbd>Numpad 1</kbd> / <kbd>3</kbd> / <kbd>7</kbd></td></tr>
<tr><td>Približaj izbrani objekt</td><td><kbd>Numpad .</kbd></td></tr>
</table>
<div class="nasvet">Nimaš numeričnega dela tipkovnice? Pritisni <kbd>~</kbd> za meni s pogledi.</div>', 2),

(1, 'Izbiranje in transformacije',
'<p>Objekt izbereš z <b>levim klikom</b>. Nato ga lahko spreminjaš:</p>
<ul>
<li><kbd>G</kbd> – premik (Grab)</li>
<li><kbd>R</kbd> – vrtenje (Rotate)</li>
<li><kbd>S</kbd> – velikost (Scale)</li>
</ul>
<p>Po pritisku tipke lahko dodaš os: npr. <kbd>G</kbd> <kbd>Z</kbd> premika samo gor in dol. Lahko vtipkaš tudi številko: <kbd>R</kbd> <kbd>X</kbd> <kbd>9</kbd><kbd>0</kbd> zavrti za 90° okoli osi X.</p>', 3),

(2, 'Edit Mode: oglišča, robovi, ploskve',
'<p>S tipko <kbd>Tab</kbd> preklopiš med <b>Object Mode</b> in <b>Edit Mode</b>.</p>
<p>V Edit Mode urejaš posamezne dele mreže (mesh):</p>
<ul>
<li><kbd>1</kbd> – oglišča (vertices)</li>
<li><kbd>2</kbd> – robovi (edges)</li>
<li><kbd>3</kbd> – ploskve (faces)</li>
</ul>
<p>Tudi tukaj delujejo <kbd>G</kbd>, <kbd>R</kbd> in <kbd>S</kbd>.</p>', 1),

(2, 'Extrude, Inset in Loop Cut',
'<p>Tri najpogostejša orodja za modeliranje:</p>
<ul>
<li><kbd>E</kbd> <b>Extrude</b> – izvleče novo geometrijo iz izbrane ploskve.</li>
<li><kbd>I</kbd> <b>Inset</b> – naredi manjšo ploskev znotraj izbrane.</li>
<li><kbd>Ctrl</kbd>+<kbd>R</kbd> <b>Loop Cut</b> – doda nov obroč robov okoli objekta.</li>
</ul>
<div class="nasvet">Vaja: iz kocke z Inset in Extrude naredi preprosto skodelico.</div>', 2),

(2, 'Modifikatorji: Subdivision in Mirror',
'<p>Modifikatorji spremenijo objekt, ne da bi trajno spremenili geometrijo. Najdeš jih v Properties pod ikono ključa.</p>
<ul>
<li><b>Subdivision Surface</b> – zgladi objekt (bližnjica <kbd>Ctrl</kbd>+<kbd>1</kbd>, <kbd>2</kbd>, <kbd>3</kbd>).</li>
<li><b>Mirror</b> – zrcali objekt, da modeliraš samo polovico.</li>
</ul>', 3),

(3, 'UV razpiranje (UV Unwrap)',
'<p>Preden na objekt nališ teksturo, ga moraš "razpreti" v 2D – kot da bi razrezal škatlo in jo položil na mizo.</p>
<ol>
<li>V Edit Mode izberi vse z <kbd>A</kbd>.</li>
<li>Pritisni <kbd>U</kbd> in izberi <b>Smart UV Project</b>.</li>
<li>Rezultat poglej v zavihku <b>UV Editing</b>.</li>
</ol>', 1),

(3, 'Barvanje tekstur (Texture Paint)',
'<p>V zavihku <b>Texture Paint</b> lahko barvaš neposredno po objektu.</p>
<ul>
<li>Ustvari novo sliko teksture z gumbom <b>+</b> v panelu Texture Slots.</li>
<li><kbd>F</kbd> – velikost čopiča, <kbd>Shift</kbd>+<kbd>F</kbd> – moč.</li>
</ul>
<div class="nasvet">Ne pozabi shraniti slike: Image → Save, sicer se tekstura izgubi!</div>', 2),

(4, 'Materiali in Principled BSDF',
'<p>Material določa, kako objekt izgleda (barva, sijaj, prozornost).</p>
<ol>
<li>Izberi objekt in odpri zavihek <b>Material</b> v Properties.</li>
<li>Klikni <b>New</b>.</li>
<li>Spreminjaj <b>Base Color</b>, <b>Roughness</b> (hrapavost) in <b>Metallic</b>.</li>
</ol>', 1),

(4, 'Svetloba in prvi render',
'<p>Brez svetlobe je scena temna. Dodaj luč z <kbd>Shift</kbd>+<kbd>A</kbd> → Light.</p>
<ul>
<li><b>Eevee</b> – hiter, primeren za predogled.</li>
<li><b>Cycles</b> – počasnejši, a bolj realističen.</li>
</ul>
<p>Sliko upodobiš s <kbd>F12</kbd>, shraniš pa z Image → Save As.</p>', 2),

(5, 'Uvod v Sculpt Mode',
'<p>Kiparjenje je kot delo z glino. Najprej dodaj kroglo (<kbd>Shift</kbd>+<kbd>A</kbd> → Mesh → UV Sphere) in preklopi v <b>Sculpt Mode</b>.</p>
<ul>
<li><b>Draw</b> – dviguje površino.</li>
<li><b>Grab</b> – vleče večje dele.</li>
<li><kbd>Ctrl</kbd> – obrne učinek, <kbd>Shift</kbd> – zgladi.</li>
</ul>', 1),

(5, 'Dyntopo in Remesh',
'<p>Ko kiparim podrobnosti, potrebujemo več geometrije.</p>
<ul>
<li><b>Remesh</b> (<kbd>Ctrl</kbd>+<kbd>R</kbd> v Sculpt Mode) – enakomerno prerazporedi mrežo.</li>
<li><b>Dyntopo</b> – sproti dodaja geometrijo tam, kjer kipariš.</li>
</ul>', 2),

(6, 'Projekt 1: Stilizirana hiša',
'<p>Uporabi osnove modeliranja in postavitve.</p>
<ol>
<li>Iz kocke naredi telo hiše (<kbd>S</kbd> <kbd>Z</kbd> za višino).</li>
<li>Streho naredi iz druge kocke: v Edit Mode izberi zgornji rob in ga zmanjšaj.</li>
<li>Z Inset in Extrude naredi okna in vrata.</li>
<li>Dodaj materiale in upodobi sliko s <kbd>F12</kbd>.</li>
</ol>
<p>Ko končaš modul, naloži svojo sliko v <a href="galerija.php">galerijo</a>!</p>', 1),

(6, 'Projekt 2: Karakter',
'<p>Kiparjenje preprostega lika.</p>
<ol>
<li>Začni s kroglo in modifikatorjem Mirror.</li>
<li>V Sculpt Mode z Grab oblikuj glavo in telo.</li>
<li>S čopičem Draw dodaj nos, ušesa in oči.</li>
<li>Uporabi Remesh za gladko površino.</li>
</ol>', 2),

(6, 'Projekt 3: Zunanja scena',
'<p>Združi vse naučeno v zaključni izdelek.</p>
<ol>
<li>Naredi tla (Plane) in nekaj objektov (drevesa, kamni, hiša iz projekta 1).</li>
<li>UV razpri objekte in jim dodaj teksture.</li>
<li>Postavi sonce (Sun light) in kamero.</li>
<li>Upodobi končno sliko v Cycles.</li>
</ol>', 3);

INSERT INTO bliznjica (tipka, opis, kategorija) VALUES
('Tab', 'Preklop med Object Mode in Edit Mode', 'Splošno'),
('F3', 'Iskanje ukazov', 'Splošno'),
('Ctrl + Z', 'Razveljavi', 'Splošno'),
('Ctrl + S', 'Shrani datoteko', 'Splošno'),
('N', 'Odpre/zapre stranski panel', 'Splošno'),
('Shift + A', 'Dodaj nov objekt', 'Splošno'),
('Numpad 1 / 3 / 7', 'Pogled spredaj / desno / zgoraj', 'Navigacija'),
('Numpad 5', 'Perspektiva / ortografski pogled', 'Navigacija'),
('Numpad .', 'Približaj izbrani objekt', 'Navigacija'),
('Home', 'Pokaži vse objekte', 'Navigacija'),
('G', 'Premik (Grab)', 'Transformacije'),
('R', 'Vrtenje (Rotate)', 'Transformacije'),
('S', 'Spreminjanje velikosti (Scale)', 'Transformacije'),
('X / Y / Z', 'Omejitev na os med transformacijo', 'Transformacije'),
('Shift + D', 'Podvoji objekt', 'Transformacije'),
('Alt + G / R / S', 'Ponastavi položaj / vrtenje / velikost', 'Transformacije'),
('1 / 2 / 3', 'Izbira oglišč / robov / ploskev (Edit Mode)', 'Modeliranje'),
('E', 'Extrude', 'Modeliranje'),
('I', 'Inset', 'Modeliranje'),
('Ctrl + R', 'Loop Cut', 'Modeliranje'),
('Ctrl + B', 'Bevel (posneti rob)', 'Modeliranje'),
('K', 'Knife (nož)', 'Modeliranje'),
('M', 'Merge (združi oglišča)', 'Modeliranje'),
('Ctrl + J', 'Združi objekte', 'Modeliranje'),
('U', 'UV Unwrap meni', 'Teksturiranje'),
('F', 'Velikost čopiča', 'Kiparjenje'),
('Shift + F', 'Moč čopiča', 'Kiparjenje'),
('Z', 'Meni za način prikaza (Solid, Material, Rendered)', 'Senčenje'),
('F12', 'Upodobi sliko (Render)', 'Senčenje');

-- Slike in animacije lekcij (upodobljene v Blenderju)
UPDATE lekcija SET slika_gif = 'img/lekcije/zacetna_scena.jpg' WHERE id = 1;
UPDATE lekcija SET slika_gif = 'img/lekcije/gif_premikanje.gif' WHERE id = 2;
UPDATE lekcija SET slika_gif = 'img/lekcije/gif_transformacije.gif' WHERE id = 3;
UPDATE lekcija SET slika_gif = 'img/lekcije/edit_mode.jpg' WHERE id = 4;
UPDATE lekcija SET slika_gif = 'img/lekcije/gif_extrude.gif' WHERE id = 5;
UPDATE lekcija SET slika_gif = 'img/lekcije/gif_subdivision.gif' WHERE id = 6;
UPDATE lekcija SET slika_gif = 'img/lekcije/teksturiranje.jpg' WHERE id = 7;
UPDATE lekcija SET slika_gif = 'img/lekcije/barvanje.jpg' WHERE id = 8;
UPDATE lekcija SET slika_gif = 'img/lekcije/gif_materiali.gif' WHERE id = 9;
UPDATE lekcija SET slika_gif = 'img/lekcije/luci.jpg' WHERE id = 10;
UPDATE lekcija SET slika_gif = 'img/lekcije/kiparjenje.jpg' WHERE id = 11;
UPDATE lekcija SET slika_gif = 'img/lekcije/gif_kiparjenje.gif' WHERE id = 12;
UPDATE lekcija SET slika_gif = 'img/lekcije/projekt_hisa.jpg' WHERE id = 13;
UPDATE lekcija SET slika_gif = 'img/lekcije/projekt_karakter.jpg' WHERE id = 14;
UPDATE lekcija SET slika_gif = 'img/lekcije/projekt_scena.jpg' WHERE id = 15;
