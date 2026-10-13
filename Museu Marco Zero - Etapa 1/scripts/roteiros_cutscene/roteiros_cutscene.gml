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
