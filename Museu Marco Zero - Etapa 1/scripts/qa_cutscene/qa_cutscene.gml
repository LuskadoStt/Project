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
