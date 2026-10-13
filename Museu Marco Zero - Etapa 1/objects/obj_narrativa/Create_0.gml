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
