#!/bin/bash

HOST_UID=$(id -u)
HOST_GID=$(id -g)

# Check if the image exists, build if it doesn't
if ! podman image exists jupyter-torch; then
    echo "Building jupyter-torch image..."
    podman build -t jupyter-torch -f jupyter_torch.Dockerfile \
        --build-arg USER_ID="${HOST_UID}" \
        --build-arg GROUP_ID="${HOST_GID}" .
fi

podman run -d -p 8888:8888 \
  -v $(pwd)/notebooks:/home/torch/work:z \
  -e USER_ID="${HOST_UID}" \
  -e GROUP_ID="${HOST_GID}" \
  --name jupyter-torch \
  --replace \
  jupyter-torch
