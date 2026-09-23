# CLAUDE.md

Contexto para sessões futuras do Claude Code neste repositório.

## O que é este repositório

`Notas` é um satélite do hub acadêmico do Prof. Dr. Raphael Teixeira
(`raphateixeira.github.io`, UFPA-CAMTUC-FEE), publicado em
<https://raphateixeira.github.io/Notas/>, linkado a partir da aba **Notas** da barra de
navegação principal. Formato canônico: Quarto (`quarto render`, `execute.freeze: auto`).
Tema visual: `TemaRTx.scss` (idêntico ao usado por TikZ, Manim, DeepLearning,
MetodosNumericos, ControleEstados, DataDrivenControl — não inventar paleta própria).

Tem dois tipos de conteúdo: **Fundamentos** (links para um repositório por tema),
**Livros** (uma pasta por livro, neste repositório, com slides e notas complementares).

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
  `fade`). Modelo completo: `chan-probabilidade/Cap01MathBack.qmd`.
- `imgs/` (opcional) — figuras do livro usadas nos slides (referenciadas como `imgs/…`).

Livros atuais: `chan-probabilidade`, `brunton-otimizacao`, `brunton-kutz-data-driven`,
`bishop-deep-learning`, `strang-linear-algebra`, `ventura-geometria-diferencial`,
`larson-calculo-multivariavel`, `hasan-advanced-control-power-converters`.

Ao adicionar um livro novo: criar a pasta e o `index.qmd`; adicionar a entrada em
`referencias.bib`; adicionar o item no menu **Livros** de `_quarto.yml` e a linha na tabela
de `index.qmd`. Escreva apenas o que foi de fato lido — nunca invente numeração de
teorema, equação ou resumo de capítulo.

Notas conceituais de Deep Learning ficam aqui (`bishop-deep-learning/`); implementações de
código substanciais vão para o satélite
[DeepLearning](https://raphateixeira.github.io/DeepLearning/).

## Fundamentos (temas, não livros)

A seção **Fundamentos** de `index.qmd` lista temas de estudo (não livros), cada um
apontando para um repositório dedicado com o material (esse material é reusado em várias
disciplinas/projetos: `Identificacao` é referenciado por ControleCC2CC, ControleDFIG,
DataDrivenControl, Projeto-Aeropendulo, MScOseias).

- Identificação de Sistemas → [Identificacao](https://raphateixeira.github.io/Identificacao/)
- Controle Linear → repositório ainda não criado
- Controle MPC → repositório ainda não criado
- Conversores de Energia → repositório ainda não criado

Ao criar o repositório de um novo tema, atualizar o link em `index.qmd` (e tirar o "em
construção").

## Notas complementares (dentro da pasta do livro)

Uma nota que aprofunda um tema ligado a um livro (não um capítulo dele) fica **na pasta do
livro**, como artigo HTML, listada em "Notas complementares" no `index.qmd` do livro. Não
existe pasta genérica de notas soltas: toda nota se associa a um livro (por tema) ou vira
tema de Fundamentos. Ex.: `brunton-otimizacao/MPCMassaMolaAmortecedor.qmd`,
`bishop-deep-learning/RedesNeuraisAproximador.qmd`. Front matter:

```yaml
---
title: "Título da nota"
description: "Uma frase sobre o que a nota cobre."
author: "Raphael Teixeira"
date: "AAAA-MM-DD"
date-modified: last-modified
categories: [Categoria1, Categoria2, Python]
livro: "Autor — Título do livro"
autor-livro: "Nome do Autor"
status: rascunho        # rascunho | revisão | consolidada — exatamente um destes três
lang: pt-BR
---
```

Para criar: copie `_templates/nota-modelo.qmd` para a pasta do livro, preencha o front
matter e nomeie o arquivo `Assunto.qmd`. Rode `quarto preview` antes de publicar.

## Não versionar

`_site/`, `.quarto/`, `__pycache__/`, `.ipynb_checkpoints/`, `Livros/` e qualquer
`*.pdf`/`*.epub`/`*.djvu`.
