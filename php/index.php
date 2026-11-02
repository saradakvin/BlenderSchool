<?php
require 'config.php';
$moduli = $pdo->query('SELECT * FROM modul ORDER BY vrstni_red')->fetchAll();

$naslov_strani = 'Domov';
include 'includes/glava.php';
?>
<section class="hero">
    <h1>Nauči se Blenderja korak za korakom</h1>
    <p>Kratke in jasne lekcije za začetnike, cheat sheet z bližnjicami in trije vodeni projekti. Tvoj napredek se sproti shranjuje.</p>
    <a href="lekcija.php" class="gumb gumb-velik">Začni z učenjem »</a>
</section>

<main class="vsebina-siroka">
    <h2>Moduli</h2>
    <div class="mreza-kartic">
        <?php foreach ($moduli as $m): ?>
            <a class="kartica" href="lekcija.php?modul=<?= $m['id'] ?>">
                <h3><?= e($m['naslov']) ?></h3>
                <p><?= e($m['opis']) ?></p>
                <?php if (je_prijavljen()):
                    $p = odstotek_napredka($pdo, $_SESSION['uporabnik_id'], $m['id']); ?>
                    <div class="vrstica-napredka"><div style="width: <?= $p ?>%"></div></div>
                    <small><?= $p ?> % dokončano</small>
                <?php endif; ?>
            </a>
        <?php endforeach; ?>
    </div>
</main>
<?php include 'includes/noga.php'; ?>
