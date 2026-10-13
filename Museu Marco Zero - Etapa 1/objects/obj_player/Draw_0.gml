// Sprites existentes preservados, com a pose escolhida pelo movimento atual.
// O shader já existente remove somente o verde puro dos frames provisórios.
if (shader_is_compiled(sh_pixel_clean)) shader_set(sh_pixel_clean);
// Mantém os degraus de escala até a revisão da cutscene do quadro na etapa 3.
var escala = max(0.125, round(escala_portal * 8) / 8);
draw_sprite_ext(sprite_index, image_index, round(x), round(y),
    image_xscale * escala, image_yscale * escala, 0, image_blend, image_alpha);
shader_reset();
