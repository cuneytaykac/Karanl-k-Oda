# Rulo 5 · Çekmece — 3 Mart 1989 akşamı. Yarışma için gece ışığında dükkân; Cem arka çekmecede.
from photolib import *
from reel2 import hs, ayse, nar

ST = "'89 3 3"
D = '3 Mart 1989'
FRAMES = []
G = GLOW_DEFS


def dark_shop(lamp_x=150, lamp_y=200):
    return shop_wall('#5A4C3C', '#2E251D') + counter(290, '#3E3228', '#5B4836') + lamp(lamp_x, lamp_y, 140, 0.55)


# K1 · Gece vitrini, saat 20:00
body = rect(0, 0, 300, 400, '#2A221B') + shopfront('SAATÇİ NECATİ', wall='#6E5E47') + '<rect x="36" y="130" width="130" height="160" fill="#F2D898" opacity="0.7"/>' + wall_clock(100, 210, 30, 8, 0) + rect(0, 330, 300, 70, '#241C16') + night(0.25)
FRAMES.append(dict(
    title="Gece vitrini", date=D, photo=photo(body, ST, '', 'R5 K1 · vitrin saati 20:00 (100, 210)'),
    art=["##########", "#........#", "#.######.#", "#.#....#.#", "#.#.#..#.#", "#.#.###..#", "#.#....#.#", "#.######.#", "#........#", "##########"],
    hotspots=[hs("wm.r5.t2000", 100, 210, 36, "time", "Gece çekimi", "Vitrindeki saat 20:00. Necati yarışma için dükkânını gece ışığında çekiyor.", tag="20:00")],
    reaction="Babam bu yarışmayı çok istiyormuş. Annem \"ilk ödülü alacaktı\" derdi.", search=False))

# K2 · Tezgâh lambası, aletler
body = dark_shop(150, 150) + ''.join(f'<path d="M{x} 286 l{d} -26" stroke="#B8A88A" stroke-width="3" stroke-linecap="round"/>' for x, d in ((90, 8), (110, -6), (130, 10))) + wristwatch(200, 270, 16, 8, 5, 90)
FRAMES.append(dict(
    title="Tezgâh lambası", date=D, photo=photo(body, ST, G, 'R5 K2 · lamba (150, 150)'),
    art=["....##....", "...####...", "..######..", ".########.", "....##....", "....##....", "....##....", "...####...", "..######..", "##########"],
    hotspots=[hs("wm.r5.lamp", 150, 146, 34, "clue", "Uzun pozlama", "Lamba yanık, her şey keskin. Necati makineyi sehpaya kurmuş, ışığı uzun süre içeri alıyor.")],
    reaction="Uzun pozlama… Hareket eden her şey bulanık çıkar. Babam bunu bilirdi.", search=False))

# K3 · Arka tarafta bulanık Cem, çekmeceye eğilmiş
# Hareket izi: figür kaydırılarak soluk soluk üst üste çizilir (filtre kullanmadan bulanıklık).
ghost = ''.join(f'<g opacity="{op}" transform="translate({dx} {dy})">{figure(220, 330, 170, "#7A8478", head="#D8B898")}</g>' for dx, dy, op in ((-16, 4, 0.3), (-8, 2, 0.45), (0, 0, 0.6), (8, -2, 0.45), (16, -4, 0.3)))
body = dark_shop(70, 160) + drawer(170, 300, 110, 40) + ghost
FRAMES.append(dict(
    title="Bulanık gölge", date=D, photo=photo(body, ST, G, 'R5 K3 · bulanık Cem (222, 250)'),
    art=["......##..", ".....####.", "......##..", "....#####.", "...######.", "....####..", "....####..", "...#.##.#.", "..########", "..#......#"],
    hotspots=[hs("wm.r5.blur", 222, 250, 40, "clue", "Bulanık gölge", "Uzun pozlamada hareket eden biri bulanık çıkar: Cem, arka çekmeceye eğilmiş.")],
    reaction="Neden bulanık? Hareket ediyormuş. Çekmeceye bir şey koyuyor ya da alıyor.", search=True))

# K4 · Çekmece aralık, lacivert kutunun köşesi
body = dark_shop(60, 120) + drawer(70, 170, 170, 70, open_=0.9, box=True)
FRAMES.append(dict(
    title="Çekmece aralık", date=D, photo=photo(body, ST, G, 'R5 K4 · kutu (180, 268)'),
    art=["##########", "#........#", "#...##...#", "#........#", "##########", ".#......#.", ".#.####.#.", ".#.####.#.", ".########.", ".........."],
    hotspots=[hs("wm.r5.box", 182, 266, 32, "clue", "Lacivert kadife", "Arka çekmece aralık kalmış. İçinde lacivert kadife bir kutunun köşesi.")],
    reaction="Aynı kutu. Dava dosyasındaki kutu. Saat 20:00'de babamın çekmecesinde duruyormuş.", search=True))

# K5 · Aynadaki Necati, gözü vizörde
body = (dark_shop(240, 120) + rect(40, 60, 150, 200, '#7E7466', f'stroke="#3B3128" stroke-width="8"')
        + f'<g transform="translate(0 0)">{person("necati", 115, 150, 0.7, "flat")}</g>'
        + rect(92, 140, 46, 28, '#1C1714') + '<circle cx="115" cy="154" r="9" fill="#5A524A"/>' + rect(40, 60, 150, 200, '#C8BC9E', 'opacity="0.18"'))
FRAMES.append(dict(
    title="Aynadaki Necati", date=D, photo=photo(body, ST, G, 'R5 K5 · makine (115, 154)'),
    art=["##########", "#........#", "#.######.#", "#.#....#.#", "#.#.##.#.#", "#.#.##.#.#", "#.#....#.#", "#.######.#", "#........#", "##########"],
    hotspots=[hs("wm.r5.mirror", 115, 154, 34, "clue", "Aynadaki Necati", "Aynada Necati: gözü vizörde. Arka çekmeceyi görmüyor.")],
    reaction="Babam tam karşısında, ama görmüyor. Gözü sadece ışıkta.", search=False))

# K6 · 20:20 Cem çıkıyor, elleri boş
body = dark_shop(250, 110) + clock_wall(8, 20, rows=1) + rect(30, 120, 90, 210, '#3B2E24', f'stroke="{INK}" stroke-width="3"') + figure(80, 328, 170, '#4A5248', limp=True)
FRAMES.append(dict(
    title="Cem çıkıyor", date=D, photo=photo(body, ST, G, 'R5 K6 · saat 20:20 (196, 62)'),
    art=["..######..", ".#......#.", "#.......##", "#......#.#", "#....##..#", "#....#...#", "#........#", "#........#", ".#......#.", "..######.."],
    hotspots=[hs("wm.r5.t2020", 196, 62, 30, "time", "Cem çıktı", "20:20. Cem kaskını alıp çıkıyor. Elleri boş.", tag="20:20")],
    reaction="Elleri boş çıkıyor. Kutu çekmecede kaldı.", search=False))

# K7 · 20:45 kapı kilitleniyor, anahtar
body = (rect(0, 0, 300, 400, '#3E3228') + rect(60, 40, 180, 340, '#4A3B2E', f'stroke="{INK}" stroke-width="4"') + wall_clock(250, 60, 22, 8, 45)
        + '<circle cx="200" cy="230" r="14" fill="#C9A34E"/><rect x="196" y="228" width="40" height="6" fill="#C9A34E"/><rect x="226" y="234" width="6" height="10" fill="#C9A34E"/>'
        + f'<ellipse cx="236" cy="236" rx="30" ry="18" fill="{SKIN}"/>' + night(0.3))
FRAMES.append(dict(
    title="Anahtar", date=D, photo=photo(body, ST, '', 'R5 K7 · saat 20:45 (250, 60)'),
    art=["..........", "..........", ".###......", "#...#.....", "#...######", "#...#..#.#", ".###...#.#", "..........", "..........", ".........."],
    hotspots=[hs("wm.r5.t2045", 250, 60, 28, "time", "Dükkân kilitlendi", "20:45. Necati kapıyı kilitliyor. Anahtar yalnızca onda ve Cem'de var.", tag="20:45")],
    reaction="Anahtar ikisinde de varmış. Başka kimse giremezdi.", search=False))

# K8 · Yarışma karesi: lambalı dükkân
body = dark_shop(150, 170) + clock_wall(8, 30) + '<rect x="60" y="300" width="180" height="20" fill="#7A634B"/>' + wristwatch(150, 296, 14, 8, 30, 90)
FRAMES.append(dict(
    title="Yarışma karesi", date=D, photo=photo(body, ST, G, 'R5 K8 · ışık (150, 170)'),
    art=["#..#..#..#", ".#.#..#.#.", "..#....#..", "...####...", "##.####.##", "...####...", "..#....#..", ".#.#..#.#.", "#..#..#..#", ".........."],
    hotspots=[hs("wm.r5.contest", 150, 172, 38, "clue", "Yarışma fotoğrafı", "Necati'nin yarışma için seçtiği kare. Hiç gönderilmedi.")],
    reaction="Ne güzel bir fotoğraf. Bunu çerçeveletip asacağım, ne olursa olsun.", search=False))

# K9 · Arka çekmecenin kilidi yok
body = dark_shop(250, 90) + drawer(40, 160, 220, 110) + '<rect x="134" y="206" width="32" height="24" fill="none" stroke="#C9A34E" stroke-width="3"/><path d="M140 206 v-10 a10 10 0 0 1 20 0" fill="none" stroke="#8C847A" stroke-width="3" stroke-dasharray="4 3"/>'
FRAMES.append(dict(
    title="Kilitsiz", date=D, photo=photo(body, ST, G, 'R5 K9 · kilit yeri (150, 214)'),
    art=["..........", "##########", "#........#", "#...##...#", "#..#..#..#", "#..####..#", "#..####..#", "#........#", "##########", ".........."],
    hotspots=[hs("wm.r5.nolock", 150, 214, 30, "clue", "Kilitsiz", "Arka çekmecenin kilidi yok. Dükkânda olan herkes açabilir.")],
    reaction="Avukat bunu hiç sormamış mı? Herkes açabilirmiş.", search=False))

# K10 · Kutunun yakını: Rıza Kuyumculuk damgası
body = rect(0, 0, 300, 400, '#2E251D') + lamp(60, 60, 160, 0.45) + velvet_box(40, 130, 220, 150, stamp=True)
FRAMES.append(dict(
    title="Damga", date=D, photo=photo(body, ST, G, 'R5 K10 · damga (150, 232)'),
    art=["..........", "##########", "##########", "#........#", "#.######.#", "#.#....#.#", "#.######.#", "#........#", "##########", ".........."],
    hotspots=[hs("wm.r5.stamp", 150, 232, 40, "clue", "Rıza'nın damgası", "Kutunun kapağında altın yaldızla \"Rıza Kuyumculuk\". Çalıntı kutu, soygundan yedi buçuk saat sonra burada.")],
    reaction="Artık şüphe yok. Kutuyu oraya Cem koymuş. Babam değil.", search=True))

SCENES = {
    3: {"eyebrow": "BUGÜN · AYŞE'NİN EVİ", "title": "Delil 4", "lines": [
        nar("Ayşe dava dosyasından tek bir sayfa çıkarıyor; kenarları parmak izinden kararmış.", sfx="folder"),
        nar("DELİL 4 · Lacivert kadife kolye kutusu. Sanığın dükkânında, arka çekmecede bulunmuştur. 5 Mart 1989.", style="paper", sfx="newspaper"),
        ayse("Bu fotoğrafı yıllarca ezberledim. Babamı mahkûm eden kutu."),
    ]},
    7: {"eyebrow": "BUGÜN · GECE", "title": "Görüldü", "lines": [
        nar("Gece yarısına doğru Ayşe'den bir mesaj geliyor.", sfx="message"),
        ayse("Cem'e yazdım. \"Babamın 1989'dan kalma fotoğraflarını buldum\" dedim, başka bir şey demedim."),
        ayse("Üç saattir \"görüldü\"de. Cevap yok."),
    ]},
}

QUESTION = {
    "text": "Haluk bunu biliyor muydu?",
    "options": [
        {"id": "knew", "text": "Biliyordu, kardeşini korudu", "reply": ayse("O zaman mahkemedeki yalan da anlaşılır. Ama bu, babamın arkadaşının bunu bile bile yaptığı demek.")},
        {"id": "nothing", "text": "Hiçbir şeyden haberi yoktu", "reply": ayse("Keşke. Ama telsizi dinledi, motosikleti gördü. Hiç mi düşünmedi?")},
        {"id": "believed", "text": "Necati'yi gerçekten suçlu sandı", "reply": ayse("O zaman neden \"onu görmedim\" dedi? Göldeydiler, birlikte.")},
    ],
    "truth": "knew",
    "outro": [
        nar("Altıncı rulonun etiketi: \"4 Mart, sabah.\"", sfx="bag"),
        ayse("Soygunun ertesi sabahı. Babam tutuklanmadan bir gün önce."),
    ],
}

REEL = {"number": 5, "title": "Çekmece", "intro": "Etikette: \"Gece ışığı.\" Necati bir fotoğraf yarışması için dükkânını gece çekmiş."}
