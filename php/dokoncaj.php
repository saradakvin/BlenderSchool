<?php
// Označi lekcijo kot dokončano ali ponovno nedokončano (preklop).
// JavaScript ga kliče s fetch() in dobi JSON; brez JS pa preusmeri nazaj na lekcijo.
require 'config.php';
zahtevaj_prijavo();

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    header('Location: lekcija.php');
    exit;
}

$id_uporabnika = $_SESSION['uporabnik_id'];
$id_lekcije = (int)($_POST['id_lekcije'] ?? 0);

$stmt = $pdo->prepare('SELECT id_modula FROM lekcija WHERE id = ?');
$stmt->execute([$id_lekcije]);
$id_modula = $stmt->fetchColumn();
if (!$id_modula) {
    http_response_code(404);
    exit('Lekcija ne obstaja.');
}

if (in_array($id_lekcije, dokoncane_lekcije($pdo, $id_uporabnika))) {
    $stmt = $pdo->prepare('DELETE FROM napredek WHERE id_uporabnika = ? AND id_lekcije = ?');
    $stmt->execute([$id_uporabnika, $id_lekcije]);
    $dokoncana = false;
} else {
    $stmt = $pdo->prepare('INSERT INTO napredek (id_uporabnika, id_lekcije) VALUES (?, ?)');
    $stmt->execute([$id_uporabnika, $id_lekcije]);
    $dokoncana = true;
}

if (!empty($_SERVER['HTTP_X_REQUESTED_WITH'])) {
    header('Content-Type: application/json');
    echo json_encode([
        'dokoncana' => $dokoncana,
        'odstotek' => odstotek_napredka($pdo, $id_uporabnika),
        'odstotek_modula' => odstotek_napredka($pdo, $id_uporabnika, $id_modula),
    ]);
} else {
    header('Location: lekcija.php?id=' . $id_lekcije);
}
