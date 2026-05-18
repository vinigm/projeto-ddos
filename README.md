# Detecção de Anomalias de Rede com Machine Learning — CICIDS-2017

Trabalho prático da disciplina **CMP263 — Aprendizagem de Máquina** (PPGC/UFRGS, 2026/1, Profa. Mariana Recamonde Mendoza).

**Pergunta de pesquisa:** Quais algoritmos de ML apresentam melhor desempenho na detecção de tráfego malicioso no CICIDS-2017, considerando o desbalanceamento severo de classes, e quais *features* mais contribuem para essa detecção?

**Tarefa:** Classificação binária (BENIGN vs ATTACK).

---

## Estrutura do repositório

```
.
├── README.md                        ← este arquivo
├── DOCKER.md                        ← como rodar o experimento com Docker
├── Dockerfile
├── docker-compose.yml
├── .dockerignore
├── requirements.txt                 ← dependências Python (versões fixadas)
├── .gitignore
├── artifacts/                       ← cache de modelos, scores e SHAP (ver artifacts/README.md)
├── projeto/
│   ├── readme.txt
│   ├── códigos/
│   │   └── notebook_completo.ipynb  ← pipeline completo
│   └── archive/
│       ├── eda_*.png                ← figuras de EDA (geradas pelo notebook)
│       └── interp_*.png             ← figuras de interpretabilidade (SHAP, Gini)
└── artigo/                       ← artigo científico (em construção)
```

**Não versionados** (ver `.gitignore`): CSVs do CICIDS-2017 (~880 MB), `raw_limpo.parquet` (234 MB), PDFs com copyright e ambiente virtual.

---

## Reprodutibilidade

### Docker (plug and play)

Para subir **Jupyter Lab** em container (Python 3.11 e dependências fixadas), sem configurar Python no host, siga o guia **[DOCKER.md](DOCKER.md)**.

### 1. Pré-requisitos

- **Python 3.10 ou superior** (testado em 3.14.4). Python 3.9 ou inferior **não funciona** — versões modernas de pandas/numpy/sklearn não têm wheels pra essas versões antigas.
- macOS, Linux ou WSL2
- ~3 GB de espaço livre (para os dados brutos)

> ⚠️ **macOS — atenção ao Python do sistema:** O Python que vem com o Xcode Command Line Tools costuma ser 3.9. Se você nunca instalou Python explicitamente, é muito provável que esse seja o seu. Verifique com `python3 --version`. Se for < 3.10, instale uma versão nova:
> ```bash
> brew install python@3.11
> python3.11 -m venv .venv
> source .venv/bin/activate
> ```
> A célula de setup do notebook detecta Python antigo e mostra essa orientação automaticamente.

### 2. Clonar o repositório

```bash
git clone https://github.com/vinigm/projeto-ddos.git
cd projeto-ddos
```

### 3. Criar ambiente virtual

```bash
python3 -m venv .venv
source .venv/bin/activate          # macOS/Linux
# .venv\Scripts\activate           # Windows
```

> 💡 As dependências são instaladas **automaticamente** pela primeira célula do notebook (chama `pip install -r requirements.txt` por baixo). Se preferir instalar manualmente antes, rode `pip install -r requirements.txt`.

### 4. Obter os dados

Existem **dois caminhos**, escolha conforme seu interesse:

#### 🟢 Caminho rápido — apenas o pipeline de ML (recomendado)

O notebook **baixa automaticamente** o dataset pré-processado (`raw_limpo.parquet`, 224 MB) do [release v1.0](https://github.com/vinigm/projeto-ddos/releases/tag/v1.0) na primeira execução. Você não precisa fazer nada manualmente.

#### 🟡 Caminho completo — regenerar o parquet desde os CSVs originais

Útil se você quiser auditar também a etapa de limpeza. Baixe os 8 CSVs do CICIDS-2017 da [fonte oficial UNB](https://www.unb.ca/cic/datasets/ids-2017.html) (pasta `GeneratedLabelledFlows`):

- `Monday-WorkingHours.pcap_ISCX.csv`
- `Tuesday-WorkingHours.pcap_ISCX.csv`
- `Wednesday-workingHours.pcap_ISCX.csv`
- `Thursday-WorkingHours-Morning-WebAttacks.pcap_ISCX.csv`
- `Thursday-WorkingHours-Afternoon-Infilteration.pcap_ISCX.csv`
- `Friday-WorkingHours-Morning.pcap_ISCX.csv`
- `Friday-WorkingHours-Afternoon-DDos.pcap_ISCX.csv`
- `Friday-WorkingHours-Afternoon-PortScan.pcap_ISCX.csv`

Coloque todos em `projeto/archive/`.

### 5. Executar o pipeline

```bash
jupyter notebook projeto/códigos/notebook_completo.ipynb
```

- **Caminho rápido:** vá até a seção **"Pós EDA"** e use **"Run All Below"** (ou clique com o botão direito → "Run from this cell"). O parquet será baixado automaticamente e o pipeline de ML rodará.
- **Caminho completo:** use **"Run All"** desde o início. Requer os 8 CSVs em `projeto/archive/`.

O notebook é determinístico: `random_state=42` está fixo em toda fonte de aleatoriedade (split, K-Fold, modelos, RandomizedSearch, amostragem SHAP).

### Sistema de cache (artifacts)

O notebook salva automaticamente em `artifacts/` os objetos mais caros (modelos treinados, scores de CV, melhores hiperparâmetros, valores SHAP). Veja [artifacts/README.md](artifacts/README.md) para detalhes.

| Cenário | Tempo |
|---|---|
| 1ª execução end-to-end (cache vazio) | ~6 horas (gargalo: Repeated Stratified K-Fold) |
| Execuções subsequentes (cache cheio) | ~1 minuto |
| Forçar recomputação (`RECOMPUTE=True`) | ~6 horas |

Os artefatos são commitados no repositório (com `joblib compress=3`), então um `git clone` já vem com tudo pronto.

---

## Metodologia (resumo)

| Etapa | Decisão |
|---|---|
| Formulação | Classificação binária (BENIGN vs ATTACK) |
| Limpeza | Remoção de inf/NaN, duplicatas, 8 features de variância zero, coluna duplicada `Fwd Header Length.1`, outliers via IQR |
| Redução de dimensionalidade | Remoção de features com correlação \|r\| ≥ 0.95 (resultado: 68 features) |
| Divisão | Holdout estratificado 80/20 (seed=42) |
| Balanceamento | `class_weight=balanced` (sem SMOTE) |
| Spot-checking | 5 algoritmos: Logistic Regression, Random Forest, Decision Tree, Hist Gradient Boosting, Gaussian Naive Bayes |
| Validação | Repeated Stratified K-Fold (10 folds × 3 repetições = 30 avaliações) |
| Teste estatístico | Friedman (omnibus) + Wilcoxon pareado com correção de Bonferroni |
| Otimização | `RandomizedSearchCV(n_iter=20)` nos dois melhores (RF e HGB), em amostra estratificada de 20% do treino |
| Métrica principal | F1 (classe positiva = ATTACK) |
| Métricas secundárias | Precision, Recall, ROC-AUC, Accuracy |
| Interpretabilidade | Feature Importance (Gini) + SHAP (beeswarm + dependence plots) |
