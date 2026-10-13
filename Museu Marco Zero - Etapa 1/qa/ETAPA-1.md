# Etapa 1 — quadro e destino com a mesma imagem

## Resultado e escopo

Foi aplicada sua escolha: imagem inteira, sem recorte, e faixa inferior de piso provisório feita com retângulos. Nenhum sprite foi redesenhado ou gerado. Foram restaurados os bitmaps do museu e dos personagens, substituindo os desenhos procedurais da versão anterior. O sistema narrativo, suas falas e a lógica de oito direções foram preservados, com os ajustes de limites e colisão necessários ao piso.

## Escala e composição

O sprite `spr_cenario_obra_1` tem 1665×945 pixels. Na praça, ele é encaixado proporcionalmente numa área 800×360. A escala é `min(800/1665, 360/945) = 0,380952…`: a imagem ocupa aproximadamente 634,286×360, com faixas laterais de aproximadamente 82,857 pixels. A parte inferior inteira da imagem continua visível. O piso provisório ocupa y=360…499; os pés podem andar em x=32…768 e y=380…486.

No quadro, o mesmo recurso é encaixado em x=179, y=199, largura=258, altura=140. A escala é aproximadamente 0,148148…, resultando em 246,667×140 e pequenas faixas laterais. Apenas o interior da moldura é coberto; a moldura existente fica preservada. Não há legenda desenhada por cima.

`gpu_set_texfilter(false)` é mantido e aplicado no desenho. A amostragem usa vizinho mais próximo, sem borramento. Redução não inteira descarta detalhes e produz distribuição desigual de pixels; não é escala pixel-perfect. Uma redução inteira não conseguiria preencher essas áreas com a imagem de 1665×945. Não foi escolhido esticar ou recortar, para preservar a composição e as proporções. O museu usa uma escala proporcional única de `2048/2172`, ficando com aproximadamente 682,667 pixels de altura; a sala limita a última fração de pixel na borda inferior.

## Posições e colisão

O protagonista chega em (400,430), centro da faixa explorável, e o historiador fica em (520,430). Os seis visitantes foram reposicionados no piso. A área acima do piso fica inacessível pelo limite superior dos pés. São mantidas as colisões existentes entre protagonista e visitantes; o historiador passa a ter máscara de pés e também bloqueia a passagem. Não foram adicionados obstáculos dentro do piso provisório aberto.

A imagem provisória representa uma vista do rio e parapeito. O diálogo do Marco Zero é mantido conforme solicitado; a arte final será fornecida depois. O conteúdo do quadro e a imagem do destino têm a mesma composição; o piso adicional é um placeholder para exploração.

## Arquivos novos/alterados

- `LEIA-ME.md` — alterado
- `game P.I.yyp` — alterado
- `objects/obj_guia/Draw_0.gml` — alterado
- `objects/obj_narrativa/Create_0.gml` — alterado
- `objects/obj_narrativa/Draw_0.gml` — alterado
- `objects/obj_narrativa/Step_0.gml` — alterado
- `objects/obj_npc/Draw_0.gml` — alterado
- `objects/obj_npc/Step_0.gml` — alterado
- `objects/obj_npc_obra/Create_0.gml` — alterado
- `objects/obj_npc_obra/Draw_0.gml` — alterado
- `objects/obj_npc_obra/obj_npc_obra.yy` — alterado
- `objects/obj_obra_1/Draw_0.gml` — novo
- `objects/obj_obra_1/obj_obra_1.yy` — alterado
- `objects/obj_player/Draw_0.gml` — alterado
- `objects/obj_player/Step_0.gml` — alterado
- `qa/verify_project.py` — alterado
- `rooms/rm_obra_1/rm_obra_1.yy` — alterado
- `scripts/configuracao_cenario/configuracao_cenario.gml` — novo
- `scripts/configuracao_cenario/configuracao_cenario.yy` — novo

Além desses arquivos, foram acrescentados este relatório, `GML-COMPLETOS-ETAPA-1.md`, `EDICOES-METADADOS-ETAPA-1.json` e `METADADOS-ETAPA-1.diff` como documentação.

## Código completo e edições exatas

O conteúdo completo de TODOS os GML novos/alterados está em `GML-COMPLETOS-ETAPA-1.md`. O ZIP inclui esses arquivos completos nos caminhos efetivos.

As edições estruturais exatas dos `.yy` e `.yyp` são mostradas abaixo por caminhos JSON Pointer, com valores antes/depois. O diff textual integral também está em `METADADOS-ETAPA-1.diff`. Arquivos metadata novos incluem seu conteúdo completo. Nenhuma edição de metadados de sprite foi necessária.

```json
[
  {
    "arquivo": "game P.I.yyp",
    "edicoes": [
      {
        "operacao": "substituir",
        "caminho": "/resources",
        "antes": [
          {
            "id": {
              "name": "obj_dialogo_obra",
              "path": "objects/obj_dialogo_obra/obj_dialogo_obra.yy"
            }
          },
          {
            "id": {
              "name": "obj_npc_obra",
              "path": "objects/obj_npc_obra/obj_npc_obra.yy"
            }
          },
          {
            "id": {
              "name": "obj_npc",
              "path": "objects/obj_npc/obj_npc.yy"
            }
          },
          {
            "id": {
              "name": "obj_obra_1",
              "path": "objects/obj_obra_1/obj_obra_1.yy"
            }
          },
          {
            "id": {
              "name": "obj_obstaculo",
              "path": "objects/obj_obstaculo/obj_obstaculo.yy"
            }
          },
          {
            "id": {
              "name": "obj_player",
              "path": "objects/obj_player/obj_player.yy"
            }
          },
          {
            "id": {
              "name": "obj_ponto_obra",
              "path": "objects/obj_ponto_obra/obj_ponto_obra.yy"
            }
          },
          {
            "id": {
              "name": "rm_galeria",
              "path": "rooms/rm_galeria/rm_galeria.yy"
            }
          },
          {
            "id": {
              "name": "rm_obra_1",
              "path": "rooms/rm_obra_1/rm_obra_1.yy"
            }
          },
          {
            "id": {
              "name": "spr_cenario_obra_1",
              "path": "sprites/spr_cenario_obra_1/spr_cenario_obra_1.yy"
            }
          },
          {
            "id": {
              "name": "spr_cenario",
              "path": "sprites/spr_cenario/spr_cenario.yy"
            }
          },
          {
            "id": {
              "name": "spr_colisao",
              "path": "sprites/spr_colisao/spr_colisao.yy"
            }
          },
          {
            "id": {
              "name": "spr_npc_obra",
              "path": "sprites/spr_npc_obra/spr_npc_obra.yy"
            }
          },
          {
            "id": {
              "name": "spr_player_e",
              "path": "sprites/spr_player_e/spr_player_e.yy"
            }
          },
          {
            "id": {
              "name": "spr_player_hitbox",
              "path": "sprites/spr_player_hitbox/spr_player_hitbox.yy"
            }
          },
          {
            "id": {
              "name": "spr_player_n",
              "path": "sprites/spr_player_n/spr_player_n.yy"
            }
          },
          {
            "id": {
              "name": "spr_player_ne",
              "path": "sprites/spr_player_ne/spr_player_ne.yy"
            }
          },
          {
            "id": {
              "name": "spr_player_nw",
              "path": "sprites/spr_player_nw/spr_player_nw.yy"
            }
          },
          {
            "id": {
              "name": "spr_player_se",
              "path": "sprites/spr_player_se/spr_player_se.yy"
            }
          },
          {
            "id": {
              "name": "spr_player_sw",
              "path": "sprites/spr_player_sw/spr_player_sw.yy"
            }
          },
          {
            "id": {
              "name": "spr_player_w",
              "path": "sprites/spr_player_w/spr_player_w.yy"
            }
          },
          {
            "id": {
              "name": "spr_player",
              "path": "sprites/spr_player/spr_player.yy"
            }
          },
          {
            "id": {
              "name": "spr_walk_e",
              "path": "sprites/spr_walk_e/spr_walk_e.yy"
            }
          },
          {
            "id": {
              "name": "spr_walk_n",
              "path": "sprites/spr_walk_n/spr_walk_n.yy"
            }
          },
          {
            "id": {
              "name": "spr_walk_ne",
              "path": "sprites/spr_walk_ne/spr_walk_ne.yy"
            }
          },
          {
            "id": {
              "name": "spr_walk_nw",
              "path": "sprites/spr_walk_nw/spr_walk_nw.yy"
            }
          },
          {
            "id": {
              "name": "spr_walk_s",
              "path": "sprites/spr_walk_s/spr_walk_s.yy"
            }
          },
          {
            "id": {
              "name": "spr_walk_se",
              "path": "sprites/spr_walk_se/spr_walk_se.yy"
            }
          },
          {
            "id": {
              "name": "spr_walk_sw",
              "path": "sprites/spr_walk_sw/spr_walk_sw.yy"
            }
          },
          {
            "id": {
              "name": "spr_walk_w",
              "path": "sprites/spr_walk_w/spr_walk_w.yy"
            }
          },
          {
            "id": {
              "name": "obj_narrativa",
              "path": "objects/obj_narrativa/obj_narrativa.yy"
            }
          },
          {
            "id": {
              "name": "marco_zero",
              "path": "scripts/marco_zero/marco_zero.yy"
            }
          },
          {
            "id": {
              "name": "sh_pixel_clean",
              "path": "shaders/sh_pixel_clean/sh_pixel_clean.yy"
            }
          },
          {
            "id": {
              "name": "arte_pixel",
              "path": "scripts/arte_pixel/arte_pixel.yy"
            }
          },
          {
            "id": {
              "name": "obj_guia",
              "path": "objects/obj_guia/obj_guia.yy"
            }
          },
          {
            "id": {
              "name": "snd_ambiente",
              "path": "sounds/snd_ambiente/snd_ambiente.yy"
            }
          },
          {
            "id": {
              "name": "snd_portal",
              "path": "sounds/snd_portal/snd_portal.yy"
            }
          }
        ],
        "depois": [
          {
            "id": {
              "name": "obj_dialogo_obra",
              "path": "objects/obj_dialogo_obra/obj_dialogo_obra.yy"
            }
          },
          {
            "id": {
              "name": "obj_npc_obra",
              "path": "objects/obj_npc_obra/obj_npc_obra.yy"
            }
          },
          {
            "id": {
              "name": "obj_npc",
              "path": "objects/obj_npc/obj_npc.yy"
            }
          },
          {
            "id": {
              "name": "obj_obra_1",
              "path": "objects/obj_obra_1/obj_obra_1.yy"
            }
          },
          {
            "id": {
              "name": "obj_obstaculo",
              "path": "objects/obj_obstaculo/obj_obstaculo.yy"
            }
          },
          {
            "id": {
              "name": "obj_player",
              "path": "objects/obj_player/obj_player.yy"
            }
          },
          {
            "id": {
              "name": "obj_ponto_obra",
              "path": "objects/obj_ponto_obra/obj_ponto_obra.yy"
            }
          },
          {
            "id": {
              "name": "rm_galeria",
              "path": "rooms/rm_galeria/rm_galeria.yy"
            }
          },
          {
            "id": {
              "name": "rm_obra_1",
              "path": "rooms/rm_obra_1/rm_obra_1.yy"
            }
          },
          {
            "id": {
              "name": "spr_cenario_obra_1",
              "path": "sprites/spr_cenario_obra_1/spr_cenario_obra_1.yy"
            }
          },
          {
            "id": {
              "name": "spr_cenario",
              "path": "sprites/spr_cenario/spr_cenario.yy"
            }
          },
          {
            "id": {
              "name": "spr_colisao",
              "path": "sprites/spr_colisao/spr_colisao.yy"
            }
          },
          {
            "id": {
              "name": "spr_npc_obra",
              "path": "sprites/spr_npc_obra/spr_npc_obra.yy"
            }
          },
          {
            "id": {
              "name": "spr_player_e",
              "path": "sprites/spr_player_e/spr_player_e.yy"
            }
          },
          {
            "id": {
              "name": "spr_player_hitbox",
              "path": "sprites/spr_player_hitbox/spr_player_hitbox.yy"
            }
          },
          {
            "id": {
              "name": "spr_player_n",
              "path": "sprites/spr_player_n/spr_player_n.yy"
            }
          },
          {
            "id": {
              "name": "spr_player_ne",
              "path": "sprites/spr_player_ne/spr_player_ne.yy"
            }
          },
          {
            "id": {
              "name": "spr_player_nw",
              "path": "sprites/spr_player_nw/spr_player_nw.yy"
            }
          },
          {
            "id": {
              "name": "spr_player_se",
              "path": "sprites/spr_player_se/spr_player_se.yy"
            }
          },
          {
            "id": {
              "name": "spr_player_sw",
              "path": "sprites/spr_player_sw/spr_player_sw.yy"
            }
          },
          {
            "id": {
              "name": "spr_player_w",
              "path": "sprites/spr_player_w/spr_player_w.yy"
            }
          },
          {
            "id": {
              "name": "spr_player",
              "path": "sprites/spr_player/spr_player.yy"
            }
          },
          {
            "id": {
              "name": "spr_walk_e",
              "path": "sprites/spr_walk_e/spr_walk_e.yy"
            }
          },
          {
            "id": {
              "name": "spr_walk_n",
              "path": "sprites/spr_walk_n/spr_walk_n.yy"
            }
          },
          {
            "id": {
              "name": "spr_walk_ne",
              "path": "sprites/spr_walk_ne/spr_walk_ne.yy"
            }
          },
          {
            "id": {
              "name": "spr_walk_nw",
              "path": "sprites/spr_walk_nw/spr_walk_nw.yy"
            }
          },
          {
            "id": {
              "name": "spr_walk_s",
              "path": "sprites/spr_walk_s/spr_walk_s.yy"
            }
          },
          {
            "id": {
              "name": "spr_walk_se",
              "path": "sprites/spr_walk_se/spr_walk_se.yy"
            }
          },
          {
            "id": {
              "name": "spr_walk_sw",
              "path": "sprites/spr_walk_sw/spr_walk_sw.yy"
            }
          },
          {
            "id": {
              "name": "spr_walk_w",
              "path": "sprites/spr_walk_w/spr_walk_w.yy"
            }
          },
          {
            "id": {
              "name": "obj_narrativa",
              "path": "objects/obj_narrativa/obj_narrativa.yy"
            }
          },
          {
            "id": {
              "name": "marco_zero",
              "path": "scripts/marco_zero/marco_zero.yy"
            }
          },
          {
            "id": {
              "name": "sh_pixel_clean",
              "path": "shaders/sh_pixel_clean/sh_pixel_clean.yy"
            }
          },
          {
            "id": {
              "name": "arte_pixel",
              "path": "scripts/arte_pixel/arte_pixel.yy"
            }
          },
          {
            "id": {
              "name": "obj_guia",
              "path": "objects/obj_guia/obj_guia.yy"
            }
          },
          {
            "id": {
              "name": "snd_ambiente",
              "path": "sounds/snd_ambiente/snd_ambiente.yy"
            }
          },
          {
            "id": {
              "name": "snd_portal",
              "path": "sounds/snd_portal/snd_portal.yy"
            }
          },
          {
            "id": {
              "name": "configuracao_cenario",
              "path": "scripts/configuracao_cenario/configuracao_cenario.yy"
            }
          }
        ]
      }
    ]
  },
  {
    "arquivo": "objects/obj_npc_obra/obj_npc_obra.yy",
    "edicoes": [
      {
        "operacao": "substituir",
        "caminho": "/spriteMaskId",
        "antes": null,
        "depois": {
          "name": "spr_player_hitbox",
          "path": "sprites/spr_player_hitbox/spr_player_hitbox.yy"
        }
      }
    ]
  },
  {
    "arquivo": "objects/obj_obra_1/obj_obra_1.yy",
    "edicoes": [
      {
        "operacao": "substituir",
        "caminho": "/eventList",
        "antes": [],
        "depois": [
          {
            "$GMEvent": "v1",
            "%Name": "",
            "collisionObjectId": null,
            "eventNum": 0,
            "eventType": 8,
            "isDnD": false,
            "name": "",
            "resourceType": "GMEvent",
            "resourceVersion": "2.0"
          }
        ]
      },
      {
        "operacao": "substituir",
        "caminho": "/visible",
        "antes": false,
        "depois": true
      }
    ]
  },
  {
    "arquivo": "rooms/rm_obra_1/rm_obra_1.yy",
    "edicoes": [
      {
        "operacao": "substituir",
        "caminho": "/layers/0/instances/0/y",
        "antes": 350,
        "depois": 430
      },
      {
        "operacao": "substituir",
        "caminho": "/layers/0/instances/1/y",
        "antes": 310,
        "depois": 430
      },
      {
        "operacao": "substituir",
        "caminho": "/layers/0/instances/3/x",
        "antes": 160,
        "depois": 150
      },
      {
        "operacao": "substituir",
        "caminho": "/layers/0/instances/3/y",
        "antes": 275,
        "depois": 398
      },
      {
        "operacao": "substituir",
        "caminho": "/layers/0/instances/4/x",
        "antes": 210,
        "depois": 215
      },
      {
        "operacao": "substituir",
        "caminho": "/layers/0/instances/4/y",
        "antes": 280,
        "depois": 456
      },
      {
        "operacao": "substituir",
        "caminho": "/layers/0/instances/5/y",
        "antes": 310,
        "depois": 398
      },
      {
        "operacao": "substituir",
        "caminho": "/layers/0/instances/6/x",
        "antes": 680,
        "depois": 690
      },
      {
        "operacao": "substituir",
        "caminho": "/layers/0/instances/6/y",
        "antes": 320,
        "depois": 456
      },
      {
        "operacao": "substituir",
        "caminho": "/layers/0/instances/7/x",
        "antes": 95,
        "depois": 90
      },
      {
        "operacao": "substituir",
        "caminho": "/layers/0/instances/7/y",
        "antes": 380,
        "depois": 470
      },
      {
        "operacao": "substituir",
        "caminho": "/layers/0/instances/8/x",
        "antes": 715,
        "depois": 725
      },
      {
        "operacao": "substituir",
        "caminho": "/layers/0/instances/8/y",
        "antes": 390,
        "depois": 470
      }
    ]
  },
  {
    "arquivo": "scripts/configuracao_cenario/configuracao_cenario.yy",
    "edicoes": [
      {
        "operacao": "criar_arquivo",
        "conteudo_completo": {
          "$GMScript": "v1",
          "%Name": "configuracao_cenario",
          "isCompatibility": false,
          "isDnD": false,
          "name": "configuracao_cenario",
          "parent": {
            "name": "game P.I",
            "path": "game P.I.yyp"
          },
          "resourceType": "GMScript",
          "resourceVersion": "2.0"
        }
      }
    ]
  }
]
```

## Verificação realizada

- Verificação estrutural dos 38 recursos, eventos, referências GML, frames, salas, estados e sons: PASS.
- Verificação de que os dois desenhos usam `configuracao.imagem_destino` e que o Draw atual não chama a praça/museu procedurais: PASS.
- Todas as instâncias ativas da praça estão dentro da faixa caminhável: PASS.
- Hashes dos PNGs antes/depois: nenhuma imagem alterada.
- Compilação e execução GameMaker: NÃO REALIZADAS; runtime indisponível.

## O que testar agora no GameMaker 2026

1. Abrir o projeto extraído e executar F5. Caso haja erro de compilação, enviar a mensagem completa com objeto/evento/linha.
2. Verificar se o museu mostra a arte antiga, e se a primeira pintura cabe dentro da moldura sem legenda sobreposta.
3. Terminar o passeio atual com Espaço/Enter e pressionar E perto da primeira obra. Comparar a imagem do quadro com o destino: o rio, o parapeito e o monumento devem manter a mesma disposição, com toda a imagem visível.
4. Conferir a chegada na faixa inferior, os seis visitantes e o historiador. Avançar a história, depois explorar em oito direções. Não deve ser possível subir até o rio nem sair da sala.
5. Aproximar-se do historiador: E deve reiniciar a história. Caminhar contra ele deve respeitar sua máscara de pés.
6. Voltar com R e viajar mais três vezes; verificar ausência de instâncias duplicadas e que o passeio não se repete.
7. Testar Esc/F11 e o retorno à janela: a surface deve ser recriada se necessário.
8. Se houver um save da versão anterior, abrir o jogo e confirmar que o personagem é reposicionado dentro do piso. Para testar do começo, fechar o jogo e remover somente `museu_marco_zero.ini` da área de dados local.

## O que ainda pode apresentar erro ou diferença

O shader de chroma key já existente voltou a ser usado para retirar o verde puro dos frames de caminhada. Ele ainda precisa compilar na sua plataforma; se falhar, a checagem permite desenho sem shader, mas o verde pode aparecer. A diferença de proporção entre idle 64×64 e walk 84/88×84/88 permanece e não foi corrigida por redesenho. A ordenação visual, o contato com a moldura e o tamanho dos balões devem ser confirmados jogando.

A cutscene atual ainda é fixa e o passeio não tem as três paradas solicitadas: isso é a etapa 2. A levitação/pose/entrada no quadro terá revisão na etapa 3. Os scripts procedurais legados e o placeholder desativado `obj_dialogo_obra` permanecem no projeto para limpeza na etapa 4, mas o cenário atual não os desenha. Os slots definitivos e a lista de arte pendente serão preparados na etapa 5. Nenhuma dessas etapas foi antecipada.

Esta entrega encerra a etapa 1 e aguarda seu teste antes de começar a etapa 2.
