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
