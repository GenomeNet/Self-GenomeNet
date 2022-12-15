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

train_model(
  train_type = "label_folder",
  model = model,
  path = c(
    "data/virus-phage-data/train_10percent",
    "data/virus-no-phage-data/train_10percent"
  ),
  path_val = c(
    "data/virus-phage-data/validation",
    "data/virus-no-phage-data/validation"
  ),
  path_checkpoint = "checkpoints",
  run_name = "semisupervised_paper_acgt_train_10percent_directfinetuning",
  batch_size = 2048,
  epochs = 1000,
  patience = 3,
  cooldown = 1,
  steps_per_epoch = 1000,
  step = 150,
  shuffle_file_order = TRUE,
  vocabulary = c("a", "c", "g", "t"),
  path_tensorboard = "tensorboard",
  shuffle_input = TRUE,
  output = list(
    none = FALSE,
    checkpoints = TRUE,
    tensorboard = TRUE,
    log = FALSE,
    serialize_model = FALSE,
    full_model = FALSE
  ),
  vocabulary_label = c("virus-no-phage", "virus-phage"),
  ambiguous_nuc = "discard",
  proportion_per_seq = c(0.9, 0.9),
  seed = c(645, 456),
  skip_amb_nuc = 0.001,
  lr_plateau_factor = 0.1,
  train_val_ratio = 0.2,
  max_samples = 64
)
