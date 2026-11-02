<?php
require 'config.php';

$napaka = '';
$moduli = $pdo->query('SELECT * FROM modul ORDER BY vrstni_red')->fetchAll();

// Moduli, ki jih je prijavljen uporabnik dokončal 100 % (samo tam lahko oddaja sliko)
$dokoncani_moduli = [];
if (je_prijavljen()) {
    foreach ($moduli as $m) {
        if (odstotek_napredka($pdo, $_SESSION['uporabnik_id'], $m['id']) == 100) {
            $dokoncani_moduli[] = $m;
        }
    }
}

// Nalaganje slike
if ($_SERVER['REQUEST_METHOD'] === 'POST' && je_prijavljen()) {
    $id_modula = (int)($_POST['id_modula'] ?? 0);
    $besedilo = trim($_POST['besedilo'] ?? '');
    $datoteka = $_FILES['slika'] ?? null;
    $dovoljeni_tipi = ['image/jpeg' => 'jpg', 'image/png' => 'png'];

    if (!in_array($id_modula, array_column($dokoncani_moduli, 'id'))) {
        $napaka = 'Sliko lahko oddaš samo za modul, ki si ga dokončal/a 100 %.';
    } elseif (!$datoteka || $datoteka['error'] !== UPLOAD_ERR_OK) {
        $napaka = 'Napaka pri nalaganju datoteke.';
    } elseif ($datoteka['size'] > 5 * 1024 * 1024) {
        $napaka = 'Slika je prevelika (največ 5 MB).';
    } else {
        // Preverimo dejansko vsebino datoteke, ne le končnice
        $info = @getimagesize($datoteka['tmp_name']);
        $tip = $info['mime'] ?? '';
        if (!isset($dovoljeni_tipi[$tip])) {
            $napaka = 'Dovoljeni so samo JPG in PNG.';
        } else {
            $ime = 'uploads/' . bin2hex(random_bytes(8)) . '.' . $dovoljeni_tipi[$tip];
            move_uploaded_file($datoteka['tmp_name'], __DIR__ . '/' . $ime);
            $stmt = $pdo->prepare('INSERT INTO objava (id_uporabnika, id_modula, pot_do_slike, besedilo) VALUES (?, ?, ?, ?)');
            $stmt->execute([$_SESSION['uporabnik_id'], $id_modula, $ime, $besedilo]);
            header('Location: objava.php?id=' . $pdo->lastInsertId());
            exit;
        }
    }
}

$objave = $pdo->query(
    'SELECT o.*, u.uporabnisko_ime, m.naslov AS modul,
            (SELECT COUNT(*) FROM komentar k WHERE k.id_objave = o.id) AS st_komentarjev
     FROM objava o
     JOIN uporabnik u ON u.id = o.id_uporabnika
     JOIN modul m ON m.id = o.id_modula
     ORDER BY o.datum DESC'
)->fetchAll();

$naslov_strani = 'Galerija';
include 'includes/glava.php';
?>
<main class="vsebina-siroka">
    <h1>Galerija izdelkov</h1>

    <?php if (!je_prijavljen()): ?>
        <p class="nasvet"><a href="prijava.php">Prijavi se</a> in dokončaj modul, da lahko naložiš svoj izdelek.</p>
    <?php elseif (!$dokoncani_moduli): ?>
        <p class="nasvet">🔒 Nalaganje slike se odklene, ko dokončaš vse lekcije v vsaj enem modulu.</p>
    <?php else: ?>
        <div class="obrazec-okvir levo">
            <h2>Naloži svoj izdelek</h2>
            <?php if ($napaka): ?><div class="napaka"><?= e($napaka) ?></div><?php endif; ?>
            <form method="post" enctype="multipart/form-data">
                <label>Modul
                    <select name="id_modula">
                        <?php foreach ($dokoncani_moduli as $m): ?>
                            <option value="<?= $m['id'] ?>"><?= e($m['naslov']) ?></option>
                        <?php endforeach; ?>
                    </select>
                </label>
                <label>Slika (JPG ali PNG, največ 5 MB)
                    <input type="file" name="slika" accept="image/jpeg,image/png" required>
                </label>
                <label>Opis
                    <textarea name="besedilo" rows="3"></textarea>
                </label>
                <button type="submit" class="gumb">Objavi</button>
            </form>
        </div>
    <?php endif; ?>

    <div class="mreza-kartic">
        <?php foreach ($objave as $o): ?>
            <a class="kartica" href="objava.php?id=<?= $o['id'] ?>">
                <img src="<?= e($o['pot_do_slike']) ?>" alt="Izdelek uporabnika <?= e($o['uporabnisko_ime']) ?>">
                <b><?= e($o['uporabnisko_ime']) ?></b> · <span class="oznaka"><?= e($o['modul']) ?></span>
                <p><?= e($o['besedilo']) ?></p>
                <small>💬 <?= $o['st_komentarjev'] ?></small>
            </a>
        <?php endforeach; ?>
        <?php if (!$objave): ?><p>Ni še objav. Bodi prvi!</p><?php endif; ?>
    </div>
</main>
<?php include 'includes/noga.php'; ?>
