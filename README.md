# Notas

Notas de fundamentação teórica e de leitura de livros-texto, publicadas em
<https://raphateixeira.github.io/Notas/>. Satélite do hub acadêmico
[raphateixeira.github.io](https://raphateixeira.github.io), linkado a partir da barra de
navegação principal (aba **Notas**).

- **Fundamentos** (`fundamentos/`): um tema de estudo por pasta (identificação de sistemas,
  controle preditivo, controle digital, conversores de energia), sistematizado a partir das
  notas dos livros; quando o tema ganha volume, é promovido a repositório próprio.
- **Livros** (`leituras/`): notas de leitura em slides, **uma pasta por livro**; notas
  complementares sobre um tema do livro (ex.: MPC em `leituras/brunton-otimizacao/`) ficam
  na mesma pasta.

> **Este repositório é público. Nunca versione PDFs/ebooks dos livros** (direitos autorais).
> Eles ficam apenas localmente em `Livros/`, que está no `.gitignore` junto com `*.pdf`,
> `*.epub` e `*.djvu`. Veja [CLAUDE.md](CLAUDE.md).

## Estrutura

- `index.qmd` — cards de Fundamentos e de Livros (com capa).
- `fundamentos/<tema>/` — um tema: `index.qmd` (escopo, fontes, notas) e os slides do tema.
- `leituras/<autor>-<assunto>/` — um livro: `index.qmd` (página do livro) e um `.qmd` revealjs por
  capítulo/aula (`chan-probabilidade/`, `brunton-otimizacao/`, `brunton-kutz-data-driven/`,
  `bishop-deep-learning/`, `strang-linear-algebra/`, `ventura-geometria-diferencial/`,
  `larson-calculo-multivariavel/`, `hasan-advanced-control-power-converters/`,
  `ljung-system-identification/`, `pillonetto-regularized-system-identification/`).
- `imgs/` — logos da UFPA usados nos slides.
- `referencias.bib`, `abnt.csl` — bibliografia (uma entrada por livro) e estilo.
- `_templates/nota-modelo.qmd` — modelo de nota complementar de um livro (artigo HTML).

## Uso local

```bash
quarto render
quarto preview
```

Requer Quarto ≥ 1.9 e Python (ambiente conda/Miniforge com `requirements.txt` instalado).

## Publicação

`.github/workflows/publish.yml` renderiza e publica via GitHub Pages a cada push em
`main`, usando o workflow reutilizável `raphateixeira/.github`.
