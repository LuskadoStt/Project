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
draw_set_color(c_white);
