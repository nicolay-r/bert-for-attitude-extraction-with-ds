#!/usr/bin/env bash
# setup dependencies
sudo apt-get install python3-pip virtualenv
# setup venv
virtualenv --python=python3.6 myenv
# activate myenv
source myenv/bin/activate
pip install -r requirements.txt

# important to fix this issue: https://github.com/tensorflow/tensorflow/issues/32949
pip install gast==0.2.2

# Install CUDA
sudo apt install nvidia-cuda-toolkit

# How to replace libcublas
# find /usr/lib -name "libcublas.so.9.1"
# ln -s /usr/lib/x86_64-linux-gnu/libcublas.so.9.1 /usr/lib/x86_64-linux-gnu/libcublas.so.9.0
# ln -s /usr/lib/x86_64-linux-gnu/libcusolver.so.9.1 /usr/lib/x86_64-linux-gnu/libcusolver.so.9.0
# ln -s /usr/lib/x86_64-linux-gnu/libcudart.so.9.1 /usr/lib/x86_64-linux-gnu/libcudart.so.9.0
# ln -s /usr/lib/x86_64-linux-gnu/libcufft.so.9.1 /usr/lib/x86_64-linux-gnu/libcufft.so.9.0
# ln -s /usr/lib/x86_64-linux-gnu/libcurand.so.9.1 /usr/lib/x86_64-linux-gnu/libcurand.so.9.0
