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

