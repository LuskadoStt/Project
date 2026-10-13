# Museu — Marco Zero

Projeto GameMaker 2026.0.0.16 em GML.

A versão atual está em **Museu Marco Zero - Etapa 1/**. Abra `game P.I.yyp` dessa pasta no GameMaker.

O pacote da mesma versão é **Museu-Marco-Zero-Etapa-1-Audio-v2.zip**. Ele inclui a correção do esquema dos recursos de áudio GMSound v2. Os ZIPs anteriores não fazem parte desta atualização.

A paisagem usa a mesma imagem provisória no quadro e no destino, com calçamento explorável obtido da própria imagem e sem faixas laterais. Nenhum PNG foi redesenhado. As próximas etapas aguardam teste desta versão.

Documentação: `LEIA-ME.md`, `qa/ETAPA-1.md`, `qa/GML-COMPLETOS-ETAPA-1.md` e `qa/DIAGNOSTICO-AUDIO-V2.md` dentro da pasta do projeto.

Verificação estrutural: `python qa/verify_project.py`, executado dentro da pasta do projeto. Compilação e execução no GameMaker ainda precisam ser confirmadas.

`game P.I.rar` é o arquivo original enviado e foi preservado.

## Atualização e testes automáticos

Use GitHub Desktop para clonar este repositório uma vez e atualizar com Fetch/Pull. Abra sempre o mesmo `.yyp` da pasta clonada. A documentação está em `qa/REVISAO-TELA-PISO.md` no projeto.

O workflow **Validar GameMaker e gerar jogo Windows**, em Actions, verifica os recursos e a composição e tenta produzir o jogo compilado. Se tiver sucesso, o executável empacotado é disponibilizado como artifact. A automação não executa gameplay.

## Resultado confirmado

A compilação Windows passou com a chave GameMaker configurada. Veja `VALIDACAO-WINDOWS.md` para evidências, link do jogo compilado e limites dos testes. A compilação não substitui teste jogável.

## Etapa 2 — atual

O passeio por dados com três paradas está implementado; visitantes estão desativados e o historiador foi mantido. A pasta original foi mantida para não mudar o caminho do seu projeto local. Consulte `qa/ETAPA-2.md` dentro do projeto. A execução automática do jogo Windows passou: passeio, bloqueio de input, pausa, viagem e retorno. Os artifacts do workflow incluem jogo compilado, relatório e capturas.
