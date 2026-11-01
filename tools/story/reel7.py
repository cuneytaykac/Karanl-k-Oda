# Rulo 7 · Son gün — 4 Mart 1989 öğleden sonra. Ev, bebek Ayşe'nin ilk adımı, filmler Karanlık Oda'ya.
from photolib import *
from reel2 import hs, ayse, nar


def photo_line(name, caption):
    """Hikâye içinde banyo edilir gibi beliren son fotoğraf."""
    return {"speaker": None, "style": "photo", "image": f"assets/case_files/wrong_man/photos/{name}.svg", "text": caption}


ST = "'89 3 4"
D = '4 Mart 1989'
FRAMES = []
HOME = '#A8967A'

# K1 · Ev
body = (rect(0, 0, 300, 400, '#CDBD9C') + rect(40, 110, 220, 200, '#B8A27E') + '<path d="M28 116 L150 40 L272 116 Z" fill="#7A5A44"/>'
        + window(66, 150, 60, 60) + window(176, 150, 60, 60) + rect(126, 230, 48, 80, '#4A3B2E') + rect(0, 310, 300, 90, '#8A9068')
        + ''.join(f'<circle cx="{x}" cy="306" r="{r}" fill="#6E7458"/>' for x, r in ((30, 26), (60, 18), (250, 24), (280, 20))))
FRAMES.append(dict(
    title="Ev", date=D, photo=photo(body, ST, '', 'R7 K1 · ev (150, 180)'),
    art=["....##....", "...####...", "..######..", ".########.", "##########", ".#......#.", ".#.##.#.#.", ".#.##.#.#.", ".#....#.#.", ".########."],
    hotspots=[hs("wm.r7.home", 150, 176, 44, "clue", "Aydın ailesinin evi", "4 Mart öğleden sonra. Necati'nin evi.")],
    reaction="Bu ev… Babam hapisteyken satmışız. Burada yaşadığımı bile hatırlamıyorum.", search=False))

# K2 · Evdeki tamir masası, saatçi büyüteci
body = (rect(0, 0, 300, 400, HOME) + rect(0, 250, 300, 150, '#6A5440') + rect(0, 240, 300, 14, '#8A7058') + lamp(240, 120, 120, 0.4)
        + '<circle cx="120" cy="214" r="28" fill="#1C1714"/><circle cx="120" cy="214" r="18" fill="#8FA3A8" opacity="0.7"/>' + wristwatch(190, 230, 14, 3, 45, 90)
        + ''.join(f'<circle cx="{x}" cy="232" r="3" fill="#C9A34E"/>' for x in (60, 72, 84)))
FRAMES.append(dict(
    title="Tamir masası", date=D, photo=photo(body, ST, GLOW_DEFS, 'R7 K2 · büyüteç (120, 214)'),
    art=["..........", "...####...", "..#....#..", ".#......#.", ".#......#.", ".#......#.", "..#....#..", "...####...", "..........", "##########"],
    hotspots=[hs("wm.r7.loupe", 120, 214, 32, "clue", "Saatçi büyüteci", "Necati'nin evdeki tamir masası; üstünde saatçi büyüteci.")],
    reaction="Bu büyüteç bende. Babamdan kalan tek şey.", search=False))

# K3 · İlk adım: bebek Ayşe ayakta
body = rect(0, 0, 300, 400, HOME) + rect(0, 300, 300, 100, '#8A7058') + person('baby', 150, 190, 1.2, 'laugh') + '<path d="M130 330 v40 M170 330 v40" stroke="#D8CBB2" stroke-width="16" stroke-linecap="round"/>' + '<path d="M90 280 l-20 -30 M210 280 l20 -30" stroke="#D8CBB2" stroke-width="12" stroke-linecap="round"/>'
FRAMES.append(dict(
    title="İlk adım", date=D, photo=photo(body, ST, '', 'R7 K3 · bebek Ayşe (150, 200)'),
    art=["...####...", "..######..", "..#.##.#..", "..######..", "...####...", "#.######.#", ".########.", "..######..", "..##..##..", "..##..##.."],
    hotspots=[hs("wm.r7.firststep", 150, 200, 40, "person", "Bebek Ayşe", "Ayşe'nin ilk adımları. 4 Mart 1989.", person="ayse")],
    reaction="Bu benim. İlk adımım. Hiç bilmiyordum.", search=False))

# K4 · Necati, Ayşe'yi kucağında, tamir masasının başında
body = rect(0, 0, 300, 400, HOME) + rect(0, 300, 300, 100, '#6A5440') + person('necati', 130, 150, 1.0, 'laugh') + person('baby', 196, 240, 0.8, 'smile') + '<path d="M90 300 Q150 330 210 300" stroke="#5A4A3A" stroke-width="20" fill="none" stroke-linecap="round"/>'
FRAMES.append(dict(
    title="Kucakta", date=D, photo=photo(body, ST, '', 'R7 K4 · baba ve kız (170, 250)'),
    art=["..####....", ".######...", ".#.##.#...", ".######...", "..####.##.", ".#####.##.", "########..", "#########.", "#########.", ".########."],
    hotspots=[hs("wm.r7.hug", 170, 250, 40, "clue", "Babası", "Necati, Ayşe'yi tamir masasının başında kucağına almış.")],
    reaction="Ertesi sabah onu götürdüler. Bir babanın son mutlu günü.", search=False))

# K5 · Evdeki duvar saati 16:30
body = rect(0, 0, 300, 400, HOME) + rect(110, 40, 80, 300, '#6A4E3A', f'stroke="{INK}" stroke-width="3"') + wall_clock(150, 110, 32, 4, 30) + '<path d="M150 160 V260" stroke="#C9A34E" stroke-width="3"/><circle cx="150" cy="270" r="14" fill="#C9A34E"/>'
FRAMES.append(dict(
    title="Duvar saati", date=D, photo=photo(body, ST, '', 'R7 K5 · saat 16:30 (150, 110)'),
    art=["..######..", ".#......#.", ".#..#...#.", ".#..#...#.", ".#..##..#.", ".#......#.", "..######..", "....##....", "...####...", "...####..."],
    hotspots=[hs("wm.r7.t1630", 150, 110, 36, "time", "Evdeki saat", "16:30. Necati filmleri bırakmak için evden çıkmak üzere.", tag="16:30")],
    reaction="Saatleri hep doğru. Evde bile.", search=True))

# K6 · Karanlık Oda, 1989
body = rect(0, 0, 300, 400, '#CDBD9C') + shopfront('KARANLIK ODA', wall='#B8A27E', sign_bg='#5A2A22', sign_fg='#F1E8D6', door_sign='AÇIK') + rect(0, 330, 300, 70, '#8A7A60')
FRAMES.append(dict(
    title="Karanlık Oda", date=D, photo=photo(body, ST, '', 'R7 K6 · tabela (150, 84)'),
    art=["##########", "#.#.##.#.#", "##########", "..........", "####..####", "#..#..#..#", "#..#..#..#", "####..#.##", "#..#..#..#", "####..####"],
    hotspots=[hs("wm.r7.darkroom", 150, 86, 40, "clue", "Senin dükkânın", "Tabelada \"Karanlık Oda\". 1989'da, senin dükkânın.")],
    reaction="Burası… burası senin dükkânın! Babam filmleri buraya getirmiş.", search=True))

# K7 · Genç Nermin Hanım tezgâhta, yedi ruloyu teslim alıyor
rolls = ''.join(f'<rect x="{70+i*24}" y="282" width="18" height="30" rx="3" fill="#1C1714"/><rect x="{73+i*24}" y="276" width="12" height="7" fill="#C9A34E"/>' for i in range(7))
body = rect(0, 0, 300, 400, '#9C8A6A') + rect(0, 300, 300, 100, '#5B4836') + rect(0, 290, 300, 12, '#7A634B') + person('nermin', 150, 160, 1.0, 'smile') + rolls
FRAMES.append(dict(
    title="Nermin Hanım", date=D, photo=photo(body, ST, '', 'R7 K7 · genç Nermin (150, 160), rulolar (150, 296)'),
    art=["...####...", "..######..", "..#.##.#..", "..######..", "...####...", "..######..", ".########.", "..........", "#.#.#.#.#.", "#.#.#.#.#."],
    hotspots=[hs("wm.r7.nermin", 150, 296, 40, "clue", "Yedi rulo", "Tezgâhta genç Nermin Hanım yedi ruloyu teslim alıyor: \"N. Aydın, 4 Mart 1989.\"")],
    reaction="Nermin Hanım'ı hiç bu kadar genç görmemiştim. Babam ona güvenmiş.", search=False))

# K8 · Teslim fişi 17:10
body = rect(0, 0, 300, 400, '#5B4836') + note(50, 70, 200, 250, ['KARANLIK ODA', 'Fiş No. 1147', '', 'Ad: N. Aydın', 'Adet: 7 rulo', 'Tarih: 4.3.1989', 'Saat: 17.10', '', 'Teslim: 11 Mart'], rot=2, size=18, font='Caveat')
FRAMES.append(dict(
    title="Teslim fişi", date=D, photo=photo(body, ST, '', 'R7 K8 · saat satırı (130, 220)'),
    art=["##########", "#........#", "#.######.#", "#........#", "#.####...#", "#........#", "#.#####..#", "#........#", "#.###....#", "##########"],
    hotspots=[hs("wm.r7.t1710", 130, 222, 36, "time", "Filmler teslim edildi", "Fiş No. 1147: N. Aydın, 7 rulo, 4 Mart 1989 saat 17:10. Teslim günü: 11 Mart.", tag="17:10")],
    reaction="11 Mart'ta alacakmış. 5 Mart'ta tutuklandı. Bir daha hiç gelemedi.", search=True))

# K9 · Vitrine yansıyan Necati, makinesi elinde
body = rect(0, 0, 300, 400, '#9C8A6A') + window(20, 20, 260, 360, glass='#B9AE94') + f'<g opacity="0.55">{person("necati", 150, 170, 1.0, "smile")}</g>' + rect(118, 160, 64, 36, '#1C1714', 'opacity="0.6"') + '<path d="M40 40 L120 380 M100 40 L180 380" stroke="#F1E8D6" stroke-width="10" opacity="0.12"/>'
FRAMES.append(dict(
    title="Yansıma", date=D, photo=photo(body, ST, '', 'R7 K9 · yansıma (150, 180)'),
    art=["##########", "#...##...#", "#..####..#", "#..#..#..#", "#..####..#", "#...##...#", "#.######.#", "#########.", "##########", "##########"],
    hotspots=[hs("wm.r7.selfie", 150, 178, 40, "clue", "Son fotoğraf", "Necati'nin kendini çektiği tek kare: Karanlık Oda'nın vitrinine yansımış, makinesi elinde.")],
    reaction="Gülümsüyor. Ertesi gün olacaklardan habersiz.", search=False))

# K10 · Son kare: ışık sızmış
body = light_leak()
FRAMES.append(dict(
    title="Son kare", date=D, photo=photo(body, ST, '', 'R7 K10 · ışık sızıntısı (230, 130)'),
    art=["......####", ".......###", "........##", ".........#", "..........", "..........", "#.........", "##........", "###.......", "####......"],
    hotspots=[hs("wm.r7.lastframe", 236, 130, 44, "clue", "Son kare", "Rulonun son karesine ışık sızmış. Geri kalanı fotoğraflarda değil artık.")],
    reaction="Hepsi bu. Artık her şeyi biliyoruz… değil mi?", search=False))

SCENES = {
    3: {"eyebrow": "BUGÜN · DÜKKÂNDA", "title": "İlk adım", "lines": [
        nar("Ayşe uzun süre konuşmuyor. Fotoğrafı iki eliyle tutuyor.", sfx="clock"),
        ayse("Annem \"İlk adımını babanın kucağına doğru attın\" derdi. Hep uydurduğunu sanırdım."),
    ]},
    7: {"eyebrow": "BUGÜN · TORBANIN DİBİ", "title": "Bir not", "lines": [
        nar("Torbanın dibinde katlanmış, sararmış bir kâğıt var. Nermin Hanım'ın el yazısı.", sfx="bag"),
        nar("6 Mart'ta Haluk Bey geldi, filmleri istedi. \"Bozuk çıktı\" dedim, vermedim. Mahkemeye de götüremedim, korktum. Bu dolaptaki her film bir borç.", style="letter", sfx="letter"),
        ayse("Nermin Hanım da biliyormuş. Ve otuz yedi yıl susmuş."),
        ayse("Dükkânı sana bırakmış. Belki de borcu sen ödeyesin diye."),
    ]},
}

QUESTION = {
    "text": "Delil masası: kutuyu çekmeceye kim koydu, kim sakladı?",
    "options": [
        {"id": "cem_haluk", "text": "Cem koydu, Haluk sakladı",
         "reply": ayse("12:18'deki motosiklet. Sargılı bilek. Gece çekmeceye eğilen bulanık gölge. Ertesi sabah çekmeceye bakıp dokunmayan Haluk. Hepsi aynı yeri gösteriyor.")},
        {"id": "cem_alone", "text": "Cem koydu, kimse bilmiyordu",
         "reply": ayse("Haluk ertesi sabah doğruca o çekmeceyi açtı. Aramayı da kendisi yönetti. Biliyordu.")},
        {"id": "haluk_alone", "text": "Haluk koydu, suçu Cem'e attı",
         "reply": ayse("12:30'da Haluk babamla göldeydi. Kutuyu çalan da koyan da o olamaz. Ama sakladı.")},
    ],
    "truth": "cem_haluk",
    "outro": [
        nar("Ayşe fotoğrafları masaya diziyor. Tek tek, sırayla. Sonunda ortaya çıkan hikâye şu:"),
        nar("3 Mart, öğle arası. Kumar borcu olan Cem, kuyumcuya arka pencereden giriyor. Atlarken bileğini incitiyor."),
        nar("Çaldıklarından bir kutuyu, sonra almak üzere ustasının dükkânındaki arka çekmeceye saklıyor."),
        nar("Haluk o saatte Necati'yle göldeydi. Telsizden soygunu duydu; yolda kardeşinin motosikletini görmüştü. Ertesi sabah gerçeği öğrendi."),
        nar("Kardeşini korumak için kutuyu yerinde bıraktı, aramayı kendisi yönetti ve mahkemede arkadaşını görmediğini söyledi."),
        nar("Necati ölene kadar kimin yaptığını hiç öğrenmedi. Gerçeği ilk öğrenen kişi sensin."),
    ],
}

REEL = {"number": 7, "title": "Son gün", "intro": "Etikette: \"4 Mart, ev.\" Torbadaki son rulo."}

FINALE = {
    "eyebrow": "SON KARAR",
    "intro": [
        ayse("Şimdi ne yapmalıyım?"),
        ayse("Haluk amca yetmiş bir yaşında, emekli. Cem elli dört yaşında, iki çocuk babası. Babam artık yok."),
    ],
    "question": "Fotoğrafları kime vereceksin?",
    "hint": "Doğru cevabı yok. Ayşe senin kararına uyacak.",
    "options": [
        {"id": "lawyer", "text": "Bir avukata ver", "detail": "Davanın yeniden açılması için başvurulsun; Necati'nin adı resmen temize çıksın.",
         "ending": [
             nar("Bir hafta sonra, kasabanın tek hukuk bürosu. Avukat fotoğrafları tek tek masaya diziyor.", sfx="folder"),
             ayse("Davanın yeniden açılması aylar sürebilir, dedi. Ama babamın adı resmen temize çıkacak."),
             nar("İki ay sonra, adliye koridoru. Ayşe'nin karşısındaki bankta yaşlı, uzun boylu bir adam oturuyor; şapkası dizlerinde."),
             {"speaker": "haluk", "text": "Otuz yedi yıl, her sabah o çekmeceyi düşündüm. Kardeşimdi. Onu kurtardığımı sandım."},
             {"speaker": "haluk", "text": "Necati'yi değil… kendimi kurtarmışım. O da değil aslında."},
             ayse("Babam sizi hiç suçlamadı, biliyor musunuz? Ölene kadar \"Haluk'un bir bildiği vardır\" dedi."),
             nar("Haluk başını eğiyor. Bir şey diyecek gibi oluyor, diyemiyor."),
             nar("Koridorun ucunda Cem beliriyor. İzmir'den ilk otobüsle gelmiş, kendi ayağıyla. Ağabeyinin yanına oturuyor ve ilk kez Ayşe'nin yüzüne bakıyor."),
             photo_line("end_court", "Adliye koridoru. Necati Aydın'ın davası yeniden açıldı."),
             ayse("Babam bunu görseydi… Belki de görüyor."),
         ]},
        {"id": "ayse", "text": "Sadece Ayşe'ye ver", "detail": "Babasının masum olduğunu o bilsin; başka kimse bilmesin.",
         "ending": [
             nar("Ayşe yarışma fotoğrafını çerçeveletiyor. Evinin duvarına, babasının portresinin yanına asıyor."),
             ayse("Kimse bilmeyecek. Ama ben biliyorum. Babam yapmadı."),
             nar("Bir akşam dükkânın zili çalıyor. Kapıda yine o yaşlı adam. Bu kez filmleri sormuyor.", sfx="doorbell"),
             {"speaker": "haluk", "text": "Necati'nin kızı… biliyor mu?"},
             nar("Başını sallıyorsun. Haluk uzun süre susuyor. Sonra cebinden kenarları yıpranmış bir fotoğraf çıkarıp tezgâha bırakıyor: göl kıyısı, iki genç adam, kol kola."),
             {"speaker": "haluk", "text": "Ona ver. Bende durmaya hakkı yok."},
             nar("Bir hafta sonra Ayşe'nin kapısının altından bir zarf atılmış. İçinde tek satır var.", sfx="letter"),
             nar("Özür dilerim. — C.", style="letter"),
             photo_line("end_wall", "Ayşe'nin evi. Duvarda iki fotoğraf: yarışma karesi ve göldeki iki arkadaş."),
             ayse("Bazen gerçeği bilmek yeter. Bazen yetmez. Bugün yetiyor."),
         ]},
    ],
    "epilogue": [
        nar("O gece dükkânda yalnızsın. Saatlerin tik takından başka ses yok.", sfx="clock"),
        nar("Nermin Hanım'ın notu hâlâ cebinde: \"Bu dolaptaki her film bir borç.\""),
        nar("Torbanın boşalan yerine kendi el yazınla küçük bir etiket yapıştırıyorsun: \"N. Aydın · teslim edildi.\""),
        nar("Rafta onlarca torba daha var; her biri başka birinin hikâyesi. Birinin etiketi gözüne takılıyor: \"Oda 214, Temmuz 1979.\"", sfx="bag"),
        photo_line("end_shelf", "Teslim edilmeyenler. Bir borç ödendi."),
    ],
}


# ---- Kapanış fotoğrafları (finalde, karara göre)
ENDING_PHOTOS = {}

# Adliye koridoru: bankta Haluk ve Cem, karşıda Ayşe'nin silueti; masada dosya.
body = (rect(0, 0, 300, 400, '#A89A80') + rect(0, 290, 300, 110, '#7A6C56')
        + ''.join(f'<rect x="{x}" y="40" width="40" height="200" fill="#9C8E74" stroke="#7A6C56" stroke-width="3"/>' for x in (20, 130, 240))
        + rect(30, 250, 160, 14, '#5B4836') + '<path d="M40 264 v30 M180 264 v30" stroke="#4A3B2E" stroke-width="6"/>'
        # Bugün: Haluk 71, Cem 54 yaşında; saçları ağarmış.
        + person('haluk', 80, 200, 0.55, 'down').replace('fill="#3B3128"', 'fill="#C8C0B4"')
        + person('cem', 150, 205, 0.5, 'down', look=1).replace('fill="#2E261F"', 'fill="#8A8278"')
        + figure(250, 330, 150, '#6A4E44'))
ENDING_PHOTOS['end_court'] = photo(body, "'27 1 15", '', 'Kapanış · adliye koridoru')

# Ayşe'nin duvarı: iki çerçeve, yarışma karesi ve göldeki iki arkadaş.
frame_a = rect(40, 90, 100, 130, '#3B3128') + rect(48, 98, 84, 114, '#5A4C3C') + '<circle cx="90" cy="140" r="26" fill="#F2D898" opacity="0.6"/>' + ''.join(f'<circle cx="{x}" cy="190" r="6" fill="#E2D6BC"/>' for x in (66, 90, 114))
frame_b = rect(160, 110, 100, 120, '#3B3128') + rect(168, 118, 84, 104, '#8C9488') + '<circle cx="196" cy="160" r="12" fill="#C7A98A"/><circle cx="226" cy="160" r="12" fill="#C7A98A"/><path d="M180 222 q16 -40 32 0 M210 222 q16 -40 32 0" fill="#4A4236"/>'
body = rect(0, 0, 300, 400, '#B8A88A') + rect(0, 320, 300, 80, '#7A6A52') + frame_a + frame_b + '<path d="M90 90 L90 60 M210 110 L210 60" stroke="#3B3128" stroke-width="1.5"/>' + lamp(150, 40, 160, 0.35)
ENDING_PHOTOS['end_wall'] = photo(body, "'27 1 8", GLOW_DEFS, 'Kapanış · Ayşe\'nin duvarı')

# Teslim edilmeyenler rafı: torbalar, biri "Oda 214".
bags = ''
for row, y in enumerate((70, 170, 270)):
    bags += rect(10, y + 80, 280, 10, '#4A3B2E')
    for i, x in enumerate(range(22, 280, 52)):
        h = 60 + (i * 7 + row * 11) % 18
        bags += f'<path d="M{x} {y+80} L{x+4} {y+80-h} Q{x+20} {y+70-h} {x+40} {y+80-h} L{x+44} {y+80} Z" fill="{"#8A7458" if (i+row)%2 else "#7A664E"}"/>'
body = rect(0, 0, 300, 400, '#3E3228') + bags + note(178, 196, 64, 30, ['Oda 214'], rot=-4, size=14) + note(74, 300, 92, 30, ['N. Aydın ✓'], rot=3, size=13) + lamp(240, 30, 140, 0.4) + night(0.2)
ENDING_PHOTOS['end_shelf'] = photo(body, "'27 1 31", GLOW_DEFS, 'Kapanış · Teslim edilmeyenler rafı')
