# Yanlış Adam · case.json üretici: içerik burada yazılır, bulmacalar çözücüyle doğrulanır.
import json, sys
sys.path.insert(0, '/tmp/claude-0/-home-claude/ed5e3f0f-5ad1-5f6a-9a71-86a9292f8b58/scratchpad/story')
from solvlib import solve

R1 = {
  "k1": ["..######..", ".##....##.", "##..#...##", "#...#....#", "#...#....#", "#...#####.", "#........#", "##......##", ".##....##.", "..######.."],
  "k2": ["..######..", ".########.", ".##....##.", ".#..#...#.", ".#..###.#.", ".##....##.", ".########.", "..##..##..", "..##.###..", "..######.."],
  "k3": ["...####...", "...####...", "..######..", ".##....##.", ".#..#...#.", ".#..###.#.", ".##....##.", "..######..", "...####...", "...####..."],
  "k4": ["....##....", "..#.##.#..", ".########.", "..##..##..", "####..####", "####..####", "..##..##..", ".########.", "..#.##.#..", "....##...."],
  "k5": ["..........", "...####...", "..######..", ".##.##.##.", ".########.", ".########.", "..........", "##########", "#########.", ".........."],
  "k6": ["..######..", ".##.##.##.", "##########", ".########.", "..######..", "...####...", "....##....", "...#..#...", "..#....#..", "...####..."],
  "k7": [".########.", ".#......#.", ".#.####.#.", ".#.#..#.#.", ".#.####.#.", ".#......#.", ".#....###.", ".#......#.", ".#......#.", "##########"],
  "k8": ["...............", "......##.......", ".......####....", "..#####.#......", ".#######.......", "##########..##.", ".###...######..", "#...#.#.....#..", "#.#.#.#.###..#.", "#...#.#.#.#..#.", ".###...######.."],
  "k9": ["...####...", "..#....#..", "..#....#..", "..#....#..", ".########.", ".###..###.", ".###..###.", ".####.###.", ".########.", ".########."],
  "k10": ["........##", ".......##.", "......##..", ".....##..#", "....##...#", "...##....#", "..##...#.#", ".##..####.", "##..######", ".....####."],
}

# Yumuşak giriş: Rulo 1'in bulmacaları küçükten büyüğe (r1_easy.py).
from r1_easy import R1_EASY
R1.update(R1_EASY)

def hs(id, x, y, r, kind, title, body, tag=None, person=None):
    d = {"id": id, "x": x, "y": y, "r": r, "kind": kind, "title": title, "body": body}
    if tag: d["tag"] = tag
    if person: d["person"] = person
    return d

case = {
  "id": "wrong_man",
  "number": 1,
  "title": "Yanlış Adam",
  "summary": "Saatçi Necati Aydın, 1989'da bir kuyumcu soygunundan hapse girdi. Ölene kadar \"Yapmadım\" dedi. Onu aklayacak filmler 37 yıldır senin dükkânında duruyor.",
  "reelCount": 7,
  "tags": ["7 rulo", "70 kare", "Gizem · 12+"],
  # Defterdeki zaman çizelgesi: baştan bilinen olaylar. Fotoğraflardan bulunan saatler buna eklenir.
  "timeline": {
    "title": "3 Mart 1989 · Cumartesi",
    "date": "3 Mart 1989",
    "events": [
      {"tag": "12:30", "title": "Soygun", "body": "Rıza Kuyumculuk soyuldu. Kaçan kişi topallıyordu."},
    ],
  },
  "intro": [
    {"speaker": None, "text": "\"Teslim edilmeyenler\" dolabında bir torba: yedi film rulosu. Üstünde Nermin Hanım'ın el yazısı: \"N. Aydın, 4 Mart 1989.\""},
    {"speaker": None, "text": "Eski bir gazetede adı çıkıyor: saatçi Necati Aydın, 5 Mart 1989'da kuyumcu soygunundan tutuklanmış."},
    {"speaker": "ayse", "text": "Babam ölene kadar \"yapmadım\" dedi. Kimse inanmadı. Ben de hiç emin olamadım."},
    {"speaker": "ayse", "text": "Soygun 3 Mart cumartesi, saat 12:30'da olmuş. Kaçan kişi topallıyormuş; babamın da eski bir bacak sakatlığı vardı. İki gün sonra polis, babamın dükkânında arka çekmecede çalıntı bir kolye kutusu buldu."},
    {"speaker": "ayse", "text": "Babam \"O saatte göldeydim, Haluk da yanımdaydı\" dedi. Ama Haluk amca mahkemede \"O gün onu görmedim\" dedi."},
  ],
  "people": [
    {"id": "ayse", "name": "Ayşe Aydın", "initial": "A", "role": "Necati'nin kızı · 38 · öğretmen", "known": True},
    {"id": "necati", "name": "Necati Aydın", "initial": "N", "role": "Saatçi · 1989'da hapse girdi", "known": True},
    {"id": "cem", "name": "Cem Demir", "initial": "C", "role": "Necati'nin çırağı · 1989'da 17 yaşında", "known": False},
    {"id": "haluk", "name": "Haluk Demir", "initial": "H", "role": "Polis memuru · Necati'nin çocukluk arkadaşı", "known": False},
    {"id": "riza", "name": "Rıza Usta", "initial": "R", "role": "Karşıdaki kuyumcu · soyulan dükkân", "known": False},
  ],
  "reels": [
    {
      "number": 1,
      "title": "Saatçi dükkânı",
      "intro": "Torbadaki ilk film. Etikette Necati'nin el yazısı: \"Dükkân, Şubat.\"",
      "question": {
        "text": "Soygun saatinde, 12:30'da, Necati neredeydi?",
        "options": [
          {"id": "lake", "text": "Haluk'la göle gitti",
           "reply": {"speaker": "ayse", "text": "Babamın yıllarca söylediği de buydu. Ama Haluk amca mahkemede tersini söyledi. İkisinden biri yalan söylüyor."}},
          {"id": "shop", "text": "Dükkânındaydı, yalnızdı",
           "reply": {"speaker": "ayse", "text": "Ama 11:05'te kapıya \"Kapalı\" asmış. İnsan yalnız oturmak için dükkânını kapatır mı? Bilmiyorum… belki."}},
          {"id": "jeweller", "text": "Kuyumcunun arka sokağındaydı",
           "reply": {"speaker": "ayse", "text": "Bunu düşünmek bile istemiyorum. Ama fotoğraflara sen bakıyorsun, ben değil. Belki de herkes haklıydı."}},
        ],
        "outro": [
          {"speaker": None, "text": "Torbada ikinci bir rulo var. Etiketinde aynı el yazısı: \"Göl, 3 Mart.\""},
          {"speaker": "ayse", "text": "Bu ruloyu banyo ettiğinde kimin yalan söylediğini göreceğiz. Babamın mı, Haluk amcanın mı."},
        ],
        "truth": "lake",
        "truthNote": "Rulo 2'deki göl fotoğrafları gösterecek.",
      },
      "frames": [
        {"number": 1, "title": "Saatçi dükkânı", "date": "24 Şubat 1989", "puzzle": R1["k1"], "photo": "photos/r1_k1_shopfront.svg",
         "hotspots": [hs("wm.r1.sign", 150, 92, 44, "person", "Necati Aydın", "Saatçi. Dükkânı çarşının tam ortasında; tabelası hep tozsuz.", person="necati")]},
        {"number": 2, "title": "Duvar saatleri", "date": "24 Şubat 1989", "puzzle": R1["k2"], "photo": "photos/r1_k2_clocks.svg",
         "hotspots": [hs("wm.r1.clocks", 150, 165, 34, "clue", "Saatler hep doğru", "Duvardaki bütün saatler aynı anı gösteriyor. Necati'nin fotoğraflarında saate güvenebilirsin.", tag="4:10")]},
        {"number": 3, "title": "Tezgâh", "date": "24 Şubat 1989", "puzzle": R1["k3"], "photo": "photos/r1_k3_bench.svg",
         "hotspots": [hs("wm.r1.camera", 222, 300, 36, "clue", "Fotoğraf makinesi", "Necati fotoğraf meraklısı; makinesi tezgâhta, hep elinin altında.")]},
        {"number": 4, "title": "Çırak", "date": "25 Şubat 1989", "puzzle": R1["k4"], "photo": "photos/r1_k4_apprentice.svg",
         "hotspots": [hs("wm.r1.cem", 150, 150, 36, "person", "Cem Demir", "17 yaşında, Necati'nin çırağı. İşini seviyor; ustasına hayran.", person="cem")]},
        {"number": 5, "title": "Üçü bir arada", "date": "25 Şubat 1989", "puzzle": R1["k5"], "photo": "photos/r1_k5_three.svg",
         "hotspots": [hs("wm.r1.haluk", 230, 150, 34, "person", "Haluk Demir", "Polis memuru. Necati'nin çocukluk arkadaşı ve Cem'in ağabeyi.", person="haluk")]},
        {"number": 6, "title": "Karşı dükkân", "date": "25 Şubat 1989", "puzzle": R1["k6"], "photo": "photos/r1_k6_jeweller.svg",
         "hotspots": [
           hs("wm.r1.insurance", 98, 252, 32, "clue", "Yeni sigorta levhası", "Rıza Usta'nın vitrininde yepyeni bir \"Sigortalıdır\" levhası. Ayşe: \"Belki kendi dükkânını soydu, sigortadan para almak için.\""),
           hs("wm.r1.riza", 226, 248, 34, "person", "Rıza Usta", "Karşıdaki kuyumcu. Soyulan dükkân onun.", person="riza"),
         ]},
        {"number": 7, "title": "3 Mart, sabah", "date": "3 Mart 1989", "puzzle": R1["k7"], "photo": "photos/r1_k7_morning.svg",
         "hotspots": [hs("wm.r1.t0900", 80, 110, 30, "time", "Dükkân açıldı", "Soygun günü. Necati dükkânı her zamanki gibi açıyor.", tag="09:00")]},
        {"number": 8, "title": "Kırmızı motosiklet", "date": "3 Mart 1989", "puzzle": R1["k8"], "photo": "photos/r1_k8_moto.svg",
         "hotspots": [
           hs("wm.r1.t1040", 62, 78, 28, "time", "Cem çıktı", "\"Annem hasta\" deyip izin istedi.", tag="10:40"),
           hs("wm.r1.moto", 178, 292, 44, "clue", "Kırmızı motosiklet", "Cem'in motosikleti. Kasabada başka kırmızısı yok."),
         ]},
        {"number": 9, "title": "Kapalı", "date": "3 Mart 1989", "puzzle": R1["k9"], "photo": "photos/r1_k9_closed.svg",
         "hotspots": [hs("wm.r1.t1105", 150, 66, 28, "time", "Dükkân kapandı", "Necati kapıya \"Kapalı\" levhasını astı.", tag="11:05")]},
        {"number": 10, "title": "Göle", "date": "3 Mart 1989", "puzzle": R1["k10"], "photo": "photos/r1_k10_car.svg",
         "hotspots": [hs("wm.r1.rods", 210, 170, 38, "clue", "Arabada oltalar", "Kapıda Haluk'un arabası, arka camdan oltalar uzanıyor. Göle gidiyorlar.")]},
      ],
    },
  ],
}

R1_REACT = {1: 'Tabelayı babam kendi elleriyle boyamış. Annem anlatırdı; ben o zaman kucakta bebekmişim.', 2: 'Annem hep söylerdi: babam saatleri asla yanlış bırakmazmış. "Saat yalan söylerse insan da söyler" dermiş.', 3: "Bu makineyi hiç görmedim. Babam tutuklanınca ortadan kaybolmuş. Demek filmleriyle birlikte Nermin Hanım'a bırakmış.", 4: 'Cem. Babamın çırağı. Mahkemeden sonra kasabadan gitmiş; nereye gittiğini kimse bilmiyor.', 5: 'Haluk amca her bayram bize gelirmiş. Mahkemeden sonra bir kez bile kapımızı çalmamış.', 6: "Rıza Usta soygundan bir yıl sonra dükkânı kapatıp İzmir'e taşınmış. Sigortadan ne aldığını kimse bilmiyor.", 7: '3 Mart. Babamın son sıradan sabahı. Bunu bilmeden fotoğrafını çekmiş.', 8: '"Annem hasta" mı? Annem, Cem\'in annesiyle komşuydu. O hafta hasta olduğunu hiç söylemedi.', 9: 'Cumartesi öğleden önce dükkânı kapatmak babama hiç uymaz. Ya çok önemli bir işi vardı ya da biri onu çağırdı.', 10: 'Göl. Babam yıllarca "göldeydim" dedi. O gün gerçekten oradaysa, sonraki rulo bunu gösterecek.'}
R1_SCENE = {3: {'eyebrow': 'BUGÜN · DÜKKÂNDA', 'title': 'Gazete kupürleri', 'lines': [{'speaker': None, 'text': 'Ertesi sabah Ayşe dükkâna sararmış bir dosyayla geliyor.'}, {'speaker': None, 'style': 'paper', 'text': 'SAATÇİ KUYUMCUYU SOYDU. Kasabamızda 3 Mart cumartesi öğle saatlerinde Rıza Kuyumculuk soyuldu. Tutuklanan saatçi N. A. suçlamaları kabul etmiyor. (6 Mart 1989)'}, {'speaker': 'ayse', 'text': 'Annem bu kupürleri yıllarca sakladı. Ben bakmaya hiç cesaret edemedim.'}, {'speaker': 'ayse', 'text': '"Kabul etmiyor" yazmışlar. Sanki susmak da bir suçmuş gibi.'}, {'speaker': 'ayse', 'text': 'Sen fotoğraflara devam et. Ben bu sefer sonuna kadar okuyacağım.'}]}, 7: {'eyebrow': 'BUGÜN · AKŞAM', 'title': 'Bir mektup', 'lines': [{'speaker': None, 'text': "Akşam telefon çalıyor. Ayşe'nin sesi titrek."}, {'speaker': 'ayse', 'text': 'Kupürlerin arasından bir mektup çıktı. Babam cezaevinden yazmış, ben altı yaşındayken.'}, {'speaker': None, 'style': 'letter', 'text': 'Kızım, saatler yalan söylemez. Bir gün o sabahın saatleri de konuşacak. O gün beni affet ya da affetme, ama bil ki ben göldeydim.'}, {'speaker': 'ayse', 'text': 'Çocukken okusam hiçbir şey anlamazdım. Ama şimdi elimizde o sabahın fotoğrafları var.'}, {'speaker': 'ayse', 'text': 'Sıradaki kareler soygun günü, değil mi? Saatlere iyi bak.'}]}}
for f in case["reels"][0]["frames"]:
    f["reaction"] = {"speaker": "ayse", "text": R1_REACT[f["number"]]}
    if f["number"] in R1_SCENE: f["scene"] = R1_SCENE[f["number"]]
    # Oyuncunun büyüteçle kendisi aradığı kareler; diğerlerinde ayrıntı kendiliğinden işaretlenir.
    f["search"] = f["number"] in (2, 8, 9, 10)

# ---- Rulo 2–7 ve final (reel2.py … reel7.py): bulmacalar onarılır, fotoğraflar yazılır.
import importlib, os, re as _re
from check import check_reel
PHOTOS = '/mnt/user-data/outputs/ko_story/assets/case_files/wrong_man/photos'
os.makedirs(PHOTOS, exist_ok=True)
TR = str.maketrans('çğıöşüâÇĞİÖŞÜÂ', 'cgiosuaCGIOSUA')
def slug(t): return _re.sub(r'[^a-z0-9]+', '_', t.translate(TR).lower()).strip('_')[:18]
for n in range(2, 8):
    m, notes = check_reel(f'reel{n}')
    for line in notes: print(f'  R{n} {line}')
    frames = []
    for i, f in enumerate(m.FRAMES, 1):
        name = f'r{n}_k{i}_{slug(f["title"])}.svg'
        open(f'{PHOTOS}/{name}', 'w').write(f['photo'])
        fr = {"number": i, "title": f["title"], "date": f["date"], "puzzle": f["art"], "photo": f"photos/{name}",
              "hotspots": f["hotspots"], "reaction": {"speaker": "ayse", "text": f["reaction"]}, "search": bool(f["search"])}
        if i in m.SCENES: fr["scene"] = m.SCENES[i]
        frames.append(fr)
    case["reels"].append({**m.REEL, "question": m.QUESTION, "frames": frames})
    if hasattr(m, 'FINALE'): case["finale"] = m.FINALE
    for name, svg in getattr(m, 'ENDING_PHOTOS', {}).items():
        open(f'{PHOTOS}/{name}.svg', 'w').write(svg)

# Hikâye satırlarının sesleri (assets/audio/<ad>.wav).
case["intro"][0]["sfx"] = "bag"
case["intro"][1]["sfx"] = "newspaper"
R1_SCENE[3]["lines"][0]["sfx"] = "doorbell"
R1_SCENE[3]["lines"][1]["sfx"] = "newspaper"
R1_SCENE[7]["lines"][0]["sfx"] = "phone"
R1_SCENE[7]["lines"][2]["sfx"] = "letter"
case["reels"][0]["question"]["outro"][0]["sfx"] = "bag"

# Doğrulama: her bulmaca tek çözümlü ve tahminsiz çözülebilir; ayrıntılar 300×400 içinde.
ok = True
for reel in case["reels"]:
    for f in reel["frames"]:
        rows = f["puzzle"]
        assert len(set(map(len, rows))) == 1, (reel["number"], f["number"])
        r = solve(rows)
        good = r != 'contra' and r[1]
        print(f"R{reel['number']}K{f['number']:<2} {len(rows[0])}x{len(rows):<2} {'✓' if good else '✗ ' + str(r)}  {f['title']}")
        ok &= good
        for h in f["hotspots"]:
            assert h["x"] - h["r"] >= 0 and h["y"] - h["r"] >= 0 and h["x"] + h["r"] <= 300 and h["y"] + h["r"] <= 400, h["id"]
for rl in case["reels"]:
    for f in rl["frames"]:
        sc = f.get("scene")
        for l in ([f["reaction"]] if "reaction" in f else []) + (sc["lines"] if sc else []):
            assert l["speaker"] is None or l["speaker"] in {p["id"] for p in case["people"]}, l
            assert l.get("style") in (None, "paper", "letter", "photo"), l
    if l.get("style") == "photo":
        assert os.path.exists('/mnt/user-data/outputs/ko_story/' + l["image"]), ("fotoğraf yok", l["image"])
for rl in case["reels"]:
    n = sum(1 for f in rl["frames"] if f.get("search"))
    assert 2 <= n <= 4, ("rulo başına 3–4 arama karesi", rl["number"], n)
import os
SOUNDS = {f[:-4] for f in os.listdir('/mnt/user-data/outputs/ko_step14/assets/audio')} | {f[:-4] for f in os.listdir('/mnt/user-data/outputs/ko_step13/assets/audio')} | {f[:-4] for f in os.listdir('/mnt/user-data/outputs/ko_step19/assets/audio')} | {f[:-4] for f in os.listdir('/mnt/user-data/outputs/ko_step12/assets/audio')}
def lines_of(c):
    yield from c["intro"]
    for rl in c["reels"]:
        if rl.get("question"): yield from rl["question"].get("outro", [])
        for f in rl["frames"]:
            if f.get("scene"): yield from f["scene"]["lines"]
            if f.get("reaction"): yield f["reaction"]
    fin = c.get("finale")
    if fin:
        yield from fin["intro"]; yield from fin["epilogue"]
        for o in fin["options"]: yield from o["ending"]
    for rl in c["reels"]:
        for o in (rl.get("question") or {}).get("options", []):
            if o.get("reply"): yield o["reply"]
PEOPLE = {p["id"] for p in case["people"]}
for l in lines_of(case):
    assert l.get("speaker") is None or l["speaker"] in PEOPLE, ("bilinmeyen kişi", l)
    assert l.get("style") in (None, "paper", "letter", "photo"), l
    if l.get("style") == "photo":
        assert os.path.exists('/mnt/user-data/outputs/ko_story/' + l["image"]), ("fotoğraf yok", l["image"])
    assert l.get("sfx") is None or l["sfx"] in SOUNDS, ("bilinmeyen ses", l.get("sfx"))
ids = [h["id"] for rl in case["reels"] for f in rl["frames"] for h in f["hotspots"]]
assert len(ids) == len(set(ids))
assert ok
out = '/mnt/user-data/outputs/ko_story/assets/case_files/wrong_man/case.json'
json.dump(case, open(out, 'w'), ensure_ascii=False, indent=1)
print('yazıldı', out)
