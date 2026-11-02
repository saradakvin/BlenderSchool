<?php
// Pomožne funkcije, ki jih uporabljajo vse strani.

// Varen izpis besedila v HTML (prepreči XSS napade)
function e($besedilo) {
    return htmlspecialchars($besedilo ?? '', ENT_QUOTES, 'UTF-8');
}

function je_prijavljen() {
    return isset($_SESSION['uporabnik_id']);
}

// Če uporabnik ni prijavljen, ga preusmeri na prijavo
function zahtevaj_prijavo() {
    if (!je_prijavljen()) {
        header('Location: prijava.php');
        exit;
    }
}

// Seznam vseh modulov z lekcijami (za levi meni)
function vsi_moduli_z_lekcijami($pdo) {
    $moduli = $pdo->query('SELECT * FROM modul ORDER BY vrstni_red')->fetchAll();
    $lekcije = $pdo->query('SELECT id, id_modula, naslov FROM lekcija ORDER BY vrstni_red')->fetchAll();
    foreach ($moduli as &$m) {
        $m['lekcije'] = array_values(array_filter($lekcije, fn($l) => $l['id_modula'] == $m['id']));
    }
    return $moduli;
}

// ID-ji lekcij, ki jih je uporabnik že dokončal
function dokoncane_lekcije($pdo, $id_uporabnika) {
    $stmt = $pdo->prepare('SELECT id_lekcije FROM napredek WHERE id_uporabnika = ?');
    $stmt->execute([$id_uporabnika]);
    return $stmt->fetchAll(PDO::FETCH_COLUMN);
}

// Odstotek dokončanosti: za cel tečaj ali za en modul
function odstotek_napredka($pdo, $id_uporabnika, $id_modula = null) {
    if ($id_modula === null) {
        $vse = $pdo->query('SELECT COUNT(*) FROM lekcija')->fetchColumn();
        $stmt = $pdo->prepare('SELECT COUNT(*) FROM napredek WHERE id_uporabnika = ?');
        $stmt->execute([$id_uporabnika]);
    } else {
        $stmt = $pdo->prepare('SELECT COUNT(*) FROM lekcija WHERE id_modula = ?');
        $stmt->execute([$id_modula]);
        $vse = $stmt->fetchColumn();
        $stmt = $pdo->prepare(
            'SELECT COUNT(*) FROM napredek n JOIN lekcija l ON l.id = n.id_lekcije
             WHERE n.id_uporabnika = ? AND l.id_modula = ?'
        );
        $stmt->execute([$id_uporabnika, $id_modula]);
    }
    $dokoncane = $stmt->fetchColumn();
    return $vse > 0 ? round($dokoncane / $vse * 100) : 0;
}
