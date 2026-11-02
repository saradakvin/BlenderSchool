# BlenderSchool

Spletna stran za učenje Blenderja za začetnike v stilu W3Schools, s sledenjem napredku v SQL bazi.

**Tehnologije:** PHP 8, MySQL/MariaDB, HTML, CSS, JavaScript (brez ogrodij).

## Zagon na računalniku (XAMPP)

1. Namesti [XAMPP](https://www.apachefriends.org/) in zaženi **Apache** in **MySQL**.
2. Mapo `blenderschool` skopiraj v `C:\xampp\htdocs\`.
3. Odpri `http://localhost/phpmyadmin` → **Uvozi** → izberi `database.sql` → **Izvedi**.
4. Odpri `http://localhost/blenderschool`.

Če ima tvoj MySQL geslo, ga vpiši v `config.php`.

## Objava na InfinityFree

1. V nadzorni plošči ustvari MySQL bazo in si zapiši host, ime baze, uporabnika in geslo.
2. V phpMyAdmin uvozi `database.sql`, a **prej izbriši prvi dve vrstici** (`CREATE DATABASE` in `USE`), ker baza že obstaja.
3. Podatke vpiši v `config.php`.
4. Vse datoteke naloži v mapo `htdocs` (preko File Managerja ali FTP).

## Zgradba

| Datoteka | Namen |
|---|---|
| `database.sql` | Tabele in vzorčni podatki (6 modulov, 15 lekcij, 29 bližnjic) |
| `config.php` | Povezava z bazo (PDO) in začetek seje |
| `includes/funkcije.php` | Pomožne funkcije (izračun napredka, preverjanje prijave) |
| `includes/glava.php`, `noga.php` | Skupna glava in noga vseh strani |
| `index.php` | Domača stran z moduli |
| `registracija.php`, `prijava.php`, `odjava.php` | Uporabniški računi (bcrypt gesla) |
| `lekcija.php` | Lekcija z levim menijem, gumbi Prejšnja/Naslednja |
| `dokoncaj.php` | Shrani/odstrani dokončano lekcijo, vrne JSON z odstotkom |
| `profil.php` | Napredek po modulih, zadnje lekcije, moje objave |
| `bliznjice.php` | Cheat sheet z iskalnikom |
| `galerija.php` | Nalaganje slik (odklene se pri 100 % modula, samo JPG/PNG do 5 MB) |
| `objava.php` | Posamezna objava s komentarji |
| `css/style.css`, `js/main.js` | Izgled in interaktivnost |
| `uploads/` | Naložene slike |

## Podatkovni model

- `uporabnik` 1:N `napredek` N:1 `lekcija` N:1 `modul`
- `uporabnik` 1:N `objava` 1:N `komentar`
- `bliznjica` (samostojna tabela)

Odstotek napredka se ne shranjuje, ampak izračuna: dokončane lekcije / vse lekcije × 100.

## Dodajanje vsebine

Novo lekcijo dodaš v phpMyAdmin v tabelo `lekcija` (vsebina je HTML). GIF ali sliko daš v mapo, npr. `img/`, in pot vpišeš v stolpec `slika_gif`.

## Varnost

- Gesla: `password_hash()` (bcrypt), nikoli v odkritem besedilu.
- SQL poizvedbe: pripravljeni stavki (prepared statements) proti SQL injection.
- Izpis: `htmlspecialchars()` proti XSS.
- Nalaganje: preverja se dejanska vsebina slike (`getimagesize`), naključno ime datoteke, PHP v `uploads/` je blokiran.
