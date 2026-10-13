# QA — Museu e viagem ao Marco Zero

Data: 13/10/2026. Referência de direção: Impostor Factory.

## Parecer

O projeto tem o fluxo narrativo básico solicitado, mas ainda não deve ser aprovado como visualmente fiel à referência nem como pronto para distribuição. Foram feitas inspeção dos recursos de imagem e análise do código; não houve execução do jogo. O ambiente não contém compilador/runtime GameMaker nem uma cópia jogável de Impostor Factory. Esta é uma avaliação qualitativa da direção conhecida da referência, sem comparação lado a lado ou benchmark medido.

A referência orienta personagens compactos e expressivos, cenários de pixel art coerentes, leitura clara das interações, diálogos com ritmo e transições narrativas fluidas. Os personagens e recursos específicos da referência não foram copiados.

## Falhas encontradas e ajustes

| Prioridade | Evidência anterior | Ajuste no código | Validação |
| --- | --- | --- | --- |
| P0 | `spr_walk_s` usado no GML, mas ausente na lista de recursos do `.yyp` | Registrado o sprite existente | Referências verificadas por script; compilação pendente |
| P1 | Frames de caminhada com fundo verde opaco, confirmado pela inspeção do PNG | Shader com chroma key restrito ao verde puro, aplicado aos personagens | Código inspecionado; compilação e renderização do shader pendentes |
| P1 | Praça com altura 450 e câmera com altura 500 | Sala e piso ampliados para 500 | Dimensões verificadas por script |
| P2 | Personagem e visitantes moviam-se em unidades por frame; cutscene usava segundos | Movimento em unidades por segundo, com limite de recuperação após travamentos | Código inspecionado; comparar execução em 30/60/120 FPS |
| P2 | Câmera atualizada antes de todas as movimentações e com deslocamentos bruscos | Atualização em End Step, interpolação e posição arredondada | Código inspecionado; teste visual pendente |
| P2 | Conversas alteravam temporizador no evento Draw | Conversas e duração passam a ser atualizadas em Step | Código inspecionado |
| P2 | Reserva de obras podia impedir que visitantes passeassem; movimento preso não tinha recuperação | Alternância entre destinos e passeios, liberação de reservas, nova tentativa após bloqueio | Código inspecionado; observar aglomerações no runtime |
| P2 | Diálogo exibido integralmente, sem ritmo de leitura | Texto progressivo a 40 caracteres/s; primeira pressão completa, seguinte avança | Código inspecionado; verificar acentos e largura no runtime |
| P2 | Guia usava sprite parado durante o passeio | Animação direcional durante deslocamentos | Código inspecionado; proporção dos sprites ainda pendente |

Os ajustes acima são correções de fonte verificadas estruturalmente. Não representam aprovação de gameplay ou de renderização.

## Arte: diferenças ainda abertas

| Prioridade | Diferença | Critério para aprovação |
| --- | --- | --- |
| P1 | Museu tem acabamento muito detalhado, praça usa formas simples; não há unidade de pixel art | Cenários com a mesma escala de pixel, nível de detalhe e linguagem de luz; preservar a composição compartilhada entre quadro e praça |
| P1 | Idle 64×64 e caminhada 84/88×84/88, com desenhos e silhuetas diferentes | Personagem mantém altura aparente, roupa, rosto e posição dos pés em todas as direções e animações |
| P2 | Guia e historiador são variantes de cor do protagonista | Silhuetas, trajes e expressões distinguíveis sem depender só da cor |
| P2 | Redução contínua durante o portal pode deformar os pixels | Conferir a escala na animação real; usar etapas de escala ou tratamento coerente com a direção artística |
| P2 | Conversas de visitantes podem se sobrepor em grupos | Balões legíveis, prioridade por proximidade e quantidade limitada de falas simultâneas |
| P2 | Shader retira verde puro, mas bordas podem conter tons misturados | Conferir todos os frames sobre fundos claros/escuros; revisar transparência dos assets na produção de arte |

O desenho do Marco Zero é uma interpretação estilizada, não uma reconstrução arquitetônica precisa. Ainda requer revisão de fachadas, perspectiva, ornamentos e mosaico para alcançar a riqueza visual pretendida.

## Funcionalidades e sensação de jogo

O fluxo implementado é: boas-vindas → passeio automático → tecnologia → retorno ao quadro → exploração → toque → levitação → transição → historiador → exploração da praça → retorno. Durante falas e deslocamentos de cutscene, o controle fica bloqueado; visitantes continuam ativos. O quadro e a praça chamam a mesma função de desenho.

A aproximação inicial termina abaixo da moldura; não existe ainda um frame específico de mão tocando a tela. O guia é desenhado junto ao cenário, sem ordenação dinâmica por pés como os demais personagens. Essas duas apresentações precisam de revisão visual. Música, efeitos sonoros, pausa/configurações, salvamento e opções de acessibilidade não estão implementados nesta versão. São diferenças de acabamento e funcionalidades a avaliar conforme o escopo final; não foram tratadas como funcionalidades já existentes.

## Desempenho

Não há dados de FPS, uso de CPU/GPU ou memória. O projeto está configurado para 60 atualizações/s. Isso não comprova que alcance 60 FPS nem que tenha desempenho equivalente à referência.

Metas propostas para homologação, não números medidos de Impostor Factory:

- 60 FPS estáveis no hardware mínimo definido para o projeto; orçamento aproximado de 16,7 ms por frame.
- Registrar tempo de frame médio, percentil 95 e picos durante passeio, portal, chegada e aglomeração de visitantes.
- Fazer ao menos 20 viagens e retornos; observar crescimento de memória e falhas de estado.
- Verificar movimento em 30/60/120 FPS. A compensação de tempo é limitada a 50 ms por atualização para evitar grandes saltos; abaixo de 20 FPS o jogo pode desacelerar.
- Medir antes de otimizar: o desenho estático da praça é refeito a cada frame e é candidato a cache se aparecer como custo relevante.

Não foi adicionado cache de surfaces sem evidência de gargalo; isso exigiria testes de perda/recriação de surfaces e memória. O shader acrescenta trabalho de GPU e precisa ser validado nas plataformas de destino.

## Roteiro jogável obrigatório no GameMaker

Todos os casos abaixo estão PENDENTES de execução.

| Caso | Procedimento | Resultado esperado |
| --- | --- | --- |
| Compilação | Abrir `.yyp` e executar F5 | Sem recursos ausentes, erros de GML ou erros de shader |
| Entrada | Iniciar uma sessão nova e pressionar movimento durante a fala | Protagonista fica bloqueado; NPCs continuam ativos |
| Diálogo | Pressionar Espaço antes e depois de terminar a revelação | Completa o texto, depois avança; nada cortado na caixa |
| Passeio | Observar ida e volta completas | Personagens não saltam; câmera acompanha; animações não mostram verde |
| Controle | Após o convite, testar oito direções e bordas | Velocidade diagonal consistente; não sai da área caminhável |
| Interação distante | Pressionar E longe da obra | Não inicia teletransporte |
| Portal | Pressionar E perto da obra, depois insistir em E e movimento | Uma única viagem; controle bloqueado; levitação legível e sem interrupção |
| Continuidade | Comparar quadro e cenário da chegada | Mesmos edifícios, piso e marco na mesma disposição |
| Historiador | Avançar todas as falas e conversar novamente | História correta, texto legível e controle liberado após finalizar |
| Retorno | Pressionar R na praça e interagir novamente | Museu retorna sem repetir passeio; próxima viagem inicia normalmente |
| Visitantes | Observar grupos por cinco minutos | Passeiam, conversam e observam; não ficam presos nem atravessam o protagonista |
| Ordenação | Passar na frente/atrás do guia e historiador | Conferir oclusão; guia tem pendência de ordenação conhecida |
| Resolução | Testar janela, tela cheia e tamanhos disponíveis | Sem faixa descoberta, texto cortado ou pixels borrados |
| Estabilidade | Repetir 20 viagens, alternar foco da janela | Sem erro de instância, estado preso ou crescimento contínuo de memória |

## Verificações realizadas

`python qa/verify_project.py`: PASS — 33 recursos registrados, arquivos de eventos, frames, ordem de criação das salas, referências a recursos no GML, dimensões das câmeras e estados da narrativa. A mesma função de desenho é usada no quadro e na praça.

A inspeção estrutural não interpreta toda a linguagem GML, não compila os shaders e não verifica colisões, oclusão, ritmo ou desempenho em execução. Aprovação final depende do roteiro jogável e da revisão de arte acima.
