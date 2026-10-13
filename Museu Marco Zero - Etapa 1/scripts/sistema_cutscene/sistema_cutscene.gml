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
