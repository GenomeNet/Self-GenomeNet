source("R/pretraining/deepsea/train.R")
source("R/pretraining/deepsea/context.R")
source("R/pretraining/deepsea/encoder.R")
source("R/pretraining/deepsea/loss_functionSG_multi_q.R")
train_data_folder <- "data/deepSea/train"
validation_data_folder <- "data/deepSea/validation"
tensorboard_folder <- "tensorboard"

train_Self_GenomeNet(
  path            = train_data_folder,
  path.val        = validation_data_folder,
  maxlen          = 1000,
  encoder         = encoder_deepsea_pretraining(1000),
  context         = context_deepsea_pretraining,
  loss_function   = loss_functionSG_multi_q,
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
