# Artifacts — Cache de objetos computados

Esta pasta armazena resultados intermediários caros do notebook (`opcao2/códigos/notebook_completo.ipynb`), permitindo que o pipeline seja reproduzido em ~1 minuto em vez de ~6 horas.

## Como funciona

O notebook tem uma flag `RECOMPUTE` na célula de imports:
- `RECOMPUTE = False` (padrão): se o artefato existe, carrega do disco. Senão, computa e salva.
- `RECOMPUTE = True`: ignora o cache e recomputa tudo.

Todos os artefatos são gerados **automaticamente** na primeira execução end-to-end (~6h). Daí em diante, "Run All Below" leva ~1 minuto.

## O que mora aqui

| Arquivo | Conteúdo | Tamanho aprox. |
|---|---|---|
| `lr.joblib` | Regressão Logística baseline (tupla com tempo de treino) | ~10 KB |
| `rf_baseline.joblib` | Random Forest baseline (100 trees) | ~30–80 MB |
| `dt.joblib` | Decision Tree | ~5–20 MB |
| `hgb_baseline.joblib` | Hist Gradient Boosting baseline | ~5–10 MB |
| `nb.joblib` | Naive Bayes (rápido, cache por consistência) | ~5 KB |
| `rf_optimized.joblib` | Random Forest após RandomizedSearchCV | ~50–200 MB |
| `hgb_optimized.joblib` | HGB após RandomizedSearchCV | ~5–20 MB |
| `scores_cv.npz` | Scores brutos de Repeated Stratified K-Fold (30 folds × 5 modelos × 4 métricas) | ~5 KB |
| `df_cv_summary.csv` | Tabela resumo do CV (média ± desvio) | ~1 KB |
| `best_params_rf.json` | Melhores hiperparâmetros do RF | ~500 B |
| `best_params_hgb.json` | Melhores hiperparâmetros do HGB | ~500 B |
| `shap_values.npz` | Valores SHAP para 5.000 amostras × 68 features | ~2–3 MB |

Todos os modelos são serializados com `joblib.dump(..., compress=3)`.

## Reprodutibilidade

Os artefatos são determinísticos: rodar com `RECOMPUTE=True` em qualquer máquina com `random_state=42` deve produzir os **mesmos números** (modulo diferenças de ponto flutuante entre CPUs).

## ⚠️ Artefatos grandes

Se algum `.joblib` exceder **100 MB** (limite por arquivo do GitHub), ele não consegue ir pro repo. Nesse caso, movemos pro [release v1.0](https://github.com/vinigm/projeto-ddos/releases/tag/v1.0) e adicionamos lógica de download no notebook.
