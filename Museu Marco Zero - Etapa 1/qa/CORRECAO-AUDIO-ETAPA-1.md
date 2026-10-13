# Correção do carregamento de áudio — etapa 1

O GameMaker informou que os recursos GMSound v2 não declaravam `channelFormat`. A validação anterior conferia JSON e referências, mas não detectava esse campo obrigatório do formato GameMaker.

Alterados somente os dois recursos de áudio e o verificador estrutural; nenhuma alteração em GML, imagens ou WAVs.

Em ambos os recursos foram acrescentados `"channelFormat": 0` e `"exportDir": ""`. O segundo campo declara o diretório de exportação padrão explicitamente. Abaixo estão os arquivos completos corrigidos.

## `sounds/snd_ambiente/snd_ambiente.yy`

```json
{
  "$GMSound": "v2",
  "%Name": "snd_ambiente",
  "audioGroupId": {
    "name": "audiogroup_default",
    "path": "audiogroups/audiogroup_default"
  },
  "bitDepth": 1,
  "bitRate": 128,
  "channelFormat": 0,
  "compression": 0,
  "conversionMode": 0,
  "duration": 16,
  "exportDir": "",
  "name": "snd_ambiente",
  "parent": {
    "name": "game P.I",
    "path": "game P.I.yyp"
  },
  "preload": true,
  "resourceType": "GMSound",
  "resourceVersion": "2.0",
  "sampleRate": 22050,
  "soundFile": "snd_ambiente.wav",
  "type": 0,
  "volume": 0.6
}
```

## `sounds/snd_portal/snd_portal.yy`

```json
{
  "$GMSound": "v2",
  "%Name": "snd_portal",
  "audioGroupId": {
    "name": "audiogroup_default",
    "path": "audiogroups/audiogroup_default"
  },
  "bitDepth": 1,
  "bitRate": 128,
  "channelFormat": 0,
  "compression": 0,
  "conversionMode": 0,
  "duration": 2.4,
  "exportDir": "",
  "name": "snd_portal",
  "parent": {
    "name": "game P.I",
    "path": "game P.I.yyp"
  },
  "preload": true,
  "resourceType": "GMSound",
  "resourceVersion": "2.0",
  "sampleRate": 22050,
  "soundFile": "snd_portal.wav",
  "type": 0,
  "volume": 0.6
}
```

## Teste

Extraia o ZIP corrigido numa pasta nova e abra `game P.I.yyp`. Se carregar, execute F5. O campo obrigatório agora é verificado por `qa/verify_project.py`. Não houve compilação nem carregamento no GameMaker neste ambiente; envie qualquer nova mensagem de erro completa.
