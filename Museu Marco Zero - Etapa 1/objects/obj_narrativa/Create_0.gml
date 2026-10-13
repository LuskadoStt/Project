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
