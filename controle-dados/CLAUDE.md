# CLAUDE.md — DataDrivenControl

## Contexto do projeto
Repositório de pesquisa e material didático sobre controle baseado em dados
(DeePC, Koopman, SINDy, RL) aplicado a conversores de potência, ligado à
proposta CNPq e ao grupo LINCE (UFPA/CAMTUC).

## Padrão de qualidade para slides (Quarto RevealJS)
Os decks existentes em Koopman/slides/*.qmd estão rasos demais — cobrem só
definições superficiais sem desenvolver a matemática nem exemplos numéricos
reais. TODO NOVO deck deve seguir esta estrutura mínima (ver seção abaixo)
e este nível de profundidade, não um resumo de tópicos.

## Estrutura obrigatória de cada deck (~10-15 slides)
1. Motivação (1-2 slides) — problema concreto que motiva o bloco
2. Formalismo (3-4 slides) — matemática desenvolvida passo a passo, não só
   enunciada. Usar $$ para equações centrais, com derivação visível quando
   fizer sentido.
3. Algoritmo (3-5 slides) — pseudocódigo OU fluxo visual (mermaid/tikz),
   nunca apenas texto corrido
4. Exemplo numérico (2-3 slides) — código real (Python/MATLAB) + resultado
   visual (gráfico), preferencialmente rodável, não só ilustrativo
5. Ponte para o próximo bloco (1 slide)

## Convenções técnicas
- Template dos decks: o mesmo de Notas/leituras/brunton-kutz-data-driven.
  Cabeçalho revealjs com `center: true`, sem `self-contained`/`footer`, logo
  da capa em `data-background-position: "top 45px center"`, `lang: pt-BR`;
  terminar com `{{< include ../_encerramento.qmd >}}`. Usar `{.small-slide}`
  em slides densos e `{.nostretch}` em slides com figura (senão o `r-stretch`
  do revealjs encolhe a figura até sumir). Separar código longo (> ~12 linhas)
  e o gráfico resultante em slides diferentes. Incluir
  `include-in-header: ../_mathjax.html` (fonte web TeX do MathJax; sem isso
  `\underbrace` sai quebrado e `\mathcal` vira □ com as fontes STIX do macOS).
- Tema: TemaRTx.scss (cores UFPA: azul #002C6F, vinho #96263a, dourado #FFD700)
- Diagramas: mermaid nativo ou TikZ via knitr (arquivos standalone em
  Notas/imgs/tikz/)
- Bibliografia: Referencias.bib (Zotero/Better BibTeX), citar com @key
- Sequência da linha Koopman: SVD → DMD → Teoria Koopman → EDMD →
  Koopman-MPC → Validação (ver Koopman/README.md)