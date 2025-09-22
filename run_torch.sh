HOST_UID=$(id -u)
HOST_GID=$(id -g)

podman run -d -p 8888:8888 \
  -v $(pwd)/notebooks:/home/torch/work:z \
  -e USER_ID="${HOST_UID}" \
  -e GROUP_ID="${HOST_GID}" \
  --name jupyter-torch \
  --replace \
  jupyter-torch
