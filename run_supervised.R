Packages <- c("deepG", "keras", "magrittr", "microseq", "purrr", "tensorflow", "tfautograph", "tfdatasets")
suppressMessages(lapply(Packages, library, character.only = TRUE))

self_supervised_model <- load_model_hdf5("pretrained-models/model.hdf5")

# edit code to run supervised model like you did 
trainNetwork(
  train_type = "label_folder",
  model = self_supervised_model,
  path = list("data/viral_phage/train", "data/viral_no_phage/train"),
  path.val = list("data/viral_phage/val", "data/viral_no_phage/val"),
  run.name = "run",
  batch.size = 32,
  epochs = 100,
  steps.per.epoch = 1000,
  ...
  )