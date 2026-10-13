# Etapa 3 — GML completos

Conteúdo integral dos nove GML novos/alterados. Código validado: `21f1b5c404b2228d1ae9c907b26481a3d0bb70f5`.

## `objects/obj_narrativa/Create_0.gml`

```gml
configuracao = configuracao_cenario();
depth = 50;
gpu_set_texfilter(false);
display_set_gui_size(800,500);
jogador = instance_find(obj_player,0);
guia = noone;
tempo = 0; pagina = 0; fala = ""; nome = "Guia do museu";
letras = 0; ultima_fala = ""; fade = 0;
erro_cutscene = "";
tipo_cutscene = "";
fase_portal = "";
brilho_quadro = 0; oscilacao_atual = 0;
trocando_sala = false;
dados_portal = pontos_portal(configuracao);
carregou_posicao = false;
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
    global.viagens_iniciadas = 0;
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

estado = room == rm_galeria ? "livre" : "praca_livre";
if (room == rm_obra_1) {nome = "Historiador local"; fade = 1;}
retomar_praca = global.carregar_posicao && global.local_salvo == "praca" && room == rm_galeria;
if (global.carregar_posicao && ((room == rm_obra_1 && global.local_salvo == "praca")
    || (room == rm_galeria && global.local_salvo == "museu"))) {
    var limites = room == rm_galeria ? configuracao.limites_museu : configuracao.limites_praca;
    jogador.x = clamp(global.salvo_x,limites.esquerda,limites.direita);
    jogador.y = clamp(global.salvo_y,limites.topo,limites.base);
    if (room == rm_obra_1) {estado = "praca_livre"; fade = 0;}
    global.carregar_posicao = false;
    carregou_posicao = true;
} else if (room == rm_obra_1) {
    jogador.x = configuracao.chegada_praca.x;
    jogador.y = configuracao.chegada_praca.y;
}
if (room == rm_galeria) {
    if (!instance_exists(obj_guia)) guia = instance_create_depth(100,540,-540,obj_guia);
    else guia = instance_find(obj_guia,0);
    if (!global.visita_concluida && !retomar_praca) {
        estado = "cutscene";
        tipo_cutscene = "passeio";
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

// Chegada por dados: fade-in, pausa de leitura do cenário e história local.
if (room == rm_obra_1 && !carregou_posicao) {
    estado = "cutscene";
    tipo_cutscene = "chegada";
    executor_cutscene = cutscene_criar(roteiro_chegada(configuracao), "praca_livre");
}
```

## `objects/obj_narrativa/Draw_0.gml`

```gml
gpu_set_texfilter(false);
if (!surface_exists(fundo_surface)) {
    fundo_surface = surface_create(room_width, room_height);
    if (surface_exists(fundo_surface)) {
        surface_set_target(fundo_surface);
        draw_clear_alpha(c_black, 1);
        if (room == rm_galeria) {
            // Restaura o fundo existente, com escala proporcional à largura da sala.
            var escala_museu = room_width / sprite_get_width(configuracao.imagem_museu);
            draw_sprite_ext(configuracao.imagem_museu, 0, 0, 0,
                escala_museu, escala_museu, 0, c_white, 1);
        } else {
            desenhar_cenario_compartilhado(configuracao, configuracao.imagem_praca);
        }
        surface_reset_target();
    }
}
if (surface_exists(fundo_surface)) {
    draw_surface(fundo_surface, 0, 0);
} else {
    // Falta de memória para a surface não impede o desenho do cenário.
    if (room == rm_galeria) {
        var escala_museu_direta = room_width / sprite_get_width(configuracao.imagem_museu);
        draw_sprite_ext(configuracao.imagem_museu, 0, 0, 0,
            escala_museu_direta, escala_museu_direta, 0, c_white, 1);
    } else {
        desenhar_cenario_compartilhado(configuracao, configuracao.imagem_praca);
    }
}
draw_set_color(c_white);
```

## `objects/obj_narrativa/Draw_64.gml`

```gml
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
    if(point_distance(jogador.x,jogador.y,dados_portal.interacao_x,dados_portal.interacao_y)<configuracao.portal.raio_interacao) draw_text(24,450,"E • Tocar o quadro e iniciar a viagem");
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
```

## `objects/obj_narrativa/Step_0.gml`

```gml
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
```

## `objects/obj_obra_1/Draw_0.gml`

```gml
// O quadro mostra a mesma composição da praça, com o piso da imagem existente.
// Apenas o interior configurável da moldura é coberto.
var configuracao = configuracao_cenario();
desenhar_cenario_compartilhado(configuracao, configuracao.moldura);

// Brilho provisório sem novos sprites: contorno da moldura e partículas pequenas.
var narrativa = instance_find(obj_narrativa, 0);
if (narrativa != noone && narrativa.brilho_quadro > 0) {
    var moldura = configuracao.moldura;
    var brilho = global.movimento_reduzido ? min(0.25, narrativa.brilho_quadro) : narrativa.brilho_quadro;
    draw_set_color(make_color_rgb(145,227,218));
    for (var borda = 0; borda < 3; borda++) {
        draw_set_alpha(brilho * (0.6 - borda * 0.12));
        draw_rectangle(moldura.x - borda - 1, moldura.y - borda - 1,
            moldura.x + moldura.largura + borda, moldura.y + moldura.altura + borda, true);
    }
    if (!global.movimento_reduzido && (narrativa.fase_portal == "levitacao" || narrativa.fase_portal == "puxao")) {
        draw_set_alpha(brilho * 0.7);
        for (var particula = 0; particula < 12; particula++) {
            var angulo = particula * 30 + narrativa.tempo * 90;
            var raio = 30 + narrativa.jogador.escala_portal * 30;
            var pos_x = narrativa.dados_portal.alvo_x + lengthdir_x(raio, angulo);
            var pos_y = narrativa.dados_portal.alvo_y + lengthdir_y(raio * 0.5, angulo);
            draw_rectangle(round(pos_x), round(pos_y), round(pos_x) + 2, round(pos_y) + 2, false);
        }
    }
    draw_set_alpha(1);
    draw_set_color(c_white);
}
```

## `scripts/configuracao_cenario/configuracao_cenario.gml`

```gml
/// Configuração provisória: utiliza somente imagens existentes no projeto.
function configuracao_cenario() {
    return {
        imagem_destino: spr_cenario_obra_1,
        imagem_museu: spr_cenario,
        moldura: {x: 179, y: 199, largura: 258, altura: 140},
        imagem_praca: {x: 0, y: 0, largura: 800, altura: 500},
        // A partir de 94% da altura, a imagem provisória contém apenas calçamento.
        // Altere esta fração quando substituir a arte; nenhum PNG é modificado.
        inicio_piso_imagem: 0.94,
        // Reserva 28% da tela para circulação. O piso usa a textura do próprio sprite.
        inicio_piso_tela: 0.72,
        limites_museu: {esquerda: 32, topo: 470, direita: 2016, base: 670},
        limites_praca: {esquerda: 32, topo: 380, direita: 768, base: 486},
        chegada_praca: {x: 400, y: 430},
        historiador_praca: {x: 520, y: 430},
        raio_historiador: 100,
        // Parâmetros da viagem. Todos os pontos são derivados da moldura abaixo.
        portal: {raio_interacao: 110, offset_interacao_y: 141, offset_toque_y: 55,
            altura_levitacao: 20, amplitude_oscilacao: 2, alvo_vertical: 0.68,
            velocidade_aproximacao: 140, tempo_toque: 0.45,
            tempo_levitacao: 1.2, tempo_puxao: 1.3, tempo_transicao: 0.4,
            tempo_chegada: 1.2, pausa_chegada: 0.3},
        versao_passeio: 2,
        velocidade_passeio: 140,
        distancia_guia: 70,
        pontos_passeio: [
            {x: 307, y: 520, titulo: "Praça do Marco Zero", texto: "Esta pintura nos leva à Praça do Marco Zero, no Recife. Observe a paisagem e a relação da cidade com a água."},
            {x: 1080, y: 520, titulo: "Arquitetura e memória", texto: "Nesta obra, a arquitetura guarda memórias do lugar. Cada detalhe pode contar uma parte da sua história."},
            {x: 1830, y: 520, titulo: "Luz e reflexos", texto: "A luz e os reflexos mudam a maneira como vemos uma paisagem. Uma pintura também é um convite a observar."}
        ]
    };
}

/// Quadro e praça utilizam a mesma composição, incluindo o calçamento existente.
/// Sem faixas laterais: a paisagem preenche a largura disponível.
/// A faixa de piso é repetida verticalmente sem esticar a textura do calçamento.
function desenhar_cenario_compartilhado(_configuracao, _retangulo) {
    gpu_set_texfilter(false);
    var imagem = _configuracao.imagem_destino;
    var largura_imagem = sprite_get_width(imagem);
    var altura_imagem = sprite_get_height(imagem);
    var origem_piso = clamp(floor(altura_imagem * _configuracao.inicio_piso_imagem), 1, altura_imagem - 1);
    var altura_piso_imagem = altura_imagem - origem_piso;
    var altura_paisagem = _retangulo.altura * _configuracao.inicio_piso_tela;
    var escala_x = _retangulo.largura / largura_imagem;
    // A paisagem recebe ajuste vertical para caber acima da faixa explorável.
    // Isso preserva todos os elementos, porém altera levemente suas proporções.
    draw_sprite_part_ext(imagem, 0, 0, 0, largura_imagem, origem_piso,
        _retangulo.x, _retangulo.y, escala_x, altura_paisagem / origem_piso, c_white, 1);

    // Mesma escala da textura nas duas telas, relativa à composição lógica 800x500.
    var escala_piso_y = (800 / largura_imagem) * (_retangulo.altura / 500);
    var pos_y = _retangulo.y + altura_paisagem;
    var fim_y = _retangulo.y + _retangulo.altura;
    var altura_ladrilho = altura_piso_imagem * escala_piso_y;
    while (pos_y < fim_y) {
        // O último pedaço é limitado à área restante, sem pintar fora da moldura.
        var altura_destino = min(altura_ladrilho, fim_y - pos_y);
        var altura_origem = altura_destino / escala_piso_y;
        draw_sprite_part_ext(imagem, 0, 0, origem_piso, largura_imagem, altura_origem,
            _retangulo.x, pos_y, escala_x, escala_piso_y, c_white, 1);
        pos_y += altura_destino;
    }
    draw_set_alpha(1);
    draw_set_color(c_white);
}

/// Coordenadas comuns à interação, à animação e ao brilho do quadro.
function pontos_portal(_configuracao) {
    var moldura = _configuracao.moldura;
    var centro_x = moldura.x + moldura.largura / 2;
    var base = moldura.y + moldura.altura;
    return {
        interacao_x: centro_x, interacao_y: base + _configuracao.portal.offset_interacao_y,
        toque_x: centro_x, toque_y: base + _configuracao.portal.offset_toque_y,
        alvo_x: centro_x, alvo_y: moldura.y + moldura.altura * _configuracao.portal.alvo_vertical
    };
}
```

## `scripts/qa_cutscene/qa_cutscene.gml`

```gml
/// Teste de execução opt-in: sem interface de teste no jogo normal.
function qa_cutscene_criar() {
    return {fase: "passeio", tempo_total: 0, permitir_avanco: true,
        marcos: [], falhas: [], bloqueio_frames: 0, bloqueio_feito: false,
        pausa_frames: 0, pausa_feita: false, jogador_x: 0, jogador_y: 0,
        guia_x: 0, guia_y: 0, camera_x: 0, camera_y: 0,
        foto: "", ciclos: 0, viagens_frames: 0, teclas_repetidas: 0,
        pausa_contexto: "passeio", pausa_portal_feita: false,
        escala_salva: 1, fade_salvo: 0, brilho_salvo: 0, tempo_acao_salvo: 0,
        menor_escala: 1, menor_y: 9999, oscilacao_verificada: false,
        movimento_reduzido_verificado: false, historia_repetida: false, historia_iniciada: false,
        ultima_sala: "", ultimo_estado: "", ultimo_tipo: "",
        foto_levitacao: false, foto_puxao: false,
        finalizar_frames: -1, concluido: false};
}

function qa_cutscene_verificar(_condicao, _mensagem) {
    if (!_condicao) array_push(global.teste.falhas, _mensagem);
}

function qa_cutscene_finalizar() {
    var teste = global.teste;
    if (teste.concluido) return;
    teste.concluido = true;
    keyboard_key_release(vk_right);
    keyboard_key_release(ord("E"));
    keyboard_key_release(ord("R"));
    var resultado = {
        aprovado: array_length(teste.falhas) == 0,
        falhas: teste.falhas, marcos: teste.marcos,
        pausa_verificada: teste.pausa_feita,
        pausa_portal_verificada: teste.pausa_portal_feita,
        ciclos: teste.ciclos, viagens_iniciadas: global.viagens_iniciadas,
        teclas_e_repetidas: teste.teclas_repetidas,
        menor_escala: teste.menor_escala,
        oscilacao_verificada: teste.oscilacao_verificada,
        movimento_reduzido_verificado: teste.movimento_reduzido_verificado,
        historia_repetida: teste.historia_repetida,
        fase_teste: teste.fase, sala_final: teste.ultima_sala,
        estado_final: teste.ultimo_estado, tipo_final: teste.ultimo_tipo,
        controle_bloqueado_verificado: teste.bloqueio_feito,
        segundos: teste.tempo_total,
        testes: ["passeio com três obras", "bloqueio de movimento em diálogo",
            "pausa de atores e câmera", "liberação de controle", "viagem à praça",
            "história e historiador", "retorno sem repetir passeio", "ausência de visitantes", "guia único",
            "aproximação/toque/levitação/puxão/transição em ordem", "escala em degraus",
            "pausa durante levitação", "E repetido inicia uma única viagem",
            "segunda viagem com movimento reduzido", "repetir conversa com historiador"]
    };
    var arquivo = file_text_open_write("qa_resultado_etapa3.json");
    file_text_write_string(arquivo, json_stringify(resultado));
    file_text_close(arquivo);
    game_end();
}

/// Executado antes do bloqueio de pausa do controlador para poder retomar o teste.
function qa_cutscene_atualizar(_narrativa) {
    var teste = global.teste;
    teste.ultima_sala = room_get_name(room);
    teste.ultimo_estado = _narrativa.estado;
    teste.ultimo_tipo = _narrativa.tipo_cutscene;
    teste.tempo_total += min(delta_time / 1000000, 0.05);
    if (teste.tempo_total > 100) {
        array_push(teste.falhas, "Timeout do fluxo de teste");
        qa_cutscene_finalizar(); return;
    }
    if (teste.finalizar_frames >= 0) {
        teste.finalizar_frames--;
        if (teste.finalizar_frames <= 0) qa_cutscene_finalizar();
        return;
    }
    if (teste.pausa_frames > 0) {
        qa_cutscene_verificar(abs(_narrativa.jogador.x-teste.jogador_x) < 0.001
            && abs(_narrativa.jogador.y-teste.jogador_y) < 0.001, "Jogador moveu durante pausa");
        qa_cutscene_verificar(abs(_narrativa.guia.x-teste.guia_x) < 0.001
            && abs(_narrativa.guia.y-teste.guia_y) < 0.001, "Guia moveu durante pausa");
        qa_cutscene_verificar(abs(_narrativa.cam_x-teste.camera_x) < 0.001
            && abs(_narrativa.cam_y-teste.camera_y) < 0.001, "Câmera moveu durante pausa");
                if (teste.pausa_contexto == "portal") {
            qa_cutscene_verificar(abs(_narrativa.jogador.escala_portal-teste.escala_salva) < 0.001, "Escala mudou na pausa");
            qa_cutscene_verificar(abs(_narrativa.fade-teste.fade_salvo) < 0.001, "Fade mudou na pausa");
            qa_cutscene_verificar(abs(_narrativa.brilho_quadro-teste.brilho_salvo) < 0.001, "Brilho mudou na pausa");
            qa_cutscene_verificar(abs(_narrativa.executor_cutscene.tempo_acao-teste.tempo_acao_salvo) < 0.001, "Relógio da ação mudou na pausa");
        }
        teste.pausa_frames--;
        if (teste.pausa_frames == 0) {
            global.pausado = false;
            if (teste.pausa_contexto == "portal") teste.pausa_portal_feita = true;
            else teste.pausa_feita = true;
        }
        return;
    }
    switch (teste.fase) {
        case "passeio":
            if (!teste.bloqueio_feito && _narrativa.fala != "") {
                if (teste.bloqueio_frames == 0) {
                    teste.jogador_x = _narrativa.jogador.x;
                    teste.jogador_y = _narrativa.jogador.y;
                    teste.permitir_avanco = false;
                    keyboard_key_press(vk_right);
                } else {
                    qa_cutscene_verificar(abs(_narrativa.jogador.x-teste.jogador_x) < 0.001
                        && abs(_narrativa.jogador.y-teste.jogador_y) < 0.001, "Input moveu o jogador durante diálogo da cutscene");
                }
                teste.bloqueio_frames++;
                if (teste.bloqueio_frames >= 12) {
                    keyboard_key_release(vk_right);
                    teste.permitir_avanco = true;
                    teste.bloqueio_feito = true;
                }
            }
            var executor = _narrativa.executor_cutscene;
            if (teste.bloqueio_feito && !teste.pausa_feita && executor.ativo
                && executor.iniciado && executor.acoes[executor.indice].tipo == "grupo") {
                teste.jogador_x = _narrativa.jogador.x; teste.jogador_y = _narrativa.jogador.y;
                teste.guia_x = _narrativa.guia.x; teste.guia_y = _narrativa.guia.y;
                teste.camera_x = _narrativa.cam_x; teste.camera_y = _narrativa.cam_y;
                teste.pausa_frames = 8; global.pausado = true;
            }
            if (_narrativa.estado == "livre") {
                var esperados = ["boas_vindas", "obra_1", "obra_2", "obra_3", "tecnologia", "convite"];
                qa_cutscene_verificar(array_length(teste.marcos) == array_length(esperados), "Número de falas do passeio incorreto");
                if (array_length(teste.marcos) == array_length(esperados)) {
                    for (var indice = 0; indice < array_length(esperados); indice++)
                        qa_cutscene_verificar(teste.marcos[indice] == esperados[indice], "Ordem das obras/falas incorreta");
                }
                qa_cutscene_verificar(_narrativa.erro_cutscene == "", "Executor reportou erro");
                qa_cutscene_verificar(teste.bloqueio_feito && teste.pausa_feita, "Bloqueio/pausa não foram exercitados");
                qa_cutscene_verificar(instance_number(obj_npc) == 0, "Visitantes ainda ativos no museu");
                qa_cutscene_verificar(instance_number(obj_guia) == 1, "Museu deve ter um guia");
                qa_cutscene_verificar(global.visita_concluida && !executor.ativo, "Passeio não liberou controle");
                teste.foto = "qa_museu_etapa3.png";
                teste.fase = "iniciar_viagem";
            }
            break;
        case "iniciar_viagem":
            keyboard_key_press(ord("E"));
            teste.fase = "viagem";
            break;
        case "viagem":
            keyboard_key_release(ord("E"));
            if (room == rm_galeria) {
                teste.viagens_frames++;
                // Tenta reiniciar a viagem enquanto o executor ainda está ativo.
                if (teste.viagens_frames mod 8 == 0) {
                    keyboard_key_press(ord("E")); teste.teclas_repetidas++;
                }
                qa_cutscene_verificar(abs(_narrativa.jogador.escala_portal * 8
                    - round(_narrativa.jogador.escala_portal * 8)) < 0.001, "Escala fora dos degraus de 1/8");
                teste.menor_escala = min(teste.menor_escala,_narrativa.jogador.escala_portal);
                if (_narrativa.fase_portal == "levitacao") {
                    teste.menor_y = min(teste.menor_y,_narrativa.jogador.y);
                    if (!global.movimento_reduzido && abs(_narrativa.oscilacao_atual) > 0.01)
                        teste.oscilacao_verificada = true;
                    if (global.movimento_reduzido) {
                        qa_cutscene_verificar(abs(_narrativa.oscilacao_atual) < 0.001, "Oscilação ativa no movimento reduzido");
                        teste.movimento_reduzido_verificado = true;
                    }
                    if (!teste.pausa_portal_feita && _narrativa.executor_cutscene.tempo_acao >= 0.35) {
                        teste.pausa_contexto = "portal";
                        teste.jogador_x = _narrativa.jogador.x; teste.jogador_y = _narrativa.jogador.y;
                        teste.guia_x = _narrativa.guia.x; teste.guia_y = _narrativa.guia.y;
                        teste.camera_x = _narrativa.cam_x; teste.camera_y = _narrativa.cam_y;
                        teste.escala_salva = _narrativa.jogador.escala_portal;
                        teste.fade_salvo = _narrativa.fade; teste.brilho_salvo = _narrativa.brilho_quadro;
                        teste.tempo_acao_salvo = _narrativa.executor_cutscene.tempo_acao;
                        teste.pausa_frames = 8; global.pausado = true;
                    }
                    if (!teste.foto_levitacao && _narrativa.executor_cutscene.tempo_acao >= 0.35) {
                        teste.foto = "qa_levitacao_etapa3.png"; teste.foto_levitacao = true;
                    }
                }
                if (_narrativa.fase_portal == "puxao" && !teste.foto_puxao
                    && _narrativa.executor_cutscene.tempo_acao >= 0.5) {
                    teste.foto = "qa_puxao_etapa3.png"; teste.foto_puxao = true;
                }
            } else if (room == rm_obra_1) {
                qa_cutscene_verificar(global.viagens_iniciadas == teste.ciclos + 1, "E repetido iniciou viagens extras");
                qa_cutscene_verificar(_narrativa.jogador.escala_portal == 1, "Escala não restaurada na chegada");
                teste.fase = "praca";
            }
            break;
        case "praca":
            if (_narrativa.estado == "praca_livre") {
                qa_cutscene_verificar(instance_number(obj_npc) == 0, "Visitantes ainda ativos na praça");
                qa_cutscene_verificar(instance_number(obj_npc_obra) == 1, "Historiador deve permanecer no destino");
                qa_cutscene_verificar(instance_number(obj_guia) == 0, "Guia duplicado no destino");
                teste.foto = "qa_praca_etapa3.png";
                qa_cutscene_verificar(abs(_narrativa.jogador.x-_narrativa.configuracao.chegada_praca.x) < 0.001
                    && abs(_narrativa.jogador.y-_narrativa.configuracao.chegada_praca.y) < 0.001, "Chegada fora do centro configurado");
                teste.fase = teste.ciclos == 0 ? "iniciar_historia" : "iniciar_retorno";
            }
            break;
        case "iniciar_historia":
            // Posiciona o teste perto do historiador para exercitar E novamente.
            _narrativa.jogador.x = _narrativa.configuracao.historiador_praca.x - 40;
            _narrativa.jogador.y = _narrativa.configuracao.historiador_praca.y;
            keyboard_key_press(ord("E"));
            teste.fase = "repetindo_historia";
            break;
        case "repetindo_historia":
            keyboard_key_release(ord("E"));
            // O input simulado pode ser reconhecido no frame seguinte.
            // Não concluir o teste da conversa antes de confirmar que ela iniciou.
            if (_narrativa.estado == "cutscene" && _narrativa.tipo_cutscene == "historia")
                teste.historia_iniciada = true;
            if (teste.historia_iniciada && _narrativa.estado == "praca_livre") {
                teste.historia_repetida = true;
                teste.fase = "iniciar_retorno";
            }
            break;
        case "iniciar_retorno":
            keyboard_key_press(ord("R")); teste.fase = "retorno";
            break;
        case "retorno":
            keyboard_key_release(ord("R"));
            if (room == rm_galeria) {
                qa_cutscene_verificar(_narrativa.estado == "livre" && !_narrativa.executor_cutscene.ativo, "Passeio repetiu ao retornar");
                qa_cutscene_verificar(instance_number(obj_guia) == 1, "Guia duplicado ao retornar");
                qa_cutscene_verificar(instance_number(obj_npc) == 0, "Visitantes reapareceram");
                teste.ciclos++;
                if (teste.ciclos < 2) {
                    // A segunda viagem exercita as opções de acessibilidade.
                    global.movimento_reduzido = true;
                    _narrativa.jogador.x = _narrativa.dados_portal.interacao_x;
                    _narrativa.jogador.y = _narrativa.dados_portal.interacao_y;
                    teste.fase = "iniciar_viagem";
                } else {
                    var sequencia = ["boas_vindas", "obra_1", "obra_2", "obra_3", "tecnologia", "convite",
                        "aproximacao", "toque", "levitacao", "puxao", "transicao", "chegada", "historia_1", "historia_2", "historia_3",
                        "historia_1", "historia_2", "historia_3",
                        "aproximacao", "toque", "levitacao", "puxao", "transicao", "chegada", "historia_1", "historia_2", "historia_3"];
                    qa_cutscene_verificar(array_length(teste.marcos) == array_length(sequencia), "Quantidade de marcos das viagens incorreta");
                    if (array_length(teste.marcos) == array_length(sequencia)) {
                        for (var marco = 0; marco < array_length(sequencia); marco++)
                            qa_cutscene_verificar(teste.marcos[marco] == sequencia[marco], "Ordem incorreta nas viagens/história");
                    }
                    qa_cutscene_verificar(global.viagens_iniciadas == 2 && teste.teclas_repetidas > 0, "Proteção de viagem única não exercitada");
                    qa_cutscene_verificar(teste.menor_escala == 0.125, "Puxão não atingiu a escala final");
                    qa_cutscene_verificar(teste.menor_y < _narrativa.dados_portal.toque_y - 5, "Personagem não levitou");
                    qa_cutscene_verificar(teste.oscilacao_verificada && teste.movimento_reduzido_verificado, "Variações de movimento não exercitadas");
                    qa_cutscene_verificar(teste.pausa_portal_feita && teste.historia_repetida, "Pausa ou conversa repetida não exercitadas");
                    teste.finalizar_frames = 3;
                }
            }
            break;
    }
}
```

## `scripts/roteiros_cutscene/roteiros_cutscene.gml`

```gml
/// Roteiro por dados: edite falas e destinos sem alterar o executor.
function roteiro_passeio(_configuracao) {
    var acoes = [
        {tipo: "falar", nome: "Guia do museu", texto: "Bem-vindo! Venha comigo conhecer três obras e uma nova forma de viajar pela arte.", marcador: "boas_vindas"}
    ];
    for (var indice = 0; indice < array_length(_configuracao.pontos_passeio); indice++) {
        var ponto = _configuracao.pontos_passeio[indice];
        array_push(acoes, {tipo: "grupo", acoes: [
            {tipo: "mover", ator: "guia", x: ponto.x + _configuracao.distancia_guia, y: ponto.y, velocidade: _configuracao.velocidade_passeio},
            {tipo: "mover", ator: "jogador", x: ponto.x, y: ponto.y, velocidade: _configuracao.velocidade_passeio}
        ]});
        array_push(acoes, {tipo: "pose", ator: "guia", direcao: 4});
        array_push(acoes, {tipo: "pose", ator: "jogador", direcao: 4});
        array_push(acoes, {tipo: "esperar", segundos: 0.3});
        array_push(acoes, {tipo: "falar", nome: "Guia • " + ponto.titulo, texto: ponto.texto, marcador: "obra_" + string(indice + 1)});
    }
    array_push(acoes, {tipo: "pose", ator: "guia", direcao: 6});
    array_push(acoes, {tipo: "falar", nome: "Guia do museu", texto: "Nossa nova tecnologia permite entrar nas pinturas e visitar esses lugares.", marcador: "tecnologia"});
    var destino = _configuracao.pontos_passeio[0];
    array_push(acoes, {tipo: "grupo", acoes: [
        {tipo: "mover", ator: "guia", x: destino.x + _configuracao.distancia_guia, y: destino.y, velocidade: _configuracao.velocidade_passeio},
        {tipo: "mover", ator: "jogador", x: destino.x, y: destino.y, velocidade: _configuracao.velocidade_passeio}
    ]});
    array_push(acoes, {tipo: "pose", ator: "guia", direcao: 6});
    array_push(acoes, {tipo: "pose", ator: "jogador", direcao: 4});
    array_push(acoes, {tipo: "falar", nome: "Guia do museu", texto: "Toque no quadro para iniciar a viagem.", marcador: "convite"});
    return acoes;
}

/// A viagem não aceita avanço por tecla: movimentos e esperas cumprem a duração.
function roteiro_viagem(_configuracao) {
    var pontos = pontos_portal(_configuracao);
    var tempos = _configuracao.portal;
    return [
        {tipo: "mover", ator: "jogador", x: pontos.toque_x, y: pontos.toque_y,
            velocidade: tempos.velocidade_aproximacao, fase: "aproximacao", marcador: "aproximacao"},
        // Pose provisória: voltado para cima. O brilho indica o contato com a pintura.
        {tipo: "sprite", ator: "jogador", sprite: spr_player_n, quadro: 0,
            fase: "toque", marcador: "toque"},
        {tipo: "brilho", valor: 1, segundos: 0.25},
        {tipo: "esperar", segundos: tempos.tempo_toque},
        {tipo: "som", som: snd_portal},
        {tipo: "animar", ator: "jogador", x: pontos.toque_x,
            y: pontos.toque_y - tempos.altura_levitacao, escala: 1,
            oscilacao: tempos.amplitude_oscilacao, segundos: tempos.tempo_levitacao,
            fase: "levitacao", marcador: "levitacao"},
        // A escala só assume múltiplos de 1/8, sem redução visual contínua.
        {tipo: "animar", ator: "jogador", x: pontos.alvo_x, y: pontos.alvo_y,
            escala: 0.125, oscilacao: 0, segundos: tempos.tempo_puxao,
            fase: "puxao", marcador: "puxao"},
        {tipo: "fade", valor: 1, segundos: tempos.tempo_transicao,
            fase: "transicao", marcador: "transicao"},
        {tipo: "ir_room", sala: rm_obra_1}
    ];
}

/// História preservada integralmente. Também usada quando E repete a conversa.
function roteiro_historia() {
    return [
        {tipo: "falar", nome: "Historiador local", marcador: "historia_1",
            texto: "Este é o Marco Zero, ponto simbólico do Recife e da sua história."},
        {tipo: "falar", nome: "Historiador local", marcador: "historia_2",
            texto: "A Praça Rio Branco fica no Recife Antigo, junto ao porto que ajudou a formar a cidade. O marco é referência para medir as distâncias rodoviárias de Pernambuco."},
        {tipo: "falar", nome: "Historiador local", marcador: "historia_3",
            texto: "O piso colorido traz a Rosa dos Ventos, de Cícero Dias, inaugurada em 2000. Ao redor, o casario guarda memórias da vida comercial e cultural do Recife."}
    ];
}

function roteiro_chegada(_configuracao) {
    var acoes = [
        {tipo: "pose", ator: "jogador", direcao: 2},
        {tipo: "fade", valor: 0, segundos: _configuracao.portal.tempo_chegada,
            fase: "chegada", marcador: "chegada"},
        {tipo: "esperar", segundos: _configuracao.portal.pausa_chegada}
    ];
    var historia = roteiro_historia();
    for (var indice = 0; indice < array_length(historia); indice++) array_push(acoes, historia[indice]);
    return acoes;
}
```

## `scripts/sistema_cutscene/sistema_cutscene.gml`

```gml
/// Executor reutilizável. Cada ação só termina quando seu objetivo é cumprido.
function cutscene_criar(_acoes, _estado_final) {
    return {acoes: _acoes, indice: 0, ativo: array_length(_acoes) > 0,
        iniciado: false, tempo_acao: 0, filhos: [], fade_inicial: 0,
        estado_final: _estado_final, origem_x: 0, origem_y: 0, escala_inicial: 1, brilho_inicial: 0};
}

function cutscene_ator(_narrativa, _nome) {
    switch (_nome) {
        case "jogador": return _narrativa.jogador;
        case "guia": return _narrativa.guia;
        case "historiador": return instance_find(obj_npc_obra, 0);
    }
    return noone;
}

/// Mesmas oito direções e sprites existentes do protagonista.
function cutscene_pose(_ator, _direcao, _andando) {
    var parados = [spr_player, spr_player_se, spr_player_e, spr_player_ne,
        spr_player_n, spr_player_nw, spr_player_w, spr_player_sw];
    var andando = [spr_walk_s, spr_walk_se, spr_walk_e, spr_walk_ne,
        spr_walk_n, spr_walk_nw, spr_walk_w, spr_walk_sw];
    _ator.ultima_direcao = _direcao;
    _ator.sprite_index = _andando ? andando[_direcao] : parados[_direcao];
    _ator.image_speed = _andando ? 1.6 : 0;
    if (!_andando) _ator.image_index = 0;
    _ator.depth = -_ator.y;
}

function cutscene_falhar(_executor, _narrativa, _mensagem) {
    _executor.ativo = false;
    _narrativa.erro_cutscene = _mensagem;
    _narrativa.fala = "";
    _narrativa.estado = _executor.estado_final;
    show_debug_message("Cutscene interrompida: " + _mensagem);
}

/// Ações: mover, falar, esperar, pose, sprite, grupo, animar, brilho, som, fade e ir_room.
/// Grupos executam ações em paralelo (o passeio usa apenas movimentos em grupo).
function cutscene_atualizar(_executor, _narrativa, _dt, _avancar) {
    if (!_executor.ativo || global.pausado) return;
    if (_executor.indice >= array_length(_executor.acoes)) {
        _executor.ativo = false;
        return;
    }
    var acao = _executor.acoes[_executor.indice];
    if (!_executor.iniciado) {
        _executor.iniciado = true;
        _executor.tempo_acao = 0;
        if (variable_struct_exists(acao, "fase")) _narrativa.fase_portal = acao.fase;
        if (global.modo_teste && variable_struct_exists(acao, "marcador"))
            array_push(global.teste.marcos, acao.marcador);
        if (acao.tipo == "animar") {
            var ator_inicial = cutscene_ator(_narrativa, acao.ator);
            if (!instance_exists(ator_inicial)) {
                cutscene_falhar(_executor, _narrativa, "Ator ausente na animação"); return;
            }
            _executor.origem_x = ator_inicial.x;
            _executor.origem_y = ator_inicial.y;
            _executor.escala_inicial = ator_inicial.escala_portal;
            ator_inicial.image_speed = 0;
        }
        if (acao.tipo == "brilho") _executor.brilho_inicial = _narrativa.brilho_quadro;
        if (acao.tipo == "falar") {
            _narrativa.nome = acao.nome;
            _narrativa.fala = acao.texto;
            _narrativa.letras = 0;
            _narrativa.ultima_fala = acao.texto;
        }
        if (acao.tipo == "fade") _executor.fade_inicial = _narrativa.fade;
        if (acao.tipo == "grupo") {
            _executor.filhos = [];
            for (var filho = 0; filho < array_length(acao.acoes); filho++)
                array_push(_executor.filhos, cutscene_criar([acao.acoes[filho]], _executor.estado_final));
        }
    }
    _executor.tempo_acao += _dt;
    var terminou = false;
    switch (acao.tipo) {
        case "mover":
            var ator = cutscene_ator(_narrativa, acao.ator);
            if (!instance_exists(ator)) {
                cutscene_falhar(_executor, _narrativa, "Ator ausente: " + acao.ator);
                return;
            }
            var distancia = point_distance(ator.x, ator.y, acao.x, acao.y);
            var passo = acao.velocidade * _dt;
            if (distancia <= passo) {
                ator.x = acao.x; ator.y = acao.y;
                cutscene_pose(ator, ator.ultima_direcao, false);
                terminou = true;
            } else {
                var angulo = point_direction(ator.x, ator.y, acao.x, acao.y);
                var direcao = (2 + round(angulo / 45)) mod 8;
                ator.x += lengthdir_x(passo, angulo);
                ator.y += lengthdir_y(passo, angulo);
                cutscene_pose(ator, direcao, true);
            }
            break;
        case "falar":
            // Uma pressão completa a revelação; outra avança, como no diálogo existente.
            if (_avancar && _executor.tempo_acao > _dt
                && _narrativa.letras >= string_length(acao.texto)) {
                _narrativa.fala = "";
                terminou = true;
            }
            break;
        case "esperar":
            terminou = _executor.tempo_acao >= acao.segundos;
            break;
        case "pose":
            var ator_pose = cutscene_ator(_narrativa, acao.ator);
            if (!instance_exists(ator_pose)) {
                cutscene_falhar(_executor, _narrativa, "Ator ausente na pose"); return;
            }
            cutscene_pose(ator_pose, acao.direcao, false);
            terminou = true;
            break;
        case "sprite":
            var ator_sprite = cutscene_ator(_narrativa, acao.ator);
            if (!instance_exists(ator_sprite)) {
                cutscene_falhar(_executor, _narrativa, "Ator ausente na troca de sprite"); return;
            }
            ator_sprite.sprite_index = acao.sprite;
            ator_sprite.image_index = acao.quadro;
            ator_sprite.image_speed = 0;
            terminou = true;
            break;
        case "grupo":
            terminou = true;
            for (var indice_filho = 0; indice_filho < array_length(_executor.filhos); indice_filho++) {
                var executor_filho = _executor.filhos[indice_filho];
                cutscene_atualizar(executor_filho, _narrativa, _dt, false);
                if (_narrativa.erro_cutscene != "") {
                    cutscene_falhar(_executor, _narrativa, _narrativa.erro_cutscene); return;
                }
                if (executor_filho.ativo) terminou = false;
            }
            break;
        case "animar":
            var ator_animado = cutscene_ator(_narrativa, acao.ator);
            if (!instance_exists(ator_animado)) {
                cutscene_falhar(_executor, _narrativa, "Ator ausente na animação"); return;
            }
            var progresso = acao.segundos <= 0 ? 1 : clamp(_executor.tempo_acao / acao.segundos, 0, 1);
            var suave = progresso * progresso * (3 - 2 * progresso);
            var amplitude = global.movimento_reduzido ? 0 : acao.oscilacao;
            _narrativa.oscilacao_atual = sin(progresso * pi * 6) * amplitude * sin(progresso * pi);
            ator_animado.x = lerp(_executor.origem_x, acao.x, suave);
            ator_animado.y = lerp(_executor.origem_y, acao.y, suave) + _narrativa.oscilacao_atual;
            ator_animado.escala_portal = max(0.125, round(lerp(_executor.escala_inicial, acao.escala, suave) * 8) / 8);
            ator_animado.depth = -ator_animado.y;
            terminou = progresso >= 1;
            break;
        case "brilho":
            var progresso_brilho = acao.segundos <= 0 ? 1 : clamp(_executor.tempo_acao / acao.segundos, 0, 1);
            _narrativa.brilho_quadro = lerp(_executor.brilho_inicial, acao.valor, progresso_brilho);
            terminou = progresso_brilho >= 1;
            break;
        case "som":
            _narrativa.portal_som = audio_play_sound(acao.som, 1, false);
            global.portal_som = _narrativa.portal_som;
            terminou = true;
            break;
        case "fade":
            var fator = acao.segundos <= 0 ? 1 : clamp(_executor.tempo_acao / acao.segundos, 0, 1);
            _narrativa.fade = lerp(_executor.fade_inicial, acao.valor, fator);
            terminou = fator >= 1;
            break;
        case "ir_room":
            _executor.ativo = false;
            _narrativa.trocando_sala = true;
            room_goto(acao.sala);
            return;
        default:
            cutscene_falhar(_executor, _narrativa, "Ação desconhecida: " + acao.tipo);
            return;
    }
    if (terminou) {
        _executor.indice++;
        _executor.iniciado = false;
        if (_executor.indice >= array_length(_executor.acoes)) _executor.ativo = false;
    }
}
```
