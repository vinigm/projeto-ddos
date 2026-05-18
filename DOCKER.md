# Docker — ambiente plug and play

Este guia descreve como subir o **Jupyter Lab** em um container com **Python 3.11** e as versões do `requirements.txt`, sem instalar Python na máquina host. Funciona em **Linux**, **macOS** e **Windows** (com Docker Desktop).

## O que você precisa

1. [Docker](https://docs.docker.com/get-docker/) instalado, com o plugin **Docker Compose** (o comando `docker compose` deve existir).
2. **~2 GB** livres para a imagem; mais espaço para `raw_limpo.parquet` (~224 MB) e, se for treinar sem cache, RAM suficiente (recomenda-se **8 GB+** reservados ao Docker na primeira execução pesada).

## Passo a passo

### 1. Clonar e entrar na pasta do projeto

```bash
git clone https://github.com/vinigm/projeto-ddos.git
cd projeto-ddos
```

### 2. Subir o Jupyter

Na **raiz** do repositório (onde estão `docker-compose.yml` e `Dockerfile`):

```bash
docker compose up --build
```

- Na primeira vez o build pode levar vários minutos (download da imagem base + `pip install`).
- Quando aparecer a URL do Jupyter nos logs, abra o navegador.

### 3. Abrir o notebook

No navegador, use:

**http://localhost:8888/lab?token=ddos-local**

Abra o arquivo `notebook_completo.ipynb` (ele já estará na pasta correta: `opcao2/códigos`).

### 4. Executar o experimento

- **Caminho rápido (recomendado):** role até a seção **“Pós EDA”** no notebook e use **“Run All Below”** a partir da célula que define `PARQUET` e `ARTIFACTS_DIR`. O `raw_limpo.parquet` é baixado automaticamente se não existir em `opcao2/archive/`.
- **Caminho completo (CSV originais):** coloque os 8 CSVs do CICIDS-2017 em `opcao2/archive/` e use **“Run All”** desde o início (veja o [README.md](README.md)).

Os resultados (parquet, figuras em `opcao2/archive/`, cache em `artifacts/`) ficam no **seu clone no disco** graças ao volume montado (`.:/workspace`). Parar o container **não apaga** esses arquivos.

## Porta ocupada

Se a porta **8888** estiver em uso:

```bash
JUPYTER_PORT=8890 docker compose up --build
```

Acesse então **http://localhost:8890/lab?token=ddos-local**.

## Parar o ambiente

No terminal onde o Compose está rodando: `Ctrl+C`. Opcionalmente remova o container:

```bash
docker compose down
```

## Segurança

O token `ddos-local` é pensado para **desenvolvimento local**. Não publique a porta do Jupyter na internet sem autenticação adequada.

## Arquivos relacionados

| Arquivo | Função |
|--------|--------|
| `Dockerfile` | Imagem com Python 3.11 + `requirements.txt` |
| `docker-compose.yml` | Sobe o serviço, monta o repo, expõe a porta |
| `.dockerignore` | Enxuga o contexto do build (não afeta o volume em execução) |

## Observação sobre a primeira célula do notebook

A primeira célula ainda pode rodar `pip install -r requirements.txt`. Dentro do container isso costuma ser rápido (já está instalado na imagem). Se quiser ignorar, pode pular essa célula após confirmar que o kernel é o do container.
