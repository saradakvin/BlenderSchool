<?php
require 'config.php';
zahtevaj_prijavo();

$id = $_SESSION['uporabnik_id'];
$stmt = $pdo->prepare('SELECT uporabnisko_ime, email, datum_registracije FROM uporabnik WHERE id = ?');
$stmt->execute([$id]);
$uporabnik = $stmt->fetch();

$moduli = $pdo->query('SELECT * FROM modul ORDER BY vrstni_red')->fetchAll();
$skupaj = odstotek_napredka($pdo, $id);

// Zadnje dokončane lekcije
$stmt = $pdo->prepare(
    'SELECT l.id, l.naslov, n.datum_dokoncanja FROM napredek n
     JOIN lekcija l ON l.id = n.id_lekcije
     WHERE n.id_uporabnika = ? ORDER BY n.datum_dokoncanja DESC LIMIT 5'
);
$stmt->execute([$id]);
$zadnje = $stmt->fetchAll();

// Moje objave
$stmt = $pdo->prepare('SELECT * FROM objava WHERE id_uporabnika = ? ORDER BY datum DESC');
$stmt->execute([$id]);
$objave = $stmt->fetchAll();

$naslov_strani = 'Moj profil';
include 'includes/glava.php';
?>
<main class="vsebina-siroka">
    <h1>👤 <?= e($uporabnik['uporabnisko_ime']) ?></h1>
    <p>E-pošta: <?= e($uporabnik['email']) ?> · Član od <?= date('d. m. Y', strtotime($uporabnik['datum_registracije'])) ?></p>

    <h2>Skupni napredek: <?= $skupaj ?> %</h2>
    <div class="vrstica-napredka velika"><div style="width: <?= $skupaj ?>%"></div></div>

    <h2>Napredek po modulih</h2>
    <table class="tabela">
        <tr><th>Modul</th><th>Napredek</th><th></th></tr>
        <?php foreach ($moduli as $m):
            $p = odstotek_napredka($pdo, $id, $m['id']); ?>
            <tr>
                <td><a href="lekcija.php?modul=<?= $m['id'] ?>"><?= e($m['naslov']) ?></a></td>
                <td style="width:50%"><div class="vrstica-napredka"><div style="width: <?= $p ?>%"></div></div></td>
                <td><?= $p ?> %<?= $p == 100 ? ' 🏆' : '' ?></td>
            </tr>
        <?php endforeach; ?>
    </table>

    <h2>Nazadnje dokončano</h2>
    <?php if (!$zadnje): ?>
        <p>Še nisi dokončal/a nobene lekcije. <a href="lekcija.php">Začni zdaj!</a></p>
    <?php else: ?>
        <ul>
            <?php foreach ($zadnje as $z): ?>
                <li><a href="lekcija.php?id=<?= $z['id'] ?>"><?= e($z['naslov']) ?></a>
                    <small>(<?= date('d. m. Y H:i', strtotime($z['datum_dokoncanja'])) ?>)</small></li>
            <?php endforeach; ?>
        </ul>
    <?php endif; ?>

    <h2>Moje objave</h2>
    <?php if (!$objave): ?>
        <p>Ko dokončaš modul, lahko v <a href="galerija.php">galerijo</a> naložiš sliko svojega izdelka.</p>
    <?php else: ?>
        <div class="mreza-kartic">
            <?php foreach ($objave as $o): ?>
                <a class="kartica" href="objava.php?id=<?= $o['id'] ?>">
                    <img src="<?= e($o['pot_do_slike']) ?>" alt="">
                    <p><?= e($o['besedilo']) ?></p>
                </a>
            <?php endforeach; ?>
        </div>
    <?php endif; ?>
</main>
<?php include 'includes/noga.php'; ?>
