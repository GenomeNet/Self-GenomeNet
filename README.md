# Self-GenomeNet

We introduce Self-GenomeNet, a novel contrastive self-supervised learning method for nucleotide-level genomic data, which substantially improves the quality of the learned representations and performance compared to the current state-of-the-art deep learning frameworks. To the best of our knowledge, Self-GenomeNet is the first self-supervised framework that learns a representation of nucleotide-level genome data, using domain-specific characteristics. Our proposed method learns and parametrizes the latent space by leveraging the reverse-complement of genomic sequences. During the training procedure, we force our framework to capture semantic representations with a novel context network on top of intermediate features extracted by a deep encoder network. The network is trained with an unsupervised contrastive loss. Extensive experiments show that our method with self-supervised and semi-supervised settings is able to considerably outperform previous deep learning methods on different datasets and a public bioinformatics benchmark. Moreover, the learned representations generalize well when transferred to new datasets and tasks. The source code of the method and all the experiments are available at supplementary.

## Pre-trained models for Self-GenomeNet
<a href="https://colab.research.google.com/drive/1gEm8WvOmN30X9LzH7VV53KDLpTqncpNr?usp=sharing" target="_parent"><img src="https://colab.research.google.com/assets/colab-badge.svg" alt="Open In Colab"/></a>
<!-- ADD TABLE? -->

## Enviromental setup

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

