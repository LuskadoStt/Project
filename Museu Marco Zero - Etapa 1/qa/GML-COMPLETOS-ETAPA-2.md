# Etapa 2 — GML completos

Todos os GML novos e alterados nesta etapa, com caminho relativo à raiz do projeto.

## `objects/obj_guia/Create_0.gml`

```gml
ultima_direcao = 0;
image_speed = 0;
image_blend = make_color_rgb(139,198,206);
depth = -y;
```

## `objects/obj_guia/Draw_0.gml`

```gml
// Placeholder: mantém sprites existentes e a animação direcional do executor.
var narrativa = instance_find(obj_narrativa, 0);
if (narrativa == noone) exit;
var quadro = image_speed > 0 ? floor(narrativa.tempo * 8) mod sprite_get_number(sprite_index) : image_index;
if (shader_is_compiled(sh_pixel_clean)) shader_set(sh_pixel_clean);
draw_sprite_ext(sprite_index, quadro, round(x), round(y), 1, 1, 0, image_blend, 1);
shader_reset();
```

## `objects/obj_guia/Step_2.gml`

```gml
// O executor move a instância real; este evento apenas mantém a ordenação.
if (global.pausado) exit;
depth = -y;
```

## `objects/obj_narrativa/Create_0.gml`

```gml
configuracao = configuracao_cenario();
depth = 50;
gpu_set_texfilter(false);
display_set_gui_size(800,500);
jogador = instance_find(obj_player,0);
guia = noone;
tempo = 0; pagina = 0; fala = ""; nome = "Guia do museu";
letras = 0; ultima_fala = ""; fade = 0;
erro_cutscene = "";
fundo_surface = -1; autosave_tempo = 0; retomar_praca = false;
cam_x = 0; cam_y = 0;
executor_cutscene = cutscene_criar([], "livre");

// O modo de teste só existe com argumento explícito no executável.
if (!variable_global_exists("modo_teste")) {
    global.modo_teste = false;
    for (var argumento = 1; argumento <= parameter_count(); argumento++) {
        if (parameter_string(argumento) == "--qa-cutscene") global.modo_teste = true;
    }
}
if (!variable_global_exists("sessao_iniciada")) {
    global.sessao_iniciada = true;
    global.pausado = false;
    global.volume = global.modo_teste ? 0 : 0.6;
    global.texto_rapido = global.modo_teste;
    global.movimento_reduzido = false;
    global.visita_concluida = false;
    global.local_salvo = "";
    global.salvo_x = 320; global.salvo_y = 540;
    global.carregar_posicao = false;
    // O teste ignora saves do usuário e não escreve progresso/configurações.
    if (!global.modo_teste) {
        ini_open("museu_marco_zero.ini");
        global.volume = clamp(ini_read_real("opcoes","volume",0.6),0,1);
        global.texto_rapido = ini_read_real("opcoes","texto",0);
        global.movimento_reduzido = ini_read_real("opcoes","movimento",0);
        var versao_salva = ini_read_real("visita","versao_passeio",1);
        global.visita_concluida = ini_read_real("visita","guia",0)
            && versao_salva >= configuracao.versao_passeio;
        global.local_salvo = ini_read_string("visita","local","");
        global.salvo_x = ini_read_real("visita","x",320);
        global.salvo_y = ini_read_real("visita","y",540);
        global.carregar_posicao = global.local_salvo != "";
        ini_close();
    }
    global.musica = audio_play_sound(snd_ambiente,0,true);
    global.portal_som = -1;
    if (global.modo_teste) global.teste = qa_cutscene_criar();
}

estado = room == rm_galeria ? "livre" : "chegada";
if (room == rm_obra_1) {nome = "Historiador local"; fade = 1;}
retomar_praca = global.carregar_posicao && global.local_salvo == "praca" && room == rm_galeria;
if (global.carregar_posicao && ((room == rm_obra_1 && global.local_salvo == "praca")
    || (room == rm_galeria && global.local_salvo == "museu"))) {
    var limites = room == rm_galeria ? configuracao.limites_museu : configuracao.limites_praca;
    jogador.x = clamp(global.salvo_x,limites.esquerda,limites.direita);
    jogador.y = clamp(global.salvo_y,limites.topo,limites.base);
    if (room == rm_obra_1) {estado = "praca_livre"; fade = 0;}
    global.carregar_posicao = false;
} else if (room == rm_obra_1) {
    jogador.x = configuracao.chegada_praca.x;
    jogador.y = configuracao.chegada_praca.y;
}
if (room == rm_galeria) {
    if (!instance_exists(obj_guia)) guia = instance_create_depth(100,540,-540,obj_guia);
    else guia = instance_find(obj_guia,0);
    if (!global.visita_concluida && !retomar_praca) {
        estado = "cutscene";
        executor_cutscene = cutscene_criar(roteiro_passeio(configuracao), "livre");
    }
}
audio_master_gain(global.volume);
var camera_inicial = view_camera[0];
if (camera_inicial != -1) {
    cam_x = clamp(jogador.x-camera_get_view_width(camera_inicial)/2,0,max(0,room_width-camera_get_view_width(camera_inicial)));
    cam_y = clamp(jogador.y-camera_get_view_height(camera_inicial)/2,0,max(0,room_height-camera_get_view_height(camera_inicial)));
    camera_set_view_pos(camera_inicial,round(cam_x),round(cam_y));
}
```

## `objects/obj_narrativa/Draw_64.gml`

```gml
draw_set_halign(fa_left);draw_set_valign(fa_top);
if(estado=="livre" || estado=="praca_livre") {
    draw_set_alpha(0.9);draw_set_color(make_color_rgb(20,24,37));draw_rectangle(16,442,784,482,false);draw_set_alpha(1);
}
if(estado!="livre" && estado!="praca_livre") {
    draw_set_color(c_black);draw_rectangle(0,0,800,28,false);draw_rectangle(0,472,800,500,false);
}
if(fala!="") {
    draw_set_alpha(0.94);draw_set_color(make_color_rgb(20,28,39));draw_rectangle(24,344,776,474,false);draw_set_alpha(1);
    draw_set_color(make_color_rgb(231,195,127));draw_text(44,356,nome);
    draw_set_color(c_white);draw_text_ext(44,383,string_copy(fala,1,floor(letras)),19,708);
    draw_set_color(make_color_rgb(171,202,199));draw_text(585,450,"ESPAÇO / ENTER  ›");
} else if(estado=="livre") {
    draw_set_color(c_black);draw_rectangle(16,24,700,54,false);draw_set_color(c_white);draw_text(24,30,"MUSEU • Setas / WASD: mover");
    if(point_distance(jogador.x,jogador.y,307,480)<110) draw_text(24,450,"E • Tocar o quadro e iniciar a viagem");
} else if(estado=="praca_livre") {
    draw_set_color(c_black);draw_rectangle(16,24,700,54,false);draw_set_color(c_white);draw_text(24,30,"MARCO ZERO • Recife, Pernambuco");
    draw_text(24,450,"E perto do historiador: conversar    R: voltar ao museu");
}
if(fade>0) {draw_set_alpha(fade);draw_set_color(global.movimento_reduzido ? c_black : c_white);draw_rectangle(0,0,800,500,false);draw_set_alpha(1);}
draw_set_color(c_white);

if(global.pausado) {
    draw_set_alpha(0.92);draw_set_color(make_color_rgb(20,24,37));draw_rectangle(90,70,710,430,false);draw_set_alpha(1);
    draw_set_color(make_color_rgb(237,208,149));draw_text(124,98,"PAUSA • Museu / Marco Zero");
    draw_set_color(c_white);
    draw_text(124,148,"ESC • Continuar    F11 • Tela cheia");
    draw_text(124,183,"← / → • Volume: "+string(round(global.volume*100))+"%    M • Silenciar");
    draw_text(124,218,"T • Texto imediato: "+(global.texto_rapido ? "sim" : "não"));
    draw_text(124,253,"F • Movimento e clarão reduzidos: "+(global.movimento_reduzido ? "sim" : "não"));
    draw_text_ext(124,302,"O progresso é salvo ao explorar. Ao abrir o jogo novamente, você retoma o último ponto salvo.",22,542);
}
draw_set_color(c_white);

// Capturas reais do jogo para o workflow, apenas no modo de teste explícito.
if (global.modo_teste && global.teste.foto != "" && surface_exists(application_surface)) {
    surface_save(application_surface, global.teste.foto);
    global.teste.foto = "";
}
```

## `objects/obj_narrativa/Step_0.gml`

```gml
if (global.modo_teste) qa_cutscene_atualizar(id);
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
if (global.modo_teste) avancar = global.teste.permitir_avanco;
if (!instance_exists(jogador)) exit;
var estado_anterior=estado;
switch(estado) {
case "cutscene":
    cutscene_atualizar(executor_cutscene, id, dt, avancar);
    if (!executor_cutscene.ativo) {
        estado = executor_cutscene.estado_final;
        fala = "";
        if (erro_cutscene == "") global.visita_concluida = true;
        cutscene_pose(jogador, 4, false);
    }
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
if(estado!="livre" && estado!="praca_livre" && estado!="cutscene") {
    jogador.image_speed=0;jogador.image_index=0;
    if(estado!="portal" && estado!="toque") jogador.sprite_index=spr_player_n;
}

if(fala!=ultima_fala) {letras=0;ultima_fala=fala;}

autosave_tempo+=dt;
if(autosave_tempo>=5) {salvar_visita(id);autosave_tempo=0;}

if(estado!=estado_anterior) salvar_visita(id);
```

## `objects/obj_player/Draw_0.gml`

```gml
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
```

## `scripts/arte_pixel/arte_pixel.gml`

```gml
function px_bloco(_x,_y,_s,_a,_b,_c,_d,_cor) {
    draw_set_color(_cor);
    draw_rectangle(round(_x+_a*_s),round(_y+_b*_s),round(_x+_c*_s)-1,round(_y+_d*_s)-1,false);
}
// Pés em (x,y); grade de 2 pixels, proporção igual em idle e caminhada.
// Tipos: 0 protagonista, 1 guia, 2 historiador, 3 visitante.
function pessoa_pixel(_x,_y,_tipo,_direcao,_andando,_tempo,_escala,_roupa,_tocar) {
    var s=2*_escala; var x0=round(_x);var y0=round(_y);
    var pele=make_color_rgb(210,153,116);var sombra=make_color_rgb(35,34,48);
    var cabelo=_tipo==2 ? make_color_rgb(176,172,158) : make_color_rgb(60,42,43);
    var roupa=_tipo==1 ? make_color_rgb(74,133,139) : (_tipo==2 ? make_color_rgb(170,128,82) : _roupa);
    var passo=_andando ? (floor(_tempo*8) mod 2)*2-1 : 0;
    var salto=_andando ? (floor(_tempo*8) mod 2) : 0;
    px_bloco(x0,y0,s,-7,-2,7,0,make_color_rgb(41,39,49));
    y0-=salto*s;
    px_bloco(x0,y0,s,-5,-5+passo,-1,-1+passo,sombra);
    px_bloco(x0,y0,s,1,-5-passo,5,-1-passo,sombra);
    px_bloco(x0,y0,s,-5,-14,5,-5,roupa);
    px_bloco(x0,y0,s,-6,-13,-4,-7,pele);
    px_bloco(x0,y0,s,4,-13,6,-7,pele);
    px_bloco(x0,y0,s,-6,-23,6,-14,cabelo);
    px_bloco(x0,y0,s,-5,-20,5,-14,pele);
    px_bloco(x0,y0,s,-6,-23,6,-20,cabelo);
    px_bloco(x0,y0,s,-6,-21,-4,-16,cabelo);
    if(_direcao==4 || _direcao==3 || _direcao==5) {
        px_bloco(x0,y0,s,-5,-20,5,-15,cabelo);
    } else {
        var olhar=_direcao==2 ? 2 : (_direcao==6 ? -2 : 0);
        px_bloco(x0,y0,s,-3+olhar,-18,-2+olhar,-16,sombra);
        px_bloco(x0,y0,s,2+olhar,-18,3+olhar,-16,sombra);
        px_bloco(x0,y0,s,-1,-15,2,-14,make_color_rgb(144,80,75));
    }
    if(_tipo==1) {
        px_bloco(x0,y0,s,-4,-12,-1,-10,make_color_rgb(240,214,151)); // Crachá.
        px_bloco(x0,y0,s,0,-14,2,-8,make_color_rgb(232,215,181));
    }
    if(_tipo==2) {
        px_bloco(x0,y0,s,-7,-23,7,-21,make_color_rgb(222,202,158)); // Chapéu.
        px_bloco(x0,y0,s,-4,-26,4,-23,make_color_rgb(195,173,128));
        px_bloco(x0,y0,s,3,-10,7,-5,make_color_rgb(87,62,51)); // Bolsa.
    }
    if(_tocar) {px_bloco(x0,y0,s,4,-21,6,-11,roupa);px_bloco(x0,y0,s,4,-24,7,-21,pele);}
    draw_set_color(c_white);
}
function museu_pixel() {
    var parede=make_color_rgb(48,41,61);var ouro=make_color_rgb(190,151,96);
    mz_rect(0,0,1,0,0,2048,682,parede);
    // Painéis, rodapé, tábuas e pontos de luz numa paleta comum à praça.
    for(var i=0;i<16;i++) {
        var bx=i*128;
        mz_rect(0,0,1,bx,40,bx+2,426,make_color_rgb(77,61,76));
        mz_rect(0,0,1,bx+16,58,bx+110,60,make_color_rgb(91,71,82));
    }
    mz_rect(0,0,1,0,426,2048,682,make_color_rgb(101,75,70));
    for(var row=0;row<8;row++) {
        var yy=430+row*32;
        mz_rect(0,0,1,0,yy,2048,yy+2,make_color_rgb(75,57,60));
        for(var col=0;col<17;col++) {
            var xx=col*128+(row mod 2)*64;
            mz_rect(0,0,1,xx,yy,xx+2,yy+32,make_color_rgb(75,57,60));
            mz_rect(0,0,1,xx+12,yy+8,xx+70,yy+10,make_color_rgb(118,85,74));
        }
    }
    mz_rect(0,0,1,0,418,2048,428,ouro);
    var centros=[307,1080,1830];
    for(var q=0;q<3;q++) {
        var cx=centros[q];
        mz_rect(0,0,1,cx-148,182,cx+148,372,make_color_rgb(77,48,45));
        mz_rect(0,0,1,cx-144,186,cx+144,368,ouro);
        mz_rect(0,0,1,cx-136,194,cx+136,362,make_color_rgb(227,196,132));
        if(q==0) marco_zero(179,199,258/800);
        else {
            mz_rect(0,0,1,cx-128,200,cx+128,338,make_color_rgb(111,164,173));
            mz_rect(0,0,1,cx-128,280,cx+128,338,make_color_rgb(58,98,118));
            for(var k=0;k<9;k++) mz_rect(0,0,1,cx-120+k*28,300+(k mod 3)*8,cx-106+k*28,302+(k mod 3)*8,make_color_rgb(178,193,161));
            if(q==1) {
                mz_rect(0,0,1,cx-50,229,cx+50,290,make_color_rgb(223,184,119));
                mz_rect(0,0,1,cx-64,222,cx+64,230,make_color_rgb(155,88,74));
                for(var w=0;w<4;w++) mz_rect(0,0,1,cx-39+w*23,242,cx-26+w*23,280,make_color_rgb(61,66,78));
            } else {
                mz_rect(0,0,1,cx-4,226,cx+4,302,make_color_rgb(196,163,104));
                mz_rect(0,0,1,cx-18,220,cx+18,226,make_color_rgb(233,199,136));
            }
        }
        mz_rect(0,0,1,cx-28,374,cx+28,384,ouro);
        mz_rect(0,0,1,cx-5,106,cx+5,118,ouro);
        for(var glow=0;glow<5;glow++) {
            draw_set_alpha(0.035);
            mz_rect(0,0,1,cx-30-glow*12,120,cx+30+glow*12,174+glow*24,make_color_rgb(249,192,111));
        }
        draw_set_alpha(1);
    }
    // Vasos e bancos ficam acima da faixa livre de circulação.
    for(var pot=0;pot<4;pot++) {
        var px=70+pot*600;
        mz_rect(0,0,1,px-12,391,px+12,420,make_color_rgb(160,108,82));
        mz_rect(0,0,1,px-26,350,px+26,391,make_color_rgb(67,109,92));
        mz_rect(0,0,1,px-14,334,px+14,382,make_color_rgb(95,139,105));
    }
    draw_set_color(c_white);
}
function salvar_visita(_n) {
    if (global.modo_teste) return;
    ini_open("museu_marco_zero.ini");
    ini_write_real("opcoes","volume",global.volume);
    ini_write_real("opcoes","texto",global.texto_rapido);
    ini_write_real("opcoes","movimento",global.movimento_reduzido);
    if(_n.estado=="livre" || _n.estado=="praca_livre") {
        ini_write_string("visita","local",room==rm_galeria ? "museu" : "praca");
        ini_write_real("visita","x",_n.jogador.x);ini_write_real("visita","y",_n.jogador.y);
        ini_write_real("visita","guia",global.visita_concluida);
        ini_write_real("visita","versao_passeio",_n.configuracao.versao_passeio);
    }
    ini_close();
}
```

## `scripts/configuracao_cenario/configuracao_cenario.gml`

```gml
/// Configuração provisória: utiliza somente imagens existentes no projeto.
function configuracao_cenario() {
    return {
        imagem_destino: spr_cenario_obra_1,
        imagem_museu: spr_cenario,
        moldura: {x: 179, y: 199, largura: 258, altura: 140},
        imagem_praca: {x: 0, y: 0, largura: 800, altura: 500},
        // A partir de 94% da altura, a imagem provisória contém apenas calçamento.
        // Altere esta fração quando substituir a arte; nenhum PNG é modificado.
        inicio_piso_imagem: 0.94,
        // Reserva 28% da tela para circulação. O piso usa a textura do próprio sprite.
        inicio_piso_tela: 0.72,
        limites_museu: {esquerda: 32, topo: 470, direita: 2016, base: 670},
        limites_praca: {esquerda: 32, topo: 380, direita: 768, base: 486},
        chegada_praca: {x: 400, y: 430},
        historiador_praca: {x: 520, y: 430},
        raio_historiador: 100,
        versao_passeio: 2,
        velocidade_passeio: 140,
        distancia_guia: 70,
        pontos_passeio: [
            {x: 307, y: 520, titulo: "Praça do Marco Zero", texto: "Esta pintura nos leva à Praça do Marco Zero, no Recife. Observe a paisagem e a relação da cidade com a água."},
            {x: 1080, y: 520, titulo: "Arquitetura e memória", texto: "Nesta obra, a arquitetura guarda memórias do lugar. Cada detalhe pode contar uma parte da sua história."},
            {x: 1830, y: 520, titulo: "Luz e reflexos", texto: "A luz e os reflexos mudam a maneira como vemos uma paisagem. Uma pintura também é um convite a observar."}
        ]
    };
}

/// Quadro e praça utilizam a mesma composição, incluindo o calçamento existente.
/// Sem faixas laterais: a paisagem preenche a largura disponível.
/// A faixa de piso é repetida verticalmente sem esticar a textura do calçamento.
function desenhar_cenario_compartilhado(_configuracao, _retangulo) {
    gpu_set_texfilter(false);
    var imagem = _configuracao.imagem_destino;
    var largura_imagem = sprite_get_width(imagem);
    var altura_imagem = sprite_get_height(imagem);
    var origem_piso = clamp(floor(altura_imagem * _configuracao.inicio_piso_imagem), 1, altura_imagem - 1);
    var altura_piso_imagem = altura_imagem - origem_piso;
    var altura_paisagem = _retangulo.altura * _configuracao.inicio_piso_tela;
    var escala_x = _retangulo.largura / largura_imagem;
    // A paisagem recebe ajuste vertical para caber acima da faixa explorável.
    // Isso preserva todos os elementos, porém altera levemente suas proporções.
    draw_sprite_part_ext(imagem, 0, 0, 0, largura_imagem, origem_piso,
        _retangulo.x, _retangulo.y, escala_x, altura_paisagem / origem_piso, c_white, 1);

    // Mesma escala da textura nas duas telas, relativa à composição lógica 800x500.
    var escala_piso_y = (800 / largura_imagem) * (_retangulo.altura / 500);
    var pos_y = _retangulo.y + altura_paisagem;
    var fim_y = _retangulo.y + _retangulo.altura;
    var altura_ladrilho = altura_piso_imagem * escala_piso_y;
    while (pos_y < fim_y) {
        // O último pedaço é limitado à área restante, sem pintar fora da moldura.
        var altura_destino = min(altura_ladrilho, fim_y - pos_y);
        var altura_origem = altura_destino / escala_piso_y;
        draw_sprite_part_ext(imagem, 0, 0, origem_piso, largura_imagem, altura_origem,
            _retangulo.x, pos_y, escala_x, escala_piso_y, c_white, 1);
        pos_y += altura_destino;
    }
    draw_set_alpha(1);
    draw_set_color(c_white);
}
```

## `scripts/qa_cutscene/qa_cutscene.gml`

```gml
/// Teste de execução opt-in: sem interface de teste no jogo normal.
function qa_cutscene_criar() {
    return {fase: "passeio", tempo_total: 0, permitir_avanco: true,
        marcos: [], falhas: [], bloqueio_frames: 0, bloqueio_feito: false,
        pausa_frames: 0, pausa_feita: false, jogador_x: 0, jogador_y: 0,
        guia_x: 0, guia_y: 0, camera_x: 0, camera_y: 0,
        foto: "", finalizar_frames: -1, concluido: false};
}

function qa_cutscene_verificar(_condicao, _mensagem) {
    if (!_condicao) array_push(global.teste.falhas, _mensagem);
}

function qa_cutscene_finalizar() {
    var teste = global.teste;
    if (teste.concluido) return;
    teste.concluido = true;
    keyboard_key_release(vk_right);
    keyboard_key_release(ord("E"));
    keyboard_key_release(ord("R"));
    var resultado = {
        aprovado: array_length(teste.falhas) == 0,
        falhas: teste.falhas, marcos: teste.marcos,
        pausa_verificada: teste.pausa_feita,
        controle_bloqueado_verificado: teste.bloqueio_feito,
        segundos: teste.tempo_total,
        testes: ["passeio com três obras", "bloqueio de movimento em diálogo",
            "pausa de atores e câmera", "liberação de controle", "viagem à praça",
            "história e historiador", "retorno sem repetir passeio", "ausência de visitantes", "guia único"]
    };
    var arquivo = file_text_open_write("qa_resultado_etapa2.json");
    file_text_write_string(arquivo, json_stringify(resultado));
    file_text_close(arquivo);
    game_end();
}

/// Executado antes do bloqueio de pausa do controlador para poder retomar o teste.
function qa_cutscene_atualizar(_narrativa) {
    var teste = global.teste;
    teste.tempo_total += min(delta_time / 1000000, 0.05);
    if (teste.tempo_total > 100) {
        array_push(teste.falhas, "Timeout do fluxo de teste");
        qa_cutscene_finalizar(); return;
    }
    if (teste.finalizar_frames >= 0) {
        teste.finalizar_frames--;
        if (teste.finalizar_frames <= 0) qa_cutscene_finalizar();
        return;
    }
    if (teste.pausa_frames > 0) {
        qa_cutscene_verificar(abs(_narrativa.jogador.x-teste.jogador_x) < 0.001
            && abs(_narrativa.jogador.y-teste.jogador_y) < 0.001, "Jogador moveu durante pausa");
        qa_cutscene_verificar(abs(_narrativa.guia.x-teste.guia_x) < 0.001
            && abs(_narrativa.guia.y-teste.guia_y) < 0.001, "Guia moveu durante pausa");
        qa_cutscene_verificar(abs(_narrativa.cam_x-teste.camera_x) < 0.001
            && abs(_narrativa.cam_y-teste.camera_y) < 0.001, "Câmera moveu durante pausa");
        teste.pausa_frames--;
        if (teste.pausa_frames == 0) {global.pausado = false; teste.pausa_feita = true;}
        return;
    }
    switch (teste.fase) {
        case "passeio":
            if (!teste.bloqueio_feito && _narrativa.fala != "") {
                if (teste.bloqueio_frames == 0) {
                    teste.jogador_x = _narrativa.jogador.x;
                    teste.jogador_y = _narrativa.jogador.y;
                    teste.permitir_avanco = false;
                    keyboard_key_press(vk_right);
                } else {
                    qa_cutscene_verificar(abs(_narrativa.jogador.x-teste.jogador_x) < 0.001
                        && abs(_narrativa.jogador.y-teste.jogador_y) < 0.001, "Input moveu o jogador durante diálogo da cutscene");
                }
                teste.bloqueio_frames++;
                if (teste.bloqueio_frames >= 12) {
                    keyboard_key_release(vk_right);
                    teste.permitir_avanco = true;
                    teste.bloqueio_feito = true;
                }
            }
            var executor = _narrativa.executor_cutscene;
            if (teste.bloqueio_feito && !teste.pausa_feita && executor.ativo
                && executor.iniciado && executor.acoes[executor.indice].tipo == "grupo") {
                teste.jogador_x = _narrativa.jogador.x; teste.jogador_y = _narrativa.jogador.y;
                teste.guia_x = _narrativa.guia.x; teste.guia_y = _narrativa.guia.y;
                teste.camera_x = _narrativa.cam_x; teste.camera_y = _narrativa.cam_y;
                teste.pausa_frames = 8; global.pausado = true;
            }
            if (_narrativa.estado == "livre") {
                var esperados = ["boas_vindas", "obra_1", "obra_2", "obra_3", "tecnologia", "convite"];
                qa_cutscene_verificar(array_length(teste.marcos) == array_length(esperados), "Número de falas do passeio incorreto");
                if (array_length(teste.marcos) == array_length(esperados)) {
                    for (var indice = 0; indice < array_length(esperados); indice++)
                        qa_cutscene_verificar(teste.marcos[indice] == esperados[indice], "Ordem das obras/falas incorreta");
                }
                qa_cutscene_verificar(_narrativa.erro_cutscene == "", "Executor reportou erro");
                qa_cutscene_verificar(teste.bloqueio_feito && teste.pausa_feita, "Bloqueio/pausa não foram exercitados");
                qa_cutscene_verificar(instance_number(obj_npc) == 0, "Visitantes ainda ativos no museu");
                qa_cutscene_verificar(instance_number(obj_guia) == 1, "Museu deve ter um guia");
                qa_cutscene_verificar(global.visita_concluida && !executor.ativo, "Passeio não liberou controle");
                teste.foto = "qa_museu_etapa2.png";
                teste.fase = "iniciar_viagem";
            }
            break;
        case "iniciar_viagem":
            keyboard_key_press(ord("E"));
            teste.fase = "viagem";
            break;
        case "viagem":
            keyboard_key_release(ord("E"));
            if (room == rm_obra_1) teste.fase = "praca";
            break;
        case "praca":
            if (_narrativa.estado == "praca_livre") {
                qa_cutscene_verificar(instance_number(obj_npc) == 0, "Visitantes ainda ativos na praça");
                qa_cutscene_verificar(instance_number(obj_npc_obra) == 1, "Historiador deve permanecer no destino");
                qa_cutscene_verificar(instance_number(obj_guia) == 0, "Guia duplicado no destino");
                teste.foto = "qa_praca_etapa2.png";
                teste.fase = "iniciar_retorno";
            }
            break;
        case "iniciar_retorno":
            keyboard_key_press(ord("R")); teste.fase = "retorno";
            break;
        case "retorno":
            keyboard_key_release(ord("R"));
            if (room == rm_galeria) {
                qa_cutscene_verificar(_narrativa.estado == "livre" && !_narrativa.executor_cutscene.ativo, "Passeio repetiu ao retornar");
                qa_cutscene_verificar(instance_number(obj_guia) == 1, "Guia duplicado ao retornar");
                qa_cutscene_verificar(instance_number(obj_npc) == 0, "Visitantes reapareceram");
                teste.finalizar_frames = 3;
            }
            break;
    }
}
```

## `scripts/roteiros_cutscene/roteiros_cutscene.gml`

```gml
/// Roteiro por dados: edite falas e destinos sem alterar o executor.
function roteiro_passeio(_configuracao) {
    var acoes = [
        {tipo: "falar", nome: "Guia do museu", texto: "Bem-vindo! Venha comigo conhecer três obras e uma nova forma de viajar pela arte.", marcador: "boas_vindas"}
    ];
    for (var indice = 0; indice < array_length(_configuracao.pontos_passeio); indice++) {
        var ponto = _configuracao.pontos_passeio[indice];
        array_push(acoes, {tipo: "grupo", acoes: [
            {tipo: "mover", ator: "guia", x: ponto.x + _configuracao.distancia_guia, y: ponto.y, velocidade: _configuracao.velocidade_passeio},
            {tipo: "mover", ator: "jogador", x: ponto.x, y: ponto.y, velocidade: _configuracao.velocidade_passeio}
        ]});
        array_push(acoes, {tipo: "pose", ator: "guia", direcao: 4});
        array_push(acoes, {tipo: "pose", ator: "jogador", direcao: 4});
        array_push(acoes, {tipo: "esperar", segundos: 0.3});
        array_push(acoes, {tipo: "falar", nome: "Guia • " + ponto.titulo, texto: ponto.texto, marcador: "obra_" + string(indice + 1)});
    }
    array_push(acoes, {tipo: "pose", ator: "guia", direcao: 6});
    array_push(acoes, {tipo: "falar", nome: "Guia do museu", texto: "Nossa nova tecnologia permite entrar nas pinturas e visitar esses lugares.", marcador: "tecnologia"});
    var destino = _configuracao.pontos_passeio[0];
    array_push(acoes, {tipo: "grupo", acoes: [
        {tipo: "mover", ator: "guia", x: destino.x + _configuracao.distancia_guia, y: destino.y, velocidade: _configuracao.velocidade_passeio},
        {tipo: "mover", ator: "jogador", x: destino.x, y: destino.y, velocidade: _configuracao.velocidade_passeio}
    ]});
    array_push(acoes, {tipo: "pose", ator: "guia", direcao: 6});
    array_push(acoes, {tipo: "pose", ator: "jogador", direcao: 4});
    array_push(acoes, {tipo: "falar", nome: "Guia do museu", texto: "Toque no quadro para iniciar a viagem.", marcador: "convite"});
    return acoes;
}
```

## `scripts/sistema_cutscene/sistema_cutscene.gml`

```gml
/// Executor reutilizável. Cada ação só termina quando seu objetivo é cumprido.
function cutscene_criar(_acoes, _estado_final) {
    return {acoes: _acoes, indice: 0, ativo: array_length(_acoes) > 0,
        iniciado: false, tempo_acao: 0, filhos: [], fade_inicial: 0,
        estado_final: _estado_final};
}

function cutscene_ator(_narrativa, _nome) {
    switch (_nome) {
        case "jogador": return _narrativa.jogador;
        case "guia": return _narrativa.guia;
        case "historiador": return instance_find(obj_npc_obra, 0);
    }
    return noone;
}

/// Mesmas oito direções e sprites existentes do protagonista.
function cutscene_pose(_ator, _direcao, _andando) {
    var parados = [spr_player, spr_player_se, spr_player_e, spr_player_ne,
        spr_player_n, spr_player_nw, spr_player_w, spr_player_sw];
    var andando = [spr_walk_s, spr_walk_se, spr_walk_e, spr_walk_ne,
        spr_walk_n, spr_walk_nw, spr_walk_w, spr_walk_sw];
    _ator.ultima_direcao = _direcao;
    _ator.sprite_index = _andando ? andando[_direcao] : parados[_direcao];
    _ator.image_speed = _andando ? 1.6 : 0;
    if (!_andando) _ator.image_index = 0;
    _ator.depth = -_ator.y;
}

function cutscene_falhar(_executor, _narrativa, _mensagem) {
    _executor.ativo = false;
    _narrativa.erro_cutscene = _mensagem;
    _narrativa.fala = "";
    _narrativa.estado = _executor.estado_final;
    show_debug_message("Cutscene interrompida: " + _mensagem);
}

/// Ações: mover, falar, esperar, pose, sprite, grupo, fade e ir_room.
/// Grupos executam ações em paralelo (o passeio usa apenas movimentos em grupo).
function cutscene_atualizar(_executor, _narrativa, _dt, _avancar) {
    if (!_executor.ativo || global.pausado) return;
    if (_executor.indice >= array_length(_executor.acoes)) {
        _executor.ativo = false;
        return;
    }
    var acao = _executor.acoes[_executor.indice];
    if (!_executor.iniciado) {
        _executor.iniciado = true;
        _executor.tempo_acao = 0;
        if (acao.tipo == "falar") {
            _narrativa.nome = acao.nome;
            _narrativa.fala = acao.texto;
            _narrativa.letras = 0;
            _narrativa.ultima_fala = acao.texto;
            if (global.modo_teste && variable_struct_exists(acao, "marcador"))
                array_push(global.teste.marcos, acao.marcador);
        }
        if (acao.tipo == "fade") _executor.fade_inicial = _narrativa.fade;
        if (acao.tipo == "grupo") {
            _executor.filhos = [];
            for (var filho = 0; filho < array_length(acao.acoes); filho++)
                array_push(_executor.filhos, cutscene_criar([acao.acoes[filho]], _executor.estado_final));
        }
    }
    _executor.tempo_acao += _dt;
    var terminou = false;
    switch (acao.tipo) {
        case "mover":
            var ator = cutscene_ator(_narrativa, acao.ator);
            if (!instance_exists(ator)) {
                cutscene_falhar(_executor, _narrativa, "Ator ausente: " + acao.ator);
                return;
            }
            var distancia = point_distance(ator.x, ator.y, acao.x, acao.y);
            var passo = acao.velocidade * _dt;
            if (distancia <= passo) {
                ator.x = acao.x; ator.y = acao.y;
                cutscene_pose(ator, ator.ultima_direcao, false);
                terminou = true;
            } else {
                var angulo = point_direction(ator.x, ator.y, acao.x, acao.y);
                var direcao = (2 + round(angulo / 45)) mod 8;
                ator.x += lengthdir_x(passo, angulo);
                ator.y += lengthdir_y(passo, angulo);
                cutscene_pose(ator, direcao, true);
            }
            break;
        case "falar":
            // Uma pressão completa a revelação; outra avança, como no diálogo existente.
            if (_avancar && _executor.tempo_acao > _dt
                && _narrativa.letras >= string_length(acao.texto)) {
                _narrativa.fala = "";
                terminou = true;
            }
            break;
        case "esperar":
            terminou = _executor.tempo_acao >= acao.segundos;
            break;
        case "pose":
            var ator_pose = cutscene_ator(_narrativa, acao.ator);
            if (!instance_exists(ator_pose)) {
                cutscene_falhar(_executor, _narrativa, "Ator ausente na pose"); return;
            }
            cutscene_pose(ator_pose, acao.direcao, false);
            terminou = true;
            break;
        case "sprite":
            var ator_sprite = cutscene_ator(_narrativa, acao.ator);
            if (!instance_exists(ator_sprite)) {
                cutscene_falhar(_executor, _narrativa, "Ator ausente na troca de sprite"); return;
            }
            ator_sprite.sprite_index = acao.sprite;
            ator_sprite.image_index = acao.quadro;
            ator_sprite.image_speed = 0;
            terminou = true;
            break;
        case "grupo":
            terminou = true;
            for (var indice_filho = 0; indice_filho < array_length(_executor.filhos); indice_filho++) {
                var executor_filho = _executor.filhos[indice_filho];
                cutscene_atualizar(executor_filho, _narrativa, _dt, false);
                if (executor_filho.ativo) terminou = false;
            }
            break;
        case "fade":
            var fator = acao.segundos <= 0 ? 1 : clamp(_executor.tempo_acao / acao.segundos, 0, 1);
            _narrativa.fade = lerp(_executor.fade_inicial, acao.valor, fator);
            terminou = fator >= 1;
            break;
        case "ir_room":
            _executor.ativo = false;
            room_goto(acao.sala);
            return;
        default:
            cutscene_falhar(_executor, _narrativa, "Ação desconhecida: " + acao.tipo);
            return;
    }
    if (terminou) {
        _executor.indice++;
        _executor.iniciado = false;
        if (_executor.indice >= array_length(_executor.acoes)) _executor.ativo = false;
    }
}
```

