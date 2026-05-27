# Python alinhado ao requirements.txt (pandas 3.x exige >= 3.10).
# Toolchain mínima para wheels que ainda compilam (ex.: partes do SHAP).
FROM python:3.11-slim-bookworm

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    MPLBACKEND=Agg \
    PIP_DISABLE_PIP_VERSION_CHECK=1

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libgomp1 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

COPY requirements.txt .
RUN pip install --no-cache-dir -U pip setuptools wheel \
    && pip install --no-cache-dir -r requirements.txt

# Caminhos relativos do notebook: ../archive, ../../artifacts, ../../requirements.txt
WORKDIR /workspace/opcao2/códigos

EXPOSE 8888

# Token fixo para uso local; não exponha esta porta na internet.
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", \
     "--ServerApp.allow_root=true", \
     "--ServerApp.token=ddos-local", \
     "--ServerApp.allow_origin=*"]
