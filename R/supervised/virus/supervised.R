library(keras)
library(deepG)
library(tensorflow)

model <-
  load_model_hdf5("pretrained_models/viruspretraining.h5", compile = FALSE)

model <-
  remove_add_layers(
    model,
    layer_name = model$layers[[3]]$name,
    freeze_base_model = FALSE,
    dense_layers = 2,
    compile = FALSE
  )

model <-
  tf$keras$Model(inputs = model$input, outputs = model$output[, -1,])
optimizer <-  optimizer_adam(learning_rate = 0.0001)
model %>% compile(loss = "categorical_crossentropy",
  optimizer = optimizer,
  metrics = c("acc"))

trainNetwork(
  train_type = "label_folder",
  model = model,
  path = c(
    "data/virus-phage-data/train_10percent",
    "data/virus-no-phage-data/train_10percent"
  ),
  path.val = c(
    "data/virus-phage-data/validation",
    "data/virus-no-phage-data/validation"
  ),
  checkpoint_path = "checkpoints",
  run.name = "semisupervised_paper_acgt_train_10percent_directfinetuning",
  batch.size = 2048,
  epochs = 1000,
  patience = 3,
  cooldown = 1,
  steps.per.epoch = 1000,
  step = 150,
  randomFiles = TRUE,
  vocabulary = c("a", "c", "g", "t"),
  tensorboard.log = "tensorboard",
  shuffleFastaEntries = TRUE,
  output = list(
    none = FALSE,
    checkpoints = TRUE,
    tensorboard = TRUE,
    log = FALSE,
    serialize_model = FALSE,
    full_model = FALSE
  ),
  labelVocabulary = c("virus-no-phage", "virus-phage"),
  ambiguous_nuc = "discard",
  proportion_per_file = c(0.9, 0.9),
  seed = c(645, 456),
  skip_amb_nuc = 0.001,
  lr.plateau.factor = 0.1,
  validation.split = 0.2,
  max_samples = 64
)
