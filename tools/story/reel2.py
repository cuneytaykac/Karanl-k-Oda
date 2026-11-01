# Rulo 2 · Göl — 3 Mart 1989, 11:40–13:00. Necati her balığın yanına kol saatini koyar.
from photolib import *

ST = "'89 3 3"
D = '3 Mart 1989'


def hs(id, x, y, r, kind, title, body, tag=None, person=None):
    d = {"id": id, "x": x, "y": y, "r": r, "kind": kind, "title": title, "body": body}
    if tag: d["tag"] = tag
    if person: d["person"] = person
    return d


def ayse(t): return {"speaker": "ayse", "text": t}
def nar(t, **k): return {"speaker": None, "text": t, **k}


FRAMES = []

# K1 · Göle varış: karşı kıyıda saat kulesi 11:40
body = (lake(tower_at=(232, 168, 66), time=(11, 40)) + shore(330) + reeds(0, 80, 340)
        + figure(120, 318, 70, '#4A4236') + figure(176, 322, 74, '#5A4A3A')
        + '<path d="M128 262 L196 182" stroke="#2A221B" stroke-width="2"/>')
FRAMES.append(dict(
    title="Göle varış", date=D, photo=photo(body, ST, LAKE_DEFS, 'R2 K1 · göl, karşı kıyıda kule 11:40'),
    art=["..........", "....##....", "...####...", "....##....", "....##....", ".#..##..#.", "##########", "#.#.#.#.##", "##########", ".........."],
    hotspots=[hs("wm.r2.t1140", 232, 128, 30, "time", "Göle vardılar", "Karşı kıyıdaki saat kulesi 11:40'ı gösteriyor. Kasaba 20 kilometre geride.", tag="11:40")],
    reaction="O saat kulesi hâlâ duruyor. Geçen yaz önünden geçtim, hiç dikkat etmemişim.", search=False))

# K2 · Haluk oltasını hazırlıyor (sivil); arabanın tavanında telsiz anteni
body = (lake(water_y=250) + shore(300, '#7A6A52') + car(14, 380, 0.62, rods=False)
        + person('haluk', 214, 196, 0.9, 'smile') + '<path d="M180 300 L290 120" stroke="#2A221B" stroke-width="2.4"/>')
FRAMES.append(dict(
    title="Haluk ve oltası", date=D, photo=photo(body, ST, LAKE_DEFS + CAR_DEFS, 'R2 K2 · Haluk sivil; araba tavanında anten (107, 290)'),
    art=["#.........", ".#........", "..#.......", "...#..###.", "....#.###.", ".....#.#..", "....######", "...#######", "..##.#####", ".........."],
    hotspots=[hs("wm.r2.antenna", 107, 296, 30, "clue", "Telsiz anteni", "Haluk bugün izinli; üniforması yok. Ama arabasının tavanında polis telsizinin anteni var.")],
    reaction="Haluk amca hep böyleydi; izinliyken bile telsizini yanından ayırmazmış.", search=False))

# K3 · İlk balık + kol saati 12:05
body = (rect(0, 0, 300, 400, '#8A7A5C') + ''.join(f'<path d="M0 {y} C100 {y-8} 200 {y+8} 300 {y}" stroke="#7A6A4E" stroke-width="3" fill="none"/>' for y in range(30, 400, 34))
        + fish(140, 210, 190, -8) + wristwatch(240, 300, 22, 12, 5, 20))
FRAMES.append(dict(
    title="İlk balık", date=D, photo=photo(body, ST, '', 'R2 K3 · balık ve yanında kol saati 12:05 (240, 300)'),
    art=["..........", ".....##...", "...######.", ".#########", "##.#######", "##########", ".#########", "...######.", ".....##...", ".........."],
    hotspots=[hs("wm.r2.t1205", 240, 300, 30, "time", "İlk balık", "Necati balığın yanına kol saatini koymuş: 12:05. Saatçinin şakası.", tag="12:05")],
    reaction="Babam bunu her balıkta yaparmış. Annem \"Saatçi balık tutmaz, zaman tutar\" derdi.", search=True))

# K4 · Gölgeler kısa: güneş tepede
body = (lake(water_y=230) + shore(300) + figure(150, 360, 110, '#5A4A3A')
        + '<ellipse cx="156" cy="362" rx="22" ry="5" fill="#3B3128" opacity="0.6"/>'
        + '<circle cx="250" cy="40" r="18" fill="#F1E8D6" opacity="0.8"/>')
FRAMES.append(dict(
    title="Öğle güneşi", date=D, photo=photo(body, ST, LAKE_DEFS, 'R2 K4 · kısa gölge (156, 362)'),
    art=["...##.....", "..####....", "...##.....", "..####....", ".######...", "..####....", "..#..#....", "..#..#....", "..#..#....", ".########."],
    hotspots=[hs("wm.r2.shadow", 156, 360, 28, "clue", "Gölgeler kısa", "Necati'nin gölgesi ayağının dibinde. Güneş tepede: öğle vakti.")],
    reaction="Saat, gölge, kule… Babam sanki bir gün birinin bu fotoğraflara bakacağını biliyormuş.", search=False))

# K5 · İkinci balık + saat 12:30 (anahtar kare)
body = (rect(0, 0, 300, 400, '#7E6E52') + rect(0, 250, 300, 150, '#6A5A44')
        + fish(130, 180, 220, 4, '#A3A89C') + wristwatch(222, 292, 26, 12, 30, -12)
        + '<path d="M40 330 h60" stroke="#4E453A" stroke-width="3"/>')
FRAMES.append(dict(
    title="İkinci balık", date=D, photo=photo(body, ST, '', 'R2 K5 · büyük balık, kol saati 12:30 (222, 292)'),
    art=["..........", "....###...", "..#######.", "##########", "###.######", "##########", "..#######.", "....###...", "..........", "##########"],
    hotspots=[hs("wm.r2.t1230", 222, 292, 32, "time", "Necati göldeydi", "Balığın yanındaki saat 12:30'u gösteriyor. Soygun anında Necati kasabadan 20 kilometre uzakta.", tag="12:30")],
    reaction="12:30… Tam soygun saati. Babam doğruyu söylemiş. Otuz yedi yıl sonra.", search=True))

# K6 · Haluk balığı tutuyor, gülüyor
body = (lake(water_y=240) + person('haluk', 150, 170, 1.05, 'laugh') + fish(150, 300, 150, 0) +
        '<path d="M86 290 q20 20 44 10 M214 290 q-20 20 -44 10" stroke="#C7A98A" stroke-width="14" fill="none" stroke-linecap="round"/>')
FRAMES.append(dict(
    title="Haluk gülüyor", date=D, photo=photo(body, ST, LAKE_DEFS, 'R2 K6 · Haluk balıkla, yüzü (150, 170)'),
    art=["...####...", "..######..", "..#.##.#..", "..######..", "...#..#...", "....##....", "#..####..#", "##########", "#..####..#", "....##...."],
    hotspots=[hs("wm.r2.haluk_fish", 150, 175, 40, "clue", "Haluk da oradaydı", "Haluk, Necati'nin balığını tutmuş kahkaha atıyor. Mahkemede \"O gün onu görmedim\" demişti.")],
    reaction="Mahkemede yemin etmiş. Bu fotoğrafta babamın balığını tutuyor.", search=False))

# K7 · Termos, iki bardak, günün gazetesi
body = (rect(0, 0, 300, 400, '#8C7A5E') + rect(0, 220, 300, 180, '#6E5E47') + thermos(40, 200)
        + newspaper(130, 230, 140, 110, 'POSTA', '3 MART 1989', -8))
FRAMES.append(dict(
    title="Termos", date=D, photo=photo(body, ST, '', 'R2 K7 · gazete tarihi (200, 268)'),
    art=["..##......", ".####.....", "..##......", ".####.####", ".####.#..#", ".####.####", ".####.#..#", ".####.####", ".####.....", ".........."],
    hotspots=[hs("wm.r2.paper", 200, 272, 34, "clue", "Günün gazetesi", "Termosun yanında 3 Mart 1989 tarihli gazete. Fotoğraf o güne ait.")],
    reaction="Avukat \"tarih kanıtlanamaz\" derdi belki. Ama gazete de saat de aynı günü söylüyor.", search=False))

# K8 · Kule 12:50, kıyıda iki adam
body = (lake(tower_at=(150, 170, 90), time=(12, 50)) + shore(320) + figure(70, 330, 64, '#4A4236') + figure(240, 334, 64, '#5A4A3A'))
FRAMES.append(dict(
    title="Kule", date=D, photo=photo(body, ST, LAKE_DEFS, 'R2 K8 · kule saati 12:50 (150, 105)'),
    art=["....##....", "...####...", "...#..#...", "...####...", "...####...", "...####...", "..######..", ".########.", "##########", ".........."],
    hotspots=[hs("wm.r2.t1250", 150, 105, 28, "time", "Hâlâ göldeler", "Kule 12:50'yi gösteriyor. Soygundan yirmi dakika sonra ikisi hâlâ kıyıda.", tag="12:50")],
    reaction="Yirmi kilometre. O yolu motosikletle bile yirmi dakikada gidemezsin.", search=True))

# K9 · Zamanlayıcıyla ikisi, kol kola
body = (lake(water_y=260) + person('necati', 100, 180, 0.95) + person('haluk', 205, 175, 0.95, 'laugh')
        + '<path d="M130 290 Q155 280 175 290" stroke="#5A4A3A" stroke-width="16" fill="none" stroke-linecap="round"/>')
FRAMES.append(dict(
    title="İki arkadaş", date=D, photo=photo(body, ST, LAKE_DEFS, 'R2 K9 · kol kola (155, 288)'),
    art=["..##..##..", ".####.####", ".####.####", "..##..##..", ".###..###.", "##########", "##########", "####..####", "###....###", "###....###"],
    hotspots=[hs("wm.r2.friends", 155, 286, 32, "clue", "Kol kola", "Necati makineyi bir kütüğe koyup zamanlayıcıyla ikisini birlikte çekmiş.")],
    reaction="Bu fotoğrafı duvara asmak isterdim. Ama Haluk amcanın yüzüne bakamıyorum.", search=False))

# K10 · Son balık + saat 13:00
body = (rect(0, 0, 300, 400, '#8A7A5C') + rect(30, 120, 240, 200, '#6E5E47')
        + fish(130, 220, 150, -20) + wristwatch(214, 270, 22, 1, 0, 30))
FRAMES.append(dict(
    title="Son balık", date=D, photo=photo(body, ST, '', 'R2 K10 · saat 13:00 (214, 270)'),
    art=["..........", ".###......", "#####.....", "#.####....", "######.##.", ".#######..", "..######..", "..##.###..", "......##..", ".......#.."],
    hotspots=[hs("wm.r2.t1300", 214, 270, 30, "time", "Son balık", "Saat 13:00. Necati son balığı da saatiyle fotoğraflamış.", tag="13:00")],
    reaction="Saat bir. Soygundan yarım saat sonra hâlâ oradalar. Artık eminim.", search=True))

SCENES = {
    3: {"eyebrow": "BUGÜN · ÖĞLE ARASI", "title": "Bir telefon", "lines": [
        nar("Öğle arasında Ayşe dükkâna geliyor; telefonu hâlâ elinde.", sfx="doorbell"),
        ayse("Haluk amcayı aradım. Otuz yedi yıl sonra ilk kez."),
        ayse("\"Göl\" dedim, sesi değişti. \"Eski şeyleri kurcalama, kızım\" dedi ve kapattı."),
        ayse("Hiç kızmadı. Korkmuş gibiydi."),
    ]},
    7: {"eyebrow": "BUGÜN · AKŞAM", "title": "Tanık ifadesi", "lines": [
        nar("Ayşe dava dosyasının fotokopisini getiriyor. Bir sayfanın kenarı yıllardır kıvrık.", sfx="folder"),
        nar("TANIK İFADESİ · H. DEMİR · 12 Nisan 1989. \"Üç Mart günü sanık Necati Aydın'ı görmedim. Gün boyu görevdeydim.\"", style="paper", sfx="newspaper"),
        ayse("\"Görevdeydim\" demiş. Oysa o gün izinliymiş; fotoğraflarda sivil."),
        ayse("Neden yalan söylesin? Babamın en yakın arkadaşıydı."),
    ]},
}

QUESTION = {
    "text": "Peki Haluk mahkemede neden \"onu görmedim\" dedi?",
    "options": [
        {"id": "protect", "text": "Birini korumak için",
         "reply": ayse("Kimi? Babamı değil, belli. Babamı yakmış. O zaman başka birini.")},
        {"id": "threat", "text": "Biri onu tehdit etti",
         "reply": ayse("Haluk amca polisti. Onu kim tehdit edebilir ki? Ama sesi gerçekten korkmuş gibiydi.")},
        {"id": "forgot", "text": "Gerçekten hatırlamıyordu",
         "reply": ayse("Üç gün sonra mı? Bütün gün balık tuttukları bir günü? Buna inanmak isterdim.")},
    ],
    "truth": "protect",
    "truthNote": "Rulo 5–6 gösterecek: kardeşi Cem'i koruyordu.",
    "outro": [
        nar("Torbadaki üçüncü rulonun etiketi: \"Göl yolu.\"", sfx="bag"),
        ayse("Babam dönüş yolunu da çekmiş. Belki yolda bir şey görmüşlerdir."),
    ],
}

REEL = {"number": 2, "title": "Göl", "intro": "Etikette aynı el yazısı: \"Göl, 3 Mart.\" Soygun günü, öğle saatleri."}
