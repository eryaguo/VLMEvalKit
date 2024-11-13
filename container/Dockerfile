FROM nvcr.io/nvidia/pytorch:24.05-py3

# System setup
RUN apt-get update && apt-get install -y \
    python3-pip \
    python3-venv \
    git \
    cmake \
    ffmpeg=4.4

RUN apt-get install -y tmux htop nvtop

# Upgrade pip and install required Python dependencies
RUN pip install --upgrade pip setuptools==69.5.1
RUN pip install flash-attn==2.5.8 --no-build-isolation
RUN pip install --upgrade wandb sentencepiece tensorboard tqdm pandas jupyter seaborn

# Specific adjustments for evaluation task
RUN pip uninstall -y numpy && pip install numpy==1.26.4
RUN pip install torchvision==0.16.2

# Setup workspace for Nanotron and install it
WORKDIR /workspace
RUN git clone https://github.com/swiss-ai/nanotron.git
WORKDIR /workspace/nanotron
RUN pip install -e .[nanosets]

# Clone and build decord
RUN git clone --recursive https://github.com/dmlc/decord
WORKDIR /workspace/decord
RUN mkdir build && cd build && cmake .. -DUSE_CUDA=0 -DCMAKE_BUILD_TYPE=Release && make

# Clone and install VLMEvalKit
WORKDIR /workspace
RUN git clone https://github.com/open-compass/VLMEvalKit.git

WORKDIR /workspace/VLMEvalKit
RUN install -e .

# Build this container using the following steps. 
# 1. Get a compute node
# srun --container-writable -p debug --pty bash
# 2. While in the folder with the Dockerfile, create a new a new image named nanotron_pretrain
# podman build -t nanotron_pretrain:24.04-py3 .
# 3. You can see your image now using this command
# podman images 
# 4. use enroot to export the image into a squash file
# enroot import -o nanotron_pretrain.sqsh podman://nanotron_pretrain:24.04-py3
# 5. Make it readable
# setfacl - b nanotron_pretrain.sqsh
# chmod 755 nanotron_pretrain.sqsh
# 6. If you intend to update the shared nanotron container copy this Dockerfile and the squashfile to a new folder in /store/swissai/a06/containers/nanotron_pretrain/ and update the symbolic link to the latest version.

