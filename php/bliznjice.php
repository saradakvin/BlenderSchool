<?php
require 'config.php';
$bliznjice = $pdo->query('SELECT * FROM bliznjica ORDER BY kategorija, id')->fetchAll();

$naslov_strani = 'Cheat sheet bližnjic';
include 'includes/glava.php';
?>
<main class="vsebina-siroka">
    <h1>Cheat sheet: Blender bližnjice</h1>
    <p>Vpiši tipko ali opis, da hitro najdeš bližnjico.</p>
    <input type="search" id="iskalnik" class="iskalnik" placeholder="Išči, npr. extrude ali Ctrl …" autofocus>

    <table class="tabela" id="tabela-bliznjic">
        <tr><th>Tipka</th><th>Opis</th><th>Kategorija</th></tr>
        <?php foreach ($bliznjice as $b): ?>
            <tr>
                <td><kbd><?= e($b['tipka']) ?></kbd></td>
                <td><?= e($b['opis']) ?></td>
                <td><span class="oznaka"><?= e($b['kategorija']) ?></span></td>
            </tr>
        <?php endforeach; ?>
    </table>
    <p id="ni-zadetkov" hidden>Ni zadetkov.</p>
</main>
<?php include 'includes/noga.php'; ?>
