# Self-GenomeNet

While deep learning is frequently applied in bioinformatics, it is mostly limited to problems where huge amounts of labeled data are present to train a classifier in a supervised manner. Here, we introduce Self-GenomeNet – a method that utilizes unlabeled genomic data to address the challenge of limited data availability through self-training, outperforming the standard supervised training, even when using ~10 times less labeled data.

## Pre-trained models for Self-GenomeNet
<a href="https://colab.research.google.com/drive/1gEm8WvOmN30X9LzH7VV53KDLpTqncpNr?usp=sharing" target="_parent"><img src="https://colab.research.google.com/assets/colab-badge.svg" alt="Open In Colab"/></a>
<!-- ADD TABLE? -->

## Enviromental setup

Please install the anaconda first.
In Ubuntu, by running the code below:
```
wget https://repo.anaconda.com/archive/Anaconda3-2019.10-Linux-x86_64.sh
bash Anaconda3-2019.10-Linux-x86_64.sh
```
You may need to restart your terminal after installing Anaconda.

Then, with the code below, you can create a conda environment and activate it, and install the dependencies: R, tensorflow, devtools (it is only needed to install deepG and should not be necessary to keep after the deepG installation), and deepG.

```
conda create --name selfgenomenet
conda activate selfgenomenet
conda install -c conda-forge r-base=4.0.3
conda install tensorflow==2.2.0
R -e 'install.packages("devtools",repos = "http://cran.us.r-project.org")'
R -e 'devtools::install_github("GenomeNet/deepG")'
```

Finally, you clone this repo to your computer with the code below.

```
git clone https://github.com/GenomeNet/Self-GenomeNet.git
```

## Pretraining: Self-supervised model

First, we will learn representations of the Genome Sequences with reverse-complements using contrastive learning.

To pretrain the model on virus data, you can use either of the following commands for sequences of 150 nucleotide or 1000 seqences, respectively:

```
Rscript R/pretraining/virus/virus_seqlen150/run_train.R
```
```
Rscript R/pretraining/virus/virus_seqlen1000/run_train.R
```

For pretraining the model for deepSea data, try this command: 

```
Rscript R/pretraining/deepsea/run_train.R
```
Please note, that this is only a small part of the data used for presentation purpose. For running the model on full data to achieve the same results described in the paper, please download them from [the official homepage](http://deepsea.princeton.edu/job/analysis/create/) and run ``h5_to_rds.R``


For running the model on Bacteria data, please download some Bacteria data from [NCBI](https://www.ncbi.nlm.nih.gov/assembly/) and put them in the folder ``data/bacteria``. Then run:

```
Rscript R/pretraining/bacteria/run_train.R
```

You can run the code used for the ablation analysis as below:

1. Supplementary Results / Experiments: Fixed-Length Targets vs. Varying-Length Targets

```
Rscript R/pretraining_ablation/run_train_RC_singlelength.R 
```

2. Supplementary Results / Experiments: Using Reverse-Complement Neighbor Sequences as Targets to Predict

- Forward:

```
Rscript R/pretraining_ablation/run_train_forward_multilength.R
```

- Reverse
 
```
Rscript R/pretraining_ablation/run_train_reverse_multilength.R
```

- Reverse-complement:
 
```
Rscript R/pretraining/train.R
```

Please note that the last one is our proposed method: Self-GenomeNet.

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

