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
    ini_open("museu_marco_zero.ini");
    ini_write_real("opcoes","volume",global.volume);
    ini_write_real("opcoes","texto",global.texto_rapido);
    ini_write_real("opcoes","movimento",global.movimento_reduzido);
    if(_n.estado=="livre" || _n.estado=="praca_livre") {
        ini_write_string("visita","local",room==rm_galeria ? "museu" : "praca");
        ini_write_real("visita","x",_n.jogador.x);ini_write_real("visita","y",_n.jogador.y);
        ini_write_real("visita","guia",global.visita_concluida);
    }
    ini_close();
}
