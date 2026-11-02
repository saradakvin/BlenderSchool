# BlenderSchool

Spletna stran za učenje Blenderja za začetnike v stilu W3Schools, s sledenjem napredku v SQL bazi.

**Avtorica:** Sara Šmon · šolski projekt 2026

## Dve različici

| Različica | Kje | Baza |
|---|---|---|
| **Spletna (GitHub Pages)** | koren repozitorija (`index.html`) | SQLite, ki teče v brskalniku (sql.js), shranjena v IndexedDB |
| **Strežniška (PHP)** | mapa `php/` | MySQL, za zagon v XAMPP (navodila v `php/README.md`) |

Obe uporabljata enake tabele in enake SQL poizvedbe. GitHub Pages ne zna poganjati PHP in MySQL, zato spletna različica bazo izvaja kar v brskalniku. Vsak obiskovalec ima svojo bazo, ki ostane shranjena v njegovem brskalniku.

Testni račun: **luka17** / **demo123**

## Funkcionalnosti

- Registracija in prijava (gesla so zgoščena: PBKDF2 v spletni, bcrypt v PHP različici)
- 6 modulov, 15 lekcij, levi meni, gumba Prejšnja/Naslednja
- Gumb »Označi kot dokončano« in odstotek napredka
- Profil z napredkom po modulih
- Cheat sheet z 29 bližnjicami in iskalnikom
- Galerija: nalaganje slike se odklene pri 100 % modula (samo JPG/PNG, do 5 MB), komentarji
- Stran **SQL baza**: pregled tabel in izvajanje SELECT poizvedb
- Animacije: prehodi med stranmi, razkrivanje ob drsenju, števci, konfeti ob dokončanem modulu, obvestila

Vse 3D slike in animacije (GIF) v lekcijah so upodobljene v Blenderju 5.0 (Cycles) posebej za ta projekt.

## Zgradba

```
index.html          glavna stran
css/style.css       izgled
js/db.js            SQLite baza, shranjevanje, gesla
js/app.js           strani in uporabniška logika
js/animacije.js     animacije (razkrivanje, števci, konfeti, obvestila)
js/vendor/          sql.js (SQLite za brskalnik, licenca MIT)
db/database.sql     tabele in začetni podatki
img/                slike in GIF-i lekcij (upodobljeni v Blenderju)
php/                PHP + MySQL različica
```

## Podatkovni model

- `uporabnik` 1:N `napredek` N:1 `lekcija` N:1 `modul`
- `uporabnik` 1:N `objava` 1:N `komentar`
- `bliznjica` (samostojna tabela)

Odstotek napredka se izračuna sproti: dokončane lekcije / vse lekcije × 100.
