<?php
require 'config.php';

// Katero lekcijo prikažemo? ?id=… ali prva lekcija iz ?modul=… ali prva lekcija nasploh
if (isset($_GET['id'])) {
    $stmt = $pdo->prepare('SELECT * FROM lekcija WHERE id = ?');
    $stmt->execute([(int)$_GET['id']]);
} elseif (isset($_GET['modul'])) {
    $stmt = $pdo->prepare('SELECT * FROM lekcija WHERE id_modula = ? ORDER BY vrstni_red LIMIT 1');
    $stmt->execute([(int)$_GET['modul']]);
} else {
    $stmt = $pdo->query(
        'SELECT l.* FROM lekcija l JOIN modul m ON m.id = l.id_modula
         ORDER BY m.vrstni_red, l.vrstni_red LIMIT 1'
    );
}
$lekcija = $stmt->fetch();
if (!$lekcija) {
    http_response_code(404);
    die('Lekcija ne obstaja.');
}

$moduli = vsi_moduli_z_lekcijami($pdo);

// Vse lekcije po vrsti, da najdemo prejšnjo in naslednjo
$vrsta = [];
foreach ($moduli as $m) {
    foreach ($m['lekcije'] as $l) $vrsta[] = $l['id'];
}
$poz = array_search($lekcija['id'], $vrsta);
$prejsnja = $vrsta[$poz - 1] ?? null;
$naslednja = $vrsta[$poz + 1] ?? null;

$dokoncane = je_prijavljen() ? dokoncane_lekcije($pdo, $_SESSION['uporabnik_id']) : [];
$je_dokoncana = in_array($lekcija['id'], $dokoncane);

$naslov_strani = $lekcija['naslov'];
include 'includes/glava.php';
?>
<div class="postavitev">
    <!-- Levi meni v stilu W3Schools -->
    <aside class="levi-meni">
        <?php foreach ($moduli as $m): ?>
            <h4><?= e($m['naslov']) ?></h4>
            <?php foreach ($m['lekcije'] as $l): ?>
                <a href="lekcija.php?id=<?= $l['id'] ?>"
                   class="<?= $l['id'] == $lekcija['id'] ? 'aktivna' : '' ?>">
                    <?= in_array($l['id'], $dokoncane) ? '✔' : '' ?>
                    <?= e($l['naslov']) ?>
                </a>
            <?php endforeach; ?>
        <?php endforeach; ?>
    </aside>

    <main class="lekcija">
        <?php if (je_prijavljen()):
            $skupaj = odstotek_napredka($pdo, $_SESSION['uporabnik_id']); ?>
            <div class="napredek-glava">
                Napredek tečaja: <b id="odstotek"><?= $skupaj ?></b> %
                <div class="vrstica-napredka"><div id="vrstica" style="width: <?= $skupaj ?>%"></div></div>
            </div>
        <?php endif; ?>

        <div class="navigacija-lekcij">
            <?php if ($prejsnja): ?><a class="gumb" href="lekcija.php?id=<?= $prejsnja ?>">« Prejšnja</a><?php endif; ?>
            <?php if ($naslednja): ?><a class="gumb desno" href="lekcija.php?id=<?= $naslednja ?>">Naslednja »</a><?php endif; ?>
        </div>

        <h1><?= e($lekcija['naslov']) ?></h1>

        <?php if ($lekcija['slika_gif']): ?>
            <img class="gif" src="<?= e($lekcija['slika_gif']) ?>" alt="<?= e($lekcija['naslov']) ?>">
        <?php else: ?>
            <div class="gif-prostor">Prostor za GIF / sliko (stolpec slika_gif v tabeli lekcija)</div>
        <?php endif; ?>

        <!-- Vsebina lekcije je HTML iz baze, ki ga vnese avtor -->
        <div class="besedilo"><?= $lekcija['vsebina'] ?></div>

        <?php if (je_prijavljen()): ?>
            <form method="post" action="dokoncaj.php" id="obrazec-dokoncaj">
                <input type="hidden" name="id_lekcije" value="<?= $lekcija['id'] ?>">
                <button type="submit" id="gumb-dokoncaj" class="gumb gumb-velik <?= $je_dokoncana ? 'dokoncano' : '' ?>">
                    <?= $je_dokoncana ? '✔ Dokončano' : 'Označi kot dokončano' ?>
                </button>
            </form>
        <?php else: ?>
            <p class="nasvet"><a href="prijava.php">Prijavi se</a>, da se tvoj napredek shranjuje.</p>
        <?php endif; ?>

        <div class="navigacija-lekcij">
            <?php if ($prejsnja): ?><a class="gumb" href="lekcija.php?id=<?= $prejsnja ?>">« Prejšnja</a><?php endif; ?>
            <?php if ($naslednja): ?><a class="gumb desno" href="lekcija.php?id=<?= $naslednja ?>">Naslednja »</a><?php endif; ?>
        </div>
    </main>
</div>
<?php include 'includes/noga.php'; ?>
