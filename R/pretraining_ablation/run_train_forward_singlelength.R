source("R/pretraining_ablation/train_Self_GenomeNet_forward_singlelength.R")
source("R/pretraining/virus/context_virus_pretraining.R")
source("R/pretraining/virus/encoder_virus_pretraining.R")
source("R/pretraining_ablation/loss_function_forward_singlelength.R")
train_data_folder <- list("data/virus-no-phage-data/train","data/virus-phage-data/train")
validation_data_folder <- list("data/virus-no-phage-data/validation","data/virus-phage-data/validation")
tensorboard_folder <- "tensorboard"

train_Self_GenomeNet_forward_singlelength(
  path            = train_data_folder,
  path_val        = validation_data_folder,
  maxlen          = 150,
  encoder         = encoder_virus_pretraining(150),
  context         = context_virus_pretraining,
  loss_function   = loss_function_forward,
  batch_size      = 512,
  epochs          = 360,
  steps_per_epoch = 400,
  learningrate    = 0.0001,
  run_name        = paste("Self-GenomeNet_for_single", format(Sys.time(), "_%y%m%d_%H%M"), sep = ""),
  path_tensorboard = tensorboard_folder,
  trained_model   = NULL,
  savemodels      = TRUE,
  save_every_xth_epoch = 60,
  proportion_per_seq = 0.9
)
