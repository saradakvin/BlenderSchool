// ===================================================================
// Animacije: razkrivanje ob drsenju, števci, obvestila, konfeti
// ===================================================================

const zmanjsanoGibanje = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

// Elementi z razredom .razkrij se pokažejo, ko pridejo v vidno polje
const opazovalec = new IntersectionObserver((vnosi) => {
    vnosi.forEach((v) => {
        if (v.isIntersecting) {
            v.target.classList.add('vidno');
            opazovalec.unobserve(v.target);
        }
    });
}, { threshold: 0.12 });

function sprozRazkrivanje() {
    document.querySelectorAll('.razkrij:not(.vidno)').forEach((el) => opazovalec.observe(el));
}

// Števci, ki naraščajo od 0 do ciljne številke
function animirajStevce() {
    document.querySelectorAll('[data-stevec]').forEach((el) => {
        const cilj = Number(el.dataset.stevec);
        if (zmanjsanoGibanje) { el.textContent = cilj; return; }
        const zacetek = performance.now();
        const korak = (zdaj) => {
            const t = Math.min((zdaj - zacetek) / 1200, 1);
            el.textContent = Math.round(cilj * (1 - Math.pow(1 - t, 3)));
            if (t < 1) requestAnimationFrame(korak);
        };
        requestAnimationFrame(korak);
    });
}

// Vrstice napredka se napolnijo od 0 do svoje vrednosti
function animirajVrstice() {
    document.querySelectorAll('.vrstica-napredka div[data-sirina]').forEach((el) => {
        el.style.width = '0%';
        requestAnimationFrame(() => requestAnimationFrame(() => { el.style.width = el.dataset.sirina + '%'; }));
    });
    document.querySelectorAll('.krog-napredka .polnilo').forEach((el) => {
        const obseg = 2 * Math.PI * 55;
        el.style.strokeDasharray = obseg;
        el.style.strokeDashoffset = obseg;
        requestAnimationFrame(() => requestAnimationFrame(() => {
            el.style.strokeDashoffset = obseg * (1 - Number(el.dataset.odstotek) / 100);
        }));
    });
}

// Obvestilo v spodnjem desnem kotu (namesto alert)
function obvestilo(besedilo, trajanje = 3500) {
    const el = document.createElement('div');
    el.className = 'obvestilo';
    el.innerHTML = besedilo;
    document.getElementById('obvestila').appendChild(el);
    setTimeout(() => {
        el.classList.add('ven');
        el.addEventListener('animationend', () => el.remove());
    }, trajanje);
}

// Konfeti ob dokončanem modulu
function konfeti() {
    if (zmanjsanoGibanje) return;
    const platno = document.getElementById('konfeti');
    const ctx = platno.getContext('2d');
    platno.width = innerWidth;
    platno.height = innerHeight;
    const barve = ['#ffa33a', '#ff6a2b', '#ff4d4d', '#22c55e', '#4f8cff', '#ffd23f'];
    const delci = Array.from({ length: 160 }, () => ({
        x: innerWidth / 2 + (Math.random() - 0.5) * 200,
        y: innerHeight * 0.55,
        vx: (Math.random() - 0.5) * 16,
        vy: -Math.random() * 18 - 6,
        r: Math.random() * 6 + 4,
        kot: Math.random() * Math.PI,
        vrt: (Math.random() - 0.5) * 0.3,
        barva: barve[Math.floor(Math.random() * barve.length)],
    }));
    let okvir = 0;
    const risi = () => {
        ctx.clearRect(0, 0, platno.width, platno.height);
        delci.forEach((d) => {
            d.vy += 0.45; d.vx *= 0.99; d.x += d.vx; d.y += d.vy; d.kot += d.vrt;
            ctx.save();
            ctx.translate(d.x, d.y);
            ctx.rotate(d.kot);
            ctx.fillStyle = d.barva;
            ctx.fillRect(-d.r / 2, -d.r / 4, d.r, d.r / 2);
            ctx.restore();
        });
        if (++okvir < 160) requestAnimationFrame(risi);
        else ctx.clearRect(0, 0, platno.width, platno.height);
    };
    risi();
}

// Tanka črta na vrhu, ki kaže, koliko strani si že prebral
window.addEventListener('scroll', () => {
    const visina = document.documentElement.scrollHeight - innerHeight;
    document.getElementById('napredek-branja').style.width = (visina > 0 ? scrollY / visina * 100 : 0) + '%';
}, { passive: true });

// Rahel 3D nagib kartic pod miško
document.addEventListener('mousemove', (ev) => {
    if (zmanjsanoGibanje) return;
    const slika = ev.target.closest('.hero-slika');
    if (!slika) return;
    const r = slika.getBoundingClientRect();
    const x = (ev.clientX - r.left) / r.width - 0.5;
    const y = (ev.clientY - r.top) / r.height - 0.5;
    slika.querySelector('img').style.transform = `perspective(1200px) rotateY(${x * 10}deg) rotateX(${-y * 8}deg)`;
});
document.addEventListener('mouseout', (ev) => {
    const slika = ev.target.closest && ev.target.closest('.hero-slika');
    if (slika && !slika.contains(ev.relatedTarget)) slika.querySelector('img').style.transform = '';
});

// Pokliči po vsakem izrisu strani
function poIzrisu() {
    const app = document.getElementById('aplikacija');
    app.classList.remove('stran-vstop');
    void app.offsetWidth; // ponovni zagon animacije
    app.classList.add('stran-vstop');
    sprozRazkrivanje();
    animirajStevce();
    animirajVrstice();
}
