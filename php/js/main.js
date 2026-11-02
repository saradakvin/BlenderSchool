// 1) Gumb "Označi kot dokončano": shrani napredek brez ponovnega nalaganja strani
const obrazec = document.getElementById('obrazec-dokoncaj');
if (obrazec) {
    obrazec.addEventListener('submit', async (dogodek) => {
        dogodek.preventDefault();
        const gumb = document.getElementById('gumb-dokoncaj');
        gumb.disabled = true;

        const odgovor = await fetch('dokoncaj.php', {
            method: 'POST',
            body: new FormData(obrazec),
            headers: { 'X-Requested-With': 'fetch' }
        });
        const podatki = await odgovor.json();

        gumb.textContent = podatki.dokoncana ? '✔ Dokončano' : 'Označi kot dokončano';
        gumb.classList.toggle('dokoncano', podatki.dokoncana);
        gumb.disabled = false;
        document.getElementById('odstotek').textContent = podatki.odstotek;
        document.getElementById('vrstica').style.width = podatki.odstotek + '%';

        // Kljukica v levem meniju
        const povezava = document.querySelector('.levi-meni a.aktivna');
        const besedilo = povezava.textContent.replace('✔', '').trim();
        povezava.textContent = (podatki.dokoncana ? '✔ ' : '') + besedilo;

        if (podatki.dokoncana && podatki.odstotek_modula === 100) {
            alert('🏆 Bravo! Dokončal/a si cel modul. V galeriji lahko zdaj naložiš svoj izdelek.');
        }
    });
}

// 2) Iskalnik v cheat sheetu
const iskalnik = document.getElementById('iskalnik');
if (iskalnik) {
    iskalnik.addEventListener('input', () => {
        const iskano = iskalnik.value.toLowerCase();
        let zadetki = 0;
        document.querySelectorAll('#tabela-bliznjic tr:not(:first-child)').forEach((vrstica) => {
            const ujema = vrstica.textContent.toLowerCase().includes(iskano);
            vrstica.hidden = !ujema;
            if (ujema) zadetki++;
        });
        document.getElementById('ni-zadetkov').hidden = zadetki > 0;
    });
}
