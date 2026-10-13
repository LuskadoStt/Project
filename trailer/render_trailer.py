"""Independent cinematic rendering using the project's existing sprites.

Requires Python 3, Pillow, NumPy, FFmpeg and DejaVu fonts.
Original GameMaker images/resources are only read, never overwritten.
"""
from __future__ import annotations

import argparse
import json
import math
import re
import subprocess
import wave
from functools import lru_cache
from pathlib import Path

import numpy as np
from PIL import Image, ImageDraw, ImageFilter, ImageFont

ROOT = Path(__file__).resolve().parents[1]
ASSETS = ROOT / "Museu Marco Zero - Etapa 1"
OUT = ROOT / "trailer"
W, H = 640, 360
DURATION, FPS = 49, 60
GOLD = (234, 202, 145)
CYAN = (142, 235, 250)
FONT_ROOT = Path("/usr/share/fonts/truetype/dejavu")
RNG = np.random.default_rng(801)
PARTICLES = RNG.uniform(0, 1, (38, 5))
BLOCKS = RNG.uniform(0, 1, (H // 4, W // 4))


def smooth(t):
    t = max(0.0, min(1.0, t))
    return t * t * (3 - 2 * t)


def mix(a, b, t):
    return a + (b - a) * t


def ease(t, start, end):
    return smooth((t - start) / (end - start))


def gm_json(path):
    return json.loads(re.sub(r",\s*([}\]])", r"\1", path.read_text()))


@lru_cache(maxsize=96)
def frames(name):
    folder = ASSETS / "sprites" / name
    metadata = gm_json(folder / (name + ".yy"))
    result = []
    for frame in metadata["frames"]:
        im = Image.open(folder / (frame["name"] + ".png")).convert("RGBA")
        if not name.startswith("spr_cenario"):
            data = np.array(im)
            green = (data[:, :, 1] > 242) & (data[:, :, 0] < 13) & (data[:, :, 2] < 13)
            data[green, 3] = 0
            im = Image.fromarray(data)
            im = im.crop(im.getbbox())
        result.append(im)
    return result


MUSEUM = frames("spr_cenario")[0].resize((2048, 682), Image.Resampling.NEAREST)
SOURCE = frames("spr_cenario_obra_1")[0]
LANDSCAPE = Image.new("RGBA", (800, 450))
floor_start = int(SOURCE.height * .94)
LANDSCAPE.paste(SOURCE.crop((0, 0, SOURCE.width, floor_start)).resize((800, 315), Image.Resampling.NEAREST))
floor = SOURCE.crop((0, floor_start, SOURCE.width, SOURCE.height))
floor = floor.resize((800, max(1, round(floor.height * 800 / SOURCE.width))), Image.Resampling.NEAREST)
for fy in range(315, 450, floor.height):
    LANDSCAPE.paste(floor, (0, fy))


@lru_cache(maxsize=256)
def costume(name, frame, role):
    im = frames(name)[frame % len(frames(name))].copy()
    data = np.array(im)
    if name != "spr_npc_obra":
        shirt = (data[:, :, 0] > 150) & (data[:, :, 1] > 135) & (data[:, :, 2] < 95) & (data[:, :, 1].astype(float) > data[:, :, 0] * .82) & (data[:, :, 3] > 0)
        colors = {"guide": (58, 146, 158), "pink": (206, 115, 142), "blue": (113, 150, 210), "cream": (223, 194, 155), "green": (113, 161, 121)}
        if role in colors:
            c = np.array(colors[role])
            brightness = np.max(data[:, :, :3], axis=2)[shirt] / 255
            data[shirt, :3] = (c[None, :] * brightness[:, None]).astype(np.uint8)
        if role == "guide":
            red = (data[:, :, 0] > 130) & (data[:, :, 1] < 110) & (data[:, :, 2] < 110)
            data[red, :3] = (202, 170, 106)
    else:
        data[:, :, :3] = (data[:, :, :3].astype(float) * np.array([1.04, .96, .84])).clip(0, 255).astype(np.uint8)
    return Image.fromarray(data)


def landscape(t):
    # Moving reflections stay inside the water, preserving horizon registration.
    im = LANDSCAPE.copy()
    for y in range(170, 274, 5):
        offset = round(math.sin(t * 1.8 + y * .12) * 1.4)
        strip = LANDSCAPE.crop((0, y, 800, y + 4))
        im.paste(strip, (offset, y))
    return im


def camera(t):
    keys = [(0, 540, 357, 1060), (4, 470, 379, 940), (6, 349, 385, 760),
            (15, 333, 377, 705), (18, 320, 372, 650), (21, 319, 351, 615),
            (24.4, 307, 310, 540)]
    for a, b in zip(keys, keys[1:]):
        if a[0] <= t <= b[0]:
            p = ease(t, a[0], b[0])
            cx, cy, width = (mix(a[i], b[i], p) for i in (1, 2, 3))
            break
    else:
        _, cx, cy, width = keys[0] if t < 0 else keys[-1]
    height = width * H / W
    left = max(0, min(2048 - width, cx - width / 2))
    top = max(0, min(682 - height, cy - height / 2))
    return (left, top, width, height)


def coord(x, y, cam):
    left, top, width, _ = cam
    return ((x - left) * W / width, (y - top) * W / width)


def crop_view(im, cam):
    x, y, width, height = cam
    return im.crop((round(x), round(y), round(x + width), round(y + height))).resize((W, H), Image.Resampling.NEAREST)


def actor(layer, cam, x, y, t, role="hero", direction="s", walking=False,
          height=61, alpha=1.0, touch=0, levitate=0, gesture=False):
    if alpha <= 0:
        return
    historian = role == "historian"
    name = "spr_npc_obra" if historian else ("spr_walk_" + direction if walking else ("spr_player" if direction == "s" else "spr_player_" + direction))
    frame = int(t * 10) if walking and not historian else 0
    sprite = costume(name, frame, role)
    breathing = round(math.sin(t * 2.7 + x * .01) * .65)
    bob = round(math.sin(t * 14)) if walking else breathing
    px, py = coord(x, y - levitate + bob, cam)
    scale = W / cam[2]
    sh = max(3, round(height * scale))
    sw = max(2, round(sprite.width / sprite.height * sh))
    sprite = sprite.resize((sw, sh), Image.Resampling.NEAREST)
    # Puppet gesture only during trailer; source sprite files are untouched.
    if historian and walking:
        pieces = Image.new("RGBA", (sw + 6, sh + 3))
        pieces.alpha_composite(sprite.crop((0, 0, sw, int(sh * .69))), (3, 0))
        midpoint = sw // 2
        for side, bounds in enumerate([(0, int(sh * .69), midpoint, sh), (midpoint, int(sh * .69), sw, sh)]):
            foot = sprite.crop(bounds)
            offset = round(math.sin(t * 11 + side * math.pi) * 2)
            pieces.alpha_composite(foot, (3 + bounds[0] + offset, bounds[1]))
        sprite = pieces
        sw, sh = sprite.size
    if alpha < 1:
        sprite.putalpha(sprite.getchannel("A").point(lambda v: round(v * alpha)))
    shadow = ImageDraw.Draw(layer)
    sx, sy = coord(x, y, cam)
    shadow.ellipse((sx - 12 * scale, sy - 3 * scale, sx + 12 * scale, sy + 2 * scale), fill=(10, 17, 29, round(95 * alpha * max(.25, 1 - levitate / 45))))
    layer.alpha_composite(sprite, (round(px - sw / 2), round(py - sh)))
    d = ImageDraw.Draw(layer)
    if role == "guide":
        d.rectangle((round(px - 6 * scale), round(py - 29 * scale), round(px - 3 * scale), round(py - 25 * scale)), fill=(*GOLD, round(255 * alpha)))
    if touch > 0:
        reach = smooth(touch)
        limb_scale = scale * height / 61
        ax = px + 10 * limb_scale
        ay = py - mix(30, 55, reach) * limb_scale
        d.line((px + 10 * limb_scale, py - 29 * limb_scale, ax, ay), fill=(241, 195, 49, 255), width=max(1, round(4 * limb_scale)))
        d.rectangle((round(ax - limb_scale), round(ay - 3 * limb_scale), round(ax + 2 * limb_scale), round(ay)), fill=(219, 163, 123, 255))
    if role in ("pink", "blue", "cream", "green") and not walking:
        phase = .5 + .5 * math.sin(t * 2.1 + x * .07)
        ax = px + (9 if direction == "e" else -9) * scale
        ay = py - (27 + phase * 6) * scale
        d.line((px + (7 if direction == "e" else -7) * scale, py - 26 * scale, ax, ay), fill=(217, 161, 121, 255), width=max(1, round(2 * scale)))
    if historian:
        # Two discreet dark pixels identify glasses at native resolution.
        gy = py - sh * .83
        d.line((px - sw * .12, gy, px + sw * .12, gy), fill=(45, 31, 29, round(210 * alpha)), width=1)
        if gesture:
            gx = px + sw * .33
            gy = py - sh * (.68 + .15 * math.sin(t * 4)**2)
            d.line((px + sw * .2, py - sh * .55, gx, gy), fill=(198, 155, 123, 255), width=max(1, round(scale * 3)))


def dust(layer, t, outdoor=False):
    d = ImageDraw.Draw(layer)
    for p in PARTICLES:
        x = round((p[0] * W + t * (2 + p[2] * 3)) % W)
        y = round((p[1] * H - t * (1 + p[3] * 2)) % H)
        a = int(25 + 50 * (.5 + .5 * math.sin(t + p[4] * 10)))
        color = (247, 213, 154) if not outdoor else (245, 232, 189)
        size = 1 if p[2] < .8 else 2
        d.rectangle((x, y, x + size - 1, y + size - 1), fill=(*color, a))


def museum_scene(t):
    cam = camera(t)
    background = crop_view(MUSEUM, cam)
    # Same moving master image in the painting and the destination.
    painting = landscape(t).resize((258, 140), Image.Resampling.NEAREST)
    px, py = coord(179, 199, cam)
    pw, ph = round(258 * W / cam[2]), round(140 * W / cam[2])
    background.alpha_composite(painting.resize((pw, ph), Image.Resampling.NEAREST), (round(px), round(py)))
    actors = []
    roles = ["pink", "blue", "cream", "green"]
    for i, (x, y) in enumerate([(112, 505), (159, 506), (560, 480), (608, 489), (780, 550), (883, 545), (998, 514), (1190, 510)]):
        walking = i in (4, 6)
        if walking:
            x += 70 * math.sin(t * .14 + i)
        actors.append((y, x, roles[i % 4], "e" if i % 2 == 0 else "w", walking, 55 + i % 3 * 3, 1, 0, 0))
    guide_x = mix(393, 420, ease(t, 21.2, 22.7))
    guide_y = 511
    actors.append((guide_y, guide_x, "guide", "w", 21.2 < t < 22.7, 64, 1, 0, 0))
    hx, hy = 293, 517
    direction, walking, touch, levitation, height, opacity = "e", False, 0, 0, 61, 1
    if t > 17.5:
        hy = mix(517, 390, ease(t, 17.5, 20))
        hx = mix(293, 307, ease(t, 17.5, 20))
        direction, walking = "n", t < 20
        touch = ease(t, 20, 20.45)
    if t > 21.2:
        levitation = 28 * ease(t, 21.2, 22.7) + math.sin(t * 8) * 1.5 * math.sin(math.pi * ease(t, 21.2, 22.7))
    if t > 22.7:
        p = ease(t, 22.7, 24.3)
        hy = mix(390, 290, p)
        levitation = 28 * (1 - p)
        height = mix(61, 8, p)
        touch *= (1 - p)
        opacity = 1 - ease(t, 24, 24.4)
    actors.append((hy, hx, "hero", direction, walking, height, opacity, touch, levitation))
    layer = Image.new("RGBA", (W, H))
    for y, x, role, direction, walking, height, opacity, touch, levitation in sorted(actors):
        actor(layer, cam, x, y, t, role, direction, walking, height, opacity, touch, levitation)
    dust(layer, t)
    background = Image.alpha_composite(background, layer)
    if t > 20.1:
        effects = Image.new("RGBA", (W, H))
        d = ImageDraw.Draw(effects)
        cx, cy = coord(319, 334, cam)
        energy = ease(t, 20.1, 22.7)
        for i in range(4):
            phase = (t - 20.1 - i * .19) / 1.6
            if 0 <= phase <= 1:
                r = 3 + smooth(phase) * 76
                d.ellipse((cx - r, cy - r * .62, cx + r, cy + r * .62), outline=(*CYAN, round((1 - phase) * 230)), width=2)
        d.rectangle((cx - 2, cy - 2, cx + 2, cy + 2), fill=(238, 252, 248, int(240 * energy)))
        for i in range(26):
            angle = t * 1.4 + i * math.tau / 26
            r = (8 + (i % 7) * 5) * (1 - .5 * ease(t, 22.7, 24.3))
            x = cx + math.cos(angle) * r
            y = cy + math.sin(angle) * r * .65
            d.rectangle((x, y, x + 1, y + 1), fill=(*CYAN, int(100 * energy)))
        halo = effects.filter(ImageFilter.GaussianBlur(7))
        background = Image.alpha_composite(Image.alpha_composite(background, halo), effects)
    return background, cam


def destination_scene(t):
    a = ease(t, 26, 29)
    width = mix(800, 750, a) if t < 35 else mix(750, 800, ease(t, 35, 42))
    height = width * H / W
    cy = mix(225, 233, a)
    left = max(0, min(800 - width, 400 - width / 2))
    top = max(0, min(450 - height, cy - height / 2))
    cam = (left, top, width, height)
    im = crop_view(landscape(t), cam)
    layer = Image.new("RGBA", (W, H))
    actors = []
    for i, (x, y) in enumerate([(102, 361), (142, 365), (627, 354), (667, 354), (244, 431), (730, 432)]):
        walk = i in (4, 5)
        if walk:
            x += math.sin(t * .16 + i) * 28
        actors.append((y, x, ["pink", "blue", "cream", "green"][i % 4], "e" if i % 2 == 0 else "w", walk, 53, 1, 0))
    arrival = ease(t, 26.2, 27.5)
    hero_height = 61 + 2 * math.sin(arrival * math.pi)
    actors.append((349, 397, "hero", "e" if t > 29 else "s", False, hero_height, arrival, (1 - arrival) * 20))
    historian_x = mix(805, 505, ease(t, 28.6, 31.4))
    if t > 36:
        historian_x += 22 * ease(t, 36, 37)
    actors.append((351, historian_x, "historian", "w", 28.6 < t < 31.4 or 36 < t < 37, 66, 1, 0))
    for y, x, role, direction, walking, height, alpha, lift in sorted(actors):
        actor(layer, cam, x, y, t, role, direction, walking, height, alpha, levitate=lift,
              gesture=role == "historian" and (31.4 < t < 32.2 or 36 < t < 39))
    if 26.2 <= t <= 28.2:
        d = ImageDraw.Draw(layer)
        cx, cy = coord(397, 349, cam)
        p = ease(t, 26.2, 28.2)
        radius = 4 + p * 45
        d.ellipse((cx - radius, cy - radius / 4, cx + radius, cy + radius / 4), outline=(*CYAN, int(180 * (1 - p))), width=1)
        for i in range(18):
            angle = i * math.tau / 18 + t
            r = 9 + p * 30
            x, y = cx + math.cos(angle) * r, cy - 24 + math.sin(angle) * r
            d.rectangle((x, y, x + 1, y + 1), fill=(*CYAN, int(190 * (1 - p))))
    dust(layer, t, True)
    return Image.alpha_composite(im, layer)


@lru_cache(maxsize=20)
def font(size, bold=False, serif=False):
    name = "DejaVuSerif" if serif else "DejaVuSans"
    return ImageFont.truetype(str(FONT_ROOT / (name + ("-Bold" if bold else "") + ".ttf")), size)


def centered(d, text, y, size, color, bold=False, serif=False):
    f = font(size, bold, serif)
    box = d.textbbox((0, 0), text, font=f)
    x = (1280 - (box[2] - box[0])) / 2
    d.text((x, y), text, font=f, fill=color, stroke_width=1 if size >= 46 else 0)


DIALOGUES = [
    (5.4, 11.3, "GUIA DO MUSEU", "Nossa nova tecnologia permite entrar nas pinturas\ne visitar esses lugares."),
    (11.4, 14.7, "GUIA DO MUSEU", "Toque no quadro para iniciar a viagem."),
    (15.4, 17.5, "GUIA DO MUSEU", "Não haverá aviso para não tocar."),
    (32.1, 36.8, "HISTORIADOR LOCAL", "Este é o Pico de Brennand, ponto simbólico\ndo Recife e da sua história."),
]


def movie_frame(t):
    if t < 24.4:
        im, _ = museum_scene(t)
    elif t < 26:
        base, cam = museum_scene(24.4)
        p = ease(t, 24.4, 26)
        x, y = coord(179, 199, cam)
        width, height = 258 * W / cam[2], 140 * W / cam[2]
        rect = tuple(round(v) for v in (mix(x, 0, p), mix(y, 0, p), mix(width, W, p), mix(height, H, p)))
        picture = landscape(t).resize((max(1, rect[2]), max(1, rect[3])), Image.Resampling.NEAREST)
        # Fixed-threshold pixel dissolve, with no frame-to-frame random flashing.
        arr = np.array(base)
        mask = np.repeat(np.repeat(BLOCKS < p * .7, 4, axis=0), 4, axis=1)
        arr[mask, :3] = (arr[mask, :3].astype(float) * (1 - p)).astype(np.uint8)
        im = Image.fromarray(arr)
        im.alpha_composite(picture, rect[:2])
    else:
        im = destination_scene(t)
    # Soft neon light peaks once, fades gradually, then reveals the destination.
    flash = .83 * ease(t, 25.35, 26) if t < 26 else .83 * (1 - ease(t, 26, 27.1))
    if flash > 0 and 25.35 <= t <= 27.1:
        im = Image.blend(im, Image.new("RGBA", im.size, (238, 251, 247, 255)), flash)
    im = im.convert("RGB").resize((1280, 720), Image.Resampling.NEAREST).convert("RGBA")
    ui = Image.new("RGBA", im.size)
    d = ImageDraw.Draw(ui)
    # Soft cinematic edges, while keeping all dialogue inside the safe area.
    for i in range(30):
        a = round((1 - i / 30) * 4)
        d.rectangle((i, i, 1279 - i, 719 - i), outline=(5, 9, 20, a), width=2)
    if t < 4.5:
        a = ease(t, .4, 1.2) * (1 - ease(t, 3.4, 4.5))
        d.rectangle((0, 0, 1280, 170), fill=(9, 14, 29, int(125 * a)))
        centered(d, "RECIFE · UMA VIAGEM PELA ARTE", 39, 17, (*GOLD, int(255 * a)), True)
        centered(d, "Toda pintura guarda um mundo.", 75, 35, (247, 241, 222, int(255 * a)), serif=True)
    for start, end, speaker, text in DIALOGUES:
        if start <= t <= end:
            opacity = ease(t, start, start + .18) * (1 - ease(t, end - .2, end))
            lines = text.split("\n")
            box_top = 550 if len(lines) == 2 else 586
            d.rounded_rectangle((115, box_top, 1165, 695), radius=8, fill=(9, 16, 30, int(225 * opacity)), outline=(*GOLD, int(110 * opacity)), width=1)
            d.rectangle((135, box_top + 19, 138, 676), fill=(*GOLD, int(230 * opacity)))
            d.text((158, box_top + 13), speaker, font=font(14, True), fill=(*GOLD, int(255 * opacity)))
            for i, line in enumerate(lines):
                d.text((158, box_top + 40 + i * 35), line, font=font(27), fill=(250, 247, 237, int(255 * opacity)))
    if 28.0 <= t <= 31.0:
        a = ease(t, 28, 28.5) * (1 - ease(t, 30.4, 31))
        d.rectangle((46, 44, 50, 100), fill=(*GOLD, int(255 * a)))
        d.text((64, 40), "DENTRO DA PINTURA", font=font(14, True), fill=(248, 241, 222, int(255 * a)), stroke_width=1)
        d.text((64, 62), "Pico de Brennand", font=font(27, True), fill=(255, 249, 235, int(255 * a)), stroke_width=1, stroke_fill=(30, 49, 71, int(255 * a)))
    if t > 41:
        p = ease(t, 41, 42.5)
        d.rectangle((0, 0, 1280, 720), fill=(9, 17, 32, int(210 * p)))
        title_a = ease(t, 41.6, 43)
        centered(d, "MUSEU", 162, 22, (*GOLD, int(255 * title_a)), True)
        centered(d, "ENTRE NA ARTE", 206, 75, (248, 241, 223, int(255 * title_a)), True, True)
        d.line((466, 321, 814, 321), fill=(*GOLD, int(200 * title_a)), width=2)
        centered(d, "Toque. Atravesse. Descubra.", 351, 29, (232, 236, 240, int(255 * title_a)))
        centered(d, "UMA EXPERIÊNCIA NARRATIVA EM PIXEL ART", 410, 17, (*GOLD, int(255 * title_a)), True)
        centered(d, "TRAILER CONCEITUAL · ARTE PROVISÓRIA DO PROJETO", 639, 12, (175, 185, 196, int(255 * title_a)))
    im = Image.alpha_composite(im, ui).convert("RGB")
    fade = ease(t, 0, .65) * (1 - ease(t, 48, 49))
    if fade < 1:
        im = Image.blend(Image.new("RGB", im.size, (5, 9, 17)), im, fade)
    return im


def add_audio(track, signal, start, pan=0):
    index = round(start * 44100)
    begin = max(0, index)
    end = min(len(track), index + len(signal))
    if end <= begin:
        return
    signal = signal[begin - index:end - index]
    track[begin:end, 0] += signal * math.sqrt((1 - pan) / 2)
    track[begin:end, 1] += signal * math.sqrt((1 + pan) / 2)


def piano(midi, seconds, level=.18):
    sr = 44100
    t = np.arange(round(seconds * sr)) / sr
    frequency = 440 * 2 ** ((midi - 69) / 12)
    envelope = (1 - np.exp(-t * 160)) * np.exp(-t * 1.4)
    tone = np.zeros_like(t)
    for h in range(1, 9):
        tone += np.sin(math.tau * frequency * h * np.sqrt(1 + .0001 * h*h) * t) * np.exp(-t * .35 * h) / h ** 1.6
    return tone * envelope * level


def make_audio():
    sr = 44100
    track = np.zeros((DURATION * sr, 2), dtype=np.float64)
    beat = 60 / 96
    chords = [[48, 55, 60, 63], [44, 51, 56, 60], [51, 58, 63, 67], [46, 53, 58, 62]]
    melody = [[72, 75, 79, 77, 75, 72, 70, 72], [72, 75, 80, 79, 75, 72, 68, 70],
              [75, 79, 82, 79, 77, 75, 74, 72], [74, 77, 82, 80, 77, 74, 70, 72]]
    for bar in range(19):
        start = .35 + bar * beat * 4
        chord = chords[bar % 4]
        energy = .9 if start < 17 else (1.15 if start < 26 else 1.0)
        for note in chord:
            add_audio(track, piano(note, 3.2, .10 * energy), start, -.20)
        for step in range(8):
            st = start + step * beat / 2
            note = melody[bar % 4][step]
            add_audio(track, piano(note, 2.6, .20 * energy), st, .22)
        if start > 14:
            for step in (0, 2):
                st = start + step * beat
                tx = np.arange(int(sr * .26)) / sr
                kick = np.sin(math.tau * (50 * tx + 4 * (1 - np.exp(-tx * 25)))) * np.exp(-tx * 24) * .08
                add_audio(track, kick, st)
    # Broad, understated warm pad with slow harmonic movement.
    for bar in range(10):
        st = bar * beat * 8
        tx = np.arange(int(sr * 6)) / sr
        env = np.sin(np.minimum(1, tx / 1.2) * math.pi / 2)**2 * np.minimum(1, (6 - tx) / 1.8)
        for note in chords[(bar * 2) % 4][1:]:
            f = 440 * 2 ** ((note - 69) / 12)
            signal = (np.sin(math.tau * f * tx) + .3 * np.sin(math.tau * f * 2.002 * tx)) * env * .025
            add_audio(track, signal, st, -.35 if note % 2 else .35)
    # Original project portal sound, resampled to the soundtrack rate.
    sound_path = ASSETS / "sounds/snd_portal/snd_portal.wav"
    with wave.open(str(sound_path)) as w:
        signal = np.frombuffer(w.readframes(w.getnframes()), dtype="<i2").astype(float) / 32768
        signal = np.interp(np.arange(round(len(signal) * sr / w.getframerate())) * w.getframerate() / sr, np.arange(len(signal)), signal)
    add_audio(track, signal * .22, 21.5)
    # Filtered air and a rising shimmer connect the two rooms.
    for st, seconds, gain in [(20.2, 5.8, .045), (26.0, 3.4, .025)]:
        tx = np.arange(int(sr * seconds)) / sr
        noise = RNG.normal(0, 1, len(tx))
        noise = np.convolve(noise, np.ones(28) / 28, mode="same")
        swell = np.sin(math.pi * tx / seconds)**2
        shimmer = np.sin(math.tau * (240 * tx + 190 * tx*tx / seconds)) * .22
        add_audio(track, (noise + shimmer) * swell * gain, st)
    # Gentle stereo room response.
    dry = track.copy()
    for delay, amount in [(0.12, .13), (0.26, .09), (0.43, .05)]:
        n = int(delay * sr)
        track[n:] += dry[:-n, ::-1] * amount
    tx = np.arange(len(track)) / sr
    envelope = np.minimum(1, tx / 1.1) * np.minimum(1, np.maximum(0, (DURATION - tx) / 2.3))
    track *= envelope[:, None]
    track = np.tanh(track * 1.25)
    track *= .87 / max(np.max(np.abs(track)), .01)
    path = OUT / "trilha-original.wav"
    with wave.open(str(path), "wb") as w:
        w.setnchannels(2)
        w.setsampwidth(2)
        w.setframerate(sr)
        w.writeframes((track * 32767).astype("<i2").tobytes())
    return path


def srt_time(seconds):
    total = round(seconds * 1000)
    return f"{total // 3600000:02}:{total // 60000 % 60:02}:{total // 1000 % 60:02},{total % 1000:03}"


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--previews", action="store_true")
    parser.add_argument("--fps", type=int, default=FPS)
    args = parser.parse_args()
    OUT.mkdir(exist_ok=True)
    checkpoints = [2.5, 8, 16, 19.8, 21.8, 23.5, 25.2, 28, 30.8, 34, 39, 45]
    if args.previews:
        preview_dir = OUT / "previews"
        preview_dir.mkdir(exist_ok=True)
        sheet = Image.new("RGB", (1280, 3 * 216), (10, 16, 29))
        d = ImageDraw.Draw(sheet)
        for i, t in enumerate(checkpoints):
            frame = movie_frame(t)
            frame.save(preview_dir / f"frame-{t:04.1f}.png")
            thumb = frame.resize((320, 180))
            x, y = i % 4 * 320, i // 4 * 216
            sheet.paste(thumb, (x, y))
            d.text((x + 12, y + 190), f"{t:.1f} s", font=font(17), fill="white")
        sheet.save(OUT / "storyboard-preview.jpg", quality=93)
        print("Previews rendered.", flush=True)
        return
    audio = make_audio()
    output = OUT / "Museu-Entre-na-Arte-Trailer.mp4"
    command = ["ffmpeg", "-y", "-hide_banner", "-loglevel", "warning", "-f", "rawvideo", "-pix_fmt", "rgb24",
               "-s", "1280x720", "-r", str(args.fps), "-i", "pipe:0", "-i", str(audio),
               "-c:v", "libx264", "-preset", "medium", "-crf", "20", "-pix_fmt", "yuv420p",
               "-c:a", "aac", "-b:a", "192k", "-movflags", "+faststart", "-t", str(DURATION), str(output)]
    process = subprocess.Popen(command, stdin=subprocess.PIPE)
    try:
        for i in range(DURATION * args.fps):
            frame = movie_frame(i / args.fps)
            process.stdin.write(frame.tobytes())
            if i % (args.fps * 3) == 0:
                print(f"Rendered {i / args.fps:.0f}/{DURATION} seconds", flush=True)
    except BaseException:
        process.stdin.close()
        process.wait()
        raise
    finally:
        process.stdin.close()
    if process.wait() != 0:
        raise RuntimeError("FFmpeg failed")
    srt = []
    for i, (start, end, speaker, text) in enumerate(DIALOGUES, 1):
        srt.append(f"{i}\n{srt_time(start)} --> {srt_time(end)}\n{speaker}: {text}\n")
    (OUT / "falas.srt").write_text("\n".join(srt), encoding="utf-8")
    movie_frame(45).save(OUT / "capa-trailer.jpg", quality=95)
    print(f"Saved {output} ({output.stat().st_size} bytes)", flush=True)


if __name__ == "__main__":
    main()
