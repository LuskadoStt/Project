// A pintura embutida no fundo é coberta somente dentro da moldura.
// O mesmo recurso é usado como cenário em rm_obra_1.
var configuracao = configuracao_cenario();
desenhar_imagem_inteira(configuracao.imagem_destino,
    configuracao.moldura, configuracao.cor_faixas);
