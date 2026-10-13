# Etapa 2 — passeio por dados e apenas os NPCs principais

## Entrega

Os visitantes (`obj_npc`) estão desativados nas duas rooms, sem apagar seus recursos. No museu permanecem protagonista e guia. No destino permanecem protagonista e historiador, conforme sua escolha. A arte provisória existente foi preservada.

O guia agora tem Create, sprites e animação próprios na instância, profundidade pelos pés e movimento realizado pelo executor. A narrativa usa uma lista de ações para o passeio. Não há salto imediato do jogador para acompanhar o guia: os dois percorrem seus caminhos em paralelo.

## Cada passo da cutscene do passeio

| Passo | Ação | Comportamento esperado |
| --- | --- | --- |
| 1 | Boas-vindas | Guia convida a conhecer três obras. Controle bloqueado, texto progressivo; Espaço/Enter completa e depois avança. |
| 2 | Ir à obra 1 | Guia e protagonista andam até o quadro do Marco Zero; câmera acompanha o protagonista. |
| 3 | Observar obra 1 | Ambos viram para cima, esperam 0,3 s e o guia comenta a paisagem e a relação com a água. |
| 4 | Ir à obra 2 | Os dois caminham até a pintura central, em caminhos paralelos. |
| 5 | Observar obra 2 | Viram para a obra, fazem a pausa e ouvem a fala sobre arquitetura e memória. O nome é uma descrição provisória, não identificação histórica da imagem. |
| 6 | Ir à obra 3 | Ambos caminham até a terceira moldura. |
| 7 | Observar obra 3 | Viram para a obra, fazem a pausa e o guia comenta luz e reflexos. |
| 8 | Apresentar a tecnologia | Guia vira para o protagonista e diz: “Nossa nova tecnologia permite entrar nas pinturas e visitar esses lugares.” |
| 9 | Retornar à obra 1 | Guia e protagonista caminham até o primeiro quadro. |
| 10 | Convidar e liberar | “Toque no quadro para iniciar a viagem.” Ao avançar, o passeio termina e o controle é devolvido. |

As posições e falas das três obras estão em `configuracao_cenario.gml`. `roteiro_passeio` monta a lista de ações em `roteiros_cutscene.gml`. `sistema_cutscene.gml` executa mover ator, falar, esperar, mudar pose, mudar sprite, fade, ir para room e grupos de movimentos simultâneos. Nesta etapa, o passeio exercita mover, falar, esperar, pose e grupo. Fade, troca explícita de sprite e mudança de room estão disponíveis para as próximas cutscenes, mas ainda não foram exercitados como ações do executor no teste de passeio.

O controle do jogador e o relógio das cutscenes ficam bloqueados durante a pausa. O passeio é salvo como revisão 2 somente após terminar. Um save da etapa anterior permite ver o novo passeio uma vez; voltar da praça não o repete. Os saves não armazenam uma cutscene pela metade.

## Cutscene do quadro e chegada

A viagem existente foi preservada: E próximo da obra → aproximação → pose voltada para cima → entrada com redução em degraus e fade → praça → história. Ela também foi percorrida pelo teste automatizado desta etapa.

A revisão detalhada dessa segunda cutscene continua reservada para a etapa 3: aproximação, toque/brilho, levitação com oscilação, puxão, transição e chegada serão convertidos para as ações por dados e ajustados no próximo passo. Não foram antecipadas as etapas 3, 4 ou 5.

## Validações realizadas

Execução: https://github.com/LuskadoStt/Project/actions/runs/38409487819 . Código testado: `4bec6f37c92dc165621894d9ed657b83780b03e4`.

- Estrutura dos 41 recursos e metadados: PASS.
- Geometria/composição compartilhada: PASS.
- Leitor oficial ResourceTool: PASS.
- Compilação/empacotamento Windows, VM, runtime 2026.0.0.23: PASS.
- EXECUÇÃO REAL do executável Windows em GitHub Actions: PASS.
- O relatório gerado pelo próprio jogo registrou `aprovado: true`, `falhas: []`, pausa e bloqueio verificados, e marcos na ordem `boas_vindas → obra_1 → obra_2 → obra_3 → tecnologia → convite`.
- O teste executou passeio, pausou atores/câmera, tentou mover o protagonista durante diálogo, verificou liberação de controle, entrou na praça, avançou a história e voltou ao museu. Confirmou ausência de visitantes, um guia no museu, um historiador no destino e que o passeio não se repetiu no retorno.
- Duração simulada registrada: aproximadamente 30,57 segundos. Não é medição de FPS, e o teste avança as falas automaticamente; o ritmo de leitura normal pode ser maior.

O modo de teste requer `--qa-cutscene` no executável. Uma execução normal não ativa o modo, não avança diálogos automaticamente e usa os saves habituais. O teste ignora saves e não escreve progresso do usuário.

Jogo compilado: https://github.com/LuskadoStt/Project/actions/runs/38409487819/artifacts/11820377401 .

Relatório JSON e duas capturas geradas pelo executável: https://github.com/LuskadoStt/Project/actions/runs/38409487819/artifacts/11820172852 . As capturas foram geradas e enviadas pelo workflow; o download para inspeção local ficou bloqueado pela rede deste ambiente. Não houve aprovação visual humana das capturas. Áudio perceptivo, qualidade da arte e desempenho em diferentes máquinas continuam exigindo avaliação.

## Arquivos e edições

- `game P.I.yyp`
- `objects/obj_guia/Create_0.gml`
- `objects/obj_guia/Draw_0.gml`
- `objects/obj_guia/Step_2.gml`
- `objects/obj_guia/obj_guia.yy`
- `objects/obj_narrativa/Create_0.gml`
- `objects/obj_narrativa/Draw_64.gml`
- `objects/obj_narrativa/Step_0.gml`
- `objects/obj_player/Draw_0.gml`
- `qa/verify_project.py`
- `rooms/rm_galeria/rm_galeria.yy`
- `rooms/rm_obra_1/rm_obra_1.yy`
- `scripts/arte_pixel/arte_pixel.gml`
- `scripts/configuracao_cenario/configuracao_cenario.gml`
- `scripts/qa_cutscene/qa_cutscene.gml`
- `scripts/qa_cutscene/qa_cutscene.yy`
- `scripts/roteiros_cutscene/roteiros_cutscene.gml`
- `scripts/roteiros_cutscene/roteiros_cutscene.yy`
- `scripts/sistema_cutscene/sistema_cutscene.gml`
- `scripts/sistema_cutscene/sistema_cutscene.yy`

Na raiz do repositório: alterado `.github/workflows/validar-gamemaker.yml`; criado `qa/testar-executavel.ps1`. O workflow passou a iniciar o executável e recolher relatório/capturas após compilar. A rotina tem timeout e captura diagnóstico se o jogo travar.

Os GML novos e alterados são entregues INTEIROS em `GML-COMPLETOS-ETAPA-2.md`. Todas as edições `.yy`/`.yyp`, incluindo arquivos novos completos, constam em `METADADOS-ETAPA-2.diff`. A documentação e o pacote da etapa foram acrescentados após a validação; não alteram o código testado.

## Conferência curta para você

Execute o jogo sem argumentos e confira o ritmo normal: três paradas, guia voltado para as obras, câmera suave, fala da tecnologia e retorno ao primeiro quadro. Teste Espaço/Enter, Esc e movimento após a última fala. Verifique se você vê apenas os dois personagens no museu e o historiador no destino. Essa conferência visual complementa o teste automatizado já aprovado.

Depois desta conferência encerramos a etapa 2 e aguardamos seu retorno antes da etapa 3.
