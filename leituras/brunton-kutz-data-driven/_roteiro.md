# Roteiro das notas — Brunton & Kutz, *Data-Driven Science and Engineering*


- **Livro:** Steven L. Brunton, J. Nathan Kutz — *Data-Driven Science and Engineering: Machine
  Learning, Dynamical Systems, and Control*, 2ª ed., Cambridge University Press, 2022.
- **PDF local:** `Livros/Brunton-Kutz_DataDrivenScienceAndEngineering.pdf` (nunca versionar).
  Página do PDF = página do livro + 26.
- **Convenções dos slides:** `title:` = título da nota; `subtitle:` = `"<seções> - Brunton:
  Data-Driven Science and Engineering"`; sem sumário, slides de seção, resumo ou referências
  (ver `CLAUDE.md`). Figuras do livro vão em `imgs/` (`FigXpY_<Descricao>.png`, recortadas do
  PDF); o PDF não. Slides densos usam `{.small-slide}`.
- **Exemplos:** o livro puxa muito para dinâmica dos fluidos (área do Brunton). Nos slides,
  trocar por exemplos de sistemas LIT: controle, identificação de sistemas, resposta em
  frequência, sinais medidos em plantas.
- **Códigos:** como no livro, cada slide de código tem abas **Python** (executa no render) e
  **MATLAB** (só exibido; testado no MATLAB R2025a local antes de entrar no slide). Vários exemplos usam dados do repositório do livro (`DATA/…`), que não estão aqui:
  para cada um, decidir entre obter os dados ou trocar por um exemplo equivalente.

## Visão geral

| Nota | Seções | Páginas | Arquivo | Estado |
|---|---|---|---|---|
| 1 | 1.1–1.2 | 3–14 | `01-SVDAproximacaoMatrizes.qmd` | escrita (17 slides) |
| 2 | 1.3 | 14–19 | — | prevista |
| 3 | 1.4 | 19–27 | — | prevista |
| 4 | 1.5–1.6 | 27–41 | — | prevista (ver observação) |
| 5 | 1.7 | 41–48 | — | prevista |
| 6 | 1.8 | 48–55 | — | prevista |
| 7 | 1.9 | 55–60 | — | prevista |
| 8 | 2.1 | 64–76 | — | prevista |
| 9 | 2.2 | 76–85 | — | prevista |
| 10 | 2.3 | 85–91 | — | prevista |
| 11 | 2.4–2.5 | 91–102 | — | prevista |
| 12 | 2.6–2.7 | 102–113 | — | prevista |
| 13 | 3.1–3.2 | 118–128 | — | prevista |
| 14 | 3.3–3.4 | 128–137 | — | prevista |
| 15 | 3.5–3.6 | 137–145 | — | prevista |
| 16 | 3.7–3.8 | 145–154 | — | prevista |

---

## Capítulo 1 — Singular Value Decomposition (SVD)

### Nota 1 — 1.1–1.2 SVD e aproximações de matrizes ✅

**Livro.** §1.1 *Overview* (Definition of the SVD; Computing the SVD; Historical Perspective;
Uses in This Book) e §1.2 *Matrix Approximation* (Optimal Approximation and Error Bounds;
Example: Image Compression). Eqs. (1.1)–(1.11), Teorema 1.1 (Eckart–Young), Figs. 1.1–1.4,
Código 1.1.

**Slides feitos:**

1. Alta dimensão, poucos padrões (motivação), ilustrado com a foto de uma
   revoada (`imgs/RevoadaEstorninhos.jpg`, Stockcake; não é do livro)
2. A mesma ideia em identificação de sistemas (**não está no livro**): PRBS → G(z) → y com
   500 amostras; Ho–Kalman/ERA (resposta ao impulso por MQ → Hankel 25×25 → SVD) mostra 2
   valores singulares dominantes = ordem 2 = 2 polos; figura gerada em Python no próprio deck
3. Por que a SVD (estável, hierárquica, existe sempre; SVD × FFT; usos no livro)
4. A matriz de dados — Eq. (1.1) com a 1ª parte da Fig. 1.17 (rostos como colunas), *snapshots*, *tall-skinny*
5. Definição da SVD — quadro de Definição, Eq. (1.2)
6. SVD completa e SVD econômica — Eq. (1.3) e Fig. 1.1
7. Computando a SVD — bidiagonalização + Golub–Kahan; `np.linalg.svd` / `svd` (abas Python e MATLAB)
8. Soma diádica — Eq. (1.4) com a Fig. 1.29(a) (soma de produtos externos)
9. SVD truncada — Eq. (1.5) e Fig. 1.2
10. Teorema de Eckart–Young — quadro de Teorema, Eq. (1.6), norma de Frobenius
11. Erro na norma de Frobenius — Eqs. (1.7)–(1.8) e interpretações (energia, variância)
12. Aproximação ótima na norma 2 — Eqs. (1.9)–(1.11)
13. Verificação numérica das expressões de erro (**não está no livro**: confere (1.7) e (1.10))
14. Exemplo: compressão de imagem — código
15. Imagem reconstruída para r = 5, 20, 100 (equivalente à Fig. 1.3)
16. Valores singulares e soma acumulada (equivalente à Fig. 1.4) + erro relativo (1.8)

**Decisões.** A foto do livro (Mordecai, 2000 × 1500, de `DATA/dog.jpg`) foi trocada pela foto
de Grace Hopper que acompanha o matplotlib (600 × 512), para rodar sem baixar dados. Figs. 1.1
e 1.2 recortadas do PDF para `imgs/`; também a 1ª parte da Fig. 1.17 (§1.6) e a Fig. 1.29(a)
(§1.9), antecipadas porque ilustram bem a matriz de dados e a soma diádica.

### Nota 2 — 1.3 Propriedades matemáticas e manipulações

**Livro (p. 14–19).** Interpretation as Dominant Correlations; Method of Snapshots;
Generalization of the Eigendecomposition; Geometric Interpretation; Invariance of the SVD to
Unitary Transformations. Figs. 1.5–1.8 (matrizes de correlação XX\* e X\*X; imagem geométrica
da SVD como um mapeamento de uma esfera em Rⁿ).

### Nota 3 — 1.4 Pseudoinversa, mínimos quadrados e regressão

**Livro (p. 19–27).** Pseudoinversa e solução de Ax = b; Condition Number; One-Dimensional
Linear Regression; Multi-linear Regression. Figs. 1.9–1.12; Códigos 1.2 (ajuste de dados
ruidosos) e 1.3 (regressão multilinear dos dados de calor do cimento).
**Dados:** Código 1.3 usa os dados de cimento; a Fig. 1.11 usa preços de imóveis.

### Nota 4 — 1.5–1.6 Análise de componentes principais (PCA) e o exemplo eigenfaces

**Livro (p. 27–41).** §1.5 PCA: Computation; Example: Noisy Gaussian Data; Example: Ovarian
Cancer Data. §1.6 Eigenfaces Example. Figs. 1.13–1.21; Códigos 1.4–1.9.
**Dados:** câncer de ovário (Código 1.5) e base de rostos Yale (Códigos 1.6–1.9).
**Observação:** são ~14 páginas e dois exemplos grandes; considerar dividir em duas notas
(1.5 PCA e 1.6 eigenfaces).

### Nota 5 — 1.7 Truncamento e alinhamento

**Livro (p. 41–48).** Optimal Hard Threshold; Importance of Data Alignment. Figs. 1.22–1.26;
Código 1.10 (comparação de limiares em matriz de posto baixo com ruído).

### Nota 6 — 1.8 SVD randomizada

**Livro (p. 48–55).** Randomized Linear Algebra; Randomized SVD Algorithm; Example of
Randomized SVD. Figs. 1.27–1.28; Códigos 1.11 (algoritmo) e 1.12 (imagem de alta resolução).

### Nota 7 — 1.9 Decomposições tensoriais e arranjos de dados N-dimensionais

**Livro (p. 55–60).** SVD × decomposição tensorial; exemplo com a função (1.58). Figs.
1.29–1.31; Códigos 1.13 (cria o tensor) e 1.14 (modelo de dois fatores).

---

## Capítulo 2 — Fourier and Wavelet Transforms

### Nota 8 — 2.1 Séries e transformadas de Fourier

**Livro (p. 64–76).** Inner Products of Functions and Vectors; Fourier Series; Fourier
Transform. Figs. 2.1–2.7 (inclui o fenômeno de Gibbs, Fig. 2.5); Código 2.1 (série de Fourier
da função chapéu).

### Nota 9 — 2.2 Transformada discreta de Fourier (DFT) e FFT

**Livro (p. 76–85).** Discrete Fourier Transform; Fast Fourier Transform; FFT Example: Noise
Filtering; FFT Example: Spectral Derivatives. Figs. 2.8–2.12; Códigos 2.2 (matriz da DFT),
2.3 (filtragem de ruído) e 2.4 (derivadas espectrais).

### Nota 10 — 2.3 Transformando equações diferenciais parciais

**Livro (p. 85–91).** Heat Equation; One-Way Wave Equation; Burgers' Equation. Figs.
2.13–2.18; Códigos 2.5–2.8.

### Nota 11 — 2.4–2.5 Transformada de Gabor, espectrograma e transformada de Laplace

**Livro (p. 91–102).** §2.4: Discrete Gabor Transform; Example: Quadratic Chirp; Example:
Beethoven's Sonata Pathétique; Uncertainty Principles. §2.5 Laplace Transform. Figs.
2.19–2.25; Códigos 2.9 (chirp) e 2.10 (Beethoven).
**Dados:** Código 2.10 usa a gravação da Sonata Pathétique.

### Nota 12 — 2.6–2.7 Wavelets, análise multirresolução e transformadas bidimensionais

**Livro (p. 102–113).** §2.6: Discrete Wavelet Transform (Haar). §2.7: Two-Dimensional
Fourier Transform for Images; Two-Dimensional Wavelet Transform for Images. Figs. 2.26–2.31;
Códigos 2.11–2.14 (compressão e remoção de ruído de imagem via FFT e wavelets).

---

## Capítulo 3 — Sparsity and Compressed Sensing

### Nota 13 — 3.1–3.2 Esparsidade, compressão e compressed sensing

**Livro (p. 118–128).** §3.1: Example: Image Compression; Why Signals Are Compressible: the
Vastness of Image Space. §3.2: Compressed Sensing; Disclaimer; Alternative Formulations.
Figs. 3.1–3.6; Código 3.1 (compressão via FFT).

### Nota 14 — 3.3–3.4 Exemplos de compressed sensing e a geometria da compressão

**Livro (p. 128–137).** §3.3: The ℓ1-norm and Sparse Solutions to an Under-determined System;
Recovering an Audio Signal from Sparse Measurements. §3.4: normas ℓp; The Restricted Isometry
Property (RIP); Incoherence and Measurement Matrices; Bad Measurements. Figs. 3.7–3.12;
Códigos 3.2 (ℓ1 × ℓ2 em sistema subdeterminado) e 3.3 (sinal de dois tons).

### Nota 15 — 3.5–3.6 Regressão esparsa e representação esparsa

**Livro (p. 137–145).** §3.5: Outlier Rejection and Robustness; Feature Selection and LASSO
Regression. §3.6: Sparse Representation (classificação). Figs. 3.13–3.19; Código 3.4
(regressão robusta com ℓ1).
**Dados:** §3.6 usa a base de rostos Yale.

### Nota 16 — 3.7–3.8 PCA robusta (RPCA) e posicionamento esparso de sensores

**Livro (p. 145–154).** §3.7: RPCA pelo método de direções alternadas (ADM). §3.8: Sparse
Sensor Placement for Reconstruction (sensores por QR); Sparse Classification (SSPOC).
Figs. 3.20–3.24; Código 3.5 (RPCA).
**Dados:** Fig. 3.20 usa a base Yale B.
