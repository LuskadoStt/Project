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
            desenhar_imagem_inteira(configuracao.imagem_destino,
                configuracao.imagem_praca, configuracao.cor_faixas);
            desenhar_piso_provisorio(configuracao);
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
        desenhar_imagem_inteira(configuracao.imagem_destino,
            configuracao.imagem_praca, configuracao.cor_faixas);
        desenhar_piso_provisorio(configuracao);
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
