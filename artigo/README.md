# Artigo Científico — CMP263

Manuscrito em LaTeX usando o template oficial da SBC.

## Estrutura

```
artigo/
├── artigo.tex              ← arquivo principal
├── referencias.bib         ← bibliografia (BibTeX)
├── sbc-template.sty        ← estilo SBC (não mexer)
├── sbc.bst                 ← estilo bibliográfico (não mexer)
├── caption2.sty            ← dependência do template (não mexer)
├── figuras/                ← imagens referenciadas pelo .tex
│   ├── eda_01_distribuicao_classes.png
│   ├── eda_02_tipos_ataque.png
│   ├── eda_03_volume_por_dia.png
│   ├── interp_01_feature_importance_gini.png
│   ├── interp_02_shap_beeswarm.png
│   └── interp_03_shap_dependence.png
└── README.md               ← este arquivo
```

## Como compilar (gerar o PDF)

### Opção 1 — Local (precisa de uma distribuição LaTeX instalada)

```bash
cd artigo/
pdflatex artigo.tex
bibtex artigo
pdflatex artigo.tex
pdflatex artigo.tex
```

A dupla compilação após o `bibtex` é necessária pra resolver as referências cruzadas e a bibliografia.

Se não tiver LaTeX instalado:

- **macOS:** `brew install --cask mactex` (grande, ~4 GB) ou `brew install --cask basictex` (menor, mas precisa baixar pacotes adicionais)
- **Linux:** `sudo apt install texlive-full` ou similar
- **Alternativa moderna:** `brew install tectonic` e depois `tectonic artigo.tex` (compila tudo de uma vez, baixa pacotes sob demanda)

### Opção 2 — Overleaf (sem instalar nada)

1. Acesse https://www.overleaf.com
2. New Project → Upload Project
3. Compacte o conteúdo da pasta `artigo/` em um zip e suba
4. O Overleaf detecta automaticamente que é LaTeX e compila

Recomendado pra colaborar com o Matheus em tempo real.

### Opção 3 — Docker (sem instalar nada localmente)

```bash
docker run --rm -v "$(pwd)":/data ghcr.io/xu-cheng/texlive-full:latest \
  bash -c "cd /data && pdflatex artigo && bibtex artigo && pdflatex artigo && pdflatex artigo"
```

## Status atual do conteúdo

O `artigo.tex` está com **esqueleto completo** seguindo a estrutura padrão de artigo científico (Introdução, Trabalhos Relacionados, Métodos, Resultados, Reprodutibilidade, Discussão, Conclusão).

### O que já está escrito

- ✅ Abstract e Resumo
- ✅ Introdução com pergunta de pesquisa
- ✅ Metodologia completa (dataset, EDA, estratégia de avaliação, algoritmos, métricas, tuning, interpretabilidade)
- ✅ Resultados com todas as tabelas (spot-checking, CV, hiperparâmetros, baseline vs otimizado, overfitting)
- ✅ Seção de Reprodutibilidade
- ✅ Discussão com modelo recomendado e justificativa
- ✅ Limitações e Trabalhos Futuros
- ✅ Conclusão
- ✅ Bibliografia inicial com referências principais

### O que precisa ser preenchido

Marcado no texto com `% TODO:` ou `\textit{[a preencher]}`:

- ❌ Sobrenome do Matheus na linha do autor
- ❌ Email do Matheus
- ❌ Trabalhos Relacionados (Seção 2): 2–3 parágrafos
- ❌ Algumas referências em `\cite{}` que ficaram como `[CITAR REFERÊNCIA]`
- ❌ Adicionar referências dos dois PDFs em `projeto/` (Anomalias de Rede CICIDS 2017, Benchmarking ML Anomaly Detection)
- ❌ Possíveis ajustes de figuras (algumas estão como placeholder comentado)

### Verificações finais

- [ ] Caber em até 20 páginas (limite do enunciado)
- [ ] Revisar consistência terminológica (atributo/feature, modelo/classificador, etc.)
- [ ] Revisar números nas tabelas contra os artifacts em `artifacts/`
- [ ] Material suplementar de IA generativa (separado, conforme enunciado)
