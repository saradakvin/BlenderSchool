<?php
require 'config.php';

$id = (int)($_GET['id'] ?? 0);
$stmt = $pdo->prepare(
    'SELECT o.*, u.uporabnisko_ime, m.naslov AS modul FROM objava o
     JOIN uporabnik u ON u.id = o.id_uporabnika
     JOIN modul m ON m.id = o.id_modula WHERE o.id = ?'
);
$stmt->execute([$id]);
$objava = $stmt->fetch();
if (!$objava) {
    http_response_code(404);
    die('Objava ne obstaja.');
}

// Dodajanje komentarja
if ($_SERVER['REQUEST_METHOD'] === 'POST' && je_prijavljen()) {
    $besedilo = trim($_POST['besedilo'] ?? '');
    if ($besedilo !== '') {
        $stmt = $pdo->prepare('INSERT INTO komentar (id_objave, id_uporabnika, besedilo) VALUES (?, ?, ?)');
        $stmt->execute([$id, $_SESSION['uporabnik_id'], $besedilo]);
    }
    header('Location: objava.php?id=' . $id);
    exit;
}

$stmt = $pdo->prepare(
    'SELECT k.*, u.uporabnisko_ime FROM komentar k
     JOIN uporabnik u ON u.id = k.id_uporabnika
     WHERE k.id_objave = ? ORDER BY k.datum'
);
$stmt->execute([$id]);
$komentarji = $stmt->fetchAll();

$naslov_strani = 'Objava';
include 'includes/glava.php';
?>
<main class="vsebina-siroka ozka">
    <p><a href="galerija.php">« Nazaj na galerijo</a></p>
    <img class="velika-slika" src="<?= e($objava['pot_do_slike']) ?>" alt="">
    <p><b><?= e($objava['uporabnisko_ime']) ?></b> · <span class="oznaka"><?= e($objava['modul']) ?></span>
        · <small><?= date('d. m. Y', strtotime($objava['datum'])) ?></small></p>
    <p><?= nl2br(e($objava['besedilo'])) ?></p>

    <h2>Komentarji (<?= count($komentarji) ?>)</h2>
    <?php foreach ($komentarji as $k): ?>
        <div class="komentar">
            <b><?= e($k['uporabnisko_ime']) ?></b> <small><?= date('d. m. Y H:i', strtotime($k['datum'])) ?></small>
            <p><?= nl2br(e($k['besedilo'])) ?></p>
        </div>
    <?php endforeach; ?>

    <?php if (je_prijavljen()): ?>
        <form method="post" class="obrazec-komentar">
            <textarea name="besedilo" rows="3" placeholder="Napiši komentar …" required></textarea>
            <button type="submit" class="gumb">Objavi komentar</button>
        </form>
    <?php else: ?>
        <p><a href="prijava.php">Prijavi se</a> za komentiranje.</p>
    <?php endif; ?>
</main>
<?php include 'includes/noga.php'; ?>
