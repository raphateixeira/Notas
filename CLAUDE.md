# CLAUDE.md

Contexto para sessões futuras do Claude Code neste repositório.

## O que é este repositório

`Notas` é um satélite do hub acadêmico do Prof. Dr. Raphael Teixeira
(`raphateixeira.github.io`, UFPA-CAMTUC-FEE), publicado em
<https://raphateixeira.github.io/Notas/>, linkado a partir da aba **Notas** da barra de
navegação principal. Formato canônico: Quarto (`quarto render`, `execute.freeze: auto`).
Tema visual: `TemaRTx.scss` (idêntico ao usado por TikZ, Manim, DeepLearning,
MetodosNumericos, ControleEstados, DataDrivenControl — não inventar paleta própria).

**Não é** o lugar para notas de leitura de livros-texto — essas vivem em repositórios
próprios (`LivroXXX`), listados em
[Referências](https://raphateixeira.github.io/Referencias/) no site principal. Esse era o
propósito original deste repositório (pastas por livro); foi descontinuado porque cada
livro passou a ter seu próprio repositório desde o início. Se você encontrar uma pasta de
livro aqui de novo, é resíduo — mova para o `LivroXXX` correspondente e remova daqui.

## Regra central: Fundamentos, por tema, um repositório por tema

Este repositório é um **hub de links**: `index.qmd` tem uma seção **Fundamentos** listando
temas de estudo (não livros), cada um apontando para um repositório dedicado que contém o
material de fato. Diferente de um livro específico, um tema de fundamentação **é** um
repositório próprio desde o início, porque esse material é reusado diretamente em várias
disciplinas/projetos de pesquisa (ex.: `Identificacao` é referenciado por ControleCC2CC,
ControleDFIG, DataDrivenControl, Projeto-Aeropendulo, MScOseias).

Temas definidos (ver `index.qmd` para o estado atual de cada um):

- Identificação de Sistemas → [Identificacao](https://raphateixeira.github.io/Identificacao/)
- Controle Linear → repositório ainda não criado
- Controle MPC → repositório ainda não criado
- Conversores de Energia → repositório ainda não criado

Ao criar o repositório de um novo tema, atualizar o link correspondente em `index.qmd` (e
tirar o "em construção").

## Avulsas

`avulsas/` guarda notas pontuais que não pertencem a nenhum tema consolidado de
Fundamentos — artigos, materiais avulsos, fundamentações que surgiram de outras leituras.
Front matter:

```yaml
---
title: "Título da nota"
description: "Uma frase sobre o que a nota cobre."
author: "Raphael Teixeira"
date: "AAAA-MM-DD"
date-modified: last-modified
categories: [Categoria1, Categoria2, Python]
status: rascunho        # rascunho | revisão | consolidada — exatamente um destes três
lang: pt-BR
---
```

Para criar uma nova nota avulsa: copie `_templates/nota-modelo.qmd` para `avulsas/`,
preencha o front matter acima e nomeie o arquivo `assunto.qmd`. Escreva apenas o que você
efetivamente leu/entendeu — nunca invente numeração de teorema, equação ou resumo que não
foi lido. Rode `quarto preview` antes de publicar.

Se uma nota avulsa amadurecer até formar um tema consolidado com reuso em outras
disciplinas/projetos, ela segue o mesmo caminho de promoção: vira (ou entra em) um
repositório próprio, e ganha uma entrada na seção Fundamentos.

## Não versionar

`_site/`, `.quarto/`, `__pycache__/`, `.ipynb_checkpoints/`.
