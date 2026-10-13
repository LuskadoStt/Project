// Placeholder: usa os sprites existentes sem redesenhar o guia.
var narrativa = instance_find(obj_narrativa, 0);
if (narrativa == noone) exit;
var sprite_guia = spr_player;
var quadro_animacao = 0;
if (narrativa.estado == "passeio") {
    sprite_guia = spr_walk_e;
    quadro_animacao = floor(narrativa.tempo * 8) mod sprite_get_number(sprite_guia);
} else if (narrativa.estado == "volta_quadro") {
    sprite_guia = spr_walk_w;
    quadro_animacao = floor(narrativa.tempo * 8) mod sprite_get_number(sprite_guia);
}
if (shader_is_compiled(sh_pixel_clean)) shader_set(sh_pixel_clean);
draw_sprite_ext(sprite_guia, quadro_animacao, round(x), round(y),
    1, 1, 0, make_color_rgb(139,198,206), 1);
shader_reset();
