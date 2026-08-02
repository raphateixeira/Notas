# Notas

Repositório único de notas de leitura, organizado por livro, publicado em
<https://raphateixeira.github.io/Notas/>. Satélite do hub acadêmico
[raphateixeira.github.io](https://raphateixeira.github.io), linkado a partir da home
(seção "Coleções") e da aba **Estudos**.

Cada livro é uma **pasta** (não um repositório separado); a separação lógica entre
livros é feita por metadados (`categories`, `livro`) e pelos *listings* do Quarto — veja
[CLAUDE.md](CLAUDE.md) para a convenção completa.

## Estrutura

- `index.qmd` — todas as notas, mais recentes primeiro.
- `estante.qmd` — tabela de livros com status de leitura.
- `chan-probabilidade/`, `brunton-otimizacao/`, `brunton-kutz-data-driven/`,
  `bishop-deep-learning/` — uma pasta por livro ativo.
- `avulsas/` — notas que não pertencem a um livro específico.
- `_templates/nota-modelo.qmd` — template para iniciar uma nova nota.

## Uso local

```bash
quarto render
quarto preview
```

Requer Quarto ≥ 1.9 e Python (ambiente conda/Miniforge com `requirements.txt` instalado).

## Publicação

`.github/workflows/publish.yml` renderiza e publica via GitHub Pages a cada push em
`main`, usando o workflow reutilizável `raphateixeira/.github`.
