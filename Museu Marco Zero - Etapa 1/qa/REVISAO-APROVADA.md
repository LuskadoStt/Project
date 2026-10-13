# Revisão após aprovação — 13/10/2026

As melhorias do relatório foram implementadas no código. A avaliação anterior permanece como registro das evidências da versão anterior; suas pendências de implementação são substituídas pelo estado abaixo. Os testes de execução continuam pendentes.

| Área | Implementação atual | Verificação restante |
| --- | --- | --- |
| Unidade visual | Museu e personagens substituídos por desenho original em grade de pixels; praça enriquecida com textura e detalhes | Julgar composição, atmosfera e riqueza visual no jogo |
| Proporção do personagem | Idle e caminhada usam a mesma função e proporções; fundo verde não participa da renderização atual | Conferir todas as direções e silhuetas |
| NPCs principais | Guia com crachá e historiador com chapéu/bolsa | Legibilidade e expressões em execução |
| Toque | Aproximação até o quadro e braço elevado, antes do portal | Contato visual da mão com a pintura |
| Ordenação | Guia tem instância própria com profundidade pelos pés; historiador também | Oclusão ao cruzar personagens |
| Portal | Escala em passos de 1/8, partículas e opção de movimento/clarão reduzidos | Ritmo, legibilidade e ausência de distorções |
| Conversas | No máximo uma fala próxima visível durante exploração; suprimidas durante falas principais | Testar aglomerações e limites da câmera |
| Áudio | Loop ambiente e efeito de portal sintetizados, originais, com volume e silêncio | Compilar recursos e escutar volume, continuidade e ausência de cliques |
| Pausa | Esc bloqueia atualização de atores e câmera e pausa o loop | Testar em cada estado, inclusive durante o portal |
| Acessibilidade | Texto imediato, movimento/clarão reduzidos e controles por teclado | Fonte, contraste e resoluções |
| Salvamento | Checkpoints de exploração e configurações em INI; retomada da sala e posição | Fechar/reabrir em ambas as salas, opções e retorno ao museu |
| Renderização | Surface por sala, recriação após perda, liberação em CleanUp e fallback direto | Alternar foco/tela cheia e repetir 20 viagens; observar memória |
| Desempenho | Redesenho de cenário estático evitado; atualização temporal mantida | Medir FPS, tempo de frame e memória no hardware-alvo |

## Resultado automatizado

`python qa/verify_project.py`: integridade de 37 recursos, eventos Create/Step/End Step/Draw/GUI/CleanUp, frames, salas, referências GML, estados, dimensões das câmeras, duração dos WAVs e presença de limpeza da surface e bloqueio de pausa.

Este script não compila GML. PASS estrutural não significa aprovação jogável nem benchmark.

## Casos adicionais obrigatórios

1. Iniciar sem INI: passeio completo; pausar em cada fala e nos deslocamentos.
2. Tocar a obra: conferir mão, levitação, redução, continuidade e chegada.
3. Pausar no portal por dez segundos: ao continuar, a cutscene deve prosseguir da mesma posição. O loop ambiente e o efeito de portal devem ficar pausados e continuar de onde pararam.
4. Concluir a história, andar, fechar/reabrir: retomar posição na praça sem repetir a chegada.
5. Voltar ao museu, explorar, fechar/reabrir: retomar no museu sem passeio obrigatório.
6. Alterar opções, fechar/reabrir: preservar volume, leitura e movimento reduzido.
7. Alternar F11 e foco da janela: cenário deve se manter ou ser recriado sem erro de surface.
8. Repetir vinte viagens: verificar memória, instâncias de guia e estabilidade.
9. Comparar 30/60/120 FPS, inclusive diagonal e aglomerações.
10. Conferir arte e ritmo lado a lado com a referência, usando critérios gerais e sem exigir cópia de recursos específicos.

## Limites

Sem runtime GameMaker neste ambiente, não houve compilação nem gameplay. A arte é uma interpretação original, e a praça não é uma reconstrução arquitetônica precisa. Ainda não há benchmark medido de desempenho ou aprovação de fidelidade visual a Impostor Factory.
