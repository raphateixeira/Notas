# CLAUDE.md

Contexto para sessões futuras do Claude Code neste repositório.

## O que é este repositório

`Code` é um satélite do hub acadêmico do Prof. Dr. Raphael Teixeira
(`raphateixeira.github.io`, UFPA-CAMTUC-FEE), publicado em
<https://raphateixeira.github.io/Code/>. É um **repositório único de estudo de
linguagens de programação e seus pacotes**, organizado por linguagem. Formato canônico:
Quarto (`quarto render`, `execute.freeze: auto`). Tema visual: `TemaRTx.scss` (idêntico
ao usado por Notas, TikZ, Manim, DeepLearning, MetodosNumericos, ControleEstados,
DataDrivenControl — não inventar paleta própria).

## Regra central: pasta, não repositório

Cada linguagem é uma **pasta** neste repositório (`python/`, `julia/`, `r/`,
`matlab/`), nunca um repositório Git separado. A separação lógica é feita por metadados
de front matter (`categories`, `linguagem`, `ordem`) e pelos *listings* do Quarto
(`index.qmd` de cada pasta), não por isolamento de repositório.

**Critério de promoção a satélite próprio:** só crie um repositório dedicado quando
houver (a) código executável substancial e reutilizável ligado a um projeto ou linha de
pesquisa específica (não apenas exemplos de sintaxe/pacote), ou (b) reuso direto do
material em uma disciplina (aulas, avaliações). Estudo de linguagem e de pacotes, por si
só, permanece aqui.

## Convenção de front matter

```yaml
---
title: "Título da nota"
subtitle: "Tópico — Assunto"
description: "Uma frase sobre o que a nota cobre."
author: "Raphael Teixeira"
date: "AAAA-MM-DD"
date-modified: last-modified
categories: [Categoria1, Categoria2]
linguagem: "Python"
ordem: N
status: rascunho        # rascunho | revisão | consolidada — exatamente um destes três
lang: pt-BR
---
```

Notas em `avulsas/` (não ligadas a uma linguagem específica — ex.: comparações entre
linguagens, ferramentas de ambiente, Git) omitem `linguagem` e `ordem`.

## Criar uma nova nota

1. Copie `_templates/nota-modelo.qmd` para a pasta da linguagem correspondente (ou para
   `avulsas/` se não pertencer a uma linguagem específica).
2. Preencha o front matter (veja convenção acima) e o nome do arquivo seguindo o padrão
   `NN-assunto.qmd` (numeração de dois dígitos, na ordem de estudo).
3. Rode `quarto preview` para conferir antes de publicar.

## Execução de código por linguagem

O workflow de publicação (`raphateixeira/.github/quarto-publish.yml`) só provisiona
runtimes para **Python** (`needs_python`) e **R** (`needs_r`) no GitHub Actions. Não há
runtime de Julia nem MATLAB no CI.

- Notas em `python/` e `r/` podem usar blocos executáveis normalmente
  (` ```{python} `, ` ```{r} `).
- Notas em `julia/` e `matlab/` devem usar blocos de código **não executados** (cerca
  simples, ex. ` ```julia ` ou ` ```matlab `, sem chaves) até que o autor renderize
  localmente com o runtime instalado e comite o cache de `_freeze/` correspondente. Sem
  isso, `quarto render` falha no CI por falta do engine.

## Linguagens ativas

| Pasta | Linguagem | Uso típico |
|---|---|---|
| `python` | Python | numpy, scipy, matplotlib, pandas — computação científica geral |
| `julia` | Julia | computação numérica de alta performance, EDOs, controle |
| `r` | R | estatística, visualização |
| `matlab` | MATLAB | controle, processamento de sinais, Simulink |

Ao adicionar uma linguagem nova: criar a pasta, o `index.qmd` filtrado, atualizar o menu
"Linguagens" em `_quarto.yml`, a tabela em `progresso.qmd` e esta lista.

## Não versionar

`_site/`, `.quarto/`, `__pycache__/`, `.ipynb_checkpoints/`, ambientes virtuais
(`.venv/`, `Manifest.toml`/`Project.toml` de scratch, `renv/`) e artefatos de execução
local do MATLAB.
