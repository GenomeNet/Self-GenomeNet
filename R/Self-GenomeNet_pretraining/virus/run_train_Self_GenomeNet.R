source("R/Self-GenomeNet_pretraining/virus/train_Self_GenomeNet.R")
source("R/Self-GenomeNet_pretraining/virus/context_virus_pretraining.R")
source("R/Self-GenomeNet_pretraining/virus/encoder_virus_pretraining.R")
source("R/Self-GenomeNet_pretraining/virus/loss_functionSG.R")
train_data_folder <- "data/virus-no-phage-data/train"
validation_data_folder <- "data/virus-no-phage-data/validation"
tensorboard_folder <- "tensorboard"

train_Self_GenomeNet(
  path            = train_data_folder,
  path.val        = validation_data_folder,
  maxlen          = 150,
  encoder         = encoder_virus_pretraining(150),
  context         = context_virus_pretraining,
  loss_function   = loss_functionSG,
  batch.size      = 512,
  epochs          = 360,
  steps.per.epoch = 400,
  learningrate    = 0.0001,
  run.name        = paste("Self-GenomeNet", format(Sys.time(), "_%y%m%d_%H%M"), sep = ""),
  tensorboard.log = tensorboard_folder,
  trained_model   = NULL,
  savemodels      = TRUE,
  save_every_xth_epoch = 60,
  proportion_per_file = 0.9
)
