FROM docker.io/pytorch/pytorch:latest
LABEL authors="Daniel Mellado <dmellado@fedoraproject.org>"

ARG TORCH_HOME=/home/torch
ENV TORCH_HOME=${TORCH_HOME}
ARG VIRTUAL_ENV=/opt/venv
ENV PATH="${VIRTUAL_ENV}/bin:${TORCH_HOME}/.local/bin:${PATH}"

RUN apt-get update && apt-get install -y nodejs npm \
    && npm install -g bash-language-server \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install --no-cache-dir --upgrade pip \
    && python3 -m pip install --no-cache-dir \
       jupyterlab scikit-learn matplotlib jedi-language-server \
       python-lsp-server[all] pyright huggingface_hub \
       transformers ipywidgets gensim

ARG USER_ID=1000
ARG GROUP_ID=1000
RUN groupadd -g ${GROUP_ID} torch \
    && useradd -m -d ${TORCH_HOME} -u ${USER_ID} -g ${GROUP_ID} -s /bin/bash torch

USER torch

WORKDIR ${TORCH_HOME}/work
EXPOSE 8888

ENV JP_LSP_VIRTUAL_DIR=/tmp/jupyter-lsp-virtual
RUN mkdir -p /tmp/jupyter-lsp-virtual

RUN mkdir -p ${TORCH_HOME}/.jupyter/lab/user-settings/@jupyterlab/apputils-extension \
 && echo '{ "theme": "JupyterLab Dark" }' \
    > ${TORCH_HOME}/.jupyter/lab/user-settings/@jupyterlab/apputils-extension/themes.jupyterlab-settings

CMD ["bash", "-c", "\
    export USER_ID=${USER_ID}; \
    export GROUP_ID=${GROUP_ID}; \
    exec jupyter lab --ip=0.0.0.0 --no-browser --ServerApp.token= --ServerApp.password= --notebook-dir=${TORCH_HOME}/work"]
