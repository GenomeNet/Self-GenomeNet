
source("R/Self-GenomeNet_pretraining/virus/train_Self_GenomeNet.R")
source("R/Self-GenomeNet_pretraining/bacteria/context_bacteria_pretraining.R")
source("R/Self-GenomeNet_pretraining/bacteria/encoder_bacteria_pretraining.R")
source("R/Self-GenomeNet_pretraining/bacteria/loss_functionSG.R")
train_data_folder <- "/home/deepsea_train/train"
validation_data_folder <- "/home/deepsea_train/validation"
tensorboard_folder <- "tensorboard"

train_Self_Genomenet(
  path            = train_data_folder,
  path.val        = validation_data_folder,
  maxlen          = 1000,
  encoder         = encoder(1000),
  context         = context,
  loss_function   = loss_functionSG_deepsea,
  batch.size      = 128,
  epochs          = 600,
  steps.per.epoch = 400,
  learningrate    = 0.0001,
  run.name        = paste("Self-Genomenet_deepsea", format(Sys.time(), "_%y%m%d_%H%M"), sep = ""),
  tensorboard.log = tensorboard_folder,
  trained_model   = NULL,
  savemodels = TRUE,
  save_every_xth_epoch = 100
)
