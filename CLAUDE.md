# CLAUDE.md

Contexto para sessões futuras do Claude Code neste repositório.

## O que é este repositório

`Notas` é um satélite do hub acadêmico do Prof. Dr. Raphael Teixeira
(`raphateixeira.github.io`, UFPA-CAMTUC-FEE), publicado em
<https://raphateixeira.github.io/Notas/>, linkado a partir da aba **Notas** da barra de
navegação principal. Formato canônico: Quarto (`quarto render`, `execute.freeze: auto`).
Tema visual: `TemaRTx.scss` (idêntico ao usado por TikZ, Manim, DeepLearning,
MetodosNumericos, ControleEstados, DataDrivenControl — não inventar paleta própria).

Tem dois tipos de conteúdo: **Fundamentos** (`fundamentos/<tema>/`, temas gestados aqui e
promovidos a repositório próprio quando ganharem volume) e **Livros** (`leituras/<livro>/`,
uma pasta por livro, com slides e notas complementares). A pasta pública dos livros chama-se
`leituras/` (e não `livros/`) porque `Livros/` guarda os PDFs locais e, no macOS, os dois
nomes colidiriam.

## REGRA INEGOCIÁVEL: nunca versionar PDFs/ebooks

Este repositório é **público** (o GitHub Pages exige, no plano gratuito). O usuário não quer
os PDFs dos livros no GitHub, em hipótese alguma (direitos autorais). As figuras usadas nos
slides podem ser versionadas; o PDF do livro não.

- Os PDFs ficam só localmente em `Livros/` (no `.gitignore`, junto com `*.pdf`, `*.epub`,
  `*.djvu`).
- Existe um hook local `.git/hooks/pre-commit` que barra qualquer PDF/ebook no commit. Ele
  não é versionado: em um clone novo, recrie-o (bloquear
  `git diff --cached --name-only` com `\.(pdf|epub|djvu)$`).
- **Nunca** use `git add -f` em PDF, nem `git add -A` sem conferir `git status` antes.
  Não ignore o hook (`--no-verify`).

## Livros: pasta, não repositório

Cada livro é uma **pasta** deste repositório, nunca um repositório Git separado. Decisão de
2026-09-23 (reverte a de 2026-08-23, que criara um repositório privado `Livro*` por livro;
esses repositórios foram excluídos). Motivo: repositório privado não publica GitHub Pages
no plano gratuito, e o único motivo real para privacidade eram os PDFs, que agora ficam
fora do repositório.

Cada pasta (`<autor>-<assunto>/`, kebab-case) contém:

- `index.qmd` — página do livro (título, autor, edição, lista de capítulos com links para os
  decks na mesma pasta; sem bloco `format:` — herda o tema do projeto).
- um `.qmd` **revealjs** por capítulo/aula, com o front matter dos decks existentes (tema
  `[simple, ../TemaRTx.scss]`, logo `../imgs/ufpa-colorido.png`, 1600x900, transição
  `fade`). Modelo completo: `leituras/chan-probabilidade/Cap01MathBack.qmd`.
- `imgs/` (opcional) — figuras do livro usadas nos slides (referenciadas como `imgs/…`).

Livros atuais (em `leituras/`): `chan-probabilidade`, `brunton-otimizacao`, `brunton-kutz-data-driven`,
`bishop-deep-learning`, `strang-linear-algebra`, `ventura-geometria-diferencial`,
`larson-calculo-multivariavel`, `hasan-advanced-control-power-converters`,
`ljung-system-identification`, `pillonetto-regularized-system-identification`.

Ao adicionar um livro novo: criar a pasta e o `index.qmd`; adicionar a entrada em
`referencias.bib`; adicionar o item no menu **Livros** de `_quarto.yml` e a linha na tabela
de `index.qmd`. Escreva apenas o que foi de fato lido — nunca invente numeração de
teorema, equação ou resumo de capítulo.

Notas conceituais de Deep Learning ficam aqui (`bishop-deep-learning/`); implementações de
código substanciais vão para o satélite
[DeepLearning](https://raphateixeira.github.io/DeepLearning/).

## Fundamentos (temas, não livros)

A seção **Fundamentos** de `index.qmd` mostra cards de tema (sem capa, com selo de estado e
fontes). Cada tema é uma pasta em `fundamentos/<tema>/` com `index.qmd`, nascida a partir das
notas de leitura dos livros; quando ganhar volume, é promovida a repositório próprio (e o card
passa a apontar para ele). Temas atuais: `identificacao-sistemas`, `controle-mpc`,
`controle-digital`, `conversores-energia`.

Ao criar um tema: pasta + `index.qmd` (com `status:`), card em `index.qmd`, item no menu
**Fundamentos** de `_quarto.yml`. Cite as fontes (pastas de livros) e não escreva conteúdo que
não foi lido.
