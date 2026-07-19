# DataDrivenControl

Notas de pesquisa sobre **Controle Baseado em Dados** (Data-Driven Control):
projeto de controladores e identificação de dinâmicas diretamente a partir de
dados experimentais, sem depender de um modelo matemático completo da planta.
Site Quarto com apresentações em slides (Reveal.js), páginas de artigo por
subtema e um portal de navegação (HTML), organizado por subtema de pesquisa.

## Estrutura

```
DataDrivenControl/
├── _quarto.yml                 configuração do site, navbar e bibliografia
├── TemaRTx.scss                 tema único (paleta, slides e páginas HTML)
├── index.qmd                    portal com os links dos subtemas
├── Referencias.bib              bibliografia citável com @chave (10+ refs. por subtema)
├── apa.csl                      estilo de citação
├── .github/workflows/
│   └── publish.yml                CI: renderiza e publica em GitHub Pages
├── imgs/
│   ├── ufpa-colorido.png, ufpa-preto.png, ufpa-branco.png   brasão UFPA
│   └── tikz/                       diagramas em TikZ, compartilhados entre os subtemas
├── DeePC/
│   ├── index.qmd                   sub-portal: Nota + apresentações
│   ├── DeePCNota.qmd                artigo de referência (formato texto)
│   ├── DeePC01Introducao.qmd        apresentação: Lema de Willems, formulação
│   └── DeePC02Regularizacao.qmd     apresentação: ruído e regularização (Python)
├── Koopman/
│   ├── index.qmd
│   ├── KoopmanNota.qmd
│   ├── Koopman01Introducao.qmd      apresentação: definição, DMD, EDMD
│   └── Koopman02EDMDPratica.qmd     apresentação: EDMD na prática (Python)
├── SINDy/
│   ├── index.qmd
│   ├── SINDyNota.qmd
│   ├── SINDy01Introducao.qmd        apresentação: formulação, STLSQ, extensões
│   └── SINDy02STLSQPratica.qmd      apresentação: Lotka–Volterra em Python
├── RL/
│   ├── index.qmd
│   ├── RLNota.qmd
│   ├── RL01Introducao.qmd           apresentação: MDPs, Bellman, Q-learning
│   └── RL02QLearningControle.qmd    apresentação: Q-learning vs. LQR (Python)
└── DataGuidedControl/
    └── ControleGuiadoPorDados.qmd   apresentação-síntese: como as quatro técnicas se conectam
```

Cada subtema segue o mesmo padrão: um sub-portal (`index.qmd`) que lista a
**Nota** (artigo de referência, estilo enciclopédico, formato `html`) e as
**apresentações** (slides Reveal.js). O portal raiz (`index.qmd`) linka para
os sub-portais, não diretamente para uma apresentação.

`DataGuidedControl/` foge um pouco desse padrão: é uma única apresentação de
panorama (sem Nota nem sub-portal, por ora), que soma as quatro técnicas num
mesmo quadrante (direto/indireto × linear/não linear) e liga de volta para
cada uma. Acessível pelo item "Panorama" da navbar.

## Exemplos em Python nas apresentações

As apresentações "02" de cada subtema incluem um exemplo mínimo executável em
Python (chunks `{python}`), reproduzido de verdade a cada render — não são
apenas trechos ilustrativos. Isso é possível mesmo com `engine: knitr`
(necessário para os diagramas TikZ) porque cada `.qmd` com Python inclui um
chunk de configuração no início:

```r
reticulate::use_python(Sys.which("python3"), required = TRUE)
```

que aponta o `reticulate` para o `python3` do `PATH` (local ou do runner de
CI), em vez de deixar o `reticulate` provisionar um Python isolado sem os
pacotes necessários.

## Como adicionar um subtema ou apresentação

1. Crie uma pasta no nível raiz para o novo subtema (ex.: `MFAC/`), com
   `index.qmd` (sub-portal) e `<Tema>Nota.qmd` (artigo), seguindo os
   existentes como modelo; ou adicione um novo `.qmd` a uma pasta existente
   (ex.: `DeePC/DeePC03Aplicacoes.qmd`).
2. Copie o cabeçalho YAML de um `.qmd` existente — aponta para
   `../TemaRTx.scss`, para o brasão em `../imgs/ufpa-colorido.png`, e usa
   `center: false` (título sempre no topo do slide — ver nota no `TemaRTx.scss`).
3. Adicione a entrada correspondente no menu `Métodos` em `_quarto.yml`
   (apontando para o `index.qmd` do subtema), no bloco `render:`, e um card
   no `index.qmd` do subtema (e no `index.qmd` raiz, se for um subtema novo).
4. Diagramas TikZ ficam em `imgs/tikz/`, nomeados por subtema (ex.:
   `EsquemaDeePC.tikz`).
5. Ao citar uma referência nova, adicione-a em `Referencias.bib` na seção do
   subtema correspondente (marcada com `%% ===== TEMA — ... =====`).

## Renderização

Dentro da pasta do projeto:

```bash
quarto preview      # servidor local com navegação
quarto render       # gera o site em _site/
```

### Pré-requisitos

- **Quarto** instalado.
- **LaTeX** para os diagramas TikZ: `quarto install tinytex` (ou TeX Live com `pgf`/`tikz`).
- Pacote **R `magick`** (o engine TikZ converte PDF→PNG por meio dele) e
  **`reticulate`** (para os chunks Python):
  ```r
  install.packages(c("magick", "reticulate"))
  ```
- **Python 3** com `numpy`, `scipy` e `matplotlib` no `PATH` (basta o
  ambiente padrão — os exemplos evitam dependências mais pesadas como
  `pysindy`/`cvxpy`, implementando os algoritmos diretamente).

### Observações sobre os chunks TikZ

- As opções de um chunk ```` ```{tikz} ```` começam com `%|` (comentário LaTeX), **não** com `#|`.
- Carregue as bibliotecas TikZ necessárias no próprio chunk, com `\usetikzlibrary{...}`, antes do `\input`.
