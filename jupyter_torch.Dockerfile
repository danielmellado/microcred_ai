FROM docker.io/pytorch/pytorch:latest
LABEL authors="Daniel Mellado <dmellado@fedoraproject.org>"

ARG TORCH_HOME=/home/torch
ARG USER_ID=1000
ARG GROUP_ID=1000

RUN apt-get update && apt-get install -y nodejs npm \
    && npm install -g bash-language-server \
    && rm -rf /var/lib/apt/lists/*

RUN groupadd -g ${GROUP_ID} torch \
    && useradd -m -d ${TORCH_HOME} -u ${USER_ID} -g ${GROUP_ID} \
       -s /bin/bash torch \
    && usermod -aG video torch

USER torch
ENV TORCH_HOME=${TORCH_HOME}
WORKDIR ${TORCH_HOME}

ENV VIRTUAL_ENV=${TORCH_HOME}/venv
RUN python3 -m venv ${VIRTUAL_ENV}
ENV PATH="${VIRTUAL_ENV}/bin:${PATH}"

RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir \
       jupyterlab scikit-learn matplotlib jedi-language-server \
       python-lsp-server[all] pyright huggingface_hub \
       transformers ipywidgets gensim bitsandbytes \
       accelerate datasets

RUN mkdir -p ${TORCH_HOME}/work
WORKDIR ${TORCH_HOME}/work
EXPOSE 8888

ENV JP_LSP_VIRTUAL_DIR=/tmp/jupyter-lsp-virtual
RUN mkdir -p /tmp/jupyter-lsp-virtual

RUN mkdir -p ${TORCH_HOME}/.jupyter/lab/user-settings/\
@jupyterlab/apputils-extension \
 && echo '{ "theme": "JupyterLab Dark" }' \
    > ${TORCH_HOME}/.jupyter/lab/user-settings/\
@jupyterlab/apputils-extension/themes.jupyterlab-settings

CMD jupyter lab --ip=0.0.0.0 --no-browser \
    --ServerApp.token= --ServerApp.password= \
    --notebook-dir=${TORCH_HOME}/work
