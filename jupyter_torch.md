build: podman build -f jupyter_torch.Dockerfile -t jupyter-torch .
run: podman run -it -p 8888:8888 -v /home/daniel/Devel/UDC/notebooks:/home/torch/work:Z -w /home/torch/work jupyter-torch
