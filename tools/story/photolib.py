# Karanlık Oda · fotoğraf çizim kütüphanesi (SVG, 300×400). Rulo 1 üslubu:
# düz sepya şekiller, sıcak örtü, vinyet, köşede turuncu tarih damgası.
import math

INK = '#2A221B'
SKIN = '#C7A98A'
NECK = '#B8977A'
PAPER = '#E9DFC9'
STAMP = '#E8893A'


def photo(body, stamp, defs='', comment=''):
    return f'''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 300 400" width="300" height="400">
  <!-- {comment} -->
  <defs>
    <radialGradient id="vignette" cx="0.5" cy="0.48" r="0.75">
      <stop offset="0.55" stop-color="#1C1714" stop-opacity="0"/>
      <stop offset="1" stop-color="#1C1714" stop-opacity="0.8"/>
    </radialGradient>{defs}
  </defs>
{body}
  <rect width="300" height="400" fill="#8A5A2B" opacity="0.08"/>
  <rect width="300" height="400" fill="url(#vignette)"/>
  <text x="282" y="392" text-anchor="end" font-family="JetBrainsMono" font-size="13" font-weight="700" fill="{STAMP}" opacity="0.92">{stamp}</text>
</svg>
'''


def grad(id_, top, bottom):
    return f'''
    <linearGradient id="{id_}" x1="0" y1="0" x2="0" y2="1">
      <stop offset="0" stop-color="{top}"/>
      <stop offset="1" stop-color="{bottom}"/>
    </linearGradient>'''


def rect(x, y, w, h, fill, extra=''):
    return f'<rect x="{x}" y="{y}" width="{w}" height="{h}" fill="{fill}" {extra}/>'


# ------------------------------------------------------------------ saat

def hands(cx, cy, r, h, m, color=INK, w=2.4):
    ma = math.radians(m * 6 - 90)
    ha = math.radians((h % 12 + m / 60) * 30 - 90)
    mx, my = cx + r * 0.78 * math.cos(ma), cy + r * 0.78 * math.sin(ma)
    hx, hy = cx + r * 0.5 * math.cos(ha), cy + r * 0.5 * math.sin(ha)
    return (f'<path d="M{cx:.1f} {cy:.1f} L{hx:.1f} {hy:.1f}" stroke="{color}" stroke-width="{w*1.25:.1f}" stroke-linecap="round"/>'
            f'<path d="M{cx:.1f} {cy:.1f} L{mx:.1f} {my:.1f}" stroke="{color}" stroke-width="{w:.1f}" stroke-linecap="round"/>'
            f'<circle cx="{cx}" cy="{cy}" r="{max(1.2, w*0.8):.1f}" fill="{color}"/>')


def ticks(cx, cy, r, color=INK):
    out = []
    for i in range(12):
        a = math.radians(i * 30)
        l = 0.16 if i % 3 == 0 else 0.08
        x1, y1 = cx + r * 0.9 * math.sin(a), cy - r * 0.9 * math.cos(a)
        x2, y2 = cx + r * (0.9 - l) * math.sin(a), cy - r * (0.9 - l) * math.cos(a)
        out.append(f'<path d="M{x1:.1f} {y1:.1f} L{x2:.1f} {y2:.1f}" stroke="{color}" stroke-width="{1.6 if i%3==0 else 1}"/>')
    return ''.join(out)


def wall_clock(cx, cy, r, h, m, rim='#3B3128', face='#E2D6BC'):
    return (f'<circle cx="{cx}" cy="{cy}" r="{r+3}" fill="{rim}"/><circle cx="{cx}" cy="{cy}" r="{r}" fill="{face}"/>'
            + ticks(cx, cy, r) + hands(cx, cy, r, h, m, w=max(1.4, r / 9)))


def wristwatch(cx, cy, r, h, m, angle=0):
    strap = '#4A3424'
    return (f'<g transform="rotate({angle} {cx} {cy})">'
            f'<rect x="{cx-r*0.55}" y="{cy-r*2.6}" width="{r*1.1}" height="{r*5.2}" rx="{r*0.3}" fill="{strap}"/>'
            f'<circle cx="{cx}" cy="{cy}" r="{r+2.5}" fill="#B9A27A"/><circle cx="{cx}" cy="{cy}" r="{r}" fill="#F1E8D6"/>'
            + ticks(cx, cy, r) + hands(cx, cy, r, h, m, w=max(1.3, r / 8)) + '</g>')


def tower(x, base, h, hh, mm):
    """Karşı kıyıdaki saat kulesi (uzakta, küçük)."""
    w = h * 0.28
    r = w * 0.36
    return (f'<rect x="{x-w/2}" y="{base-h}" width="{w}" height="{h}" fill="#8C7A5E"/>'
            f'<path d="M{x-w/2-2} {base-h} L{x} {base-h-w*0.9} L{x+w/2+2} {base-h} Z" fill="#6E5E47"/>'
            + wall_clock(x, base - h + w * 0.7, r, hh, mm, rim='#5A4A3A', face='#EFE5D2'))


# ------------------------------------------------------------------ insanlar

def _hair(who, cx, cy, rx, ry):
    if who == 'necati':  # kırlaşmış, yana taranmış
        return f'<path d="M{cx-rx} {cy-ry*0.28} C{cx-rx*0.95} {cy-ry*1.12} {cx+rx*0.95} {cy-ry*1.12} {cx+rx} {cy-ry*0.28} C{cx+rx*0.7} {cy-ry*0.75} {cx-rx*0.7} {cy-ry*0.75} {cx-rx} {cy-ry*0.28} Z" fill="#7E766C"/>'
    if who == 'cem':  # koyu kıvırcık
        return ''.join(f'<circle cx="{cx+dx*rx:.1f}" cy="{cy+dy*ry:.1f}" r="{rad*rx:.1f}" fill="#2E261F"/>'
                       for dx, dy, rad in ((-0.7, -0.78, 0.42), (-0.2, -1.0, 0.46), (0.32, -0.98, 0.44), (0.76, -0.7, 0.38)))
    if who in ('haluk', 'haluk_u'):
        return f'<path d="M{cx-rx} {cy-ry*0.3} C{cx-rx} {cy-ry*1.1} {cx+rx} {cy-ry*1.1} {cx+rx} {cy-ry*0.3} C{cx+rx*0.6} {cy-ry*0.8} {cx-rx*0.6} {cy-ry*0.8} {cx-rx} {cy-ry*0.3} Z" fill="#3B3128"/>'
    if who == 'riza':  # kel, yanlarda gri
        return (f'<path d="M{cx-rx} {cy-ry*0.05} C{cx-rx*1.05} {cy-ry*0.5} {cx-rx*0.8} {cy-ry*0.55} {cx-rx*0.7} {cy-ry*0.35}" fill="none" stroke="#9A9288" stroke-width="{rx*0.25:.1f}"/>'
                f'<path d="M{cx+rx} {cy-ry*0.05} C{cx+rx*1.05} {cy-ry*0.5} {cx+rx*0.8} {cy-ry*0.55} {cx+rx*0.7} {cy-ry*0.35}" fill="none" stroke="#9A9288" stroke-width="{rx*0.25:.1f}"/>')
    if who == 'nermin':  # topuz, koyu
        return (f'<circle cx="{cx+rx*0.2}" cy="{cy-ry*1.05}" r="{rx*0.42:.1f}" fill="#2E261F"/>'
                f'<path d="M{cx-rx*1.05} {cy+ry*0.1} C{cx-rx*1.1} {cy-ry*1.1} {cx+rx*1.1} {cy-ry*1.1} {cx+rx*1.05} {cy+ry*0.1} C{cx+rx*0.7} {cy-ry*0.7} {cx-rx*0.7} {cy-ry*0.7} {cx-rx*1.05} {cy+ry*0.1} Z" fill="#2E261F"/>')
    if who == 'baby':
        return f'<path d="M{cx-rx*0.5} {cy-ry*0.85} q{rx*0.5} {-ry*0.4} {rx} 0" fill="none" stroke="#6E5A44" stroke-width="{rx*0.12:.1f}" stroke-linecap="round"/>'
    return ''


BODY = {'necati': '#5A4A3A', 'cem': '#4A5248', 'haluk': '#4A4236', 'haluk_u': '#2E3A44', 'riza': '#3E3A36', 'nermin': '#6A4E44', 'baby': '#D8CBB2'}


def person(who, cx, cy, s=1.0, mood='smile', look=0, extra=''):
    """Göğüsten yukarı portre. (cx, cy) baş merkezi; s ölçek (1 = R1'deki boy)."""
    rx, ry = 28 * s, 34 * s
    if who == 'baby':
        rx, ry = 22 * s, 22 * s
    body = BODY[who]
    sh = 62 * s
    out = []
    # gövde
    out.append(f'<path d="M{cx-sh} {cy+200*s} C{cx-sh*0.97} {cy+110*s} {cx-sh*0.68} {cy+66*s} {cx} {cy+60*s} C{cx+sh*0.68} {cy+66*s} {cx+sh*0.97} {cy+110*s} {cx+sh} {cy+200*s} Z" fill="{body}"/>')
    if who == 'haluk_u':
        out.append(f'<path d="M{cx} {cy+66*s} V{cy+200*s}" stroke="#1E2830" stroke-width="{2*s:.1f}"/>')
        out.append(f'<circle cx="{cx}" cy="{cy+110*s}" r="{3*s:.1f}" fill="#C9A34E"/><circle cx="{cx}" cy="{cy+140*s}" r="{3*s:.1f}" fill="#C9A34E"/>')
        bx, by = cx - 26 * s, cy + 100 * s
        out.append(f'<path d="M{bx} {by} l{8*s} {-4*s} l{8*s} {4*s} v{9*s} l{-8*s} {6*s} l{-8*s} {-6*s} z" fill="#C9A34E"/>')
    if who == 'necati':
        out.append(f'<path d="M{cx-16*s} {cy+66*s} L{cx} {cy+116*s} L{cx+16*s} {cy+66*s}" fill="#E2D6BC"/>')
    if who != 'baby':
        out.append(f'<rect x="{cx-10*s}" y="{cy+28*s}" width="{20*s}" height="{36*s}" fill="{NECK}"/>')
    out.append(f'<ellipse cx="{cx}" cy="{cy}" rx="{rx}" ry="{ry}" fill="{SKIN}"/>')
    out.append(_hair(who, cx, cy, rx, ry))
    ex = cx + look * rx * 0.15
    if who == 'necati':
        out.append(f'<g fill="none" stroke="{INK}" stroke-width="{2*s:.1f}"><circle cx="{ex-12*s}" cy="{cy}" r="{8*s}"/><circle cx="{ex+12*s}" cy="{cy}" r="{8*s}"/><path d="M{ex-4*s} {cy} H{ex+4*s}"/></g>')
    eyes = {
        'smile': f'<path d="M{ex-15*s} {cy+2*s} q{5*s} {-4*s} {10*s} 0 M{ex+5*s} {cy+2*s} q{5*s} {-4*s} {10*s} 0" fill="none" stroke="#3B2E24" stroke-width="{2*s:.1f}" stroke-linecap="round"/>',
        'flat': f'<path d="M{ex-14*s} {cy+1*s} h{9*s} M{ex+5*s} {cy+1*s} h{9*s}" stroke="#3B2E24" stroke-width="{2.2*s:.1f}" stroke-linecap="round"/>',
        'down': f'<path d="M{ex-14*s} {cy+4*s} q{5*s} {3*s} {9*s} 0 M{ex+5*s} {cy+4*s} q{5*s} {3*s} {9*s} 0" fill="none" stroke="#3B2E24" stroke-width="{2*s:.1f}" stroke-linecap="round"/>',
        'cry': f'<path d="M{ex-14*s} {cy+4*s} q{5*s} {3*s} {9*s} 0 M{ex+5*s} {cy+4*s} q{5*s} {3*s} {9*s} 0" fill="none" stroke="#3B2E24" stroke-width="{2*s:.1f}" stroke-linecap="round"/><path d="M{ex-10*s} {cy+9*s} q{-2*s} {8*s} 0 {12*s}" fill="none" stroke="#8FA3A8" stroke-width="{2*s:.1f}"/>',
        'angry': f'<path d="M{ex-15*s} {cy-6*s} l{10*s} {4*s} M{ex+15*s} {cy-6*s} l{-10*s} {4*s}" stroke="#3B2E24" stroke-width="{2.4*s:.1f}" stroke-linecap="round"/><circle cx="{ex-9*s}" cy="{cy+3*s}" r="{2*s}" fill="#3B2E24"/><circle cx="{ex+9*s}" cy="{cy+3*s}" r="{2*s}" fill="#3B2E24"/>',
    }
    if who != 'necati' or mood != 'smile':
        out.append(eyes.get(mood, eyes['smile']))
    mouth = {'smile': (f'q{12*s} {10*s} {24*s} 0', '#7A4A3A'), 'laugh': (f'q{12*s} {16*s} {24*s} 0', '#5A2E24'),
             'flat': (f'h{20*s}', '#7A4A3A'), 'down': (f'q{12*s} {-7*s} {24*s} 0', '#7A4A3A'), 'cry': (f'q{12*s} {-8*s} {24*s} 0', '#7A4A3A'),
             'angry': (f'q{12*s} {-5*s} {24*s} 0', '#7A4A3A')}
    d, c = mouth.get(mood, mouth['smile'])
    mx0 = cx - (10 if mood == 'flat' else 12) * s
    if who == 'necati':
        out.append(f'<path d="M{cx-14*s} {cy+18*s} Q{cx} {cy+14*s} {cx+14*s} {cy+18*s}" fill="none" stroke="#3B3128" stroke-width="{4*s:.1f}" stroke-linecap="round"/>')
    if who == 'riza':
        out.append(f'<path d="M{cx-15*s} {cy+16*s} Q{cx} {cy+10*s} {cx+15*s} {cy+16*s}" fill="none" stroke="#8C847A" stroke-width="{5*s:.1f}" stroke-linecap="round"/>')
    out.append(f'<path d="M{mx0} {cy+(24 if who!="baby" else 10)*s} {d}" fill="{c if mood=="laugh" else "none"}" stroke="{c}" stroke-width="{2.4*s:.1f}" stroke-linecap="round"/>')
    if who == 'haluk_u':
        out.append(f'<path d="M{cx-32*s} {cy-20*s} C{cx-30*s} {cy-52*s} {cx+30*s} {cy-52*s} {cx+32*s} {cy-20*s} Z" fill="#26323C"/>'
                   f'<rect x="{cx-32*s}" y="{cy-28*s}" width="{64*s}" height="{10*s}" fill="#1E2830"/>'
                   f'<path d="M{cx-26*s} {cy-18*s} C{cx-12*s} {cy-8*s} {cx+14*s} {cy-8*s} {cx+30*s} {cy-18*s} L{cx+30*s} {cy-14*s} C{cx+14*s} {cy-4*s} {cx-12*s} {cy-4*s} {cx-26*s} {cy-14*s} Z" fill="#111820"/>'
                   f'<path d="M{cx-6*s} {cy-42*s} l{6*s} {-5*s} l{6*s} {5*s} l{-6*s} {6*s} z" fill="#C9A34E"/>')
    if who == 'nermin':
        out.append(f'<circle cx="{cx-rx}" cy="{cy+8*s}" r="{3*s}" fill="#C9A34E"/><circle cx="{cx+rx}" cy="{cy+8*s}" r="{3*s}" fill="#C9A34E"/>')
    out.append(extra)
    return ''.join(out)


def figure(x, feet, h, color='#3B3128', head=SKIN, limp=False, cap=False):
    """Uzaktan küçük, boydan figür."""
    hw = h * 0.14
    leg2 = f'M{x+hw*0.2} {feet-h*0.42} L{x+hw*(1.3 if limp else 0.6)} {feet-(h*0.04 if limp else 0)}'
    out = (f'<path d="M{x-hw*0.2} {feet-h*0.42} L{x-hw*0.6} {feet}" stroke="{color}" stroke-width="{hw*0.7:.1f}" stroke-linecap="round"/>'
           f'<path d="{leg2}" stroke="{color}" stroke-width="{hw*0.7:.1f}" stroke-linecap="round"/>'
           f'<path d="M{x-hw} {feet-h*0.42} L{x-hw*0.8} {feet-h*0.8} Q{x} {feet-h*0.86} {x+hw*0.8} {feet-h*0.8} L{x+hw} {feet-h*0.42} Z" fill="{color}"/>'
           f'<circle cx="{x}" cy="{feet-h*0.9}" r="{h*0.1:.1f}" fill="{head}"/>')
    if cap:
        out += f'<rect x="{x-h*0.11}" y="{feet-h*1.0}" width="{h*0.22}" height="{h*0.06}" fill="#1E2830"/>'
    return out


# ------------------------------------------------------------------ manzara

def lake(water_y=210, far='#8E8A72', tower_at=None, time=None, sky=('#D6C6A6', '#C8B897')):
    out = [rect(0, 0, 300, 400, 'url(#sky)')]
    out.append(f'<path d="M0 {water_y-30} C60 {water_y-60} 110 {water_y-44} 160 {water_y-58} C210 {water_y-70} 260 {water_y-42} 300 {water_y-52} V{water_y} H0 Z" fill="{far}"/>')
    if tower_at:
        out.append(tower(tower_at[0], tower_at[1], tower_at[2], *time))
    out.append(rect(0, water_y, 300, 400 - water_y, 'url(#water)'))
    for i, y in enumerate(range(water_y + 14, 400, 22)):
        out.append(f'<path d="M{20+i*37%90} {y} h{40+i*7%30} M{150+i*23%80} {y+8} h{30+i*11%25}" stroke="#E2D6BC" stroke-width="1.4" opacity="0.35"/>')
    return ''.join(out)


LAKE_DEFS = grad('sky', '#D6C6A6', '#C8B897') + grad('water', '#8C9488', '#5E6A62')


def reeds(x0, x1, base):
    return ''.join(f'<path d="M{x} {base} q{(i%3-1)*6} -30 {(i%5-2)*4} {-38-(i*13)%26}" stroke="#4E4A36" stroke-width="2.4" fill="none" stroke-linecap="round"/>'
                   for i, x in enumerate(range(x0, x1, 9)))


def shore(y, color='#6E5E47'):
    return f'<path d="M0 {y} C80 {y-10} 200 {y+12} 300 {y-4} V400 H0 Z" fill="{color}"/>'


def fish(cx, cy, L, angle=0, color='#9AA096'):
    h = L * 0.32
    return (f'<g transform="rotate({angle} {cx} {cy})">'
            f'<path d="M{cx-L/2} {cy} C{cx-L*0.3} {cy-h} {cx+L*0.25} {cy-h} {cx+L*0.38} {cy} C{cx+L*0.25} {cy+h} {cx-L*0.3} {cy+h} {cx-L/2} {cy} Z" fill="{color}"/>'
            f'<path d="M{cx+L*0.36} {cy} L{cx+L/2} {cy-h*0.7} L{cx+L/2} {cy+h*0.7} Z" fill="{color}"/>'
            f'<circle cx="{cx-L*0.36}" cy="{cy-h*0.15}" r="{L*0.025:.1f}" fill="{INK}"/>'
            f'<path d="M{cx-L*0.2} {cy-h*0.55} C{cx-L*0.1} {cy} {cx-L*0.1} {cy} {cx-L*0.2} {cy+h*0.55}" stroke="#6E7468" fill="none" stroke-width="1.4"/>'
            f'<path d="M{cx-L*0.05} {cy-h*0.2} h{L*0.3}" stroke="#7E8478" stroke-width="1" opacity="0.6"/></g>')


def road(horizon=170, color='#7A6A52', edge='#5B4C39'):
    return (f'<path d="M138 {horizon} L162 {horizon} L300 400 L0 400 Z" fill="{color}"/>'
            f'<path d="M150 {horizon+4} L150 400" stroke="#D8CBB2" stroke-width="3" stroke-dasharray="10 14" opacity="0.6"/>'
            f'<path d="M138 {horizon} L0 400 M162 {horizon} L300 400" stroke="{edge}" stroke-width="2"/>')


def hills(horizon=170):
    return (f'<path d="M0 {horizon} C40 {horizon-50} 90 {horizon-30} 130 {horizon-46} C180 {horizon-66} 230 {horizon-30} 300 {horizon-40} V{horizon} Z" fill="#9C8C6E"/>'
            f'<path d="M0 {horizon} V{horizon-12} C60 {horizon-26} 120 {horizon-6} 180 {horizon-18} C230 {horizon-28} 270 {horizon-10} 300 {horizon-16} V{horizon} Z" fill="#8A7A5C"/>')


def fields(horizon=170):
    return f'<rect y="{horizon}" width="300" height="{400-horizon}" fill="#A8966E"/>'


def motorcycle(cx, cy, s=1.0, red='#A8392E', rider=False, rider_hair='#2E261F'):
    r = 16 * s
    out = (f'<circle cx="{cx-34*s}" cy="{cy}" r="{r}" fill="none" stroke="#1C1714" stroke-width="{5*s:.1f}"/>'
           f'<circle cx="{cx+34*s}" cy="{cy}" r="{r}" fill="none" stroke="#1C1714" stroke-width="{5*s:.1f}"/>'
           f'<path d="M{cx-34*s} {cy} L{cx-8*s} {cy-6*s} L{cx+20*s} {cy-6*s} L{cx+34*s} {cy}" stroke="#3B3128" stroke-width="{3*s:.1f}" fill="none"/>'
           f'<path d="M{cx-18*s} {cy-26*s} C{cx-10*s} {cy-36*s} {cx+12*s} {cy-36*s} {cx+18*s} {cy-24*s} L{cx+10*s} {cy-10*s} L{cx-14*s} {cy-10*s} Z" fill="{red}"/>'
           f'<path d="M{cx-34*s} {cy-24*s} h{18*s}" stroke="#1C1714" stroke-width="{5*s:.1f}" stroke-linecap="round"/>'
           f'<path d="M{cx+18*s} {cy-26*s} L{cx+30*s} {cy-40*s} h{8*s}" stroke="#1C1714" stroke-width="{3*s:.1f}" fill="none" stroke-linecap="round"/>'
           f'<circle cx="{cx+38*s}" cy="{cy-30*s}" r="{4*s}" fill="#E9DFC9"/>')
    if rider:
        out += (f'<path d="M{cx-14*s} {cy-28*s} L{cx-4*s} {cy-70*s} L{cx+16*s} {cy-66*s} L{cx+12*s} {cy-26*s} Z" fill="#3E3A36"/>'
                f'<path d="M{cx+8*s} {cy-60*s} L{cx+30*s} {cy-42*s}" stroke="#3E3A36" stroke-width="{6*s:.1f}" stroke-linecap="round"/>'
                f'<circle cx="{cx+6*s}" cy="{cy-82*s}" r="{11*s}" fill="{SKIN}"/>'
                + ''.join(f'<circle cx="{cx+(6+dx)*s}" cy="{cy+(-88+dy)*s}" r="{6*s}" fill="{rider_hair}"/>' for dx, dy in ((-7, -2), (0, -6), (7, -3), (-9, 4))))
    return out


def car(x, y, s=1.0, body='url(#car)', rods=False, open_door=False):
    """Haluk'un arabası, yandan. (x, y) sol alt köşe."""
    def p(px, py): return f'{x+px*s:.1f} {y+py*s:.1f}'
    out = (f'<path d="M{p(0,-30)} C{p(4,-60)} {p(30,-68)} {p(60,-72)} L{p(90,-104)} C{p(100,-116)} {p(180,-116)} {p(196,-104)} L{p(228,-72)} C{p(252,-68)} {p(264,-56)} {p(266,-30)} V{y-10*s:.1f} H{x:.1f} Z" fill="{body}"/>'
           f'<path d="M{p(96,-98)} L{p(74,-72)} H{p(136,-72)} V{p(136,-100)} C{p(120,-102)} {p(104,-102)} {p(96,-98)} Z" fill="#3E4A4C"/>'
           f'<path d="M{p(144,-100)} V{p(144,-72)} H{p(216,-72)} L{p(192,-98)} C{p(180,-102)} {p(160,-102)} {p(144,-100)} Z" fill="#3E4A4C"/>'
           f'<circle cx="{x+54*s:.1f}" cy="{y-8*s:.1f}" r="{22*s:.1f}" fill="#1C1714"/><circle cx="{x+212*s:.1f}" cy="{y-8*s:.1f}" r="{22*s:.1f}" fill="#1C1714"/>'
           f'<circle cx="{x+54*s:.1f}" cy="{y-8*s:.1f}" r="{8*s:.1f}" fill="#8E8270"/><circle cx="{x+212*s:.1f}" cy="{y-8*s:.1f}" r="{8*s:.1f}" fill="#8E8270"/>'
           f'<path d="M{p(150,-114)} L{p(150,-150)}" stroke="#2A221B" stroke-width="{2*s:.1f}"/>')  # telsiz anteni
    if rods:
        out += (f'<g stroke="#2A221B" stroke-linecap="round"><path d="M{p(176,-80)} L{p(220,-210)}" stroke-width="{2.6*s:.1f}"/>'
                f'<path d="M{p(184,-78)} L{p(236,-194)}" stroke-width="{2.2*s:.1f}"/></g>')
    if open_door:
        out += f'<path d="M{p(144,-100)} L{p(126,-150)} L{p(130,-40)} L{p(144,-30)} Z" fill="#6A5F50" stroke="#4E453A" stroke-width="1.5"/>'
    return out


CAR_DEFS = grad('car', '#8E8270', '#6A5F50')


# ------------------------------------------------------------------ dükkân

def shop_wall(color='#8C7A5E', floor='#4A3B2E', floor_y=330):
    return rect(0, 0, 300, 400, color) + rect(0, floor_y, 300, 400 - floor_y, floor)


def clock_wall(h, m, y0=40, rows=2, scale=1.0):
    out = []
    spots = [(44, 0, 22), (120, -4, 18), (196, 2, 24), (262, -2, 16), (80, 64, 17), (160, 70, 20), (236, 66, 18)]
    for i, (x, dy, r) in enumerate(spots[: (4 if rows == 1 else 7)]):
        out.append(wall_clock(x, y0 + dy + 20, r * scale, h, m))
    return ''.join(out)


def counter(y=270, color='#5B4836', top='#7A634B'):
    return rect(0, y, 300, 400 - y, color) + rect(0, y - 10, 300, 12, top)


def drawer(x, y, w, h, open_=0.0, box=False, box_stamp=False, color='#6A5440'):
    out = [rect(x, y, w, h, color, f'stroke="{INK}" stroke-width="2"')]
    if open_ > 0:
        d = h * open_
        out.append(rect(x + 4, y + h, w - 8, d, '#3A2E24', f'stroke="{INK}" stroke-width="1.5"'))
        out.append(f'<path d="M{x+4} {y+h} L{x+12} {y+h+d*0.4} H{x+w-12} L{x+w-4} {y+h} Z" fill="#241C16"/>')
        if box:
            bx, by, bw, bh = x + w * 0.52, y + h + d * 0.12, w * 0.3, d * 0.5
            out.append(velvet_box(bx, by, bw, bh, stamp=box_stamp))
    out.append(f'<rect x="{x+w/2-12}" y="{y+h/2-3}" width="24" height="6" rx="3" fill="#C9A34E"/>')
    return ''.join(out)


def velvet_box(x, y, w, h, stamp=False):
    out = (f'<rect x="{x}" y="{y}" width="{w}" height="{h}" rx="{min(w,h)*0.12:.1f}" fill="#24305A"/>'
           f'<rect x="{x}" y="{y}" width="{w}" height="{h*0.35:.1f}" rx="{min(w,h)*0.12:.1f}" fill="#2E3C6E"/>')
    if stamp:
        out += f'<text x="{x+w/2}" y="{y+h*0.68}" text-anchor="middle" font-family="Lora" font-size="{h*0.17:.1f}" fill="#C9A34E">RIZA KUYUMCULUK</text>'
    return out


def note(x, y, w, h, lines, rot=-2, size=13, color='#F1E8D6', font='Caveat'):
    t = ''.join(f'<text x="{x+10}" y="{y+22+i*size*1.25:.1f}" font-family="{font}" font-size="{size}" fill="{INK}">{l}</text>' for i, l in enumerate(lines))
    return f'<g transform="rotate({rot} {x+w/2} {y+h/2})"><rect x="{x}" y="{y}" width="{w}" height="{h}" fill="{color}" stroke="#B8A88A"/>{t}</g>'


def window(x, y, w, h, frame='#3B3128', glass='#C8BC9E', mullion=True):
    out = rect(x, y, w, h, glass, f'stroke="{frame}" stroke-width="8"')
    if mullion:
        out += f'<path d="M{x+w/2} {y} V{y+h} M{x} {y+h/2} H{x+w}" stroke="{frame}" stroke-width="5"/>'
    return out


def glass_overlay(x=0, y=0, w=300, h=400):
    """Camın arkasından çekilmiş: yansıma çizgileri ve çerçeve."""
    return (f'<path d="M{x+30} {y} L{x-40} {y+h} M{x+90} {y} L{x+20} {y+h}" stroke="#F1E8D6" stroke-width="14" opacity="0.12"/>'
            f'<rect x="{x+4}" y="{y+4}" width="{w-8}" height="{h-8}" fill="none" stroke="#2A221B" stroke-width="14"/>'
            f'<path d="M{x+w/2} {y} V{y+h}" stroke="#2A221B" stroke-width="9"/>')


def lamp(cx, cy, r=90, op=0.5):
    return (f'<circle cx="{cx}" cy="{cy}" r="{r}" fill="url(#glow)" opacity="{op}"/>'
            f'<path d="M{cx-18} {cy-6} L{cx-10} {cy-24} H{cx+10} L{cx+18} {cy-6} Z" fill="#3B3128"/>'
            f'<circle cx="{cx}" cy="{cy-2}" r="6" fill="#F6E8C2"/>')


GLOW_DEFS = '''
    <radialGradient id="glow" cx="0.5" cy="0.5" r="0.5">
      <stop offset="0" stop-color="#F6E2A8" stop-opacity="0.95"/>
      <stop offset="1" stop-color="#F6E2A8" stop-opacity="0"/>
    </radialGradient>'''


def night(op=0.55):
    return rect(0, 0, 300, 400, '#14100D', f'opacity="{op}"')


def shopfront(sign, x=20, y=60, w=260, h=270, wall='#AE9B7B', sign_bg='#3B3128', sign_fg='#E9DFC9', door_sign=None, font='Lora'):
    out = [rect(x, y, w, h, wall)]
    out.append(rect(x + 10, y + 10, w - 20, 40, sign_bg))
    out.append(f'<text x="{x+w/2}" y="{y+38}" text-anchor="middle" font-family="{font}" font-size="22" font-weight="600" fill="{sign_fg}">{sign}</text>')
    out.append(window(x + 16, y + 70, w * 0.5, h - 110))
    dx = x + w * 0.62
    out.append(rect(dx, y + 70, w * 0.3, h - 70, '#4A3B2E', f'stroke="{INK}" stroke-width="3"'))
    out.append(f'<circle cx="{dx+w*0.26}" cy="{y+h*0.62}" r="4" fill="#C9A34E"/>')
    if door_sign:
        out.append(note(dx + 8, y + 100, w * 0.3 - 16, 34, [door_sign], rot=0, size=13, font='Lora'))
    return ''.join(out)


def thermos(x, y):
    return (f'<rect x="{x}" y="{y}" width="26" height="70" rx="6" fill="#6E3A30"/><rect x="{x+3}" y="{y-12}" width="20" height="14" rx="3" fill="#3B3128"/>'
            f'<rect x="{x+34}" y="{y+40}" width="18" height="22" fill="#E2D6BC" stroke="{INK}"/><rect x="{x+56}" y="{y+44}" width="18" height="20" fill="#E2D6BC" stroke="{INK}"/>')


def newspaper(x, y, w, h, title='HABER', date='3 MART 1989', rot=-6):
    lines = ''.join(f'<path d="M{x+8} {y+44+i*9} h{w*0.42 if i%2 else w*0.4}" stroke="#8C847A" stroke-width="2"/><path d="M{x+w*0.52} {y+44+i*9} h{w*0.38}" stroke="#8C847A" stroke-width="2"/>' for i in range(int((h - 50) / 9)))
    return (f'<g transform="rotate({rot} {x+w/2} {y+h/2})"><rect x="{x}" y="{y}" width="{w}" height="{h}" fill="#E6DCC4"/>'
            f'<text x="{x+w/2}" y="{y+20}" text-anchor="middle" font-family="Lora" font-weight="600" font-size="15" fill="{INK}">{title}</text>'
            f'<text x="{x+w/2}" y="{y+33}" text-anchor="middle" font-family="JetBrainsMono" font-size="8" fill="{INK}">{date}</text>{lines}</g>')


def radio(x, y, s=1.0):
    return (f'<rect x="{x}" y="{y}" width="{70*s}" height="{36*s}" rx="{4*s}" fill="#2E2A26"/>'
            f'<rect x="{x+6*s}" y="{y+6*s}" width="{30*s}" height="{12*s}" fill="#C9A34E" opacity="0.7"/>'
            f'<circle cx="{x+50*s}" cy="{y+12*s}" r="{5*s}" fill="#5A524A"/><circle cx="{x+50*s}" cy="{y+27*s}" r="{4*s}" fill="#5A524A"/>'
            f'<path d="M{x+70*s} {y+18*s} C{x+90*s} {y+20*s} {x+92*s} {y+50*s} {x+110*s} {y+56*s}" stroke="#1C1714" stroke-width="{2.4*s:.1f}" fill="none"/>'
            f'<rect x="{x+104*s}" y="{y+44*s}" width="{16*s}" height="{34*s}" rx="{5*s}" fill="#2E2A26" transform="rotate(-20 {x+112*s} {y+60*s})"/>')


def bandage(x, y, w=34, h=22, rot=0):
    return (f'<g transform="rotate({rot} {x+w/2} {y+h/2})"><rect x="{x}" y="{y}" width="{w}" height="{h}" rx="5" fill="#F1E8D6"/>'
            + ''.join(f'<path d="M{x+4+i*7} {y} l-4 {h}" stroke="#C8BC9E" stroke-width="1.4"/>' for i in range(int(w / 7) + 1)) + '</g>')


def light_leak():
    return ('<rect width="300" height="400" fill="#F3E6C8"/>'
            '<path d="M300 0 C220 80 240 200 300 260 Z" fill="#E8893A" opacity="0.55"/>'
            '<path d="M300 40 C250 120 260 180 300 220 Z" fill="#C23B2E" opacity="0.35"/>'
            '<rect width="300" height="400" fill="#FFF6E0" opacity="0.4"/>')
