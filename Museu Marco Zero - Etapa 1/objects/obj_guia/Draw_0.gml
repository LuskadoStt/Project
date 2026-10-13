// Placeholder: mantém sprites existentes e a animação direcional do executor.
var narrativa = instance_find(obj_narrativa, 0);
if (narrativa == noone) exit;
var quadro = image_speed > 0 ? floor(narrativa.tempo * 8) mod sprite_get_number(sprite_index) : image_index;
if (shader_is_compiled(sh_pixel_clean)) shader_set(sh_pixel_clean);
draw_sprite_ext(sprite_index, quadro, round(x), round(y), 1, 1, 0, image_blend, 1);
shader_reset();
