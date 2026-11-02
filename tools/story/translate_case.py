"""Bir Dosyanın çevirisini üretir: case.json (Türkçe, asıl) + çeviri tablosu → case.<dil>.json

Kullanım:  python3 tools/story/translate_case.py wrong_man en

Çeviri tablosu: tools/story/translations/<id>.<dil>.json  ([{"tr": ..., "en": ...}, ...])
Yapı (bulmacalar, kimlikler, fotoğraflar, sesler) asıl dosyadan birebir kopyalanır;
yalnızca okunan metinler değişir. Tabloda karşılığı olmayan bir metin varsa betik
durur ve eksikleri listeler: hikâye değişip çeviri unutulmasın.
"""
import json
import re
import sys
from pathlib import Path

# Metin olmayan alanlar: çevrilmez.
SKIP = {'id', 'photo', 'style', 'sfx', 'speaker', 'person', 'kind', 'image', 'truth', 'puzzle'}
ROOT = Path(__file__).resolve().parents[2]


def is_text(s):
    return isinstance(s, str) and re.search(r'[A-Za-zçğıöşüÇĞİÖŞÜ]', s)


def translate(node, table, missing, key=''):
    if isinstance(node, dict):
        return {k: (v if k in SKIP else translate(v, table, missing, k)) for k, v in node.items()}
    if isinstance(node, list):
        return [translate(v, table, missing, key) for v in node]
    if is_text(node):
        if node not in table:
            missing.append(node)
            return node
        return table[node]
    return node


def main(case_id, lang):
    src = ROOT / 'assets/case_files' / case_id / 'case.json'
    table_file = ROOT / 'tools/story/translations' / f'{case_id}.{lang}.json'
    table = {e['tr']: e[lang] for e in json.loads(table_file.read_text())}
    missing = []
    out = translate(json.loads(src.read_text()), table, missing)
    if missing:
        print(f'Çevirisi eksik {len(missing)} metin:')
        for m in dict.fromkeys(missing):
            print('  -', m)
        sys.exit(1)
    dst = src.with_name(f'case.{lang}.json')
    dst.write_text(json.dumps(out, ensure_ascii=False, indent=2) + '\n')
    print(f'Yazıldı: {dst.relative_to(ROOT)}')


if __name__ == '__main__':
    main(sys.argv[1], sys.argv[2])
