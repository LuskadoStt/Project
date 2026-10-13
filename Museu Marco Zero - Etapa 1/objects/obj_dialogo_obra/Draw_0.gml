if (dialogo_ativo)
{
    var npc = instance_find(obj_npc_obra, 0);

    if (npc != noone)
    {
        // ==============================
        // POSIÇÃO DO BALÃO
        // ==============================

        var caixa_largura = 500;
        var caixa_altura = 140;

var caixa_x = npc.x - caixa_largura / 2;
var caixa_y = npc.y - 112 - caixa_altura;

        // ==============================
        // FUNDO DO BALÃO
        // ==============================

        draw_set_color(c_black);
        draw_set_alpha(0.9);

        draw_rectangle(
            caixa_x,
            caixa_y,
            caixa_x + caixa_largura,
            caixa_y + caixa_altura,
            false
        );

        // ==============================
        // "BICO" DO BALÃO
        // ==============================

        draw_triangle(
            npc.x - 15,
            caixa_y + caixa_altura,
            npc.x + 15,
            caixa_y + caixa_altura,
            npc.x,
            caixa_y + caixa_altura + 25,
            false
        );

        // ==============================
        // TEXTO
        // ==============================

        draw_set_alpha(1);
        draw_set_color(c_white);

        draw_set_halign(fa_left);
        draw_set_valign(fa_top);

        draw_text_ext(
            caixa_x + margem,
            caixa_y + margem,
            texto,
            20,
            caixa_largura - margem * 2
        );

        // ==============================
        // RESTAURA
        // ==============================

        draw_set_color(c_white);
        draw_set_alpha(1);
    }
}