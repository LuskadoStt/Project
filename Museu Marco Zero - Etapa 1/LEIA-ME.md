# Museu — etapa 1: imagem compartilhada

Abra `game P.I.yyp` no GameMaker 2026.0.0.16 e execute com F5.

Esta versão conclui somente a etapa 1 do novo pedido. A etapa 2 aguarda seu teste. As versões de QA anteriores são históricas; consulte agora `qa/ETAPA-1.md`.

## O que mudou

O museu usa `spr_cenario` e os personagens usam os sprites existentes. Nenhum PNG foi alterado, gerado ou redesenhado. `obj_obra_1` cobre apenas a área interna da primeira moldura com `spr_cenario_obra_1`. O destino preenche a tela com a paisagem e o calçamento da própria imagem; o piso é repetido abaixo para circulação. O desenho procedural da praça e a legenda deixaram de ser chamados pelo Draw da narrativa.

A imagem atual é provisória: mostra o rio e o parapeito, não uma praça completa. Ela será substituída pela arte que você fornecer. Configurações da etapa estão em `scripts/configuracao_cenario/configuracao_cenario.gml`.

## Controles preservados

- Espaço/Enter: completar a fala, depois avançar.
- Setas/WASD: caminhar quando o controle estiver liberado.
- E: tocar o primeiro quadro; na praça, conversar perto do historiador.
- R na praça: voltar ao museu.
- Esc: pausa. F11: tela cheia.
- Na pausa, M silencia; esquerda/direita ajustam volume; T muda leitura imediata; F reduz efeitos.

O salvamento existente foi mantido. Saves antigos da praça têm a posição limitada à nova faixa caminhável. Para testar o passeio desde o início, feche o jogo e remova `museu_marco_zero.ini` da área de dados do GameMaker, se esse arquivo existir.

## Conferência

`python qa/verify_project.py` verifica a estrutura. Não compila GML, shaders nem executa o jogo. O ambiente usado não contém runtime GameMaker.

`qa/REVISAO-TELA-PISO.md` descreve a revisão mais recente, testes e atualização pelo GitHub Desktop. `qa/ETAPA-1.md` lista arquivos, alterações exatas nos metadados, escala escolhida, roteiro de teste e limitações. `qa/GML-COMPLETOS-ETAPA-1.md` contém o conteúdo completo de cada GML novo ou alterado, por caminho. O ZIP contém também todos os arquivos efetivos do projeto.

A narrativa fixa e a cutscene atual do portal foram preservadas para as etapas 2 e 3. A limpeza dos scripts procedurais legados e dos placeholders será feita na etapa 4; os slots finais de arte e a lista de entregas ficam para a etapa 5.

## Automação

A raiz do repositório contém `.github/workflows/validar-gamemaker.yml` para validação e tentativa de build Windows a cada push. Veja a página Actions para o resultado e eventuais artifacts; o workflow atual não executa gameplay. A compilação local foi tentada com o CLI oficial, mas o download das ferramentas retornou HTTP 403 antes da análise do projeto.
