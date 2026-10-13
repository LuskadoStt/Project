"""Checa cobertura e recortes; não simula o renderer nem o gameplay GameMaker."""
from pathlib import Path
import json
import re
import math
ROOT = Path(__file__).resolve().parents[1]

def load(path):
    return json.loads(re.sub(r',\s*([}\]])', r'\1', path.read_text()))

config = (ROOT / 'scripts/configuracao_cenario/configuracao_cenario.gml').read_text()
fraction_source = float(re.search(r'inicio_piso_imagem:\s*([\d.]+)', config)[1])
fraction_target = float(re.search(r'inicio_piso_tela:\s*([\d.]+)', config)[1])
source = load(ROOT / 'sprites/spr_cenario_obra_1/spr_cenario_obra_1.yy')
width, height = source['width'], source['height']
assert 0 < fraction_source < 1 and 0 < fraction_target < 1
source_y = math.floor(height * fraction_source)
source_floor_height = height - source_y
assert source_floor_height > 0
normalized_plans = []
for name in ['imagem_praca', 'moldura']:
    match = re.search(name + r':\s*\{x:\s*(\d+), y:\s*(\d+), largura:\s*(\d+), altura:\s*(\d+)\}', config)
    x, y, target_width, target_height = map(int, match.groups())
    scale_x = target_width / width
    assert math.isclose(scale_x * width, target_width)
    target_y = y + target_height * fraction_target
    end = y + target_height
    scale_floor_y = (800 / width) * (target_height / 500)
    tile_height = source_floor_height * scale_floor_y
    normalized = [(0, fraction_target)]
    for _ in range(100):
        if target_y >= end: break
        remaining = min(tile_height, end - target_y)
        assert remaining > 0
        source_part_height = remaining / scale_floor_y
        assert source_y + source_part_height <= height + 1e-9
        normalized.append(((target_y - y) / target_height, (target_y + remaining - y) / target_height))
        target_y += remaining
    else:
        raise AssertionError('Desenho não converge para o limite do retângulo')
    assert math.isclose(target_y, end)
    for left, right in zip(normalized, normalized[1:]):
        assert math.isclose(left[1], right[0]), 'Buraco entre faixas'
    normalized_plans.append(normalized)
    print(f'PASS: {name} — cobertura de {target_width}x{target_height}, sem faixas laterais, piso com {len(normalized)-1} pedaços dentro da imagem.')
assert len(normalized_plans[0]) == len(normalized_plans[1])
for first, second in zip(*normalized_plans):
    assert all(math.isclose(a, b) for a, b in zip(first, second)), 'Quadro e praça divergem'
for name in ['objects/obj_obra_1/Draw_0.gml', 'objects/obj_narrativa/Draw_0.gml']:
    code = (ROOT / name).read_text()
    assert 'desenhar_cenario_compartilhado(configuracao,' in code
    assert 'desenhar_piso_provisorio' not in code
assert 'draw_sprite_part_ext' in config and 'gpu_set_texfilter(false)' in config
print('PASS: quadro e praça compartilham a composição; piso vem do sprite existente.')
print('Teste geométrico concluído. Renderização e gameplay exigem execução GameMaker.')
