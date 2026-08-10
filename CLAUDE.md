# CLAUDE.md

Contexto para sessões futuras do Claude Code neste repositório.

## O que é este repositório

`Notas` é um satélite do hub acadêmico do Prof. Dr. Raphael Teixeira
(`raphateixeira.github.io`, UFPA-CAMTUC-FEE), publicado em
<https://raphateixeira.github.io/Notas/>. É um **repositório único de notas de leitura**,
organizado por livro. Formato canônico: Quarto (`quarto render`, `execute.freeze: auto`).
Tema visual: `TemaRTx.scss` (idêntico ao usado por TikZ, Manim, DeepLearning,
MetodosNumericos, ControleEstados, DataDrivenControl — não inventar paleta própria).

## Regra central: pasta, não repositório

Cada livro é uma **pasta** neste repositório (`chan-probabilidade/`,
`brunton-otimizacao/`, etc.), nunca um repositório Git separado. A separação lógica é
feita por metadados de front matter (`categories`, `livro`, `autor-livro`, `capitulo`) e
pelos *listings* do Quarto (`index.qmd` de cada pasta), não por isolamento de repositório.

**Critério de promoção a satélite próprio:** só crie um repositório dedicado para um livro
quando houver (a) código executável substancial e reutilizável (não apenas os blocos de
demonstração de uma nota), ou (b) reuso direto do material em uma disciplina (aulas,
avaliações). Notas de leitura, por si só, permanecem aqui. O caso já resolvido é
`bishop-deep-learning/`: as notas conceituais ficam aqui; implementações substanciais vão
para o satélite [DeepLearning](https://raphateixeira.github.io/DeepLearning/).

## Convenção de front matter

```yaml
---
title: "Título da nota"
subtitle: "Capítulo N — Assunto"
description: "Uma frase sobre o que a nota cobre."
author: "Raphael Teixeira"
date: "AAAA-MM-DD"
date-modified: last-modified
categories: [Categoria1, Categoria2, Python]
livro: "Autor — Título do livro"
autor-livro: "Nome do Autor"
capitulo: N
status: rascunho        # rascunho | revisão | consolidada — exatamente um destes três
lang: pt-BR
---
```

Notas em `avulsas/` (sem livro associado) omitem `livro`, `autor-livro` e `capitulo`.

## Criar uma nova nota

1. Copie `_templates/nota-modelo.qmd` para a pasta do livro correspondente (ou para
   `avulsas/` se não pertencer a um livro específico).
2. Preencha o front matter (veja convenção acima) e o nome do arquivo seguindo o padrão
   `NN-assunto.qmd` (numeração de dois dígitos, na ordem dos capítulos).
3. Escreva o conteúdo apenas do que você efetivamente leu/entendeu — nunca invente
   numeração de teorema, equação ou resumo de capítulo que não foi lido.
4. Rode `quarto preview` para conferir antes de publicar.

## Livros ativos

| Pasta | Livro | Autores |
|---|---|---|
| `chan-probabilidade` | Introduction to Probability for Data Science (2ª ed., 2026) | Stanley H. Chan |
| `brunton-otimizacao` | Optimization: A Bootcamp for ML, Inverse Problems, and Control (2026) | Steven L. Brunton |
| `brunton-kutz-data-driven` | Data-Driven Science and Engineering (2ª ed., 2022) | Steven L. Brunton, J. Nathan Kutz |
| `bishop-deep-learning` | Deep Learning: Foundations and Concepts (2024) | Christopher M. Bishop, Hugh Bishop |
| `ventura-geometria-diferencial` | Differential Geometry (Springer, 2024; trad. de *Geometria Diferencial*, IMPA, 1998) | Paulo Ventura Araújo |
| `larson-calculo-multivariavel` | Calculus: Multivariable (Cengage Learning) | Ron Larson |

Ao adicionar um livro novo: criar a pasta, o `index.qmd` filtrado, atualizar o menu
"Livros" em `_quarto.yml`, a tabela em `estante.qmd` e esta lista.

## Não versionar

`_site/`, `.quarto/`, `__pycache__/`, `.ipynb_checkpoints/`, e `Livros/` (PDFs dos livros —
material com direitos autorais, mantido apenas localmente).
