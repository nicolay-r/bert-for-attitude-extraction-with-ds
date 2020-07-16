#!/bin/bash

# Loading data
data=data.zip
# no-cv data
curl -L -o $data https://www.dropbox.com/s/wmkgqvmmho5hvyn/bert-experiments.1.4.zip?dl=1
mkdir -p data
unzip $data -d data/.
