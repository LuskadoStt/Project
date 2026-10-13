// A pintura e a praça usam exatamente o mesmo desenho e enquadramento.
function mz_rect(_x, _y, _s, _a, _b, _c, _d, _cor) {
    draw_set_color(_cor);
    draw_rectangle(floor(_x+_a*_s), floor(_y+_b*_s), floor(_x+_c*_s), floor(_y+_d*_s), false);
}
function marco_zero(_x, _y, _s) {
    mz_rect(_x,_y,_s,0,0,800,450,make_color_rgb(125,180,183));
    mz_rect(_x,_y,_s,0,150,800,500,make_color_rgb(193,173,141));
    // Casario histórico: fachadas, cornijas, portas e janelas.
    var cores=[make_color_rgb(213,164,105),make_color_rgb(190,112,94),make_color_rgb(147,179,166),make_color_rgb(228,203,154),make_color_rgb(164,151,175)];
    for (var i=0;i<8;i++) {
        var bx=i*100; var topo=45+(i mod 3)*12;
        mz_rect(_x,_y,_s,bx+2,topo,bx+98,190,cores[i mod 5]);
        mz_rect(_x,_y,_s,bx,topo-6,bx+100,topo,make_color_rgb(239,214,176));
        mz_rect(_x,_y,_s,bx+3,topo+42,bx+97,topo+47,make_color_rgb(239,214,176));
        for(var j=0;j<3;j++) {
            mz_rect(_x,_y,_s,bx+12+j*28,topo+10,bx+29+j*28,topo+36,make_color_rgb(52,74,82));
            mz_rect(_x,_y,_s,bx+12+j*28,topo+11,bx+15+j*28,topo+35,make_color_rgb(230,211,176));
            mz_rect(_x,_y,_s,bx+12+j*28,topo+60,bx+29+j*28,183,make_color_rgb(61,78,77));
        }
    }
    for(var tile=0;tile<70;tile++) {
        var tx=(tile*137) mod 800;var ty=207+(tile*43) mod 275;
        mz_rect(_x,_y,_s,tx,ty,tx+5,ty+2,make_color_rgb(180,160,130));
    }
    // Mosaico radial colorido da praça, com o marco no centro.
    var cx=_x+400*_s;var cy=_y+315*_s;
    var tons=[make_color_rgb(173,76,67),make_color_rgb(228,185,104),make_color_rgb(83,139,148),make_color_rgb(234,213,168)];
    for(var k=0;k<32;k++) {
        var a=k*360/32; var b=(k+1)*360/32;
        draw_set_color(tons[k mod 4]);
        draw_triangle(cx,cy,cx+lengthdir_x(182*_s,a),cy+lengthdir_y(94*_s,a),cx+lengthdir_x(182*_s,b),cy+lengthdir_y(94*_s,b),false);
    }
    draw_set_color(make_color_rgb(244,220,168));
    draw_ellipse(cx-35*_s,cy-19*_s,cx+35*_s,cy+19*_s,false);
    draw_set_color(make_color_rgb(114,80,49));
    draw_ellipse(cx-12*_s,cy-7*_s,cx+12*_s,cy+7*_s,false);
    for(var linha=0;linha<5;linha++) {
        mz_rect(_x,_y,_s,0,203+linha*49,160,205+linha*49,make_color_rgb(154,140,120));
        mz_rect(_x,_y,_s,640,203+linha*49,800,205+linha*49,make_color_rgb(154,140,120));
    }
    // Faixas de cornija e detalhes de cantaria.
    for(var orn=0;orn<8;orn++) {
        var ox=orn*100;
        mz_rect(_x,_y,_s,ox+2,185,ox+98,190,make_color_rgb(237,211,163));
        for(var pedra=0;pedra<6;pedra++) mz_rect(_x,_y,_s,ox+6+pedra*15,191,ox+12+pedra*15,193,make_color_rgb(124,115,107));
    }
    draw_set_color(c_white);
}
