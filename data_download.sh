#!/bin/bash

# Loading data
data=data.zip
# no-cv data
curl -L -o $data https://www.dropbox.com/s/1zg6w2xiym8ywz5/bert-train-fixed-data-1.1.zip?dl=1
mkdir -p data
unzip $data -d data/.
