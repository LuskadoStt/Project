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
