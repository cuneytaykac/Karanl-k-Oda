# Rulo 3 · Göl yolu — 3 Mart 1989. Necati'nin ikinci makinesi: yol, manzara, kırmızı motosiklet, telsiz.
from photolib import *
from reel2 import hs, ayse, nar

ST = "'89 3 3"
D = '3 Mart 1989'
DEFS = grad('sky', '#D6C6A6', '#C8B897')
FRAMES = []


def sky():
    return rect(0, 0, 300, 400, 'url(#sky)')


# K1 · Göl yolu, tabela
body = (sky() + hills() + fields() + road()
        + '<rect x="214" y="190" width="6" height="90" fill="#3B3128"/>'
        + note(178, 160, 84, 44, ['GÖL 3', 'KASABA 17'], rot=0, size=13, font='JetBrainsMono'))
FRAMES.append(dict(
    title="Göl yolu", date=D, photo=photo(body, ST, DEFS, 'R3 K1 · yol tabelası (220, 182)'),
    art=["..######..", "..#....#..", "..######..", ".....#....", ".....#....", "....###...", "...#####..", "..#######.", ".#########", "##########"],
    hotspots=[hs("wm.r3.sign", 220, 182, 32, "clue", "Tek yol", "Tabela: Göl 3 km, kasaba 17 km. Göl ile kasaba arasında başka yol yok.")],
    reaction="Bu yol kasabaya tek bağlantı. Gelen giden herkes buradan geçer.", search=False))

# K2 · Manzara, boş yol
body = sky() + hills(200) + fields(200) + road(200) + '<path d="M20 230 q30 -40 60 0 M240 250 q20 -30 40 0" fill="#7A6A4E"/>'
FRAMES.append(dict(
    title="Manzara", date=D, photo=photo(body, ST, DEFS, 'R3 K2 · boş yol (150, 250)'),
    art=["..........", "..##......", ".####.....", "######..##", "##########", "####..####", "###....###", "##......##", "#........#", ".........."],
    hotspots=[hs("wm.r3.empty", 150, 250, 34, "clue", "Boş yol", "Saat 12:10 sularında yol bomboş. Necati manzarayı çekmiş.")],
    reaction="Babam manzaraya bayılırdı. Ama sanki bir şey bekliyormuş gibi.", search=False))

# K3 · 12:18, uzakta kırmızı motosiklet
body = (sky() + hills(180) + fields(180) + road(180) + motorcycle(172, 214, 0.35, rider=True)
        + wristwatch(56, 330, 18, 12, 18, -10))
FRAMES.append(dict(
    title="12:18", date=D, photo=photo(body, ST, DEFS, 'R3 K3 · uzakta motosiklet (172, 204), ön planda saat 12:18'),
    art=["..........", "..........", ".#.....##.", "##....#..#", "#.#..#...#", "#..##....#", ".#..#...#.", "..##.###..", "..........", ".........."],
    hotspots=[hs("wm.r3.t1218", 172, 204, 28, "time", "Kırmızı motosiklet", "Göl yolunda kasabaya doğru hızla giden kırmızı bir motosiklet. Necati'nin saati 12:18.", tag="12:18")],
    reaction="Kırmızı bir motosiklet… Göl yolunda ne işi vardı? Nerede görmüştüm bunu?", search=True))

# K4 · Büyütme: sürücü, kasksız, kıvırcık saç
body = (rect(0, 0, 300, 400, '#B6A684') + road(60, '#8A7A60') + motorcycle(150, 300, 1.6, rider=True)
        + '<rect width="300" height="400" fill="#B6A684" opacity="0.18"/>')
FRAMES.append(dict(
    title="Büyütme", date=D, photo=photo(body, ST, DEFS, 'R3 K4 · büyütülmüş sürücü başı (160, 160)'),
    art=["...###....", "..#####...", "..#####...", "...###....", "..#####...", ".#######..", "..#####...", ".#.###.#..", "#.#...#.#.", ".#.....#.."],
    hotspots=[hs("wm.r3.rider", 160, 160, 36, "clue", "Sürücü", "Büyütünce: sürücünün kaskı yok; saçları koyu ve kıvırcık. Genç biri.")],
    reaction="Kıvırcık saç… Hayır. Acele etmeyelim.", search=True))

# K5 · Haluk dalgın, yola bakıyor
body = (lake(water_y=240) + shore(300) + person('haluk', 170, 190, 0.95, 'flat', look=-1)
        + '<path d="M60 380 L120 140" stroke="#2A221B" stroke-width="2"/>')
FRAMES.append(dict(
    title="Dalgın", date=D, photo=photo(body, ST, LAKE_DEFS, 'R3 K5 · Haluk dalgın yüz (170, 190)'),
    art=["..........", "...####...", "..######..", "..#.##.#..", "..######..", "..##..##..", "...####...", "..######..", ".########.", "##########"],
    hotspots=[hs("wm.r3.distracted", 170, 192, 36, "clue", "Dalgın", "12:40 sularında. Haluk oltasını bırakmış, yola bakıyor.")],
    reaction="Balık tutmuyor. Yola bakıyor. Bir şey görmüş olmalı.", search=False))

# K6 · Arabada telsiz
body = (rect(0, 0, 300, 400, '#5A5048') + rect(0, 0, 300, 150, '#B6A684') + '<path d="M0 150 L300 150" stroke="#2A221B" stroke-width="10"/>'
        + rect(0, 250, 300, 150, '#3E3832') + radio(60, 210, 1.3) + person('haluk', 240, 120, 0.8, 'flat'))
FRAMES.append(dict(
    title="Telsiz", date=D, photo=photo(body, ST, '', 'R3 K6 · telsiz (110, 240)'),
    art=["..........", "#########.", "#.##.#...#", "#.##.#.#.#", "#########.", "........#.", "........#.", ".......###", ".......###", ".......###"],
    hotspots=[hs("wm.r3.radio", 110, 240, 40, "clue", "Polis telsizi", "Haluk arabadaki polis telsizini dinliyor. Soygun ihbarı bu kanaldan geçmiş olmalı.")],
    reaction="Soygunu buradan, telsizden duymuş. Ve babama hiçbir şey söylememiş.", search=True))

# K7 · Necati balıkla, habersiz
body = lake(water_y=250) + person('necati', 150, 170, 1.05, 'laugh') + fish(150, 300, 140, -6)
FRAMES.append(dict(
    title="Habersiz", date=D, photo=photo(body, ST, LAKE_DEFS, 'R3 K7 · Necati gülüyor (150, 170)'),
    art=["...####...", "..######..", "..#.##.#..", "..######..", "...####...", "..........", "..#####.#.", ".########.", "..#####.#.", ".........."],
    hotspots=[hs("wm.r3.unaware", 150, 175, 40, "clue", "Habersiz", "Necati balığıyla poz veriyor; kasabada olanlardan haberi yok.")],
    reaction="Babam o an dünyanın en mutlu adamı gibi. İki gün sonra her şeyini kaybedecek.", search=False))

# K8 · 13:10 toplanıyorlar
body = (lake(water_y=230) + shore(290) + car(20, 370, 0.95, open_door=True, rods=True) + figure(258, 372, 96, '#4A4236')
        + wristwatch(260, 90, 18, 1, 10))
FRAMES.append(dict(
    title="Apar topar", date=D, photo=photo(body, ST, LAKE_DEFS + CAR_DEFS, 'R3 K8 · saat 13:10 (260, 90)'),
    art=["..........", "....####..", "...#....#.", "..#......#", "#########.", "##########", "##########", ".##....##.", ".##....##.", ".........."],
    hotspots=[hs("wm.r3.t1310", 260, 90, 30, "time", "Merkeze", "Haluk \"Merkeze gitmem lazım\" deyip toplanıyor. Saat 13:10.", tag="13:10")],
    reaction="Telsizi duyduktan yarım saat sonra. Neden hemen gitmemiş? Neyi düşünmüş o yarım saat?", search=False))

# K9 · Yol kenarında taze motosiklet izi
body = (rect(0, 0, 300, 400, '#7A6A52') + ''.join(f'<ellipse cx="{x}" cy="{y}" rx="{r}" ry="{r*0.5}" fill="#5B4C39"/>' for x, y, r in ((60, 80, 30), (230, 140, 40), (80, 320, 36), (250, 340, 24)))
        + '<path d="M40 400 C90 300 120 220 170 160 C210 110 240 60 260 0" stroke="#3B3128" stroke-width="14" fill="none" stroke-dasharray="6 5"/>')
FRAMES.append(dict(
    title="Taze iz", date=D, photo=photo(body, ST, '', 'R3 K9 · lastik izi (170, 160)'),
    art=["#.#.#.#.##", ".......###", "......###.", ".....###..", "....###...", "...###....", "..###.....", ".###......", "###.......", "#.#.#.#.#."],
    hotspots=[hs("wm.r3.track", 170, 162, 36, "clue", "Taze iz", "Yol kenarındaki çamurda ince, taze bir lastik izi. Motosiklet izi.")],
    reaction="Bunu da çekmiş. Babam bir şeyden şüphelenmiş miydi acaba?", search=False))

# K10 · 13:40 kasaba girişi, polis arabaları
body = (sky() + rect(0, 120, 300, 120, '#AE9B7B') + ''.join(f'<rect x="{x}" y="{y}" width="{w}" height="{240-y}" fill="#9C8A6A"/>' for x, y, w in ((10, 90, 60), (90, 70, 70), (190, 100, 50), (250, 80, 50)))
        + road(240) + ''.join(f'<rect x="{x}" y="262" width="54" height="22" rx="4" fill="#E2D6BC"/><rect x="{x+18}" y="252" width="16" height="10" fill="#C23B2E"/>' for x in (60, 190))
        + tower(150, 120, 60, 1, 40))
FRAMES.append(dict(
    title="Kasabaya dönüş", date=D, photo=photo(body, ST, DEFS, 'R3 K10 · polis arabaları (120, 268), kule 13:40'),
    art=["....##....", "...####...", "...#..#...", "...####...", "###....###", "#.#....#.#", "##########", "..........", ".##....##.", ".##....##."],
    hotspots=[hs("wm.r3.t1340", 150, 84, 30, "time", "Kasabaya döndüler", "Kule 13:40. Kasaba girişinde polis arabaları. Haluk, Necati'yi burada bırakıp merkeze gitmiş.", tag="13:40")],
    reaction="Babam soygunu ilk burada duymuş olmalı. Şüphelinin kendisi olacağı aklına bile gelmemiş.", search=True))

SCENES = {
    4: {"eyebrow": "BUGÜN · AKŞAM", "title": "Bir profil", "lines": [
        nar("Ayşe geç saatte arıyor.", sfx="mobile"),
        ayse("Cem'i internette buldum. İzmir'de oto tamircisi. Elli dört yaşında, iki çocuk babası."),
        ayse("Eski bir fotoğrafı var: kırmızı bir motosikletin önünde. Altında \"İlk aşkım, 1987\" yazıyor."),
        ayse("Bir şey demeyeceğim. Henüz değil."),
    ]},
    7: {"eyebrow": "BUGÜN · DÜKKÂNDA", "title": "Rıza Usta'nın kızı", "lines": [
        nar("Ayşe dükkâna not defteriyle geliyor; yarısı karalanmış.", sfx="doorbell"),
        ayse("Rıza Usta'nın kızına ulaştım. Babası yaşıyormuş, İzmir'de bir huzurevinde."),
        ayse("Kızı dedi ki: \"Babam o soygundan sonra bir daha hiç dükkân açmadı. Sigortadan tek kuruş alamadı.\""),
        ayse("Tek kuruş mu? Ama vitrinde sigorta levhası vardı…"),
    ]},
}

QUESTION = {
    "text": "O kırmızı motosiklet kimin?",
    "options": [
        {"id": "cem", "text": "Cem'in", "reply": ayse("Kasabada tek kırmızı motosiklet. \"Annem hasta\" deyip çıkmıştı. Annesinin evi göl yolunda değil.")},
        {"id": "stranger", "text": "Tanımadığımız birinin", "reply": ayse("Olabilir. Ama o yol sadece göle gider. Göl yolunda tanımadığımız biri ne arasın?")},
        {"id": "haluk", "text": "Haluk'un", "reply": ayse("Haluk amca o saatte babamın yanındaydı. Motosiklet de onun değil; arabası var.")},
    ],
    "truth": "cem",
    "outro": [
        nar("Dördüncü rulonun etiketi: \"Dükkân, akşamüstü.\"", sfx="bag"),
        ayse("Soygundan birkaç saat sonra. Bakalım o gün dükkâna kim döndü."),
    ],
}

REEL = {"number": 3, "title": "Göl yolu", "intro": "Etikette: \"Göl yolu.\" Necati'nin ikinci makinesi; aynı gün, göl ile kasaba arası."}
