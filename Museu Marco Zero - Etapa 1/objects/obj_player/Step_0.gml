if(global.pausado) exit;
var narrativa=instance_find(obj_narrativa,0);
if(narrativa!=noone && narrativa.estado!="livre" && narrativa.estado!="praca_livre") {depth=-y;exit;}
var velocidade = 240 * min(delta_time / 1000000, 0.05);

var input_x = (keyboard_check(vk_right)||keyboard_check(ord("D"))) - (keyboard_check(vk_left)||keyboard_check(ord("A")));
var input_y = (keyboard_check(vk_down)||keyboard_check(ord("S"))) - (keyboard_check(vk_up)||keyboard_check(ord("W")));

if (input_x != 0 || input_y != 0)
{
    var distancia = sqrt(sqr(input_x) + sqr(input_y));

    var movimento_x = input_x / distancia;
    var movimento_y = input_y / distancia;

var movimento_real_x = movimento_x * velocidade;
var movimento_real_y = movimento_y * velocidade;

// Movimento horizontal
if (!place_meeting(x + movimento_real_x, y, obj_obstaculo) && !place_meeting(x + movimento_real_x, y, obj_npc) && !place_meeting(x + movimento_real_x, y, obj_npc_obra))
{
    x += movimento_real_x;
}

// Movimento vertical
if (!place_meeting(x, y + movimento_real_y, obj_obstaculo) && !place_meeting(x, y + movimento_real_y, obj_npc) && !place_meeting(x, y + movimento_real_y, obj_npc_obra))
{
    y += movimento_real_y;
}

if (input_x == 0 && input_y < 0)
{
    sprite_index = spr_walk_n;
    image_speed = 1.6;
    ultima_direcao = 4;
}
else if (input_x > 0 && input_y < 0)
{
    sprite_index = spr_walk_ne;
    image_speed = 1.6;
	ultima_direcao = 3;

}
	else if (input_x > 0 && input_y == 0)
{
    sprite_index = spr_walk_e;
    image_speed = 1.6;
	ultima_direcao = 2;

}
else if (input_x > 0 && input_y > 0)
{
    sprite_index = spr_walk_se;
    image_speed = 1.6;
	ultima_direcao = 1;

}
    else if (input_x == 0 && input_y > 0)
    {
		sprite_index = spr_walk_s;
		image_speed = 1.6;
		ultima_direcao = 0;

    }
else if (input_x < 0 && input_y > 0)
{
    sprite_index = spr_walk_sw;
    image_speed = 1.6;
	ultima_direcao = 7;

}
else if (input_x < 0 && input_y == 0)
{
    sprite_index = spr_walk_w;
    image_speed = 1.6;
	ultima_direcao = 6;

}
else if (input_x < 0 && input_y < 0)
{
    sprite_index = spr_walk_nw;
    image_speed = 1.6;
	ultima_direcao = 5;

}
}

// Limites da área de caminhada
var configuracao = configuracao_cenario();
var limites = room == rm_galeria ? configuracao.limites_museu : configuracao.limites_praca;
x = clamp(x, limites.esquerda, limites.direita);
y = clamp(y, limites.topo, limites.base);

// Profundidade baseada na posição vertical
depth = -y;

if (input_x == 0 && input_y == 0)
{
    image_speed = 0;
    image_index = 0;

    switch (ultima_direcao)
    {
        case 0:
            sprite_index = spr_player;
            break;

        case 1:
            sprite_index = spr_player_se;
            break;

        case 2:
            sprite_index = spr_player_e;
            break;

        case 3:
            sprite_index = spr_player_ne;
            break;

        case 4:
            sprite_index = spr_player_n;
            break;

        case 5:
            sprite_index = spr_player_nw;
            break;

        case 6:
            sprite_index = spr_player_w;
            break;

        case 7:
            sprite_index = spr_player_sw;
            break;
    }
}

