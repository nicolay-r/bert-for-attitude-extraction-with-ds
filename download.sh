# Loading model
fzip=multi_cased_L-12_H-768_A-12.zip
subdir=pretrained
mkdir -p $subdir
wget https://storage.googleapis.com/bert_models/2018_11_23/$fzip -O ./$subdir/$fzip
cd ./$subdir/ && unzip $fzip -d .

# Loading data
git clone https://nicolay_r@bitbucket.org/nicolay_r/bert-rusentrel-experiments.git data
