"""Verificação estrutural; não substitui compilação nem execução no GameMaker."""
from pathlib import Path
import json
import re

ROOT = Path(__file__).resolve().parents[1]

def load(path):
    return json.loads(re.sub(r',\s*([}\]])', r'\1', path.read_text(encoding='utf-8-sig')))

project = load(ROOT / 'game P.I.yyp')
resources = {r['id']['name']: r['id']['path'] for r in project['resources']}
assert len(resources) == len(project['resources']), 'Recurso duplicado'
for name, path in resources.items():
    assert (ROOT / path).is_file(), f'Recurso ausente: {name}'
for path in ROOT.rglob('*.yy'):
    data = load(path)
    if data.get('resourceType') == 'GMObject':
        for ev in data['eventList']:
            prefix = {0: 'Create', 3: 'Step', 8: 'Draw', 12: 'CleanUp'}[ev['eventType']]
            assert (path.parent / f'{prefix}_{ev["eventNum"]}.gml').is_file(), (path, ev)
    if data.get('resourceType') == 'GMSprite':
        for frame in data['frames']:
            assert (path.parent / (frame['name'] + '.png')).is_file(), (path, frame)
    if data.get('resourceType') == 'GMRoom':
        instances = [i for layer in data['layers'] for i in layer.get('instances', [])]
        names = {i['name'] for i in instances}
        assert all(i['name'] in names for i in data['instanceCreationOrder']), path
        for instance in instances:
            assert (ROOT / instance['objectId']['path']).is_file(), instance
        view = data['views'][0]
        assert data['roomSettings']['Width'] >= view['wview'], path
        assert data['roomSettings']['Height'] >= view['hview'], path
for path in ROOT.rglob('*.gml'):
    code = re.sub(r'//[^\n]*|"[^"\n]*"', '', path.read_text())
    for name in re.findall(r'\b(?:spr_|obj_|rm_|sh_|snd_)[A-Za-z0-9_]+\b', code):
        assert name in resources, f'{path.name}: recurso não registrado: {name}'
    for a, b in [('(', ')'), ('{', '}'), ('[', ']')]:
        assert code.count(a) == code.count(b), (path, a)
controller = (ROOT / 'objects/obj_narrativa/Step_0.gml').read_text()
cases = set(re.findall(r'case "([^"]+)"', controller))
initial = (ROOT / 'objects/obj_narrativa/Create_0.gml').read_text()
assigned = set(re.findall(r'estado\s*=\s*"([^"]+)"', controller + initial))
assert assigned <= cases, f'Estado sem tratamento: {assigned - cases}'
config = (ROOT / 'scripts/configuracao_cenario/configuracao_cenario.gml').read_text()
assert 'imagem_destino: spr_cenario_obra_1' in config
for name in ['objects/obj_narrativa/Draw_0.gml', 'objects/obj_obra_1/Draw_0.gml']:
    code = (ROOT / name).read_text()
    assert 'desenhar_imagem_inteira(configuracao.imagem_destino' in code
    assert 'marco_zero(' not in code and 'museu_pixel(' not in code
assert load(ROOT / 'objects/obj_obra_1/obj_obra_1.yy')['visible'] is True
for name in ['obj_player', 'obj_npc', 'obj_guia', 'obj_npc_obra']:
    assert 'pessoa_pixel(' not in (ROOT / f'objects/{name}/Draw_0.gml').read_text()
for instance in load(ROOT / 'rooms/rm_obra_1/rm_obra_1.yy')['layers'][0]['instances']:
    if not instance['ignore']:
        assert 32 <= instance['x'] <= 768 and 380 <= instance['y'] <= 486

for path in ROOT.glob('sounds/*/*.yy'):
    sound = load(path)
    assert sound['channelFormat'] in (0, 1, 2), path
    assert sound['$GMSound'] == 'v2', path
    assert 'bitRate' not in sound and 'type' not in sound, path
    assert sound['compressionQuality'] == 4, path
    assert list(sound) == ['$GMSound', '%Name', 'audioGroupId', 'bitDepth', 'channelFormat', 'compression', 'compressionQuality', 'ConfigValues', 'conversionMode', 'duration', 'exportDir', 'name', 'parent', 'preload', 'resourceType', 'resourceVersion', 'sampleRate', 'soundFile', 'volume'], path
    assert isinstance(sound['exportDir'], str), path
    assert (path.parent / sound['soundFile']).is_file(), path
    import wave
    with wave.open(str(path.parent / sound['soundFile'])) as audio:
        assert abs(audio.getnframes() / audio.getframerate() - sound['duration']) < 0.01
assert 'surface_free(fundo_surface)' in (ROOT / 'objects/obj_narrativa/CleanUp_0.gml').read_text()
for name in ['obj_player', 'obj_npc']:
    assert 'if(global.pausado) exit;' in (ROOT / f'objects/{name}/Step_0.gml').read_text()
print(f'PASS: {len(resources)} recursos registrados, eventos, frames, salas, referências GML e estados.')
print('Compilação, shaders, FPS e gameplay: NÃO EXECUTADOS; requerem GameMaker.')
