#!/bin/bash

# Loading data
data=data.zip
out="../data"

# no-cv data
curl -L -o $data https://www.dropbox.com/s/wmkgqvmmho5hvyn/bert-experiments.1.4.zip?dl=1
mkdir -p $out
unzip $data -d $out
