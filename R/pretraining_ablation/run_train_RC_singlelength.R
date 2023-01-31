source("R/pretraining/train.R")
source("R/pretraining/virus_seqlen1000/context.R")
source("R/pretraining/virus_seqlen1000/encoder.R")
source("R/pretraining_ablation/loss_function_singlelength.R")
train_data_folder <- list("data/virus-no-phage-data/train","data/virus-phage-data/train")
validation_data_folder <- list("data/virus-no-phage-data/validation","data/virus-phage-data/validation")
tensorboard_folder <- "tensorboard"

train_Self_GenomeNet(
  path            = train_data_folder,
  path_val        = validation_data_folder,
  maxlen          = 1000,
  encoder         = encoder_pretraining(1000),
  context         = context_pretraining,
  loss_function   = loss_function_singlelength,
  batch_size      = 128,
  epochs          = 1000,
  steps_per_epoch = 400,
  learningrate    = 0.0001,
  run_name        = paste("Self-GenomeNet_reverse_single", format(Sys.time(), "_%y%m%d_%H%M"), sep = ""),
  path_tensorboard = tensorboard_folder,
  trained_model   = NULL,
  savemodels      = TRUE,
  save_every_xth_epoch = 100,
  proportion_per_seq = 0.9
)
