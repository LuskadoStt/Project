# Museu — etapa 3: viagem e chegada em cutscene por dados

Abra `game P.I.yyp` no GameMaker 2026.0.0.16 e execute com F5. O nome de pasta histórico mantém os caminhos da automação. Consulte `qa/ETAPA-3.md`; relatórios das etapas 1 e 2 são históricos.

## O que mudou

O passeio de três obras continua. A viagem usa ações por dados: aproximação, pose de toque, brilho, levitação, puxão com escala em degraus, fade, chegada e história. Visitantes estão desativados; guia e historiador permanecem. Nenhum PNG ou metadado foi alterado nesta etapa.

Quadro e destino compartilham `spr_cenario_obra_1`, inclusive o calçamento. A paisagem preenche a tela e o piso é repetido para circulação. A imagem mostra rio e parapeito; ainda não é arte final de uma praça completa. O gesto da mão usa uma pose existente até recebermos os sprites finais.

GML completos: `qa/GML-COMPLETOS-ETAPA-3.md`. Configurações: `scripts/configuracao_cenario/configuracao_cenario.gml`. Sequências: `scripts/roteiros_cutscene/roteiros_cutscene.gml`.

## Controles

- Espaço/Enter: completar a fala, depois avançar.
- Setas/WASD: caminhar quando o controle estiver liberado.
- E: tocar o primeiro quadro; na praça, conversar perto do historiador.
- R na praça: voltar ao museu.
- Esc: pausa. F11: tela cheia.
- Na pausa, M silencia; esquerda/direita ajustam volume; T muda leitura imediata; F reduz efeitos.

Saves existentes são preservados. Retornar não reinicia o passeio. Para rever tudo desde o início, feche o jogo e remova `museu_marco_zero.ini` da área de dados do GameMaker, se desejar.

## Validação e atualização

GitHub Actions passou na estrutura, composição, leitor oficial, compilação e execução real Windows. Duas viagens, pausa na levitação, bloqueio de input, efeitos reduzidos e retorno foram verificados sem falhas. `qa/ETAPA-3.md` contém links, código testado e limitações. `--qa-cutscene` é exclusivo da automação; não afeta execução normal.

Use Fetch/Pull no GitHub Desktop para atualizar a pasta clonada. O executável permite testar sem abrir o editor ou substituir recursos individualmente. Não houve medição de FPS nem aprovação visual humana das capturas.

## Proposta cinematográfica

`design/ROTEIRO-CINEMATOGRAFICO-PROPOSTA.md` descreve câmera, sprites, levitação, dissolução e chegada do novo pedido. Visitantes e “Pico de Brennand” pertencem à proposta; não foram adicionados nesta etapa. A arte final continua reservada à etapa correspondente. A implementação seguinte aguarda a conferência da etapa 3.
