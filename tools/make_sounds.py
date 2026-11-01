# Karanlık Oda · efekt ve ortam sesleri: hepsi koddan sentezlenir (telif yok).
import numpy as np
from scipy.io import wavfile
from scipy.signal import butter, sosfilt, fftconvolve
import os, sys

SR = 44100
OUT = sys.argv[1] if len(sys.argv) > 1 else 'out'
os.makedirs(OUT, exist_ok=True)
rng = np.random.default_rng(7)

def t(sec): return np.arange(int(SR * sec)) / SR
def noise(sec): return rng.standard_normal(int(SR * sec))
def bp(x, lo, hi, order=4): return sosfilt(butter(order, [lo, hi], 'bandpass', fs=SR, output='sos'), x)
def lp(x, f, order=4): return sosfilt(butter(order, f, 'lowpass', fs=SR, output='sos'), x)
def hp(x, f, order=2): return sosfilt(butter(order, f, 'highpass', fs=SR, output='sos'), x)
def env(n, attack, decay):
    a = int(SR * attack)
    e = np.exp(-np.arange(n) / (SR * decay))
    if a > 0: e[:a] *= np.linspace(0, 1, a)
    return e
def reverb(x, sec=0.9, wet=0.25, tone=4000):
    ir = lp(noise(sec), tone) * np.exp(-t(sec) / (sec / 5))
    ir /= np.abs(ir).sum() / 8
    y = fftconvolve(x, ir)[: len(x) + len(ir) - 1]
    dry = np.concatenate([x, np.zeros(len(y) - len(x))])
    return dry * (1 - wet) + y * wet
def fade_out(x, sec=0.02):
    n = int(SR * sec); x = x.copy(); x[-n:] *= np.linspace(1, 0, n); return x
def norm(x, peak):
    return x / (np.abs(x).max() + 1e-9) * peak
def save(name, x, peak=0.7, sr=SR):
    x = fade_out(norm(x, peak))
    if sr != SR:
        idx = np.arange(0, len(x), SR / sr).astype(int); x = x[idx]
    wavfile.write(f'{OUT}/{name}.wav', sr, (x * 32767).astype(np.int16))
    print(f'{name:10s} {len(x)/sr:5.2f} sn  {os.path.getsize(f"{OUT}/{name}.wav")//1024} KB')

def tone(freq, sec, decay, attack=0.004, partials=((1, 1.0),)):
    tt = t(sec); y = np.zeros_like(tt)
    for mult, amp in partials:
        y += amp * np.sin(2 * np.pi * freq * mult * tt)
    return y * env(len(tt), attack, decay)

# 1. Kareyi doldur: kâğıda kalemle yumuşak bir dokunuş.
x = bp(noise(0.06), 900, 5000) * env(int(SR*0.06), 0.001, 0.008) * 0.6
x += tone(170, 0.06, 0.012, 0.001) * 0.9
save('tap', reverb(x, 0.25, 0.12), 0.45)

# 2. Çarpı işaretle: iki kısa kalem çizgisi.
def scratch(sec):
    n = int(SR*sec); return bp(noise(sec), 2500, 7000) * np.sin(np.linspace(0, np.pi, n))**1.5
x = np.concatenate([scratch(0.035), np.zeros(int(SR*0.025)), scratch(0.04)])
save('cross', reverb(x, 0.2, 0.1), 0.32)

# 3. Satır/sütun tamam: hafif, cam gibi bir zil.
x = tone(1318.5, 0.7, 0.18, partials=((1, 1), (2.01, 0.25), (3.0, 0.08)))
save('line', reverb(x, 0.8, 0.3), 0.3)

# 4. Bulmaca çözüldü: sıcak, yavaş açılan bir akor (La minör 9).
tt = t(2.6); x = np.zeros_like(tt)
for i, f in enumerate([220.0, 329.63, 440.0, 493.88, 659.25]):
    start = int(SR * 0.09 * i)
    seg = tone(f, 2.6 - 0.09 * i, 1.1, attack=0.03, partials=((1, 1), (2, 0.3), (3, 0.1)))
    x[start:start + len(seg)] += seg * (1.0 if i else 0.8)
x += lp(noise(2.6), 300) * env(len(tt), 0.4, 1.0) * 0.15
save('solve', reverb(x, 1.6, 0.35, 3000), 0.55)

# 5. Su damlası.
def drip(pitch=1.0):
    sec = 0.12; tt = t(sec)
    f = (500 + 1200 * (1 - np.exp(-tt / 0.012))) * pitch
    y = np.sin(2 * np.pi * np.cumsum(f) / SR) * env(len(tt), 0.001, 0.025)
    return y
save('drip', reverb(drip(), 1.2, 0.45, 3500), 0.5)

# 6. Banyo: tepside sıvının yavaşça çalkalanması + iki damla (≈3 sn).
sec = 3.2; tt = t(sec)
slosh = lp(noise(sec), 700) * (0.55 + 0.45 * np.sin(2 * np.pi * 0.55 * tt - 1.2)) ** 2
slosh *= np.minimum(1, tt / 0.4) * np.minimum(1, (sec - tt) / 0.8)
x = slosh * 0.9
for at, p in ((0.7, 1.0), (2.1, 0.85)):
    d = drip(p) * 0.6; s = int(SR * at); x[s:s + len(d)] += d
save('develop', reverb(x, 1.4, 0.35, 3000), 0.5)

# 7. Büyüteç ayrıntıyı buldu: kısa bir tık ve parıltı.
click = hp(noise(0.012), 3000) * env(int(SR*0.012), 0.0005, 0.003)
glim = tone(1046.5, 0.5, 0.14, attack=0.01, partials=((1, 1), (1.5, 0.35), (2, 0.2)))
x = np.concatenate([click * 1.4, np.zeros(int(SR*0.02))]); x = np.concatenate([x, np.zeros(len(glim))]); x[int(SR*0.03):int(SR*0.03)+len(glim)] += glim * 0.7
save('found', reverb(x, 0.9, 0.3), 0.45)

# 8. Kâğıt: hikâye satırı açılırken hafif hışırtı.
sec = 0.32; n = int(SR*sec)
e = np.zeros(n)
for at, w in ((0.0, 0.08), (0.07, 0.12), (0.16, 0.1)):
    s = int(SR*at); m = int(SR*w); e[s:s+m] += np.sin(np.linspace(0, np.pi, m)) * rng.uniform(0.6, 1.0)
x = bp(noise(sec), 1200, 8000) * e
save('page', reverb(x, 0.3, 0.12), 0.28)

# 9. Ortam: neredeyse duyulmayan oda sesi ve seyrek, uzak damlalar (32 sn, kesintisiz döner).
# Uğultu yok: uzun oyunda yormasın. Oyuncu ancak kapatınca eksikliğini fark etmeli.
L = 32.0; tt = t(L); n = len(tt)
room = lp(noise(L), 250, order=2) * 0.6 + lp(bp(noise(L), 250, 900, order=2), 900) * 0.08
room *= 0.85 + 0.15 * np.sin(2*np.pi*tt/L*2)            # döngüyle uyumlu çok yavaş nefes
x = room * 0.35
for at, p_, v in ((7.5, 0.92, 0.22), (21.0, 1.06, 0.16)):
    d = reverb(lp(drip(p_), 2500), 1.8, 0.6, 2200) * v; s0 = int(SR*at); e = min(n, s0+len(d)); x[s0:e] += d[:e-s0]
# Dikişsiz döngü: son 2 sn başa doğru karışır.
f = int(SR * 2.0); ramp = np.linspace(0, 1, f)
head = x[:f].copy(); x[:f] = head * ramp + x[-f:] * (1 - ramp); x = x[:-f]
x = norm(x, 0.22)
idx = np.arange(0, len(x), 2).astype(int)          # 22 kHz yeter, boyut yarıya iner
wavfile.write(f'{OUT}/ambience.wav', 22050, (x[idx] * 32767).astype(np.int16))
print(f'ambience   {len(idx)/22050:5.2f} sn  {os.path.getsize(f"{OUT}/ambience.wav")//1024} KB')
