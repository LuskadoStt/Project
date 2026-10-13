// O quadro mostra a mesma composição da praça, com o piso da imagem existente.
// Apenas o interior configurável da moldura é coberto.
var configuracao = configuracao_cenario();
desenhar_cenario_compartilhado(configuracao, configuracao.moldura);

// Brilho provisório sem novos sprites: contorno da moldura e partículas pequenas.
var narrativa = instance_find(obj_narrativa, 0);
if (narrativa != noone && narrativa.brilho_quadro > 0) {
    var moldura = configuracao.moldura;
    var brilho = global.movimento_reduzido ? min(0.25, narrativa.brilho_quadro) : narrativa.brilho_quadro;
    draw_set_color(make_color_rgb(145,227,218));
    for (var borda = 0; borda < 3; borda++) {
        draw_set_alpha(brilho * (0.6 - borda * 0.12));
        draw_rectangle(moldura.x - borda - 1, moldura.y - borda - 1,
            moldura.x + moldura.largura + borda, moldura.y + moldura.altura + borda, true);
    }
    if (!global.movimento_reduzido && (narrativa.fase_portal == "levitacao" || narrativa.fase_portal == "puxao")) {
        draw_set_alpha(brilho * 0.7);
        for (var particula = 0; particula < 12; particula++) {
            var angulo = particula * 30 + narrativa.tempo * 90;
            var raio = 30 + narrativa.jogador.escala_portal * 30;
            var pos_x = narrativa.dados_portal.alvo_x + lengthdir_x(raio, angulo);
            var pos_y = narrativa.dados_portal.alvo_y + lengthdir_y(raio * 0.5, angulo);
            draw_rectangle(round(pos_x), round(pos_y), round(pos_x) + 2, round(pos_y) + 2, false);
        }
    }
    draw_set_alpha(1);
    draw_set_color(c_white);
}
