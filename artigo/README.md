# Artigo Científico — CMP263

Manuscrito em LaTeX (template SBC) para o trabalho prático de Aprendizagem de Máquina (PPGC/UFRGS, 2026/1).

## Conteúdo

| Item | Caminho |
|------|---------|
| Manuscrito | [`artgigo.tex`](artgigo.tex) |
| Template SBC | [`tex/sbc/`](tex/sbc/) |
| Como compilar | [`TEX.md`](TEX.md) |
| Figuras (notebook) | `../projeto/archive/` |

PDF final para submissão: **28/05/2026**.

O template oficial da disciplina pode estar em `../modelosparapublicaodeartigos/Template_SBC/` (não versionado); o repositório usa cópia equivalente em `tex/sbc/`.

## Build rápido

```bash
cd artigo && latexmk -pdf artgigo.tex
```

(Requer MacTeX/BasicTeX — ver [TEX.md](TEX.md).)
