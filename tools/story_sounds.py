# Hikâye anlarının sesleri: telefon, dükkân zili, gazete, mektup, torba, film makarası.
exec(open(__file__.replace('story_sounds.py', 'make_sounds.py')).read().split("# 1. Kareyi doldur")[0])

def bell(freq, sec, decay, strike=1.0):
    # Gerçek zil kısmi tonları (uyumsuz): metal tını.
    return tone(freq, sec, decay, attack=0.001, partials=((1,1),(2.32,0.55),(4.25,0.3),(5.4,0.18),(6.8,0.1))) * strike

# Telefon: eski ev telefonu, iki tokmak saniyede ~20 kez çanlara vurur. 2 çalış.
def ring(sec=1.4):
    tt = t(sec); y = np.zeros_like(tt); period = 1/22
    k = 0
    while k*period < sec - 0.05:
        s = int(SR*k*period); f = 1180 if k % 2 == 0 else 1260
        b = bell(f, 0.12, 0.05, rng.uniform(0.8, 1.0)); e = min(len(y), s+len(b)); y[s:e] += b[:e-s]; k += 1
    y *= np.minimum(1, tt/0.03) * np.minimum(1, (sec-tt)/0.06)
    return y
x = np.concatenate([ring(), np.zeros(int(SR*0.9)), ring()])
x = bp(x, 400, 6000, 2)
save('phone', reverb(x, 0.6, 0.18, 5000), 0.42)

# Dükkân kapısı zili: kapı açılınca sallanan küçük çan (birkaç düzensiz vuruş).
x = np.zeros(int(SR*2.2))
for at, f, a in ((0.0, 2100, 1.0), (0.11, 2380, 0.8), (0.19, 2100, 0.65), (0.33, 2380, 0.45), (0.5, 2100, 0.3), (0.72, 2380, 0.15)):
    b = bell(f, 1.4, 0.35, a); s = int(SR*at); x[s:s+len(b)] += b[:len(x)-s]
door = lp(noise(0.25), 500) * env(int(SR*0.25), 0.005, 0.06) * 0.8   # kapı tokmağı/menteşe tıkırtısı
x[:len(door)] += door
save('doorbell', reverb(x, 1.0, 0.25, 6000), 0.38)

# Gazete: büyük kâğıt, iki hamlede açılıp düzeltilir.
def rustle(sec, lo, hi, bursts):
    n = int(SR*sec); e = np.zeros(n)
    for at, w, a in bursts:
        s = int(SR*at); m = int(SR*w); m = min(m, n-s); e[s:s+m] += np.sin(np.linspace(0, np.pi, m))**0.7 * a
    crackle = (rng.random(n) < 0.004) * rng.uniform(0.5, 1.5, n)
    return bp(noise(sec) * (0.7 + crackle), lo, hi) * e
x = rustle(0.9, 500, 9000, ((0.0, 0.22, 1.0), (0.18, 0.15, 0.6), (0.42, 0.3, 0.9), (0.7, 0.15, 0.4)))
save('newspaper', reverb(x, 0.35, 0.15), 0.42)

# Mektup: ince kâğıt katlarından açılır (üç küçük çıtırtı).
x = rustle(0.75, 1500, 9000, ((0.0, 0.1, 0.8), (0.2, 0.12, 1.0), (0.45, 0.18, 0.7)))
save('letter', reverb(x, 0.3, 0.12), 0.35)

# Torba: eski bez/kâğıt torba, içinde makaralar tıkırdar.
x = rustle(1.0, 300, 5000, ((0.0, 0.3, 0.9), (0.25, 0.25, 0.7), (0.55, 0.35, 0.6)))
for at in (0.18, 0.31, 0.62):
    c = tone(rng.uniform(900, 1300), 0.08, 0.015, 0.001, ((1,1),(2.7,0.4))) * 0.5; s = int(SR*at); x[s:s+len(c)] += c
save('bag', reverb(x, 0.4, 0.15, 4000), 0.4)

# Film makarası: cırcırlı sarma, hızlanıp durur.
sec = 1.0; x = np.zeros(int(SR*sec)); at = 0.0; gap = 0.07
while at < sec - 0.05:
    c = hp(noise(0.006), 2500) * env(int(SR*0.006), 0.0003, 0.0015) + tone(3200, 0.006, 0.002, 0.0003) * 0.3
    s = int(SR*at); x[s:s+len(c)] += c; at += gap; gap = max(0.028, gap * 0.9)
save('reel', reverb(x, 0.25, 0.12), 0.4)
