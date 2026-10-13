# Validação Windows — etapa 1

Data: 13/10/2026. Código validado: `335f9b37d26faa0822c46997ca91168cc5464f6e`.

Execução: https://github.com/LuskadoStt/Project/actions/runs/38402984478 (segunda tentativa).

Resultados confirmados:

- Recursos, referências, metadados e geometria: PASS.
- Carregamento oficial ResourceTool@2026.0.22: PASS, `SUCCESSFUL LOAD AND LINK`.
- Autenticação GameMaker pelo secret configurado: PASS.
- Compilação e empacotamento Windows com GMS2@2026.0.0.23, runtime VM: PASS.
- Artifact do jogo compilado: criado e disponível em https://github.com/LuskadoStt/Project/actions/runs/38402984478/artifacts/11818736456 .

O pacote Windows permite testar o jogo sem abrir o projeto no GameMaker. O GitHub mantém artifacts por tempo limitado; este expira em 11/01/2027. Ele contém o ZIP produzido pelo PackageTool.

## Limites desta validação

O workflow compila e empacota; não executa o jogo. Não houve aprovação de FPS, colisões, oclusão, áudio em reprodução, ritmo narrativo ou comparação visual da nova paisagem. Os testes de geometria verificam cobertura e recortes, não substituem uma screenshot real do renderer.

O compilador emitiu um aviso de redução da textura do museu `spr_cenario`, de 2172×724 para 1086×362. A imagem da paisagem de 1665×945 não apresentou esse aviso. A redução da textura do museu pode diminuir detalhes; a revisão da imagem final deve levar isso em conta. Não houve erro de compilação.

Nenhum valor de chave de acesso foi colocado no código ou nesta documentação. A autenticação é fornecida pelo repository secret `GAMEMAKER_PAT`.

O código da etapa 2 ainda não foi implementado. Esta entrega valida estruturalmente e compila a etapa 1; a homologação do gameplay continua pendente.
