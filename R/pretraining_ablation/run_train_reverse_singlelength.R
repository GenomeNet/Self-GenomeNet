source("R/Self-GenomeNet_pretraining_ablation/train_Self_GenomeNet_reverse.R")
source("R/Self-GenomeNet_pretraining/virus/context_virus_pretraining.R")
source("R/Self-GenomeNet_pretraining/virus/encoder_virus_pretraining.R")
source("R/Self-GenomeNet_pretraining_ablation/loss_function_reverse_singlelength.R")
train_data_folder <- list("data/virus-no-phage-data/train","data/virus-phage-data/train")
validation_data_folder <- list("data/virus-no-phage-data/validation","data/virus-phage-data/validation")
tensorboard_folder <- "tensorboard"

train_Self_GenomeNet_reverse(
  path            = train_data_folder,
  path.val        = validation_data_folder,
  maxlen          = 150,
  encoder         = encoder_virus_pretraining(150),
  context         = context_virus_pretraining,
  loss_function   = loss_function_reverse,
  batch.size      = 512,
  epochs          = 360,
  steps.per.epoch = 400,
  learningrate    = 0.0001,
  run.name        = paste("Self-GenomeNet_rev_single", format(Sys.time(), "_%y%m%d_%H%M"), sep = ""),
  tensorboard.log = tensorboard_folder,
  trained_model   = NULL,
  savemodels      = TRUE,
  save_every_xth_epoch = 60,
  proportion_per_file = 0.9
)
