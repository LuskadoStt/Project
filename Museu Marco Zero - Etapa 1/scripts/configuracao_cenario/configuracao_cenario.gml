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
        raio_historiador: 100,
        versao_passeio: 2,
        velocidade_passeio: 140,
        distancia_guia: 70,
        pontos_passeio: [
            {x: 307, y: 520, titulo: "Praça do Marco Zero", texto: "Esta pintura nos leva à Praça do Marco Zero, no Recife. Observe a paisagem e a relação da cidade com a água."},
            {x: 1080, y: 520, titulo: "Arquitetura e memória", texto: "Nesta obra, a arquitetura guarda memórias do lugar. Cada detalhe pode contar uma parte da sua história."},
            {x: 1830, y: 520, titulo: "Luz e reflexos", texto: "A luz e os reflexos mudam a maneira como vemos uma paisagem. Uma pintura também é um convite a observar."}
        ]
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
