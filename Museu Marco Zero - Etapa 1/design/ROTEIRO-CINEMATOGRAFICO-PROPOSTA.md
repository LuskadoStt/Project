# Cutscene proposta — a pintura como passagem

Roteiro e direção visual para revisão. A proposta inclui visitantes e o destino chamado aqui de “Pico de Brennand”, conforme o pedido. A etapa 3 já implementada continua no Marco Zero, com protagonista, guia e historiador; os visitantes permanecem desativados. Os planos, zooms, novos gestos e efeitos abaixo ainda não foram implementados.

## Intenção e linguagem visual

O museu começa acolhedor e cotidiano; o toque transforma curiosidade em descoberta. A chegada preserva esse encantamento, com uma pausa contemplativa antes da explicação histórica. A referência a Impostor Factory orienta a escala dos personagens, a economia dos gestos, as expressões legíveis e o ritmo emocional. Personagens, sprites, cenários e música serão próprios do projeto.

Protagonista compacto, cabeça e olhos suficientemente grandes para comunicar curiosidade em poucos pixels. Guia com uniforme escuro, detalhe claro no colarinho e postura aberta. Historiador com óculos, camisa de tecido leve e roupa adequada ao clima do Recife, sem usar um traje como suposta representação única da cultura local. A paleta separa os atores do fundo: interiores em âmbar e sombras azuladas; destino em azuis atmosféricos, pedra quente e dourado suave. O portal acrescenta ciano e branco quente.

Enquadramento em visão oblíqua de jogo, mantendo a leitura do piso e dos pés. “Plano médio-aberto” e “aproximação” significam mudanças de enquadramento nessa perspectiva, sem transformar a sequência em uma câmera 3D.

## Duração e leitura

Cerca de 38 a 45 segundos com leitura breve. Os tempos abaixo indicam uma montagem de referência; a fala espera o jogador. A contagem do próximo movimento começa depois de o texto ser avançado. Espaço/Enter completa o texto e, na segunda ação, avança. As animações de toque, levitação e transição cumprem sua duração para preservar a continuidade. Esc pausa a sequência inteira.

## Cena 1 — o museu

### Plano 1 — um lugar vivo | 0 a 4 s

Plano aberto da galeria: três pinturas visíveis, protagonista e guia no terço inferior, deixando o quadro de destino no terço superior esquerdo. Visitantes formam grupos pequenos e não bloqueiam a trajetória dos personagens principais. Uma dupla conversa à esquerda; outra pessoa inclina a cabeça diante de uma obra; alguém atravessa lentamente o fundo.

A câmera inicia um deslocamento lateral muito pequeno, de 3 a 4 pixels lógicos em quatro segundos. Uma flutuação senoidal de amplitude máxima de 1 pixel sugere presença sem sacudir a leitura. Não há tremor aleatório contínuo. Conversas ficam em murmúrio discreto; passos e uma nota de piano estabelecem a atmosfera.

As animações de fundo têm fases diferentes: gesto de mão, pequeno aceno, troca de apoio dos pés. Parados, os personagens respiram em ciclos de aproximadamente 2,5 segundos: peito e ombros variam 1 pixel; cabelo e barra da roupa respondem com um quadro de atraso. Cada ator tem seu próprio deslocamento de fase, evitando que todos respirem juntos.

### Plano 2 — o convite | 4 a 13 s, ajustável à leitura

Sem corte, a câmera desliza até enquadrar guia, protagonista e pintura. O deslocamento dura 1,6 s, com aceleração e desaceleração suaves. O guia vira a cabeça primeiro, depois o corpo; abre uma mão na direção da obra. O protagonista acompanha o gesto com o olhar, ergue ligeiramente as sobrancelhas e inclina a cabeça.

O balão entra em 0,2 s por transparência, sem deslocar os personagens. Texto progressivo com aproximadamente 30 caracteres por segundo; a caixa permanece opaca o suficiente para leitura sobre qualquer fundo.

**Guia, sorrindo com orgulho:**

> “Nossa nova tecnologia permite entrar nas pinturas e visitar esses lugares. Toque no quadro para iniciar a viagem.”

Depois de o jogador avançar, há uma pausa dramática de **1 segundo**. A câmera inicia um zoom de apenas 5% em direção à pintura. O guia mantém o sorriso e acrescenta, em tom leve:

> “Não haverá aviso para não tocar.”

Não aparece placa de proibição. A última frase funciona como comentário do guia. Os murmúrios do museu diminuem gradualmente em cerca de 1 s, acompanhando a atenção do protagonista.

### Plano 3 — dois passos e o toque | 13 a 17 s

O protagonista dá **dois passos** até a moldura. A animação usa contatos de pé claros: apoio, passagem, apoio seguinte. A velocidade de deslocamento acompanha esses contatos para evitar que os pés deslizem. O guia permanece atrás e à direita, deixando o gesto visível.

A câmera acompanha o protagonista com pequeno atraso e termina em enquadramento que inclui mão, rosto e parte da pintura. Ele para, inclina o tronco e estende o braço em quatro poses expressivas ao longo de 0,45 s. Os pixels da mão encostam na superfície; uma pausa de aproximadamente 0,15 s torna o contato reconhecível antes do efeito.

Uma centelha de 2 pixels nasce no ponto exato do toque. Três anéis pixelados se expandem com intervalos de 0,12 s. A ondulação desloca somente a imagem pintada em 1 a 2 pixels inicialmente; depois alcança a moldura e uma faixa do ambiente. O brilho cresce de forma contínua. O som é um pulso suave que se abre em ressonância, sem impacto estridente.

### Plano 4 — a pintura o puxa | 17 a 21 s

O protagonista percebe a atração: olha para a mão, abre os olhos e separa os pés do chão. Levita entre 16 e 20 pixels lógicos durante aproximadamente 0,9 s. A sombra permanece no piso, fica menor e perde opacidade; isso comunica altura. Cabelo e roupa sobem com atraso de dois ou três quadros.

Ele oscila no máximo 2 pixels antes de ser puxado para o ponto de contato. O movimento acelera no meio e desacelera perto da superfície. Pequenas partículas ciano convergem para a mão; a pintura responde com luz branca quente. O guia recua meio passo e ergue a mão, surpreso, mantendo-se visível até a luminosidade cobrir o museu.

O corpo diminui em passos de escala planejados, alinhados à grade de pixels. A trajetória e o brilho usam interpolação contínua; o desenho do sprite mantém contornos nítidos. A animação deve sugerir absorção, sem uma súbita troca de pose.

## Transição — a moldura vira o mundo | 21 a 23 s

Antes de produzir a arte final, definir três âncoras na imagem: linha do horizonte, eixo da escultura e ponto do piso onde o protagonista aparecerá. A pintura e a cena de chegada usam a mesma imagem-mestra e as mesmas coordenadas normalizadas. O cenário de destino aparece inicialmente com o enquadramento registrado à pintura; o pan para baixo só começa após a correspondência estar concluída.

A imagem da pintura expande até ocupar a tela por uma transformação contínua, mantendo o ponto tocado como referência visual. O museu desaparece em blocos ordenados de 2×2 ou 4×4 pixels, com um padrão fixo de dissolução que avança do centro para as bordas. Simultaneamente, um crossfade de cerca de 1 s revela a paisagem. Os blocos acompanham a transformação da imagem; não surgem em posições aleatórias que façam a composição piscar.

O branco atinge o máximo uma única vez e permanece por aproximadamente 0,15 s. O efeito de blur analógico fica restrito à camada luminosa: um halo difuso ao redor dos pixels, sem borrar personagens, moldura ou texto. Murmúrio e ressonância do museu se dissolvem em vento e ambiência externa.

## Cena 2 — dentro da pintura

### Plano 5 — chegada ao “Pico de Brennand” | 23 a 28 s

O véu branco perde opacidade em 1,2 s. Horizonte e escultura surgem primeiro; em seguida, o piso. A câmera desliza para baixo aproximadamente 12 a 20 pixels durante 1,5 s, revelando o protagonista no centro da área aberta. Não ocorre corte seco nem reposicionamento instantâneo.

Ele reaparece no ponto correspondente à composição da pintura, ainda alguns pixels acima do chão; desce, toca o piso com uma flexão curta dos joelhos e se endireita. Roupa e cabelo acomodam-se após a aterrissagem. Uma pequena onda de poeira se afasta dos pés e desaparece.

A atmosfera do destino usa luz mais quente. Visitantes ficam nos planos médio e distante: duas pessoas conversam junto a um elemento da paisagem, outra caminha em trajetória lenta. Um limite inicial de 12 a 20 partículas pequenas e transparentes dá profundidade sem competir com as expressões. Partículas próximas se movem um pouco mais rápido; nenhuma cobre o diálogo.

### Plano 6 — o historiador | 28 a 36 s, ajustável à leitura

O historiador entra pela direita, já dentro da área que a câmera pode mostrar. Seu andar dura cerca de 2 s. A câmera começa a acompanhá-lo quando ele cruza o terço direito e converge suavemente para o ponto médio entre ele e o protagonista. Não abandona o protagonista fora do enquadramento.

O historiador para a uma distância confortável, olha para o visitante e ajusta os óculos: mão sobe, toca a haste, rosto inclina alguns pixels, mão desce. O gesto dura cerca de 0,6 s. O protagonista responde com um aceno pequeno. Uma pausa de 0,25 s permite ler as expressões antes do balão.

**Historiador local, acolhedor:**

> “Este é o Pico de Brennand, ponto simbólico do Recife e da sua história.”

Durante a fala, a câmera quase se estabiliza. Respiração e tecido continuam animados; visitantes não atravessam entre os dois personagens. O piano começa em volume baixo, com fade-in de aproximadamente 3 s.

### Plano 7 — contemplação e controle | 36 a 42 s

O historiador dá um passo lateral e abre o braço na direção da paisagem. O protagonista acompanha o gesto com a cabeça. A câmera recua lentamente, revertendo o zoom de aproximação durante 3 s, e revela a relação entre piso, escultura, água e horizonte.

O balão desaparece em 0,25 s. A música alcança seu volume de exploração. A câmera termina exatamente no enquadramento de gameplay e adota o acompanhamento do jogador com a mesma velocidade de interpolação. Só então surgem as instruções de interação, e o controle é devolvido. A primeira entrada de movimento não pode gerar um salto da câmera.

## Direção técnica do smoothing

- **Deslocamentos com duração definida:** usar `s = t*t*(3-2*t)` com `t` limitado de 0 a 1. Aplicar `s` a posição, zoom e transparência para terminar precisamente nos alvos.
- **Acompanhamento contínuo:** `a = 1 - exp(-k * dt)` e `posicao = lerp(posicao, alvo, a)`, com `dt` em segundos. Um valor inicial de `k` entre 4 e 6 pode ser ajustado no teste de ritmo. O atraso permanece semelhante em diferentes FPS.
- **Grade de pixels:** guardar câmera e atores em coordenadas fracionárias; alinhar o desenho à grade de pixels lógicos e usar amostragem nearest-neighbor. Não arredondar o estado usado pela interpolação. Testar panorâmicas em diferentes resoluções para identificar passos perceptíveis.
- **Zoom:** pixel art não mantém simultaneamente alinhamento inteiro perfeito e qualquer zoom contínuo. Nesta proposta, o zoom varia pouco; a composição é renderizada em uma superfície intermediária e escalada com nearest-neighbor, aceitando variação discreta de espessura dos pixels. Se o teste mostrar cintilação, manter zoom fixo e obter a aproximação pelo pan e pela expansão luminosa da pintura.
- **Sprites:** usar transições de pose desenhadas, sem interpolar imagens de membros como se fossem vetores. O smoothing atua na trajetória e no ritmo; o contorno das poses continua pixelado.
- **Pausa:** congelar relógio das ações, câmera, animações, partículas e fades. Retomar com o mesmo progresso. Bloquear novas viagens enquanto a cutscene estiver ativa.
- **Movimento reduzido:** remover flutuação, tremor e oscilação; limitar a luminosidade e substituir o clarão por fade escuro. Preservar a ordem e as falas, com câmera estável e transições graduais.

Pans e recuos exigem cenário além do enquadramento inicial. Reservar uma margem de arte de aproximadamente 10% a 15%, ou limitar os alvos da câmera à área coberta. Essa margem é requisito para a futura arte, não uma ampliação já feita da imagem provisória.

## Critérios de revisão antes de implementar a próxima etapa

1. Guia, protagonista e historiador permanecem reconhecíveis em resolução nativa; gestos e ponto do toque são legíveis.
2. Os dois passos não deslizam; a levitação se distingue claramente do puxão.
3. Horizonte, escultura e ponto de chegada coincidem entre pintura e destino antes do pan.
4. Câmera não dá saltos na troca de room, na pausa, após o diálogo nem ao devolver o controle.
5. Fade, dissolução e brilho não produzem flashes repetidos; texto permanece legível.
6. Visitantes têm ciclos variados, não bloqueiam a ação e não são reintroduzidos na etapa atual sem a implementação correspondente.
7. Medir tempo de quadro e picos da transição no executável, em máquinas de referência. A validação funcional da etapa 3 não mede esse futuro custo visual nem comprova desempenho equivalente a Impostor Factory.

## Nome do destino

“Pico de Brennand” foi mantido como nome provisório solicitado, inclusive na fala. A referência municipal consultada identifica o local como **Parque das Esculturas Francisco Brennand** e sua obra central como **Torre de Cristal**. Se esse é o lugar desejado, ajustar o título e o diálogo histórico antes da versão final. Fonte: https://visit.recife.pe.gov.br/lugar/parque-das-esculturas-francisco-brennand/ . Não é o mesmo cenário de praça e casario do Marco Zero.
