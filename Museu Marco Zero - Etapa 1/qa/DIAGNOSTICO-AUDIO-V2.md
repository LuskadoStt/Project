# Correção do esquema GMSound v2

## Diagnóstico confirmado

O ZIP anterior já continha `channelFormat` na linha 10, mas também mantinha `bitRate` na linha 9. O erro apontava a linha 9: o leitor esperava `channelFormat` e encontrou um campo legado. Foi usado um conjunto de campos de áudio antigo com a etiqueta de versão nova `$GMSound: v2`.

A correção anterior apenas acrescentou campos. Ela não removeu os campos antigos nem acrescentou `compressionQuality`, por isso foi incompleta. Validar JSON com Python não substitui a validação do esquema e serialização do GameMaker.

A referência primária de código consultada é o esquema e conversor do pacote YY de Stitch, que declara os campos v2 e remove `bitRate` e `type` ao converter. Exemplo de recurso: https://github.com/bscotch/stitch/blob/main/packages/yy/samples/sounds/2024.1400.0.815.yy . Conversor: https://github.com/bscotch/stitch/blob/main/packages/yy/src/Yy.stringify.ts . É uma referência de ferramenta externa; o carregamento final ainda deve ser confirmado no GameMaker instalado.

## Edições exatas

Em ambos os `.yy`: removidos `bitRate: 128` e `type: 0`; mantido `channelFormat: 0`; acrescentados `compressionQuality: 4` e `ConfigValues: {}`. Mantido `exportDir: ""`. Campos escritos na ordem do exemplo v2, sem ordenação alfabética genérica. Nenhum GML, WAV ou sprite foi alterado. O verificador passou a conferir o conjunto e a ordem de campos esperado para estes recursos.

## Arquivos completos

### `sounds/snd_ambiente/snd_ambiente.yy`

```json
{
  "$GMSound": "v2",
  "%Name": "snd_ambiente",
  "audioGroupId": {
    "name": "audiogroup_default",
    "path": "audiogroups/audiogroup_default"
  },
  "bitDepth": 1,
  "channelFormat": 0,
  "compression": 0,
  "compressionQuality": 4,
  "ConfigValues": {},
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
  "volume": 0.6
}
```

### `sounds/snd_portal/snd_portal.yy`

```json
{
  "$GMSound": "v2",
  "%Name": "snd_portal",
  "audioGroupId": {
    "name": "audiogroup_default",
    "path": "audiogroups/audiogroup_default"
  },
  "bitDepth": 1,
  "channelFormat": 0,
  "compression": 0,
  "compressionQuality": 4,
  "ConfigValues": {},
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
  "volume": 0.6
}
```

## Teste

Extraia `Museu-Marco-Zero-Etapa-1-Audio-v2.zip` numa pasta nova, abra o `.yyp` e confira se o projeto carrega. Depois execute F5. Não foi realizado carregamento nem compilação no GameMaker neste ambiente. Essa correção resolve a incompatibilidade identificada nos metadados; não certifica todo o gameplay.

## Alternativas

- Deixar o próprio GameMaker gerar os recursos: em um projeto vazio na mesma IDE, criar dois recursos Sound chamados `snd_ambiente` e `snd_portal`, importar os respectivos WAVs do pacote e salvar. Usar os arquivos nativos gerados para comparar/substituir os dois recursos, preservando o `parent` do projeto destino. Evita adivinhar o esquema da versão instalada.
- Temporariamente retirar áudio: remover os dois registros de sons da lista de recursos do `.yyp` e todas as referências GML aos sons e aos seus handles. Apagar somente os WAVs ou apenas remover os registros deixa o problema incompleto. Esta alternativa permite priorizar gameplay e restaurar áudio depois.
