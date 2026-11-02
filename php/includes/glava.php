<?php // Glava strani: zgornja navigacijska vrstica. Pred vključitvijo nastavi $naslov_strani. ?>
<!DOCTYPE html>
<html lang="sl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?= e($naslov_strani ?? 'BlenderSchool') ?> – BlenderSchool</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
<header class="zgornja-vrstica">
    <a href="index.php" class="logo">Blender<span>School</span></a>
    <nav>
        <a href="lekcija.php">Lekcije</a>
        <a href="bliznjice.php">Bližnjice</a>
        <a href="galerija.php">Galerija</a>
        <?php if (je_prijavljen()): ?>
            <a href="profil.php">👤 <?= e($_SESSION['uporabnisko_ime']) ?></a>
            <a href="odjava.php" class="gumb-mali">Odjava</a>
        <?php else: ?>
            <a href="prijava.php">Prijava</a>
            <a href="registracija.php" class="gumb-mali">Registracija</a>
        <?php endif; ?>
    </nav>
</header>
