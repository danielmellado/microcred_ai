FROM docker.io/pytorch/pytorch:latest
LABEL authors="Daniel Mellado <dmellado@fedoraproject.org>"

ARG TORCH_HOME=/home/torch
ENV TORCH_HOME=${TORCH_HOME}
ARG VIRTUAL_ENV=/opt/venv
ENV PATH="${VIRTUAL_ENV}/bin:${PATH}"

RUN apt-get update && apt-get install -y nodejs npm \
    && npm install -g bash-language-server \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 --no-cache-dir install -U pip \
    && python3 -m pip install --no-cache-dir \
       jupyterlab scikit-learn matplotlib jedi-language-server \
       python-lsp-server[all] pyright

RUN groupadd -r torch -g 1000 \
    && useradd -u 1000 -g torch -m -d ${TORCH_HOME} \
       -c "PyTorch user" torch

USER torch

WORKDIR ${TORCH_HOME}/work
EXPOSE 8888

ENV JUPYTERLAB_THEME="JupyterLab Dark"

CMD ["jupyter", "lab", "--ip=0.0.0.0", "--no-browser", \
     "--ServerApp.token=", "--ServerApp.password=", \
     "--notebook-dir=/home/torch/work"]
