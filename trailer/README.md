# Trailer independente — Museu: Entre na Arte

`Museu-Entre-na-Arte-Trailer.mp4` é uma animação conceitual independente de 49 segundos, em 1280×720, 60 FPS, com vídeo H.264 e áudio AAC estéreo. Abre em um player comum, sem instalar ou abrir o GameMaker.

Há visitantes animados, movimento de câmera, falas na tela, caminhada, toque, ondas luminosas, levitação, puxão, expansão da pintura, chegada e entrada do historiador. O encerramento apresenta o título “Museu — Entre na Arte”. A trilha instrumental foi sintetizada originalmente para este vídeo; também foi utilizado o som de portal existente no projeto. As falas são legendadas, sem dublagem.

O vídeo usa os sprites e cenários existentes. A paisagem é a imagem provisória do rio e do parapeito; não é arte final de uma nova praça. “Pico de Brennand” foi mantido como o nome provisório solicitado no roteiro. A referência municipal chama o local de Parque das Esculturas Francisco Brennand e a obra central de Torre de Cristal.

Esta produção não é uma captura de gameplay: é uma renderização separada do roteiro cinematográfico. Os novos visitantes e efeitos estão apenas no trailer. Os recursos, sprites, rooms e código GML da etapa 3 não foram alterados. Não foram usados sprites, música ou imagens de Impostor Factory.

## Arquivos

- `Museu-Entre-na-Arte-Trailer.mp4`: vídeo final com legendas já visíveis.
- `capa-trailer.jpg`: capa do vídeo.
- `falas.srt`: legendas em arquivo separado para edição.
- `render_trailer.py`: código completo de produção, câmera, animação e áudio.
- `validar_video.py`: verificação de codecs, duração, frames e decodificação completa.
- `validacao-video.json`: propriedades e resultado de decodificação do MP4.

As prévias, o storyboard de inspeção e o WAV intermediário são gerados localmente, não precisam ser enviados para atualizar o jogo e não fazem parte da distribuição principal.

## Renderizar novamente

Em Linux, com Python 3, Pillow, NumPy, FFmpeg e fontes DejaVu instaladas, execute a partir da raiz do repositório:

```sh
python trailer/render_trailer.py --previews
python trailer/render_trailer.py
python trailer/validar_video.py
```

O renderer apenas lê as imagens originais da pasta `Museu Marco Zero - Etapa 1`. Os outputs são gravados em `trailer/`. A interpolação smoothstep usa o tempo da montagem, sem depender da velocidade de processamento. As fontes utilizadas são DejaVu Sans/Serif do sistema, não fontes de outro jogo.

## Montagem

| Tempo | Cena |
| --- | --- |
| 0–5,4 s | Galeria movimentada; título de abertura e aproximação da câmera. |
| 5,4–11,3 s | Guia apresenta a tecnologia. |
| 11,4–14,7 s | Convite para tocar o quadro. |
| 15,4–17,5 s | Comentário do guia; pausa de observação. |
| 17,5–20,1 s | Caminhada e extensão da mão. |
| 20,1–21,2 s | Contato e ondas luminosas. |
| 21,2–22,7 s | Levitação e reação do guia. |
| 22,7–24,4 s | Puxão para dentro da pintura. |
| 24,4–27,1 s | Expansão da pintura, dissolução e luz gradual. |
| 26,2–28,6 s | Materialização no destino. |
| 28,6–32,1 s | Historiador entra e se aproxima. |
| 32,1–36,8 s | Explicação histórica em legenda. |
| 36,8–41 s | Gesto, visitantes e contemplação da paisagem. |
| 41–49 s | Título final e encerramento com fade. |

Os intervalos se sobrepõem durante as transições para evitar cortes secos.

## Validação desta exportação

O MP4 foi decodificado integralmente pelo FFmpeg sem erros: 2.940 quadros, 49 segundos, H.264 em 1280×720 a 60 FPS e AAC estéreo a 44,1 kHz. Foram inspecionados quadros da montagem e capturas extraídas do próprio MP4, incluindo levitação e diálogo do historiador. O resultado técnico está em `validacao-video.json`; isso não é um teste de desempenho do jogo.
