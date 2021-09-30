# Self-GenomeNet

We introduce Self-GenomeNet, a novel contrastive self-supervised learning method for nucleotide-level genomic data, which substantially improves the quality of the learned representations and performance compared to the current state-of-the-art deep learning frameworks. To the best of our knowledge, Self-GenomeNet is the first self-supervised framework that learns a representation of nucleotide-level genome data, using domain-specific characteristics. Our proposed method learns and parametrizes the latent space by leveraging the reverse-complement of genomic sequences. During the training procedure, we force our framework to capture semantic representations with a novel context network on top of intermediate features extracted by a deep encoder network. The network is trained with an unsupervised contrastive loss. Extensive experiments show that our method with self-supervised and semi-supervised settings is able to considerably outperform previous deep learning methods on different datasets and a public bioinformatics benchmark. Moreover, the learned representations generalize well when transferred to new datasets and tasks. The source code of the method and all the experiments are available at supplementary.

## Pre-trained models for Self-GenomeNet
<a href="colabs/finetuning.ipynb" target="_parent"><img src="https://colab.research.google.com/assets/colab-badge.svg" alt="Open In Colab"/></a>
<!-- ADD COLLAB LINK -->

<!-- ADD Table here -->

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
```

## Pretraining: Self-supervised model

To pretrain the model on <!-- ADD DATASET FOR CODE TRIAL -->, try the following command:

```
Rscript run/pretraining.R
```

## Semi-supervised learning

To train the whole network on <!-- ADD DATASET FOR CODE TRIAL -->, try the following command:

```
Rscript run/run_supervised.R
```

## Cite

<!-- ADD ARXIV WHEN PUBLISHED -->
<!-- [Self-GenomeNet paper](https://arxiv.org/abs/xxxxxxxxxx): -->

```
@inproceedings{
anonymous2022selfgenomenet,
title={Self-GenomeNet: Self-supervised Learning with Reverse-Complement Context Prediction for Nucleotide-level Genomics Data},
author={Anonymous},
booktitle={Submitted to The Tenth International Conference on Learning Representations },
year={2022},
url={https://openreview.net/forum?id=92awwjGxIZI},
note={under review}
}
```
