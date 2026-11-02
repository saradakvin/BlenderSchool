<?php
require 'config.php';

$napaka = '';
$ime = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $ime = trim($_POST['uporabnisko_ime'] ?? '');
    $geslo = $_POST['geslo'] ?? '';

    // Prijava je možna z uporabniškim imenom ali e-pošto
    $stmt = $pdo->prepare('SELECT * FROM uporabnik WHERE uporabnisko_ime = ? OR email = ?');
    $stmt->execute([$ime, $ime]);
    $uporabnik = $stmt->fetch();

    if ($uporabnik && password_verify($geslo, $uporabnik['geslo_hash'])) {
        session_regenerate_id(true);
        $_SESSION['uporabnik_id'] = $uporabnik['id'];
        $_SESSION['uporabnisko_ime'] = $uporabnik['uporabnisko_ime'];
        header('Location: lekcija.php');
        exit;
    }
    $napaka = 'Napačno uporabniško ime ali geslo.';
}

$naslov_strani = 'Prijava';
include 'includes/glava.php';
?>
<main class="obrazec-okvir">
    <h1>Prijava</h1>
    <?php if ($napaka): ?><div class="napaka"><?= e($napaka) ?></div><?php endif; ?>
    <form method="post">
        <label>Uporabniško ime ali e-pošta
            <input type="text" name="uporabnisko_ime" value="<?= e($ime) ?>" required>
        </label>
        <label>Geslo
            <input type="password" name="geslo" required>
        </label>
        <button type="submit" class="gumb">Prijava</button>
    </form>
    <p>Nimaš računa? <a href="registracija.php">Registriraj se</a>.</p>
</main>
<?php include 'includes/noga.php'; ?>
