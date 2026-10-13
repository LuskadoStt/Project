# Revisão da etapa 1 — paisagem completa e piso existente

## Alteração

A área 800×500 é totalmente preenchida. O cenário usa a parte superior de `spr_cenario_obra_1` acima de y=360. A faixa final do mesmo sprite, a partir de 94% da altura, fornece o calçamento, repetido verticalmente até y=500. Não há faixas laterais, piso cinza desenhado ou PNG novo/editado.

A paisagem recebe ajuste independente de largura/altura para preencher o espaço acima do piso; as proporções são levemente alteradas. O calçamento mantém a proporção de sua textura na tela principal. O último pedaço é limitado ao espaço restante. A moldura usa exatamente a mesma composição relativa, para manter continuidade com a praça. `gpu_set_texfilter(false)` continua ativo.

Alterados: `scripts/configuracao_cenario/configuracao_cenario.gml`, `objects/obj_narrativa/Draw_0.gml`, `objects/obj_obra_1/Draw_0.gml`, `qa/verify_project.py`. Acrescentados `qa/testar_composicao.py` e o workflow `.github/workflows/validar-gamemaker.yml` na raiz do repositório. Documentação atualizada. Nenhum `.yy` ou `.yyp` foi alterado nesta revisão. O conteúdo completo dos três GML desta revisão está abaixo.

## Testes realizados

- Integridade dos 38 recursos, referências, eventos, dimensões e metadados de áudio: PASS.
- Cobertura geométrica de 800×500 e 258×140, ausência de lacunas e recortes dentro do sprite, seis pedaços de piso por tela e composição relativa idêntica: PASS.
- Nenhum PNG alterado: conferido pelo diff do Git.
- Instalação do `gm-cli` oficial 2.4.1: concluída.
- Tentativa de compilação local com GMS2@2026.0.0.23: BLOQUEADA antes de analisar o projeto, pois o download de ProjectTool em gmpm.gamemaker.io retornou HTTP 403.
- Teste visual, FPS e gameplay desta revisão: NÃO EXECUTADOS localmente.

## Testes automáticos no GitHub

O workflow verifica estrutura e geometria a cada push relevante em main e pode ser iniciado manualmente em Actions. Em seguida, tenta compilar/empacotar Windows com o CLI oficial, Node 24 e a versão 2026.0.0.23. Se concluir, o jogo fica disponível como artifact na execução. Não há publicação em loja nem GX.games. O resultado do workflow deve ser consultado: configurar a automação não significa que a compilação já passou.

Compilação e testes estruturais podem ser automatizados. Para validar colisões, ritmo, oclusão, FPS e arte, ainda é necessário executar o jogo, com um runner e controles de teste. O workflow atual não realiza gameplay nem captura screenshots.

## Atualizar sem baixar ZIPs

No Windows, instale GitHub Desktop e clone LuskadoStt/Project uma única vez. Abra `Museu Marco Zero - Etapa 1/game P.I.yyp` da pasta clonada. Nas revisões seguintes, feche o projeto no GameMaker, clique em Fetch origin/Pull origin no GitHub Desktop e reabra o mesmo `.yyp`. Não é necessário extrair arquivos individuais. Se houver alterações locais, preserve-as em commit antes de atualizar; não use reset/force para descartá-las.

O CLI oficial também pode compilar/executar pelo terminal com Node 24 instalado, dentro da pasta do projeto:

```text
npx --yes @gamemaker/gm-cli@2.4.1 run "game P.I.yyp" --target=windows --runtime=vm --toolchain=GMS2@2026.0.0.23
```

Referência oficial: https://github.com/YoYoGames/gm-cli . Essas ferramentas precisam baixar o runtime e ter acesso à rede. A execução local depende do suporte/licença e dependências da plataforma.

## Próxima etapa

Esta revisão ainda pertence à etapa 1. A etapa 2 (cutscenes por dados e três paradas) não foi implementada. O screenshot enviado confirma que a versão anterior abriu e rodou no seu GameMaker; ele não serve como validação visual desta revisão.

## `scripts/configuracao_cenario/configuracao_cenario.gml`

```gml
/// Configuração provisória: utiliza somente imagens existentes no projeto.
function configuracao_cenario() {
    return {
        imagem_destino: spr_cenario_obra_1,
        imagem_museu: spr_cenario,
        moldura: {x: 179, y: 199, largura: 258, altura: 140},
        imagem_praca: {x: 0, y: 0, largura: 800, altura: 500},
        // A partir de 94% da altura, a imagem provisória contém apenas calçamento.
        // Altere esta fração quando substituir a arte; nenhum PNG é modificado.
        inicio_piso_imagem: 0.94,
        // Reserva 28% da tela para circulação. O piso usa a textura do próprio sprite.
        inicio_piso_tela: 0.72,
        limites_museu: {esquerda: 32, topo: 470, direita: 2016, base: 670},
        limites_praca: {esquerda: 32, topo: 380, direita: 768, base: 486},
        chegada_praca: {x: 400, y: 430},
        historiador_praca: {x: 520, y: 430},
        raio_historiador: 100
    };
}

/// Quadro e praça utilizam a mesma composição, incluindo o calçamento existente.
/// Sem faixas laterais: a paisagem preenche a largura disponível.
/// A faixa de piso é repetida verticalmente sem esticar a textura do calçamento.
function desenhar_cenario_compartilhado(_configuracao, _retangulo) {
    gpu_set_texfilter(false);
    var imagem = _configuracao.imagem_destino;
    var largura_imagem = sprite_get_width(imagem);
    var altura_imagem = sprite_get_height(imagem);
    var origem_piso = clamp(floor(altura_imagem * _configuracao.inicio_piso_imagem), 1, altura_imagem - 1);
    var altura_piso_imagem = altura_imagem - origem_piso;
    var altura_paisagem = _retangulo.altura * _configuracao.inicio_piso_tela;
    var escala_x = _retangulo.largura / largura_imagem;
    // A paisagem recebe ajuste vertical para caber acima da faixa explorável.
    // Isso preserva todos os elementos, porém altera levemente suas proporções.
    draw_sprite_part_ext(imagem, 0, 0, 0, largura_imagem, origem_piso,
        _retangulo.x, _retangulo.y, escala_x, altura_paisagem / origem_piso, c_white, 1);

    // Mesma escala da textura nas duas telas, relativa à composição lógica 800x500.
    var escala_piso_y = (800 / largura_imagem) * (_retangulo.altura / 500);
    var pos_y = _retangulo.y + altura_paisagem;
    var fim_y = _retangulo.y + _retangulo.altura;
    var altura_ladrilho = altura_piso_imagem * escala_piso_y;
    while (pos_y < fim_y) {
        // O último pedaço é limitado à área restante, sem pintar fora da moldura.
        var altura_destino = min(altura_ladrilho, fim_y - pos_y);
        var altura_origem = altura_destino / escala_piso_y;
        draw_sprite_part_ext(imagem, 0, 0, origem_piso, largura_imagem, altura_origem,
            _retangulo.x, pos_y, escala_x, escala_piso_y, c_white, 1);
        pos_y += altura_destino;
    }
    draw_set_alpha(1);
    draw_set_color(c_white);
}
```

## `objects/obj_narrativa/Draw_0.gml`

```gml
gpu_set_texfilter(false);
if (!surface_exists(fundo_surface)) {
    fundo_surface = surface_create(room_width, room_height);
    if (surface_exists(fundo_surface)) {
        surface_set_target(fundo_surface);
        draw_clear_alpha(c_black, 1);
        if (room == rm_galeria) {
            // Restaura o fundo existente, com escala proporcional à largura da sala.
            var escala_museu = room_width / sprite_get_width(configuracao.imagem_museu);
            draw_sprite_ext(configuracao.imagem_museu, 0, 0, 0,
                escala_museu, escala_museu, 0, c_white, 1);
        } else {
            desenhar_cenario_compartilhado(configuracao, configuracao.imagem_praca);
        }
        surface_reset_target();
    }
}
if (surface_exists(fundo_surface)) {
    draw_surface(fundo_surface, 0, 0);
} else {
    // Falta de memória para a surface não impede o desenho do cenário.
    if (room == rm_galeria) {
        var escala_museu_direta = room_width / sprite_get_width(configuracao.imagem_museu);
        draw_sprite_ext(configuracao.imagem_museu, 0, 0, 0,
            escala_museu_direta, escala_museu_direta, 0, c_white, 1);
    } else {
        desenhar_cenario_compartilhado(configuracao, configuracao.imagem_praca);
    }
}
// Efeito atual do portal preservado; será substituído na etapa 3.
if (room == rm_galeria && estado == "portal" && !global.movimento_reduzido) {
    draw_set_alpha(0.5);
    draw_set_color(make_color_rgb(128,228,223));
    for (var indice = 0; indice < 18; indice++) {
        var angulo = indice * 20 + tempo * 100;
        var raio = 65 * (1 - clamp(tempo / 2.4, 0, 1));
        var pos_x = 307 + lengthdir_x(raio, angulo);
        var pos_y = 290 + lengthdir_y(raio, angulo);
        draw_rectangle(pos_x, pos_y, pos_x + 3, pos_y + 3, false);
    }
    draw_set_alpha(1);
}
draw_set_color(c_white);
```

## `objects/obj_obra_1/Draw_0.gml`

```gml
// O quadro mostra a mesma composição da praça, com o piso da imagem existente.
// Apenas o interior configurável da moldura é coberto.
var configuracao = configuracao_cenario();
desenhar_cenario_compartilhado(configuracao, configuracao.moldura);
```


## Resultado da primeira execução no GitHub

Execução https://github.com/LuskadoStt/Project/actions/runs/38402342380 : estrutura e geometria passaram. A ferramenta de build foi baixada, mas a obtenção da licença guest falhou em `Igor Runtime FetchLicense`, código 255, antes da compilação. Isso não é um erro GML reportado: o compilador ainda não analisou o projeto.

O workflow foi atualizado para executar `resourcetool eval "resource list"` com o leitor oficial antes de tentar o build e para aceitar autenticação pelo secret `GAMEMAKER_PAT`. Sem esse secret, a etapa de build apresenta um erro explícito; não declara compilação aprovada.

Para liberar builds: gerar uma chave em https://gamemaker.io/en/account/access-keys e armazená-la em https://github.com/LuskadoStt/Project/settings/secrets/actions como repository secret chamado `GAMEMAKER_PAT`. Não colocar a chave em arquivos do projeto, commits ou mensagens. Depois executar o workflow em Actions > Run workflow. O login é feito a partir do secret e a ferramenta aplica as permissões/licença da conta. A chave pode ser revogada pela conta quando desejar.

## Resultado do leitor oficial

Na execução https://github.com/LuskadoStt/Project/actions/runs/38402710901 , a estrutura e a geometria passaram novamente. A etapa `Carregar projeto com leitor oficial do GameMaker` passou com ResourceTool@2026.0.22 e registrou `SUCCESSFUL LOAD AND LINK` em 371,1987 ms. O leitor listou os sons, sprites, salas, objetos e scripts do projeto. Este resultado confirma carregamento de recursos; não compila GML nem executa gameplay.

A etapa seguinte detectou a ausência de `GAMEMAKER_PAT` e interrompeu o build com a instrução para configurar a chave. Nenhum executável foi produzido. É necessário cadastrar esse secret na conta/repositório do usuário; não foi solicitada nem exposta nenhuma chave na conversa.
