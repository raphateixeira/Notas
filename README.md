# Notas

Hub de notas de fundamentação teórica por tema de estudo, publicado em
<https://raphateixeira.github.io/Notas/>. Satélite do hub acadêmico
[raphateixeira.github.io](https://raphateixeira.github.io), linkado a partir da barra de
navegação principal (aba **Notas**).

Cada tema com material suficiente ganha um **repositório próprio** (ex.: identificação de
sistemas → [Identificacao](https://raphateixeira.github.io/Identificacao/)); este
repositório apenas organiza os links, na seção "Fundamentos" de `index.qmd`. Notas de
leitura de livros-texto vivem em repositórios próprios (`LivroXXX`), listados em
[Referências](https://raphateixeira.github.io/Referencias/) no site principal — não aqui.

## Estrutura

- `index.qmd` — seção "Fundamentos": um link por tema de estudo.
- `avulsas/` — notas pontuais que não pertencem a nenhum tema consolidado.
- `_templates/nota-modelo.qmd` — template para iniciar uma nova nota avulsa.

## Uso local

```bash
quarto render
quarto preview
```

Requer Quarto ≥ 1.9 e Python (ambiente conda/Miniforge com `requirements.txt` instalado).

## Publicação

`.github/workflows/publish.yml` renderiza e publica via GitHub Pages a cada push em
`main`, usando o workflow reutilizável `raphateixeira/.github`.
