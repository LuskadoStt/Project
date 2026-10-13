# Etapa 3 — toque, levitação, puxão e chegada por dados

## Entrega implementada

A viagem e a chegada agora usam o mesmo executor de ações do passeio. A sequência tem aproximação, toque/brilho, levitação com oscilação, puxão para a pintura, fade, troca de room, chegada e explicação do historiador. Nenhum PNG, `.yy` ou `.yyp` foi alterado nesta etapa. São os mesmos 41 recursos. Visitantes continuam desativados; guia e historiador foram preservados.

## Passos da cutscene atual

| Passo | Duração/parâmetro | Comportamento |
| --- | --- | --- |
| Interação | E, a até 110 px do ponto de interação | Bloqueia controle e inicia uma única viagem. |
| Aproximação | 140 px/s, conforme a distância | Aproxima-se do ponto de toque, derivado da moldura. |
| Toque | Brilho em 0,25 s; espera de 0,45 s | Pose existente voltada para cima; brilho comunica o contato. Não há sprite de mão novo. |
| Levitação | 1,2 s, altura de 20 px | Sobe com smoothstep e oscilação de até 2 px. Som do portal e partículas acompanham a animação. |
| Puxão | 1,3 s | Move até o interior da moldura e reduz o sprite em múltiplos de 1/8, até 0,125. |
| Transição | 0,4 s | Fade antes de entrar em `rm_obra_1`; não libera o controle durante a troca. |
| Chegada | 1,2 s, mais pausa de 0,3 s | Revela o cenário compartilhado com o quadro; protagonista surge em (400,430), escala normal. |
| História | Espaço/Enter | Historiador explica o Marco Zero em três falas preservadas. |
| Exploração | Após a última fala | Devolve controle; E repete conversa, R volta sem repetir passeio. |

As sequências ficam em `scripts/roteiros_cutscene/roteiros_cutscene.gml`. Pontos e durações ficam em `scripts/configuracao_cenario/configuracao_cenario.gml`. O executor recebe ações de animação, brilho e som; a narrativa controla início e encerramento. Esc pausa atores, câmera, relógio da ação, brilho e fade. O modo de efeitos reduzidos elimina oscilação/partículas, limita brilho e usa fade escuro.

## Validação confirmada

Código testado: `21f1b5c404b2228d1ae9c907b26481a3d0bb70f5`.

Execução: https://github.com/LuskadoStt/Project/actions/runs/38415101793 .

- Estrutura dos recursos e composição: PASS.
- Carregamento pelo leitor oficial do GameMaker: PASS.
- Compilação Windows, VM, runtime 2026.0.0.23: PASS.
- Execução real do jogo Windows: PASS. Relatório: `aprovado: true`, `falhas: []`.
- Passeio de três obras, bloqueio de input e pausa: PASS.
- Duas viagens completas: normal e com efeitos reduzidos. Os 27 marcos apareceram na ordem prevista.
- 67 tentativas de E durante o fluxo iniciaram exatamente duas viagens, uma por ciclo.
- Pausa na levitação, escala em degraus até 0,125, oscilação normal e remoção no modo reduzido: PASS.
- Historiador preservado, repetição da conversa, ausência de visitantes e retorno sem duplicar guia nem repetir passeio: PASS.
- Tempo simulado: 38,235431 s. O teste avança falas automaticamente; isso não mede FPS nem tempo de leitura.

O driver de teste foi ajustado para aguardar o início efetivo da conversa repetida antes de tentar o retorno. A execução posterior passou. Sem `--qa-cutscene`, diálogos não avançam sozinhos e o jogo usa seus saves habituais. O teste ignora saves e não grava progresso do usuário.

Jogo compilado: https://github.com/LuskadoStt/Project/actions/runs/38415101793/artifacts/11823412302 .

JSON e quatro capturas: https://github.com/LuskadoStt/Project/actions/runs/38415101793/artifacts/11823587142 . Capturas de museu, levitação, puxão e praça foram geradas e enviadas, mas não inspecionadas visualmente neste ambiente: o download ficou bloqueado pela rede. A aprovação é funcional, não avaliação visual humana, percepção de áudio ou comparação de desempenho com Impostor Factory.

## Arquivos alterados

- `objects/obj_narrativa/Create_0.gml`
- `objects/obj_narrativa/Draw_0.gml`
- `objects/obj_narrativa/Draw_64.gml`
- `objects/obj_narrativa/Step_0.gml`
- `objects/obj_obra_1/Draw_0.gml`
- `scripts/configuracao_cenario/configuracao_cenario.gml`
- `scripts/qa_cutscene/qa_cutscene.gml`
- `scripts/roteiros_cutscene/roteiros_cutscene.gml`
- `scripts/sistema_cutscene/sistema_cutscene.gml`

Na raiz, `qa/testar-executavel.ps1` foi atualizado para o relatório e quatro capturas. `GML-COMPLETOS-ETAPA-3.md` entrega os nove GML inteiros. Não há alteração de metadados nesta etapa. O ZIP contém o projeto completo; o nome de pasta histórico foi mantido para preservar caminhos.

## Roteiro cinematográfico proposto

`design/ROTEIRO-CINEMATOGRAFICO-PROPOSTA.md` detalha o novo pedido: visitantes, gestos, câmeras, zooms, dissolução e destino chamado provisoriamente de “Pico de Brennand”. É uma proposta; não muda o destino atual, não reativa visitantes e não afirma que esses novos efeitos passaram nos testes desta etapa.

## Conferência visual curta

Execute sem argumentos. Toque o quadro com E e observe a subida antes do puxão. Pause na levitação e retome. Na praça, avance três falas, repita com E e retorne com R. Ative efeitos reduzidos na pausa e viaje novamente. Confira legibilidade, música e ritmo. A implementação seguinte aguarda essa conferência e sua escolha sobre o roteiro.
