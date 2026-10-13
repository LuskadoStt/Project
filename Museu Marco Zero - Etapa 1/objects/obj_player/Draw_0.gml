// Sprites existentes preservados, com a pose escolhida pelo movimento atual.
// O shader já existente remove somente o verde puro dos frames provisórios.
if (shader_is_compiled(sh_pixel_clean)) shader_set(sh_pixel_clean);
// Mantém os degraus de escala até a revisão da cutscene do quadro na etapa 3.
var escala = max(0.125, round(escala_portal * 8) / 8);
var narrativa = instance_find(obj_narrativa, 0);
var quadro = narrativa != noone && image_speed > 0 ? floor(narrativa.tempo * 8) mod sprite_get_number(sprite_index) : image_index;
draw_sprite_ext(sprite_index, quadro, round(x), round(y),
    image_xscale * escala, image_yscale * escala, 0, image_blend, image_alpha);
shader_reset();
