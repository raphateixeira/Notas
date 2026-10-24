# Koopman — códigos MATLAB

Scripts de estudo de Koopman/EDMD, vindos de `~/Pesquisa/ProjetoPowerMPC/Koopman` (2026-10-16).
Todos são autocontidos (funções locais no fim do arquivo).

| Script | Conteúdo | Nota relacionada |
|---|---|---|
| `Koopman01_MotorCC_Bilinear_MPC.m` | motor CC bilinear (Korda & Mezić, 2018, Sec. 8.2): DMDc × Koopman linear (RBF) × bilinear × polinomial na entrada, e MPC (requer Optimization Toolbox) | `Koopman04KoopmanMPC.qmd` |
| `Koopman02_VariedadeLenta.m` | sistema com variedade lenta: plano de fase, não linear × linearizado | `Koopman02EDMDPratica.qmd` |
| `Koopman03_VariedadeLenta_Entrada.m` | o mesmo sistema com entrada multinível | `Koopman02EDMDPratica.qmd` |
| `Koopman04_InversorLCL_EDMD_RBF.m` | inversor trifásico com filtro LCL em $dq$ via EDMD com RBFs e regularização de Tikhonov | ponte com o repositório `ControleVSI` |
