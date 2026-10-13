if(global.pausado) exit;
// End Step: câmera segue a posição já atualizada, sem atraso de um frame.
if(!instance_exists(jogador)) exit;
var cam=view_camera[0];
if(cam==-1) exit;
var alvo_cam_x=clamp(jogador.x-camera_get_view_width(cam)/2,0,max(0,room_width-camera_get_view_width(cam)));
var alvo_cam_y=clamp(jogador.y-camera_get_view_height(cam)/2,0,max(0,room_height-camera_get_view_height(cam)));
var peso=global.movimento_reduzido ? 1 : 1-exp(-10*min(delta_time/1000000,0.05));
cam_x=lerp(cam_x,alvo_cam_x,peso);cam_y=lerp(cam_y,alvo_cam_y,peso);
camera_set_view_pos(cam,round(cam_x),round(cam_y));
