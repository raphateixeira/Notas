# Code

Repositório único de estudo de linguagens de programação e seus pacotes, organizado por
linguagem, publicado em <https://raphateixeira.github.io/Code/>. Satélite do hub
acadêmico [raphateixeira.github.io](https://raphateixeira.github.io).

Cada linguagem é uma **pasta** (não um repositório separado); a separação lógica entre
linguagens é feita por metadados (`categories`, `linguagem`) e pelos *listings* do
Quarto — veja [CLAUDE.md](CLAUDE.md) para a convenção completa.

## Estrutura

- `index.qmd` — todas as notas, mais recentes primeiro.
- `progresso.qmd` — tabela de linguagens com status de estudo.
- `python/`, `julia/`, `r/`, `matlab/` — uma pasta por linguagem ativa.
- `avulsas/` — notas que não pertencem a uma linguagem específica (comparações,
  ferramentas de ambiente, Git).
- `_templates/nota-modelo.qmd` — template para iniciar uma nova nota.

## Uso local

```bash
quarto render
quarto preview
```

Requer Quarto ≥ 1.9 e Python (ambiente conda/Miniforge com `requirements.txt`
instalado). Notas em `julia/` e `matlab/` usam blocos de código ilustrativos, não
executados em CI — veja [CLAUDE.md](CLAUDE.md).

## Publicação

`.github/workflows/publish.yml` renderiza e publica via GitHub Pages a cada push em
`main`, usando o workflow reutilizável `raphateixeira/.github`.
