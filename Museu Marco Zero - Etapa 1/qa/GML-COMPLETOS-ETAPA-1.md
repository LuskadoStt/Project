# GML completos — etapa 1

Conteúdo integral dos arquivos novos e alterados, relativo à raiz do projeto.

## `objects/obj_guia/Draw_0.gml`

```gml
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
```

## `objects/obj_narrativa/Create_0.gml`

```gml
configuracao = configuracao_cenario();
depth = 50;
gpu_set_texfilter(false);
display_set_gui_size(800,500);
jogador=instance_find(obj_player,0);
tempo=0; pagina=0; fala=""; nome="Guia do museu";
guia_x=100; guia_y=540; fade=0;
if (!variable_global_exists("visita_concluida")) global.visita_concluida=false;
if (room==rm_galeria) {
    estado=global.visita_concluida ? "livre" : "boas_vindas";
    fala=estado=="livre" ? "" : "Bem-vindo! Venha comigo conhecer as obras e uma nova forma de viajar pela arte.";
} else {
    estado="chegada"; nome="Historiador local"; fade=1;
}

cam_x=0;cam_y=room==rm_galeria ? 182 : 0;

letras=0;ultima_fala=fala;

fundo_surface=-1;autosave_tempo=0;retomar_praca=false;
if(!variable_global_exists("sessao_iniciada")) {
    global.sessao_iniciada=true;global.pausado=false;
    ini_open("museu_marco_zero.ini");
    global.volume=clamp(ini_read_real("opcoes","volume",0.6),0,1);
    global.texto_rapido=ini_read_real("opcoes","texto",0);
    global.movimento_reduzido=ini_read_real("opcoes","movimento",0);
    global.visita_concluida=ini_read_real("visita","guia",0);
    var local_salvo=ini_read_string("visita","local","");
    global.salvo_x=ini_read_real("visita","x",320);global.salvo_y=ini_read_real("visita","y",540);
    global.carregar_posicao=local_salvo!="";
    retomar_praca=local_salvo=="praca" && room==rm_galeria;
    global.local_salvo=local_salvo;
    ini_close();
    if(local_salvo=="museu") {estado="livre";fala="";}
    global.musica=audio_play_sound(snd_ambiente,0,true);
    global.portal_som=-1;
}
if(global.carregar_posicao && ((room==rm_obra_1 && global.local_salvo=="praca") || (room==rm_galeria && global.local_salvo=="museu"))) {
    jogador.x=clamp(global.salvo_x,32,room_width-32);
    var limites_salvos=room==rm_galeria ? configuracao.limites_museu : configuracao.limites_praca;
    jogador.y=clamp(global.salvo_y,limites_salvos.topo,limites_salvos.base);
    if(room==rm_obra_1) {estado="praca_livre";fala="";fade=0;}
    global.carregar_posicao=false;
}
if(room==rm_galeria) instance_create_depth(guia_x,guia_y,-guia_y,obj_guia);
audio_master_gain(global.volume);

var camera_inicial=view_camera[0];
if(camera_inicial!=-1) {
    cam_x=clamp(jogador.x-camera_get_view_width(camera_inicial)/2,0,max(0,room_width-camera_get_view_width(camera_inicial)));
    cam_y=clamp(jogador.y-camera_get_view_height(camera_inicial)/2,0,max(0,room_height-camera_get_view_height(camera_inicial)));
    camera_set_view_pos(camera_inicial,round(cam_x),round(cam_y));
}

// A entrada nova é no centro da faixa caminhável; saves antigos são limitados acima.
if (room == rm_obra_1 && estado == "chegada") {
    jogador.x = configuracao.chegada_praca.x;
    jogador.y = configuracao.chegada_praca.y;
}
```

## `objects/obj_narrativa/Draw_0.gml`

```gml
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
```

## `objects/obj_narrativa/Step_0.gml`

```gml
if(keyboard_check_pressed(vk_f11)) window_set_fullscreen(!window_get_fullscreen());
if(retomar_praca) {retomar_praca=false;room_goto(rm_obra_1);exit;}
if(keyboard_check_pressed(vk_escape)) {
    global.pausado=!global.pausado;
    if(global.pausado) {
        audio_pause_sound(global.musica);
        if(global.portal_som!=-1 && audio_is_playing(global.portal_som)) audio_pause_sound(global.portal_som);
    } else {
        audio_resume_sound(global.musica);
        if(global.portal_som!=-1 && audio_is_paused(global.portal_som)) audio_resume_sound(global.portal_som);
    }
    salvar_visita(id);
}
if(global.pausado) {
    var opcoes_mudaram=keyboard_check_pressed(ord("M")) || keyboard_check_pressed(vk_left) || keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("T")) || keyboard_check_pressed(ord("F"));
    if(keyboard_check_pressed(ord("M"))) global.volume=global.volume>0 ? 0 : 0.6;
    if(keyboard_check_pressed(vk_left)) global.volume=max(0,global.volume-0.1);
    if(keyboard_check_pressed(vk_right)) global.volume=min(1,global.volume+0.1);
    if(keyboard_check_pressed(ord("T"))) global.texto_rapido=!global.texto_rapido;
    if(keyboard_check_pressed(ord("F"))) global.movimento_reduzido=!global.movimento_reduzido;
    audio_master_gain(global.volume);
    if(opcoes_mudaram) salvar_visita(id);
    exit;
}
var dt=min(delta_time/1000000,0.05);
tempo+=dt;
var avancar=keyboard_check_pressed(vk_space)||keyboard_check_pressed(vk_enter);
letras=global.texto_rapido ? string_length(fala) : min(string_length(fala),letras+40*dt);
// Primeira pressão completa o texto; a seguinte avança o diálogo.
if(avancar && fala!="" && letras<string_length(fala)) {
    letras=string_length(fala);avancar=false;
}
if (!instance_exists(jogador)) exit;
var estado_anterior=estado;
switch(estado) {
case "boas_vindas":
    if(avancar) {estado="passeio";fala="";tempo=0;}
    break;
case "passeio":
    guia_x=min(1080,guia_x+180*dt);
    jogador.x=guia_x-70;jogador.y=guia_y;
    jogador.sprite_index=spr_walk_e;jogador.image_speed=1;
    if(guia_x>=1080) {estado="tecnologia";fala="Nossa nova tecnologia permite entrar nas pinturas e visitar esses lugares.";}
    break;
case "tecnologia":
    if(avancar) {estado="volta_quadro";fala="";}
    break;
case "volta_quadro":
    guia_x=max(390,guia_x-180*dt);
    jogador.x=guia_x-70;jogador.y=540;
    jogador.sprite_index=spr_walk_w;jogador.image_speed=1;
    if(guia_x<=390) {estado="convite";fala="Este quadro retrata a Praça do Marco Zero, no Recife. Toque no quadro para iniciar a viagem.";}
    break;
case "convite":
    if(avancar) {estado="livre";fala="";global.visita_concluida=true;}
    break;
case "livre":
    if(keyboard_check_pressed(ord("E")) && point_distance(jogador.x,jogador.y,307,480)<110) {
        estado="toque";tempo=0;inicio_x=jogador.x;inicio_y=jogador.y;
        jogador.sprite_index=spr_player_n;jogador.image_speed=0;
    }
    break;
case "toque":
    jogador.x=lerp(inicio_x,307,min(1,tempo/0.6));
    jogador.y=lerp(inicio_y,405,min(1,tempo/0.8));
    if(tempo>=1.15) {estado="portal";tempo=0;global.portal_som=audio_play_sound(snd_portal,1,false);}
    break;
case "portal":
    var t=clamp(tempo/2.4,0,1);var suav=t*t*(3-2*t);
    jogador.x=307;jogador.y=lerp(405,295,global.movimento_reduzido ? t : suav);
    jogador.escala_portal=lerp(1,0.08,suav);
    fade=clamp((t-0.75)*4,0,1);
    if(t>=1) room_goto(rm_obra_1);
    break;
case "chegada":
    fade=max(0,fade-dt/1.2);
    if(tempo>=1.4) {estado="historia";pagina=0;fala="Este é o Marco Zero, ponto simbólico do Recife e da sua história.";}
    break;
case "historia":
    if(avancar) {
        pagina++;
        if(pagina==1) fala="A Praça Rio Branco fica no Recife Antigo, junto ao porto que ajudou a formar a cidade. O marco é referência para medir as distâncias rodoviárias de Pernambuco.";
        else if(pagina==2) fala="O piso colorido traz a Rosa dos Ventos, de Cícero Dias, inaugurada em 2000. Ao redor, o casario guarda memórias da vida comercial e cultural do Recife.";
        else {estado="praca_livre";fala="";}
    }
    break;
case "praca_livre":
    if(keyboard_check_pressed(ord("E")) && point_distance(jogador.x,jogador.y,configuracao.historiador_praca.x,configuracao.historiador_praca.y)<configuracao.raio_historiador) {
        estado="historia";pagina=0;fala="Este é o Marco Zero, ponto simbólico do Recife e da sua história.";
    }
    if(keyboard_check_pressed(ord("R"))) {salvar_visita(id);room_goto(rm_galeria);}
    break;
}
if(estado!="livre" && estado!="praca_livre" && estado!="passeio" && estado!="volta_quadro") {
    jogador.image_speed=0;jogador.image_index=0;
    if(estado!="portal" && estado!="toque") jogador.sprite_index=spr_player_n;
}

if(fala!=ultima_fala) {letras=0;ultima_fala=fala;}

autosave_tempo+=dt;
if(autosave_tempo>=5) {salvar_visita(id);autosave_tempo=0;}

if(estado!=estado_anterior) salvar_visita(id);
```

## `objects/obj_npc/Draw_0.gml`

```gml
var n=instance_find(obj_narrativa,0);
if(n==noone) exit;
// Mantém os sprites e as animações existentes dos visitantes.
if (shader_is_compiled(sh_pixel_clean)) shader_set(sh_pixel_clean);
draw_self();
shader_reset();
// No máximo uma conversa próxima visível; evita balões empilhados.
if(conversa!="" && conversa_tempo>4 && point_distance(x,y,n.jogador.x,n.jogador.y)<260 && n.fala=="") {
    var prioridade=true;
    for(var i=0;i<instance_number(obj_npc);i++) {
        var outro=instance_find(obj_npc,i);
        if(outro.id<id && outro.conversa!="" && outro.conversa_tempo>4 && point_distance(outro.x,outro.y,n.jogador.x,n.jogador.y)<260) prioridade=false;
    }
    if(prioridade) {
        draw_set_color(make_color_rgb(26,30,43));draw_rectangle(x-90,y-85,x+90,y-61,false);
        draw_set_color(make_color_rgb(249,224,182));draw_set_halign(fa_center);draw_text(x,y-81,conversa);
        draw_set_halign(fa_left);draw_set_color(c_white);
    }
}
```

## `objects/obj_npc/Step_0.gml`

```gml
if(global.pausado) exit;
var dt=min(delta_time/1000000,0.05);
var configuracao = configuracao_cenario();
var limites = room == rm_galeria ? configuracao.limites_museu : configuracao.limites_praca;
var y_min = room == rm_galeria ? 490 : limites.topo;
conversa_tempo-=dt;
if(conversa_tempo<=0) {
    conversa="";
    // Não conta a própria instância como interlocutor.
    for(var i=0;i<instance_number(obj_npc);i++) {
        var outro=instance_find(obj_npc,i);
        if(outro!=id && point_distance(x,y,outro.x,outro.y)<130) {
            conversa=room==rm_galeria ? choose("Que bela obra!","Olhe essas cores.") : choose("Vamos ver o marco?","A praça está linda.");
            break;
        }
    }
    conversa_tempo=random_range(6,10);
}
if(pausa>0) {pausa-=dt;image_speed=0;image_index=0;depth=-y;exit;}
var dist=point_distance(x,y,alvo_x,alvo_y);
if(dist<4) {
    if(instance_exists(ponto_obra)) {ponto_obra.ocupado_por=noone;ponto_obra=noone;}
    pausa=random_range(2,5);
    alvo_x=clamp(x+random_range(-180,180),limites.esquerda + 8, limites.direita - 8);
    alvo_y=clamp(y+random_range(-100,100),y_min, limites.base - 8);
    // Alterna passeios com visitas a obras; reservas são liberadas na chegada.
    if(room==rm_galeria && random(1)<0.45) {
        for(var j=0;j<instance_number(obj_ponto_obra);j++) {
            var ponto=instance_find(obj_ponto_obra,j);
            if(ponto.ocupado_por==noone) {ponto_obra=ponto;ponto.ocupado_por=id;alvo_x=ponto.x;alvo_y=max(y_min,ponto.y);break;}
        }
    }
    image_speed=0;depth=-y;exit;
}
var dx=(alvo_x-x)/dist;var dy=(alvo_y-y)/dist;
var mx=dx*min(90*dt,dist);var my=dy*min(90*dt,dist);
var antes_x=x;var antes_y=y;
if(!place_meeting(x+mx,y,obj_obstaculo) && !place_meeting(x+mx,y,obj_npc) && !place_meeting(x+mx,y,obj_player) && !place_meeting(x+mx,y,obj_npc_obra)) x+=mx;
if(!place_meeting(x,y+my,obj_obstaculo) && !place_meeting(x,y+my,obj_npc) && !place_meeting(x,y+my,obj_player) && !place_meeting(x,y+my,obj_npc_obra)) y+=my;
if(x==antes_x && y==antes_y) bloqueado_tempo+=dt;else bloqueado_tempo=0;
if(bloqueado_tempo>0.8) {
    if(instance_exists(ponto_obra)) {ponto_obra.ocupado_por=noone;ponto_obra=noone;}
    alvo_x=x;alvo_y=y;bloqueado_tempo=0;
}
x=clamp(x,limites.esquerda + 8, limites.direita - 8);y=clamp(y,y_min, limites.base - 8);
var direcao_x=abs(dx)<0.3 ? 0 : sign(dx);
var direcao_y=abs(dy)<0.3 ? 0 : sign(dy);
if(direcao_x==0 && direcao_y<0) sprite_index=spr_walk_n;
else if(direcao_x>0 && direcao_y<0) sprite_index=spr_walk_ne;
else if(direcao_x>0 && direcao_y==0) sprite_index=spr_walk_e;
else if(direcao_x>0 && direcao_y>0) sprite_index=spr_walk_se;
else if(direcao_x==0 && direcao_y>0) sprite_index=spr_walk_s;
else if(direcao_x<0 && direcao_y>0) sprite_index=spr_walk_sw;
else if(direcao_x<0 && direcao_y==0) sprite_index=spr_walk_w;
else sprite_index=spr_walk_nw;
image_speed=1.6;depth=-y;
```

## `objects/obj_npc_obra/Create_0.gml`

```gml
// Posição configurável dentro do piso provisório.
var configuracao = configuracao_cenario();
x = configuracao.historiador_praca.x;
y = configuracao.historiador_praca.y;
depth = -y;
```

## `objects/obj_npc_obra/Draw_0.gml`

```gml
// Historiador provisório: cópia visual do protagonista, com outra cor.
draw_sprite_ext(sprite_index, 0, round(x), round(y),
    1, 1, 0, make_color_rgb(235,195,124), 1);
```

## `objects/obj_obra_1/Draw_0.gml`

```gml
// A pintura embutida no fundo é coberta somente dentro da moldura.
// O mesmo recurso é usado como cenário em rm_obra_1.
var configuracao = configuracao_cenario();
desenhar_imagem_inteira(configuracao.imagem_destino,
    configuracao.moldura, configuracao.cor_faixas);
```

## `objects/obj_player/Draw_0.gml`

```gml
// Sprites existentes preservados, com a pose escolhida pelo movimento atual.
// O shader já existente remove somente o verde puro dos frames provisórios.
if (shader_is_compiled(sh_pixel_clean)) shader_set(sh_pixel_clean);
// Mantém os degraus de escala até a revisão da cutscene do quadro na etapa 3.
var escala = max(0.125, round(escala_portal * 8) / 8);
draw_sprite_ext(sprite_index, image_index, round(x), round(y),
    image_xscale * escala, image_yscale * escala, 0, image_blend, image_alpha);
shader_reset();
```

## `objects/obj_player/Step_0.gml`

```gml
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
```

## `scripts/configuracao_cenario/configuracao_cenario.gml`

```gml
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
```

