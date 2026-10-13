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
