source("R/pretraining/train.R")
source("R/pretraining/loss_functionSG.R")
source("R/pretraining/bacteria/context.R")
source("R/pretraining/bacteria/encoder.R")
train_data_folder <- "data/bacteria/train"
validation_data_folder <- "data/bacteria/validation"
tensorboard_folder <- "tensorboard"

train_Self_GenomeNet(
  path            = train_data_folder,
  path_val        = validation_data_folder,
  maxlen          = 1000,
  stepsmin        = 1,
  stepsmax        = 2,
  encoder         = encoder_bacteria_pretraining(1000),
  context         = context_bacteria_pretraining,
  loss_function   = loss_functionSG,
  batch_size      = 2,#128,
  epochs          = 5,#1000,
  steps_per_epoch = 10,#,400,
  learningrate    = 0.0001,
  run_name        = paste("Self-GenomeNet", format(Sys.time(), "_%y%m%d_%H%M"), sep = ""),
  path_tensorboard = tensorboard_folder,
  trained_model   = NULL,
  savemodels      = TRUE,
  save_every_xth_epoch = 5,
  proportion_per_seq = 0.1
)
