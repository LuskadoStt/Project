/// Configuração da etapa 1. Nenhuma imagem nova é criada ou redesenhada.
function configuracao_cenario() {
    return {
        imagem_destino: spr_cenario_obra_1,
        imagem_museu: spr_cenario,
        // Área interna da primeira moldura, após o museu ser ajustado à largura da sala.
        moldura: {x: 179, y: 199, largura: 258, altura: 140},
        // Imagem inteira acima do piso provisório, sem corte ou deformação.
        imagem_praca: {x: 0, y: 0, largura: 800, altura: 360},
        cor_faixas: make_color_rgb(35,43,59),
        cor_piso: make_color_rgb(142,127,116),
        cor_juntas: make_color_rgb(113,103,99),
        piso_inicio_y: 360,
        limites_museu: {esquerda: 32, topo: 470, direita: 2016, base: 670},
        limites_praca: {esquerda: 32, topo: 380, direita: 768, base: 486},
        chegada_praca: {x: 400, y: 430},
        historiador_praca: {x: 520, y: 430},
        raio_historiador: 100
    };
}

/// Desenha o sprite inteiro com escala proporcional e amostragem sem filtragem.
/// As faixas completam o retângulo quando as proporções não coincidem.
function desenhar_imagem_inteira(_sprite, _retangulo, _cor_fundo) {
    gpu_set_texfilter(false);
    draw_set_alpha(1);
    draw_set_color(_cor_fundo);
    draw_rectangle(_retangulo.x, _retangulo.y,
        _retangulo.x + _retangulo.largura - 1,
        _retangulo.y + _retangulo.altura - 1, false);
    var escala = min(_retangulo.largura / sprite_get_width(_sprite),
        _retangulo.altura / sprite_get_height(_sprite));
    var largura = sprite_get_width(_sprite) * escala;
    var altura = sprite_get_height(_sprite) * escala;
    var pos_x = _retangulo.x + (_retangulo.largura - largura) / 2;
    var pos_y = _retangulo.y + (_retangulo.altura - altura) / 2;
    // Compensa a origem para o ajuste continuar válido quando a arte for substituída.
    draw_sprite_ext(_sprite, 0,
        pos_x + sprite_get_xoffset(_sprite) * escala,
        pos_y + sprite_get_yoffset(_sprite) * escala,
        escala, escala, 0, c_white, 1);
    draw_set_color(c_white);
}

/// Piso simples autorizado para tornar o cenário provisório explorável.
function desenhar_piso_provisorio(_configuracao) {
    draw_set_color(_configuracao.cor_piso);
    draw_rectangle(0, _configuracao.piso_inicio_y, 799, 499, false);
    draw_set_color(_configuracao.cor_juntas);
    for (var linha = _configuracao.piso_inicio_y; linha < 500; linha += 28) {
        draw_rectangle(0, linha, 799, linha + 1, false);
    }
    for (var coluna = 0; coluna < 800; coluna += 80) {
        draw_rectangle(coluna, _configuracao.piso_inicio_y, coluna + 1, 499, false);
    }
    draw_set_color(c_white);
}
