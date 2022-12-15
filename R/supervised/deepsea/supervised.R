library(keras)
library(deepG)
library(tensorflow)

model <-
  load_model_hdf5("pretrained_models/deepsea-1p.h5", compile = FALSE)

model <-
  remove_add_layers(
    model,
    layer_name = model$layers[[5]]$name,
    freeze_base_model = TRUE,
    dense_layers = NULL,
    compile = FALSE
  )

output_tensor <-
  model$output %>% layer_flatten() %>% layer_dropout_lstm(0.5) %>% #layer_dense(units = 925, activation = "relu") %>% 
  layer_dense(units = 919, activation = "sigmoid")

model <- tf$keras$Model(inputs = model$input, outputs = output_tensor)
optimizer <-  optimizer_rmsprop(learning_rate = 0.0001)
model %>% compile(loss = "binary_crossentropy",
  optimizer = optimizer,
  metrics = c("acc"))

train_model(
  train_type = "label_rds",
  model = model,
  path = "data/deepSea/train",
  path_val = "data/deepSea/validation",
  path_checkpoint = "checkpoints",
  train_val_ratio = 0.01,
  run_name = "semisupervisedpaper_deepsea_acgt_z6_10percent_spe1000_freezed",
  batch_size = 512,
  epochs = 100,
  patience = 50,
  lr_plateau_factor = 0.1,
  proportion_per_seq = NULL,
  max_samples = NULL,
  steps_per_epoch = 1000,
  path_tensorboard = "tensorboard",
  output = list(
    none = FALSE,
    checkpoints = TRUE,
    tensorboard = TRUE,
    log = FALSE,
    serialize_model = FALSE,
    full_model = FALSE
  )
)
