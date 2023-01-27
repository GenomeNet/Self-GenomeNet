source("R/pretraining/train.R")
source("R/pretraining/loss_functionSG.R")
source("R/pretraining/deepsea/context.R")
source("R/pretraining/deepsea/encoder.R")
train_data_folder <- "data/deepSea/train"
validation_data_folder <- "data/deepSea/validation"
tensorboard_folder <- "tensorboard"

train_Self_GenomeNet(
  path            = train_data_folder,
  path_val        = validation_data_folder,
  maxlen          = 1000,
  encoder         = encoder_deepsea_pretraining(1000),
  context         = context_deepsea_pretraining,
  loss_function   = loss_functionSG,
  batch_size      = 128,
  epochs          = 600,
  steps_per_epoch = 400,
  learningrate    = 0.0001,
  run_name        = paste("Self-Genomenet_deepsea", format(Sys.time(), "_%y%m%d_%H%M"), sep = ""),
  path_tensorboard = tensorboard_folder,
  trained_model   = NULL,
  savemodels      = TRUE,
  deepSea         = F,
)
