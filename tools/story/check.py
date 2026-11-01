# Kontrol: bulmacalar tek çözümlü mü (gerekirse onar), fotoğraflar + ipucu noktaları kontrol sayfası.
import sys, base64, importlib, os, re, itertools
sys.path.insert(0, os.path.dirname(__file__))
from solvlib import solve

HERE = os.path.dirname(__file__)


def unique(rows):
    r = solve(rows)
    return r != 'contra' and r[0] == 0 and r[1]


def repair(rows, max_flips=6):
    """Tek çözümlü değilse: çözücünün çözemediği bölgede hücre çevirerek dene (en az değişiklik)."""
    if unique(rows):
        return rows, 0
    h, w = len(rows), len(rows[0])
    grid = [list(r) for r in rows]
    for flips in range(1, max_flips + 1):
        best = None
        for r in range(h):
            for c in range(w):
                g = [row[:] for row in grid]
                g[r][c] = '.' if g[r][c] == '#' else '#'
                cand = [''.join(x) for x in g]
                res = solve(cand)
                if res == 'contra':
                    continue
                score = res[0]
                if score == 0 and res[1]:
                    return cand, flips
                if best is None or score < best[0]:
                    best = (score, cand)
        if best is None:
            break
        grid = [list(x) for x in best[1]]
    return None, None


def check_reel(mod, fix=True):
    m = importlib.import_module(mod)
    out = []
    for i, f in enumerate(m.FRAMES, 1):
        rows = f['art']
        assert len(set(map(len, rows))) == 1, (mod, i, 'satır boyları')
        if not unique(rows):
            fixed, n = repair(rows)
            if fixed is None:
                out.append(f'K{i}: ONARILAMADI')
                continue
            f['art'] = fixed
            out.append(f'K{i}: {n} hücre değişti → ' + ' '.join(fixed))
        for h in f['hotspots']:
            assert h['x'] - h['r'] >= 0 and h['y'] - h['r'] >= 0 and h['x'] + h['r'] <= 300 and h['y'] + h['r'] <= 400, h['id']
    return m, out


def sheet(mods, path):
    from playwright.sync_api import sync_playwright
    cells = []
    for mod in mods:
        m = importlib.import_module(mod)
        for i, f in enumerate(m.FRAMES, 1):
            svg = f['photo']
            circles = ''.join(f'<circle cx="{h["x"]}" cy="{h["y"]}" r="{h["r"]}" fill="none" stroke="#00E0FF" stroke-width="2.5" stroke-dasharray="5 4"/>' for h in f['hotspots'])
            svg = svg.replace('</svg>', circles + '</svg>')
            b64 = base64.b64encode(svg.encode()).decode()
            art = '<br>'.join(r.replace('#', '■').replace('.', '·') for r in f['art'])
            cells.append(f"<div class=c><img src='data:image/svg+xml;base64,{b64}' width=210 height=280><div class=t>{mod[-1]}·K{i} {f['title']}{' 🔍' if f.get('search') else ''}</div><div class=a>{art}</div></div>")
    html = ("<html><head><style>body{margin:0;background:#100E0D;width:1150px;font:11px sans-serif;color:#ccc}"
            ".c{display:inline-block;margin:4px;vertical-align:top;width:220px;text-align:center}.t{margin:2px 0}.a{font:8px monospace;line-height:8px;color:#888}</style></head><body>"
            + ''.join(cells) + "</body></html>")
    hp = path.replace('.png', '.html')
    open(hp, 'w').write(html)
    with sync_playwright() as p:
        b = p.chromium.launch(); pg = b.new_page(viewport={'width': 1150, 'height': 800})
        pg.goto('file://' + hp); pg.wait_for_timeout(800); pg.screenshot(path=path, full_page=True); b.close()


if __name__ == '__main__':
    mods = sys.argv[1:]
    for mod in mods:
        m, out = check_reel(mod)
        print(mod, 'tamam' if not out else '\n  ' + '\n  '.join(out))
    sheet(mods, os.path.join(HERE, 'sheet_' + '_'.join(x[-1] for x in mods) + '.png'))
