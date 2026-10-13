# Museu — Marco Zero

Projeto GameMaker 2026.0.0.16 em GML. Etapa atual: **3**, viagem pela pintura e chegada em cutscene por dados, depois do passeio de três obras.

A pasta mantém o nome histórico **Museu Marco Zero - Etapa 1/** para preservar caminhos. Abra `game P.I.yyp` nela. Visitantes estão desativados; no museu ficam protagonista e guia, no destino protagonista e historiador. A mesma imagem provisória compõe pintura e paisagem, com calçamento da própria imagem. Nenhum PNG foi redesenhado.

Documentação atual: `LEIA-ME.md`, `qa/ETAPA-3.md` e `qa/GML-COMPLETOS-ETAPA-3.md`. O roteiro solicitado está em `design/ROTEIRO-CINEMATOGRAFICO-PROPOSTA.md`; seus novos efeitos e visitantes são proposta para revisão.

## Atualização e testes automáticos

Clone uma vez pelo GitHub Desktop e use Fetch/Pull para atualizar. Não é necessário copiar recursos individualmente. É possível jogar o executável empacotado sem abrir o GameMaker.

O workflow **Validar GameMaker e gerar jogo Windows** verifica recursos, composição, leitura oficial, compilação e execução real com o argumento reservado `--qa-cutscene`. Publica executável, JSON e capturas. A chave GameMaker já configurada é usada pela automação.

Etapa 3 aprovada em duas viagens completas, pausa durante levitação, bloqueio de input, modo reduzido, conversa repetida e retorno: `aprovado: true`, `falhas: []`.

- Execução: https://github.com/LuskadoStt/Project/actions/runs/38415101793
- Jogo Windows: https://github.com/LuskadoStt/Project/actions/runs/38415101793/artifacts/11823412302
- Relatório e capturas: https://github.com/LuskadoStt/Project/actions/runs/38415101793/artifacts/11823587142

Esses testes são funcionais; não medem FPS nem substituem avaliação visual de ritmo, arte e áudio. A próxima implementação aguarda a conferência desta etapa. `game P.I.rar` foi preservado como arquivo original.

## Trailer independente

O trailer conceitual animado está em [trailer/Museu-Entre-na-Arte-Trailer.mp4](trailer/Museu-Entre-na-Arte-Trailer.mp4): 49 segundos, HD 1280×720, 60 FPS, trilha instrumental original e falas na tela. É um MP4 independente, sem precisar abrir o GameMaker. Código de produção e validação estão em [trailer/README.md](trailer/README.md). As novas animações e os visitantes do vídeo não alteram a versão jogável.
