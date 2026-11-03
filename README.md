# BlenderSchool

A W3Schools-style website for learning Blender as a complete beginner, with progress tracking in an SQL database.

**Author:** Sara Šmon · school project 2026

## Two versions

| Version | Where | Database |
|---|---|---|
| **Web (GitHub Pages)** | repository root (`index.html`) | SQLite running in the browser (sql.js), saved in IndexedDB |
| **Server (PHP)** | `php/` folder | MySQL, runs in XAMPP (see `php/README.md`) |

Both use the same tables and the same SQL queries. GitHub Pages cannot run PHP or MySQL, so the web version runs the database inside the browser. Every visitor has their own database that stays saved in their browser.

Test account: **luka17** / **demo123**

## Features

- Sign up and log in (passwords are hashed: PBKDF2 in the web version, bcrypt in PHP)
- 6 modules and 18 lessons that teach real tool use (exact keys, settings and exercises), sidebar, Previous/Next
- 4 guided projects (coffee mug, little house, snowman, cute cottage) with a rendered picture for every step and a finished `.blend` file to compare
- "Mark as complete" button and progress percentage
- Profile with progress per module
- Cheat sheet with 54 shortcuts, search and category filters
- Gallery: uploading unlocks at 100% of a module (JPG/PNG only, max 5 MB), comments
- **SQL database** page: see all tables and run SELECT queries live
- Animations: page transitions, reveal on scroll, counters, confetti, toasts

All 3D images, GIFs and project step images were rendered in Blender 5.0 (Cycles) for this project.

## Structure

```
index.html          main page
css/style.css       styles
js/db.js            SQLite database, saving, passwords
js/app.js           pages and app logic
js/animacije.js     animations
js/vendor/          sql.js (SQLite for the browser, MIT license)
db/database.sql     tables and lesson content
img/lekcije/        lesson images and GIFs
img/projekti/       step-by-step project images
files/              finished .blend files for the projects
php/                PHP + MySQL version
```

## Data model

- `uporabnik` (user) 1:N `napredek` (progress) N:1 `lekcija` (lesson) N:1 `modul` (module)
- `uporabnik` 1:N `objava` (post) 1:N `komentar` (comment)
- `bliznjica` (shortcut, standalone table)

Progress is calculated live: completed lessons / all lessons × 100.
