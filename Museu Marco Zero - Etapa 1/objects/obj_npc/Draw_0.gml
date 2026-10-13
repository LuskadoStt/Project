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
