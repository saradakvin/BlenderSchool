<?php
// Nastavitve povezave s podatkovno bazo.
// XAMPP privzeto: uporabnik "root", brez gesla.
// Na InfinityFree vpiši podatke iz nadzorne plošče (MySQL Databases).
$DB_HOST = 'localhost';
$DB_IME  = 'blenderschool';
$DB_UPORABNIK = 'root';
$DB_GESLO = '';

session_start();

try {
    $pdo = new PDO(
        "mysql:host=$DB_HOST;dbname=$DB_IME;charset=utf8mb4",
        $DB_UPORABNIK,
        $DB_GESLO,
        [
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        ]
    );
} catch (PDOException $e) {
    die('Napaka pri povezavi z bazo: ' . $e->getMessage());
}

require_once __DIR__ . '/includes/funkcije.php';
