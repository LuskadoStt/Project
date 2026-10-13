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
switch (estado) {
    case "cutscene":
        cutscene_atualizar(executor_cutscene, id, dt, avancar);
        // A troca de sala já foi solicitada: não liberar controle no ambiente antigo.
        if (trocando_sala) exit;
        if (!executor_cutscene.ativo) {
            estado = executor_cutscene.estado_final;
            fala = "";
            if (erro_cutscene == "" && tipo_cutscene == "passeio") global.visita_concluida = true;
            tipo_cutscene = "";
            fase_portal = "";
            brilho_quadro = 0;
        }
        break;
    case "livre":
        if (keyboard_check_pressed(ord("E")) && !executor_cutscene.ativo
            && point_distance(jogador.x,jogador.y,dados_portal.interacao_x,dados_portal.interacao_y) < configuracao.portal.raio_interacao) {
            // E só é aceito aqui: outras pressões durante a viagem são ignoradas.
            global.viagens_iniciadas++;
            estado = "cutscene";
            tipo_cutscene = "viagem";
            erro_cutscene = "";
            executor_cutscene = cutscene_criar(roteiro_viagem(configuracao), "livre");
        }
        break;
    case "praca_livre":
        if (keyboard_check_pressed(ord("E"))
            && point_distance(jogador.x,jogador.y,configuracao.historiador_praca.x,configuracao.historiador_praca.y) < configuracao.raio_historiador) {
            estado = "cutscene";
            tipo_cutscene = "historia";
            executor_cutscene = cutscene_criar(roteiro_historia(), "praca_livre");
        } else if (keyboard_check_pressed(ord("R"))) {
            salvar_visita(id);
            room_goto(rm_galeria);
            exit;
        }
        break;
}

if(fala!=ultima_fala) {letras=0;ultima_fala=fala;}

autosave_tempo+=dt;
if(autosave_tempo>=5) {salvar_visita(id);autosave_tempo=0;}

if(estado!=estado_anterior) salvar_visita(id);
