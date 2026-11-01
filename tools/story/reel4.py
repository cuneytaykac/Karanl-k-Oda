# Rulo 4 · Akşamüstü — 3 Mart 1989, 16:00–18:30. Cem'in sargılı bileği; Rıza'nın sigortası yokmuş.
from photolib import *
from reel2 import hs, ayse, nar

ST = "'89 3 3"
D = '3 Mart 1989'
FRAMES = []

# K1 · Dükkâna dönüş: duvardaki saatler 16:00
body = shop_wall() + clock_wall(4, 0) + counter(290) + person('necati', 150, 230, 0.7, 'flat')
FRAMES.append(dict(
    title="Dönüş", date=D, photo=photo(body, ST, '', 'R4 K1 · saat duvarı 16:00 (196, 62)'),
    art=["..######..", ".#......#.", "#....#...#", "#....#...#", "#....#...#", "#....####.", "#........#", "#........#", ".#......#.", "..######.."],
    hotspots=[hs("wm.r4.t1600", 196, 62, 30, "time", "Dükkâna döndü", "Duvardaki saatler 16:00. Necati dükkânı yeniden açmış.", tag="16:00")],
    reaction="Soygundan üç buçuk saat sonra babam sakin sakin dükkânını açıyor. Suçlu biri böyle mi davranır?", search=True))

# K2 · Kapının önünde çamurlu kırmızı motosiklet
body = (rect(0, 0, 300, 400, '#AE9B7B') + window(20, 50, 150, 170) + rect(200, 50, 80, 230, '#4A3B2E', f'stroke="{INK}" stroke-width="3"')
        + rect(0, 280, 300, 120, '#7A6A52') + motorcycle(150, 330, 1.25)
        + ''.join(f'<circle cx="{x}" cy="{y}" r="{r}" fill="#4E3F2E"/>' for x, y, r in ((98, 340, 5), (112, 350, 4), (190, 344, 5), (204, 352, 4), (160, 316, 3))))
FRAMES.append(dict(
    title="Kapının önünde", date=D, photo=photo(body, ST, '', 'R4 K2 · çamurlu tekerlek (110, 340)'),
    art=["..........", "....##....", "..#####.##", ".######.#.", "..####....", ".##...##..", "#..#.#..#.", "#..#.#..#.", ".##...##..", ".........."],
    hotspots=[hs("wm.r4.mud", 108, 338, 34, "clue", "Çamur", "Cem'in kırmızı motosikleti dükkânın önünde. Tekerlekleri çamurlu; kasabanın yolları asfalt.")],
    reaction="Çamur… Göl yolunun çamuru mu bu?", search=False))

# K3 · Sargılı bilek: Cem poz veriyor
body = (shop_wall('#8C7A5E') + clock_wall(4, 20, rows=1) + person('cem', 150, 180, 1.05, 'down')
        + '<path d="M80 300 Q110 250 140 262" stroke="#4A5248" stroke-width="26" fill="none" stroke-linecap="round"/>' + bandage(122, 246, 40, 28, -20)
        + f'<circle cx="150" cy="262" r="10" fill="{SKIN}"/>')
FRAMES.append(dict(
    title="Sargılı bilek", date=D, photo=photo(body, ST, '', 'R4 K3 · sargı (142, 260)'),
    art=["..........", "..........", ".######...", "#.#.#.##..", "#.#.#.#.##", "######..##", "#.#.#.#.##", ".######...", "..........", ".........."],
    hotspots=[hs("wm.r4.bandage", 142, 260, 30, "clue", "Sargılı bilek", "Cem'in sol bileği sargılı. Necati'ye \"Motosikletten düştüm\" demiş.")],
    reaction="Düşmüş… Soyguncu da pencereden atlarken düşmüş olabilir mi?", search=True))

# K4 · Topallıyor, saat kutusu taşıyor
body = (shop_wall() + counter(300) + figure(150, 330, 200, '#4A5248', limp=True)
        + rect(112, 200, 76, 44, '#7A634B', f'stroke="{INK}" stroke-width="2"') + bandage(110, 226, 22, 14))
FRAMES.append(dict(
    title="Topallıyor", date=D, photo=photo(body, ST, '', 'R4 K4 · bacak (166, 310)'),
    art=["...##.....", "..####....", "...##.....", ".######...", ".######...", "..####....", "..#..#....", "..#...#...", "..#....#..", ".##....##."],
    hotspots=[hs("wm.r4.limp", 168, 306, 32, "clue", "Topallıyor", "Cem kutu taşırken sol ayağını sürüyor.")],
    reaction="Babam ona takılıyor, gülüyor. Hiçbir şeyden şüphelenmemiş.", search=False))

# K5 · Karşı dükkân: kepenk kapalı, polis mührü
body = (rect(0, 0, 300, 400, '#AE9B7B') + rect(20, 50, 260, 40, '#3B3128')
        + '<text x="150" y="78" text-anchor="middle" font-family="Lora" font-size="20" font-weight="600" fill="#E9DFC9">RIZA KUYUMCULUK</text>'
        + rect(20, 100, 260, 230, '#8C847A') + ''.join(f'<path d="M20 {y} H280" stroke="#6E665C" stroke-width="2"/>' for y in range(110, 330, 10))
        + note(110, 190, 80, 40, ['MÜHÜR', 'Emniyet'], rot=4, size=14, font='Lora') + rect(0, 330, 300, 70, '#7A6A52'))
FRAMES.append(dict(
    title="Karşı dükkân", date=D, photo=photo(body, ST, '', 'R4 K5 · mühür (150, 210)'),
    art=["##########", "#........#", "##########", "#........#", "##########", "#..####..#", "#..#..#..#", "#..####..#", "##########", "#........#"],
    hotspots=[hs("wm.r4.seal", 150, 210, 34, "clue", "Mühür", "Rıza Usta'nın dükkânı kapalı; kepenkte polis mührü.")],
    reaction="Kasabanın yarısı oradaymış herhalde. Babam ise karşıda saat tamir ediyor.", search=False))

# K6 · Camdaki el yazısı not: sigortasız
body = (rect(0, 0, 300, 400, '#8C847A') + window(20, 20, 260, 360, glass='#B9AE94')
        + note(46, 70, 210, 180, ['Dükkânımız soygun günü', 'sigortasızdı. Poliçe', '1 Nisan\'da başlayacaktı.', 'Bulana ödül verilecektir.', '— Rıza'], rot=-3, size=17)
        + note(60, 270, 180, 50, ['SİGORTALIDIR · Anadolu Sigorta'], rot=6, size=12, font='Lora', color='#D8CBB2'))
FRAMES.append(dict(
    title="Camdaki not", date=D, photo=photo(body, ST, '', 'R4 K6 · not (150, 160)'),
    art=["##########", "#........#", "#.######.#", "#........#", "#.#####..#", "#........#", "#.######.#", "#........#", "#....###.#", "##########"],
    hotspots=[hs("wm.r4.uninsured", 150, 160, 44, "clue", "Sigortasız", "Rıza'nın el yazısı: poliçe 1 Nisan'da başlayacakmış. \"Sigortalıdır\" levhasını sigortacı asmış. Soygun günü dükkân sigortasızmış.")],
    reaction="Rıza Usta'dan şüphelenmiştim. O levha sigortacının reklamıymış. Adam her şeyini kaybetmiş.", search=True))

# K7 · Rıza Usta dükkânının önünde, başı elleri arasında
body = (rect(0, 0, 300, 400, '#AE9B7B') + rect(0, 0, 300, 120, '#8C847A') + ''.join(f'<path d="M0 {y} H300" stroke="#6E665C" stroke-width="2"/>' for y in range(10, 120, 10))
        + person('riza', 150, 200, 1.0, 'down') + '<path d="M90 250 Q100 200 124 196 M210 250 Q200 200 176 196" stroke="#C7A98A" stroke-width="18" fill="none" stroke-linecap="round"/>')
FRAMES.append(dict(
    title="Rıza Usta", date=D, photo=photo(body, ST, '', 'R4 K7 · Rıza (150, 200)'),
    art=["..........", "...####...", "..######..", "#.#.##.#.#", "#.######.#", "##.####.##", ".##....##.", "..######..", ".########.", "##########"],
    hotspots=[hs("wm.r4.riza", 150, 205, 40, "person", "Rıza Usta", "Dükkânının önünde, başını elleri arasına almış. Her şeyini kaybetmiş bir adam.", person="riza")],
    reaction="Bu adamı otuz yıl içimden suçladım. Ona bir özür borçluyum.", search=False))

# K8 · Necati, Cem'in sargısına bakıyor; Cem gözlerini kaçırıyor
body = (shop_wall('#8C7A5E') + clock_wall(5, 10, rows=1) + counter(300)
        + person('necati', 95, 190, 0.85, 'smile', look=1) + person('cem', 215, 200, 0.85, 'down', look=1) + bandage(160, 270, 30, 20, -10))
FRAMES.append(dict(
    title="Göz göze", date=D, photo=photo(body, ST, '', 'R4 K8 · Cem yüzü (215, 200)'),
    art=["..##...##.", ".####.####", ".#..#.####", ".####.####", "..##...##.", ".####.####", "######.###", "######.###", "######.###", ".........."],
    hotspots=[hs("wm.r4.eyes", 215, 200, 34, "clue", "Gözlerini kaçırıyor", "Necati sargıya bakıp gülüyor. Cem başını eğmiş, gözlerini kaçırıyor.")],
    reaction="Gözlerini kaçırıyor. Bunu ilk kez fark ediyorum.", search=False))

# K9 · 18:00, kapanış
body = shop_wall() + clock_wall(6, 0) + counter(300) + figure(80, 330, 150, '#5A4A3A') + figure(220, 330, 140, '#4A5248', limp=True)
FRAMES.append(dict(
    title="Kapanış", date=D, photo=photo(body, ST, '', 'R4 K9 · saat 18:00 (120, 56)'),
    art=["..######..", ".#......#.", "#...#....#", "#...#....#", "#...#....#", "#...#....#", "#...#....#", "#...#....#", ".#..#...#.", "..######.."],
    hotspots=[hs("wm.r4.t1800", 120, 56, 28, "time", "Kapanış", "Saatler 18:00. Necati dükkânı kapatıyor; Cem hâlâ içeride.", tag="18:00")],
    reaction="Herkes eve gidiyor. Cem neden gitmiyor?", search=False))

# K10 · Akşam ışığı: kapalı dükkânda gölge
body = (rect(0, 0, 300, 400, '#5A4C3C') + shopfront('SAATÇİ NECATİ', door_sign='KAPALI') + rect(0, 330, 300, 70, '#3E3428')
        + '<rect x="36" y="130" width="130" height="160" fill="#E8C98A" opacity="0.6"/>' + figure(110, 290, 110, '#1C1714', head='#1C1714')
        + night(0.35) + '<path d="M286 0 V330" stroke="#2A221B" stroke-width="4"/><circle cx="286" cy="40" r="14" fill="#F6E2A8" opacity="0.8"/>')
FRAMES.append(dict(
    title="İçerideki gölge", date=D, photo=photo(body, ST, '', 'R4 K10 · camdaki gölge (110, 220)'),
    art=["##########", "#........#", "#...##...#", "#..####..#", "#...##...#", "#..####..#", "#.######.#", "#..#..#..#", "#..#..#..#", "##########"],
    hotspots=[hs("wm.r4.shadow", 110, 222, 36, "clue", "İçerideki gölge", "Kapanıştan sonra vitrinin ardında bir gölge: tezgâhın arkasında biri var. Boyu Cem'in boyu.")],
    reaction="Kapandıktan sonra ne işi vardı içeride?", search=True))

SCENES = {
    3: {"eyebrow": "BUGÜN · OKUL ÇIKIŞI", "title": "Dava dosyası", "lines": [
        nar("Ayşe okul çantasından kalın bir dosya çıkarıyor.", sfx="folder"),
        nar("İFADE · RIZA KARACA · 3 Mart 1989. \"Arka pencereden atlayan kişi düştü, kalkıp topallayarak kaçtı. Yüzünü görmedim.\"", style="paper", sfx="newspaper"),
        ayse("Babamın eski bir bacak sakatlığı vardı. Herkes ona baktı."),
        ayse("Kimse başka topallayan aramadı."),
    ]},
    7: {"eyebrow": "BUGÜN · TELEFON", "title": "Rıza Usta", "lines": [
        nar("Ayşe'nin telefonu çalıyor. Huzurevinden.", sfx="mobile"),
        ayse("Rıza Usta'yla konuştum. Doksanına yakın, ama her şeyi hatırlıyor."),
        ayse("\"Necati'yi hiç suçlamadım\" dedi. \"Kaçan hafifti, çevikti. Bir çocuktu.\""),
        ayse("Bir çocuk. Otuz yedi yıl boyunca kimse ona sormamış."),
    ]},
}

QUESTION = {
    "text": "Soyguncu topallıyordu. Cem neden topallıyor?",
    "options": [
        {"id": "window", "text": "Pencereden atlarken yaralandı", "reply": ayse("Rıza Usta \"atlayan düştü\" dedi. Aynı gün Cem'in bileği sargılı, ayağı aksıyor…")},
        {"id": "bike", "text": "Söylediği gibi motosikletten düştü", "reply": ayse("Belki. Ama motosikleti çizik bile değil. Sadece çamurlu.")},
        {"id": "always", "text": "Hep topallardı", "reply": ayse("Bir gün önceki fotoğraflarda koşturuyordu. Hayır, bu yeni.")},
    ],
    "truth": "window",
    "outro": [
        nar("Beşinci rulonun etiketi: \"Gece ışığı.\"", sfx="bag"),
        ayse("Babamın bir yarışma için çektiği gece fotoğrafları. Annem anlatırdı; o fotoğrafları hiç görememiş."),
    ],
}

REEL = {"number": 4, "title": "Akşamüstü", "intro": "Etikette: \"Dükkân, akşamüstü.\" Soygundan birkaç saat sonra."}
