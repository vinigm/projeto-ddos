# Compilar o artigo (`artigo/artgigo.tex`)

## Estrutura

```
artigo/
├── artgigo.tex          ← manuscrito (raiz LaTeX do artigo)
├── artgigo.pdf          ← gerado pelo build (gitignored)
├── .latexmkrc
├── TEX.md               ← este guia
├── tex/sbc/             ← sbc-template.sty, sbc.bst, referencias.bib
└── README.md
```

Figuras vêm de `../projeto/archive/` (caminhos relativos a `artigo/`).

## 1. Instalar LaTeX (obrigatório)

O erro `spawn latexmk ENOENT` / `tlmgr: command not found` significa que o TeX **não está no sistema**.

### Se `brew install --cask basictex` diz “already installed” mas `tlmgr` não existe

O Homebrew só baixou o `.pkg`; o instalador **não rodou** (senha cancelada na primeira vez). Confirme:

```bash
ls /Library/TeX/texbin    # deve dar "No such file" até instalar de verdade
```

**Instale manualmente o pacote** (assistente gráfico — use Continuar / Instalar e digite a senha do Mac):

```bash
open /opt/homebrew/Caskroom/basictex/2026.0301/mactex-basictex-20260301.pkg
```

Se a versão no Caskroom for outra, liste com:

```bash
ls /opt/homebrew/Caskroom/basictex/*/mactex*.pkg
```

Depois de concluir o assistente, **feche e abra o terminal** (ou rode `eval "$(/usr/libexec/path_helper)"`).

### Pacotes extras (após `which tlmgr` funcionar)

O BasicTeX é mínimo. O template SBC precisa de **`titlesec`**, **`latexmk`**, `graphicx`, `babel` (português), etc.

**Um comando** (recomendado):

```bash
cd ~/Desktop/projeto-ddos/artigo
bash install-tex-packages.sh
```

Ou manualmente:

```bash
export PATH="/Library/TeX/texbin:$PATH"
sudo tlmgr update --self
sudo tlmgr install latexmk titlesec caption psnfss babel-portuges hyphen-portuguese collection-latexrecommended collection-fontsrecommended
kpsewhich titlesec.sty latexmk
```

| Erro no `pdflatex` | Pacote |
|--------------------|--------|
| `titlesec.sty not found` | `titlesec` |
| `latexmk not found` | `latexmk` |
| `graphicx.sty not found` | `collection-latexrecommended` |
| `brazil` / babel | `babel-portuges` `hyphen-portuguese` |

Enquanto `latexmk` não existir, compile no terminal com:

```bash
cd ~/Desktop/projeto-ddos/artigo
export PATH="/Library/TeX/texbin:$PATH"
export TEXINPUTS="./tex/sbc//:"
export BIBINPUTS="./tex/sbc//:"
pdflatex -interaction=nonstopmode artgigo.tex
bibtex artgigo
pdflatex -interaction=nonstopmode artgigo.tex
pdflatex -interaction=nonstopmode artgigo.tex
```

No Cursor: `Cmd+Shift+P` → **LaTeX Workshop: Build with recipe** → **pdflatex + bibtex (sem latexmk)**.

Alternativa completa: [MacTeX](https://tug.org/mactex/) (~5 GB), sem depender do `tlmgr` para o básico.

Depois, no `~/.zshrc`:

```bash
export PATH="/Library/TeX/texbin:$PATH"
```

Feche e reabra o Cursor (ou reinicie o Mac) para o PATH valer na extensão.

Teste no terminal:

```bash
which latexmk pdflatex kpsewhich
kpsewhich article.cls
```

## 2. Compilar no Cursor

1. Extensão [LaTeX Workshop](https://marketplace.visualstudio.com/items?itemName=James-Yu.latex-workshop).
2. Abra `artigo/artgigo.tex`.
3. `Cmd+Option+B` (build) ou `Cmd+Option+V` (PDF).

O `.vscode/settings.json` na raiz do repositório já define:
- raiz do projeto LaTeX: `artigo/artgigo`
- `latexmk -cd` (entra em `artigo/` antes de compilar)
- `PATH` com `/Library/TeX/texbin`

## 3. Compilar no terminal

```bash
cd artigo
export PATH="/Library/TeX/texbin:$PATH"
latexmk -pdf artgigo.tex
```

Limpar auxiliares: `latexmk -c artgigo.tex`

## Problemas comuns

| Erro | Solução |
|------|---------|
| `latexmk ENOENT` | Instale MacTeX/BasicTeX e adicione `/Library/TeX/texbin` ao PATH; reinicie o Cursor. |
| `kpsewhich` / `article.cls` falha | Mesmo: LaTeX não instalado ou PATH não visto pelo Cursor. |
| `sbc-template.sty not found` | Build deve usar `-cd artigo/`; use o recipe do `.vscode/settings.json`. |
| `caption2.sty not found` | `sudo tlmgr install caption` |
| `titlesec.sty not found` | `sudo tlmgr install titlesec` ou rode `install-tex-packages.sh` |
| Figura não encontrada | Confirme PNG em `projeto/archive/`. |
