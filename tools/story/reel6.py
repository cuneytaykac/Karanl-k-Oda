# Rulo 6 · Haluk — 4 Mart 1989 sabahı. Haluk biliyor; kutuya dokunmuyor.
from photolib import *
from reel2 import hs, ayse, nar

ST = "'89 3 4"
D = '4 Mart 1989'
FRAMES = []


def through_glass(inner):
    return inner + glass_overlay()


# K1 · 08:00 Haluk üniformalı, kapıda
body = rect(0, 0, 300, 400, '#AE9B7B') + rect(0, 300, 300, 100, '#7A6A52') + person('haluk_u', 150, 160, 1.05, 'flat') + wall_clock(250, 50, 24, 8, 0)
FRAMES.append(dict(
    title="Erken ziyaret", date=D, photo=photo(body, ST, '', 'R6 K1 · saat 08:00 (250, 50)'),
    art=["...####...", "..######..", ".########.", "..#.##.#..", "..######..", "...####...", "..######..", ".#.####.#.", ".########.", ".########."],
    hotspots=[hs("wm.r6.t0800", 250, 52, 30, "time", "Haluk geldi", "4 Mart, 08:00. Haluk üniformasıyla, dükkân açılmadan geliyor.", tag="08:00")],
    reaction="Pazar sabahı, üniformayla. Görevli değilse neden üniformalı?", search=False))

# K2 · Cem'i dışarı çağırıyor (camın arkasından)
body = through_glass(rect(0, 0, 300, 400, '#B6A684') + rect(0, 300, 300, 100, '#8A7A60') + figure(90, 330, 190, '#2E3A44', cap=True) + figure(210, 330, 170, '#4A5248', limp=True)
                     + '<path d="M104 196 L150 170" stroke="#2E3A44" stroke-width="12" stroke-linecap="round"/>')
FRAMES.append(dict(
    title="Dışarı", date=D, photo=photo(body, ST, '', 'R6 K2 · çağıran el (150, 172)'),
    art=["..#.......", ".###....#.", "..#....###", ".###....#.", "#####..###", ".###..####", ".#.#...###", ".#.#...#.#", ".#.#...#..", "##.##.##.."],
    hotspots=[hs("wm.r6.call", 148, 174, 30, "clue", "Dışarı", "Haluk, Cem'i el işaretiyle dışarı çağırıyor. Necati camın arkasından çekiyor.")],
    reaction="Babam neden camın arkasından çekmiş? Merak etmiş olmalı.", search=False))

# K3 · Tartışma: Haluk parmağıyla gösteriyor, Cem başı önde
body = through_glass(rect(0, 0, 300, 400, '#B6A684') + rect(0, 300, 300, 100, '#8A7A60') + person('haluk_u', 90, 150, 0.85, 'angry')
                     + person('cem', 220, 190, 0.8, 'down') + '<path d="M130 250 L180 216" stroke="#2E3A44" stroke-width="14" stroke-linecap="round"/><path d="M180 216 l14 -6" stroke="#C7A98A" stroke-width="5" stroke-linecap="round"/>')
FRAMES.append(dict(
    title="Tartışma", date=D, photo=photo(body, ST, '', 'R6 K3 · işaret eden el (186, 214)'),
    art=[".##.......", "####......", ".##.......", "####....#.", "#####..###", "####.#..#.", "####..####", "####...###", "####...###", "####...###"],
    hotspots=[hs("wm.r6.argue", 188, 214, 30, "clue", "Tartışma", "Haluk parmağıyla Cem'i gösteriyor. Sesleri duyulmuyor ama yüzleri her şeyi anlatıyor.")],
    reaction="Ağabey kardeşini azarlıyor. Haluk biliyor.", search=True))

# K4 · Cem ağlıyor, Haluk'un eli omzunda
body = through_glass(rect(0, 0, 300, 400, '#B6A684') + person('cem', 150, 180, 1.05, 'cry') + '<path d="M290 230 Q240 250 206 266" stroke="#2E3A44" stroke-width="20" fill="none" stroke-linecap="round"/>' + f'<ellipse cx="204" cy="268" rx="14" ry="10" fill="{SKIN}"/>')
FRAMES.append(dict(
    title="Gözyaşı", date=D, photo=photo(body, ST, '', 'R6 K4 · gözyaşı (140, 196)'),
    art=["..#.##.#..", ".########.", "..######..", "..#.##.#..", "..######..", "..##..##..", "...####...", "....##....", "..######..", ".########."],
    hotspots=[hs("wm.r6.tears", 142, 196, 32, "clue", "Gözyaşı", "Cem ağlıyor. Haluk elini omzuna koymuş.")],
    reaction="On yedi yaşında bir çocuk. Kızamıyorum bile; ne garip.", search=False))

# K5 · Haluk içeride, arka çekmeceyi açıyor
body = shop_wall() + counter(300) + drawer(150, 210, 120, 60, open_=0.6, box=True) + person('haluk_u', 90, 150, 0.85, 'flat', look=1) + '<path d="M120 260 L176 266" stroke="#2E3A44" stroke-width="16" stroke-linecap="round"/>'
FRAMES.append(dict(
    title="Çekmeceye bakıyor", date=D, photo=photo(body, ST, '', 'R6 K5 · çekmece (210, 290)'),
    art=["..........", ".##.......", "####......", ".##.......", "######....", "####.#####", "####.#...#", "####.#.#.#", "####.#####", ".........."],
    hotspots=[hs("wm.r6.look", 212, 290, 34, "clue", "Çekmeceye bakıyor", "Haluk arka çekmeceyi açıp içine bakıyor. Kimse ona nereye bakacağını söylemedi.")],
    reaction="Nereye bakacağını biliyor. Kimse söylemeden.", search=True))

# K6 · Çekmece kapalı, el çekilmiş
body = shop_wall() + counter(300) + drawer(110, 200, 140, 70) + '<path d="M60 230 L96 236" stroke="#2E3A44" stroke-width="18" stroke-linecap="round"/>' + f'<ellipse cx="100" cy="237" rx="12" ry="9" fill="{SKIN}"/>'
FRAMES.append(dict(
    title="Dokunmadan", date=D, photo=photo(body, ST, '', 'R6 K6 · kapalı çekmece (180, 236)'),
    art=["..........", "..........", "....######", "....#....#", "##..#.##.#", "##..#....#", "....######", "..........", "##########", "#........#"],
    hotspots=[hs("wm.r6.closed", 180, 236, 36, "clue", "Hiçbir şey almadı", "Haluk çekmeceyi kapatıyor. Kutuya dokunmadan.")],
    reaction="Alıp atabilirdi. Ama orada bıraktı. Babamın çekmecesinde.", search=False))

# K7 · Haluk Necati'nin omzuna dokunuyor, gülümsüyor
body = shop_wall('#8C7A5E') + clock_wall(8, 20, rows=1) + person('necati', 100, 190, 0.9, 'smile') + person('haluk_u', 210, 180, 0.9, 'smile') + '<path d="M180 260 Q150 250 128 262" stroke="#2E3A44" stroke-width="16" fill="none" stroke-linecap="round"/>'
FRAMES.append(dict(
    title="Omuz", date=D, photo=photo(body, ST, '', 'R6 K7 · Haluk gülümsüyor (210, 186)'),
    art=["......##..", "..##.####.", ".####.##..", ".#..#####.", ".####.##..", "..##......", ".#####.###", "##########", "##########", "####..####"],
    hotspots=[hs("wm.r6.smile", 210, 190, 34, "clue", "Gülümseme", "Çıkarken Haluk, Necati'nin omzuna dokunup gülümsüyor. Fotoğrafı Cem çekmiş.")],
    reaction="Bu gülümsemeyi hiç unutmayacağım.", search=False))

# K8 · 09:30 Necati her sabahki gibi çalışıyor
body = shop_wall() + clock_wall(9, 30) + counter(270) + person('necati', 150, 200, 0.9, 'flat', look=-1) + wristwatch(150, 264, 14, 9, 30, 90)
FRAMES.append(dict(
    title="Sıradan bir sabah", date=D, photo=photo(body, ST, '', 'R6 K8 · saat 09:30 (196, 62)'),
    art=["..######..", ".#......#.", "#....#...#", "#....#...#", "#....#...#", "#....#...#", "#...#....#", "#..#.....#", ".#......#.", "..######.."],
    hotspots=[hs("wm.r6.t0930", 196, 62, 30, "time", "Sıradan bir sabah", "09:30. Necati her sabahki gibi saat tamir ediyor.", tag="09:30")],
    reaction="Hiçbir şeyden haberi yok. Ertesi sabah onu bu tezgâhın başından alacaklar.", search=False))

# K9 · Cem'in taburesi boş
body = shop_wall() + counter(300) + '<rect x="120" y="230" width="60" height="12" fill="#7A634B"/><path d="M126 242 L118 300 M174 242 L182 300 M150 242 V300" stroke="#5B4836" stroke-width="6"/>' + clock_wall(9, 50, rows=1)
FRAMES.append(dict(
    title="Boş tabure", date=D, photo=photo(body, ST, '', 'R6 K9 · tabure (150, 250)'),
    art=["..........", "..........", "..######..", "..######..", "...#..#...", "...#..#...", "...#..#...", "..#....#..", "..#....#..", "##########"],
    hotspots=[hs("wm.r6.stool", 150, 254, 34, "clue", "Cem gitti", "Cem'in taburesi boş. O sabahtan sonra dükkâna bir daha gelmemiş.")],
    reaction="Dava boyunca bir kez bile ifade vermemiş. Kimse ona sormamış bile.", search=False))

# K10 · Haluk'un arabası uzaklaşıyor; ön koltukta Cem
body = through_glass(rect(0, 0, 300, 400, '#B6A684') + rect(0, 280, 300, 120, '#8A7A60') + car(20, 360, 0.95)
                     + f'<circle cx="122" cy="210" r="13" fill="{SKIN}"/>' + ''.join(f'<circle cx="{122+dx}" cy="{204+dy}" r="7" fill="#2E261F"/>' for dx, dy in ((-8, -4), (0, -9), (8, -5)))
                     + f'<circle cx="182" cy="208" r="12" fill="{SKIN}"/><rect x="170" y="194" width="24" height="7" fill="#1E2830"/>')
FRAMES.append(dict(
    title="Uzaklaşan araba", date=D, photo=photo(body, ST, CAR_DEFS, 'R6 K10 · ön koltukta Cem (122, 210)'),
    art=["..........", "...#####..", "..#.#.#.#.", ".#..#.#..#", "##########", "##########", "##########", ".##....##.", ".##....##.", ".........."],
    hotspots=[hs("wm.r6.passenger", 122, 210, 28, "clue", "Ön koltukta Cem", "Haluk'un arabası uzaklaşıyor; ön koltukta Cem.")],
    reaction="Kardeşini alıp götürmüş. Ertesi gün de babamı.", search=True))

SCENES = {
    3: {"eyebrow": "BUGÜN · DÜKKÂNDA", "title": "Bir ziyaretçi", "lines": [
        nar("Dükkânın zili çalıyor. Kapıda yaşlı, uzun boylu bir adam; şapkasını çıkarıyor.", sfx="doorbell"),
        {"speaker": "haluk", "text": "Nermin Hanım'ın dükkânı burası mı? Eskiden bir filmim kalmıştı burada."},
        {"speaker": "haluk", "text": "Otuz yıldır arada bir sorarım. Hep \"yok\" dediler."},
        nar("Gözleri arkadaki dolapta. Bir süre bakıyor. Sonra hiçbir şey istemeden çıkıp gidiyor."),
    ]},
    7: {"eyebrow": "BUGÜN · GECE", "title": "Tutanak", "lines": [
        nar("Ayşe gece yarısı dava dosyasının son sayfalarını fotoğraflayıp gönderiyor.", sfx="message"),
        nar("ARAMA TUTANAĞI · 5 Mart 1989. Arama ekibi amiri: Komiser Yrd. H. Demir. Arka çekmecede lacivert kadife kolye kutusu bulunmuştur.", style="paper", sfx="newspaper"),
        ayse("Aramayı kendisi yönetmiş. Kutunun nerede olduğunu bile bile."),
        ayse("Bugün dükkâna gelen adam… Haluk amcaydı, değil mi?"),
    ]},
}

QUESTION = {
    "text": "Bu filmler neden 37 yıl boyunca hiç banyo edilmedi?",
    "options": [
        {"id": "nermin", "text": "Nermin Hanım onları sakladı", "reply": ayse("Haluk amca \"hep yok dediler\" dedi. Biri bu filmleri bilerek saklamış.")},
        {"id": "forgot", "text": "Necati onları unuttu", "reply": ayse("Ertesi gün tutuklandı. Altı yıl yattı. Belki… ama fotoğraf için yaşayan bir adam unutur mu?")},
        {"id": "haluk", "text": "Haluk onlara el koydu", "reply": ayse("O zaman neden hâlâ arıyor? Filmler onda değil. Hiç olmadı.")},
    ],
    "truth": "nermin",
    "outro": [
        nar("Torbada son bir rulo kaldı. Etiketinde: \"4 Mart, ev.\"", sfx="bag"),
        ayse("Babamın evde çektiği son fotoğraflar. Ertesi sabah onu götürdüler."),
    ],
}

REEL = {"number": 6, "title": "Haluk", "intro": "Etikette: \"4 Mart, sabah.\" Soygunun ertesi günü, tutuklanmadan bir gün önce."}
