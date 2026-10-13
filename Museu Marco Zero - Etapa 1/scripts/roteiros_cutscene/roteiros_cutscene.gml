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
