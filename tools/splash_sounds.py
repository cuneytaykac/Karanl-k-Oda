# Splash: lamba düğmesi tık + floresan/trafo vızıltısı titreyerek yükselir, yumuşakça söner.
exec(open(__file__.replace('splash_sounds.py', 'make_sounds.py')).read().split("# 1. Kareyi doldur")[0])
sec = 2.6; tt = t(sec)
click = hp(noise(0.03), 1800) * env(int(SR*0.03), 0.0003, 0.004) * 1.6 + lp(noise(0.03), 400) * env(int(SR*0.03), 0.0005, 0.01)
hum = (0.55*np.sin(2*np.pi*100*tt) + 0.25*np.sin(2*np.pi*200*tt) + 0.12*np.sin(2*np.pi*300*tt))
# titreme: iki kısa yanıp sönme, sonra sabit; sonda söner
flick = np.ones_like(tt)
for a, b in ((0.06, 0.12), (0.2, 0.26)):
    flick[int(SR*a):int(SR*b)] = 0.15
shape = np.minimum(1, tt/0.05) * np.clip((sec - tt)/1.2, 0, 1)
x = hum * flick * shape * 0.25 + lp(noise(sec), 3000) * flick * shape * 0.03
x[:len(click)] += click
# lamba yanınca alçak, sıcak bir ton (atmosfer)
pad = tone(110, sec, 1.4, attack=0.6, partials=((1, 1), (1.5, 0.4), (2, 0.25)))
x += pad * 0.35
save('lamp', reverb(x, 1.4, 0.3, 3000), 0.42)
