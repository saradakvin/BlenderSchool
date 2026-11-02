<?php
require 'config.php';

$napake = [];
$ime = '';
$email = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $ime = trim($_POST['uporabnisko_ime'] ?? '');
    $email = trim($_POST['email'] ?? '');
    $geslo = $_POST['geslo'] ?? '';
    $geslo2 = $_POST['geslo2'] ?? '';

    // Preverjanje vnosov
    if (strlen($ime) < 3) $napake[] = 'Uporabniško ime mora imeti vsaj 3 znake.';
    if (!filter_var($email, FILTER_VALIDATE_EMAIL)) $napake[] = 'E-poštni naslov ni veljaven.';
    if (strlen($geslo) < 6) $napake[] = 'Geslo mora imeti vsaj 6 znakov.';
    if ($geslo !== $geslo2) $napake[] = 'Gesli se ne ujemata.';

    if (!$napake) {
        $stmt = $pdo->prepare('SELECT COUNT(*) FROM uporabnik WHERE uporabnisko_ime = ? OR email = ?');
        $stmt->execute([$ime, $email]);
        if ($stmt->fetchColumn() > 0) {
            $napake[] = 'Uporabniško ime ali e-pošta že obstaja.';
        }
    }

    if (!$napake) {
        // Geslo shranimo kot bcrypt hash
        $hash = password_hash($geslo, PASSWORD_BCRYPT);
        $stmt = $pdo->prepare('INSERT INTO uporabnik (uporabnisko_ime, email, geslo_hash) VALUES (?, ?, ?)');
        $stmt->execute([$ime, $email, $hash]);

        // Takoj prijavimo novega uporabnika
        $_SESSION['uporabnik_id'] = $pdo->lastInsertId();
        $_SESSION['uporabnisko_ime'] = $ime;
        header('Location: lekcija.php');
        exit;
    }
}

$naslov_strani = 'Registracija';
include 'includes/glava.php';
?>
<main class="obrazec-okvir">
    <h1>Registracija</h1>
    <?php foreach ($napake as $n): ?>
        <div class="napaka"><?= e($n) ?></div>
    <?php endforeach; ?>
    <form method="post">
        <label>Uporabniško ime
            <input type="text" name="uporabnisko_ime" value="<?= e($ime) ?>" required>
        </label>
        <label>E-pošta
            <input type="email" name="email" value="<?= e($email) ?>" required>
        </label>
        <label>Geslo
            <input type="password" name="geslo" required minlength="6">
        </label>
        <label>Ponovi geslo
            <input type="password" name="geslo2" required minlength="6">
        </label>
        <button type="submit" class="gumb">Ustvari račun</button>
    </form>
    <p>Že imaš račun? <a href="prijava.php">Prijavi se</a>.</p>
</main>
<?php include 'includes/noga.php'; ?>
