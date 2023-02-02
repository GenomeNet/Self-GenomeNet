# Self-GenomeNet

While deep learning is frequently applied in bioinformatics, it is mostly limited to problems where huge amounts of labeled data are present to train a classifier in a supervised manner. Here, we introduce Self-GenomeNet – a method that utilizes unlabeled genomic data to address the challenge of limited data availability through self-training, outperforming the standard supervised training, even when using ~10 times less labeled data.

## Pre-trained models for Self-GenomeNet
<a href="https://colab.research.google.com/drive/1gEm8WvOmN30X9LzH7VV53KDLpTqncpNr?usp=sharing" target="_parent"><img src="https://colab.research.google.com/assets/colab-badge.svg" alt="Open In Colab"/></a>
<!-- ADD TABLE? -->

## Enviromental setup


```
conda create --name selfgenomenet
conda activate selfgenomenet
conda install -c r r r-essentials
conda install python==3.7
conda install tensorflow==2.2.0
conda install -c anaconda hdf5
R -e 'devtools::install_github("GenomeNet/deepG")'
```

Our models are trained with GPUs. 

The code is compatible with Python v3.7 and Tensorflow v2. See requirements.txt and requirements R.txt for all prerequisites. 

You can also install them using the following commands:

```
pip install -r requirements.txt

while IFS=" " read -r package version;
do
  Rscript -e "devtools::install_version('"$package"', version='"$version"',repos = '"https://cloud.r-project.org"')";
done < "requirementsR.txt"
Rscript -e "devtools::install_github("GenomeNet/deepG")"
```
Please note, that the package ``devtools`` needs to be installed in prior.

## Pretraining: Self-supervised model

First, we will learn representations of the Genome Sequences with reverse-complements using contrastive learning.

To pretrain the model on virus data, try the following command:

```
Rscript R/Self-GenomeNet_pretraining/virus/run_train.R
```

For pretraining the model for deepSea data, try this command: 

```
Rscript R/Self-GenomeNet_pretraining/deepsea/run_train.R
```
Please note, that this is only a small part of the data used for presentation purpose. For running the model on full data to achieve the same results described in the paper, please download them from [the official homepage](http://deepsea.princeton.edu/job/analysis/create/) and run ``h5_to_rds.R``


For running the model on Bacteria data, please download some Bacteria data from [NCBI](https://www.ncbi.nlm.nih.gov/assembly/) and put them in the folder ``data/bacteria``. Then run:

```
Rscript R/Self-GenomeNet_pretraining/bacteria/run_train.R
```

Run the ablation pretraining using the command:

```
Rscript R/Self-GenomeNet_pretraining_ablation/run_train_forward_singlelenght.R  # for the forward singlelength model
```

## Semi-supervised learning: Supervised part

We now want to use the pretrained self-supervised model in a supervised step for classification of the Genom's species type, so if it is a phage or a non-phage virus here. 

To train the whole network on virus data, try the following command:

```
Rscript R/supervised/virus/supervised.R
```

For our transfer-learning task, classifying phage vs non-phage virus after training on bacteria data, please try this command:
```
Rscript R/supervised/bacteria/supervised.R
```

The deepSea data will classify on deepSea labels. Try using the command:
```
Rscript R/supervised/deepsea/supervised.R
```

