/// Teste de execução opt-in: sem interface de teste no jogo normal.
function qa_cutscene_criar() {
    return {fase: "passeio", tempo_total: 0, permitir_avanco: true,
        marcos: [], falhas: [], bloqueio_frames: 0, bloqueio_feito: false,
        pausa_frames: 0, pausa_feita: false, jogador_x: 0, jogador_y: 0,
        guia_x: 0, guia_y: 0, camera_x: 0, camera_y: 0,
        foto: "", finalizar_frames: -1, concluido: false};
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
        controle_bloqueado_verificado: teste.bloqueio_feito,
        segundos: teste.tempo_total,
        testes: ["passeio com três obras", "bloqueio de movimento em diálogo",
            "pausa de atores e câmera", "liberação de controle", "viagem à praça",
            "história e historiador", "retorno sem repetir passeio", "ausência de visitantes", "guia único"]
    };
    var arquivo = file_text_open_write("qa_resultado_etapa2.json");
    file_text_write_string(arquivo, json_stringify(resultado));
    file_text_close(arquivo);
    game_end();
}

/// Executado antes do bloqueio de pausa do controlador para poder retomar o teste.
function qa_cutscene_atualizar(_narrativa) {
    var teste = global.teste;
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
        teste.pausa_frames--;
        if (teste.pausa_frames == 0) {global.pausado = false; teste.pausa_feita = true;}
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
                teste.foto = "qa_museu_etapa2.png";
                teste.fase = "iniciar_viagem";
            }
            break;
        case "iniciar_viagem":
            keyboard_key_press(ord("E"));
            teste.fase = "viagem";
            break;
        case "viagem":
            keyboard_key_release(ord("E"));
            if (room == rm_obra_1) teste.fase = "praca";
            break;
        case "praca":
            if (_narrativa.estado == "praca_livre") {
                qa_cutscene_verificar(instance_number(obj_npc) == 0, "Visitantes ainda ativos na praça");
                qa_cutscene_verificar(instance_number(obj_npc_obra) == 1, "Historiador deve permanecer no destino");
                qa_cutscene_verificar(instance_number(obj_guia) == 0, "Guia duplicado no destino");
                teste.foto = "qa_praca_etapa2.png";
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
                teste.finalizar_frames = 3;
            }
            break;
    }
}
