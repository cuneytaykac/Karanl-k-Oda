# Ara sahnelerin ek sesleri: cep telefonu, mesaj, dosya, saat tik takı.
exec(open(__file__.replace('scene_sounds.py', 'make_sounds.py')).read().split("# 1. Kareyi doldur")[0])

# Cep telefonu: titreşim vızıltısı (2 kez) + yumuşak bir zil melodisi (2 kez).
def buzz(sec):
    tt = t(sec)
    y = np.sign(np.sin(2*np.pi*150*tt)) * 0.6 + np.sin(2*np.pi*300*tt) * 0.3
    return lp(y, 900) * np.minimum(1, tt/0.02) * np.minimum(1, (sec-tt)/0.03)
def melody():
    out = []
    for f, d in ((880, 0.14), (1174.7, 0.14), (1318.5, 0.14), (1174.7, 0.22)):
        out.append(tone(f, d, 0.12, 0.004, ((1, 1), (2, 0.25), (3, 0.08))))
    return np.concatenate(out)
x = np.concatenate([buzz(0.45), np.zeros(int(SR*0.15)), buzz(0.45), np.zeros(int(SR*0.25)), melody() * 0.7, np.zeros(int(SR*0.35)), melody() * 0.7])
save('mobile', reverb(x, 0.3, 0.1, 6000), 0.4)

# Mesaj: iki notalı kısa bildirim.
x = np.concatenate([tone(1046.5, 0.16, 0.08, 0.003, ((1, 1), (2, 0.2))), tone(1568, 0.4, 0.14, 0.003, ((1, 1), (2, 0.2)))])
save('message', reverb(x, 0.5, 0.2, 7000), 0.32)

# Dosya: kalın dosya tezgâha konur (tok bir vuruş) ve kâğıtlar kayar.
thud = lp(noise(0.15), 220) * env(int(SR*0.15), 0.002, 0.03) * 2 + tone(95, 0.15, 0.04, 0.002) * 0.8
slide = bp(noise(0.5), 1200, 7000) * np.sin(np.linspace(0, np.pi, int(SR*0.5)))**1.2 * 0.35
x = np.concatenate([thud, np.zeros(int(SR*0.08)), slide])
save('folder', reverb(x, 0.4, 0.15, 3500), 0.45)

# Saat: birkaç saniye hafif tik tak (iki farklı ton).
x = np.zeros(int(SR*3.2))
for i in range(6):
    f = 2400 if i % 2 == 0 else 1900
    c = hp(noise(0.02), 1500) * env(int(SR*0.02), 0.0003, 0.002) + tone(f, 0.02, 0.004, 0.0005) * 0.4
    s = int(SR*(0.1 + i*0.5)); x[s:s+len(c)] += c * (0.8 if i % 2 else 1.0)
x[:int(SR*0.5)] *= np.linspace(0.3, 1, int(SR*0.5)); x[-int(SR*0.8):] *= np.linspace(1, 0.2, int(SR*0.8))
save('clock', reverb(x, 0.6, 0.2, 5000), 0.3)
