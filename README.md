# Detecção de Anomalias de Rede com Machine Learning — CICIDS-2017

Trabalho prático da disciplina **CMP263 — Aprendizagem de Máquina** (PPGC/UFRGS, 2026/1, Profa. Mariana Recamonde Mendoza).

**Pergunta de pesquisa:** Quais algoritmos de ML apresentam melhor desempenho na detecção de tráfego malicioso no CICIDS-2017, considerando o desbalanceamento severo de classes, e quais *features* mais contribuem para essa detecção?

**Tarefa:** Classificação binária (BENIGN vs ATTACK).

---

## Estrutura do repositório

```
.
├── README.md                        ← este arquivo
├── requirements.txt                 ← dependências Python (versões fixadas)
├── .gitignore
├── opcao2/
│   ├── readme.txt
│   ├── códigos/
│   │   └── notebook_completo.ipynb  ← pipeline completo
│   └── archive/
│       ├── eda_*.png                ← figuras de EDA (geradas pelo notebook)
│       └── interp_*.png             ← figuras de interpretabilidade (SHAP, Gini)
└── Artigo/
    └── Artigo_Grupo/                ← artigo científico (em construção)
```

**Não versionados** (ver `.gitignore`): CSVs do CICIDS-2017 (~880 MB), `raw_limpo.parquet` (234 MB), PDFs com copyright e ambiente virtual.

---

## Reprodutibilidade

### 1. Pré-requisitos

- Python 3.14+ (testado em 3.14.4)
- macOS, Linux ou WSL2
- ~3 GB de espaço livre (para os dados brutos)

### 2. Clonar o repositório

```bash
git clone https://github.com/vinigm/projeto-ddos.git
cd projeto-ddos
```

### 3. Criar ambiente virtual e instalar dependências

```bash
python3 -m venv .venv
source .venv/bin/activate          # macOS/Linux
# .venv\Scripts\activate           # Windows

pip install -r requirements.txt
```

### 4. Baixar o dataset CICIDS-2017

O dataset bruto **não está versionado** (limite do GitHub). Baixe da fonte oficial:

- **Fonte:** https://www.unb.ca/cic/datasets/ids-2017.html
- **Arquivos necessários** (CSVs já rotulados, pasta `GeneratedLabelledFlows`):
  - `Monday-WorkingHours.pcap_ISCX.csv`
  - `Tuesday-WorkingHours.pcap_ISCX.csv`
  - `Wednesday-workingHours.pcap_ISCX.csv`
  - `Thursday-WorkingHours-Morning-WebAttacks.pcap_ISCX.csv`
  - `Thursday-WorkingHours-Afternoon-Infilteration.pcap_ISCX.csv`
  - `Friday-WorkingHours-Morning.pcap_ISCX.csv`
  - `Friday-WorkingHours-Afternoon-DDos.pcap_ISCX.csv`
  - `Friday-WorkingHours-Afternoon-PortScan.pcap_ISCX.csv`

Coloque todos em `opcao2/archive/`.

### 5. Executar o pipeline

```bash
jupyter notebook opcao2/códigos/notebook_completo.ipynb
```

Execute as células em ordem. O notebook é determinístico: `random_state=42` está fixo em toda fonte de aleatoriedade (split, K-Fold, modelos, RandomizedSearch, amostragem SHAP).

**Tempo estimado total:** ~30–60 min em uma máquina moderna (a etapa mais cara é o Repeated Stratified K-Fold com 30 avaliações por modelo).

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

---

## Equipe

- Vinicius Guerra Maron (@vinigm)
- Matheus (a confirmar handle)

---

## Uso de IA generativa

Este projeto utilizou ferramentas de IA generativa (Claude) como apoio nas etapas de exploração de dados, refatoração de código e redação. Conforme as diretrizes da disciplina, um material suplementar listando prompts e limitações observadas acompanhará o artigo final.

---

## Licença

Código sob MIT. Os dados do CICIDS-2017 seguem a licença da fonte original (Canadian Institute for Cybersecurity).
