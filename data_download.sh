#!/bin/bash

# Loading data
data=data.zip
# no-cv data
curl -L -o $data https://www.dropbox.com/s/dp72c00zqd3b87u/bert-train-fixed-data.zip?dl=1
mkdir -p data
unzip $data -d data/.
