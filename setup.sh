#!/usr/bin/env bash
# setup dependencies
sudo apt-get install python3-pip virtualenv
# setup venv
virtualenv --python=python3.6 myenv
# activate myenv
source myenv/bin/activate
pip install -r requirements.txt

