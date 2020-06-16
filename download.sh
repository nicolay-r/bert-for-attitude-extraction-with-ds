# Loading model
fzip=multi_cased_L-12_H-768_A-12.zip
subdir=pretrained
mkdir -p $subdir
wget https://storage.googleapis.com/bert_models/2018_11_23/$fzip -O ./$subdir/$fzip
cd ./$subdir/ && unzip $fzip -d .

# Loading data
data=data.zip
# no-cv data
curl -L -o $data https://www.dropbox.com/s/dp72c00zqd3b87u/bert-train-fixed-data.zip?dl=1
unzip $data -d .
