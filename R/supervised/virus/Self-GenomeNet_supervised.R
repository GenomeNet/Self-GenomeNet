file_of_pretrained_model <- "/home/gunduza/projects/cpc_models/acgt_phagenophage_150_selfsup_210809_1847_Epoch_36_temp.h5"

model <- load_model_hdf5(file_of_pretrained_model,compile=FALSE)

model <- remove_add_layers(model, layer_name="lstm", freeze_base_model=FALSE, dense_layers=2,compile=FALSE)
model <- tf$keras$Model(inputs=model$input, outputs=model$output[,-1,])
optimizer <-  keras::optimizer_adam(lr = 0.0001)
model %>% keras::compile(loss = "categorical_crossentropy", optimizer = optimizer, metrics = c("acc"))

trainNetwork(
  train_type = "label_folder",
  model = model,
  path = c("/home/gunduza/viral-no-phage_1_3/train_10percent", "/home/gunduza/viral-phage_1_3/train_10percent"),
  path.val = c("/home/gunduza/viral-no-phage_1_3/validation", "/home/gunduza/viral-phage_1_3/validation"),
  checkpoint_path = "/home/gunduza/projects/cpc_models",
  run.name = "semisupervised_paper_acgt_train_10percent_directfinetuning",
  batch.size = 2048,
  epochs = 1000,
  patience = 3,
  cooldown = 1,
  steps.per.epoch = 1000,
  step = 150,
  randomFiles = TRUE,
  vocabulary = c("a", "c", "g", "t"),
  tensorboard.log = "/home/gunduza/projects/tensorboard",
  shuffleFastaEntries = TRUE,
  output = list(none = FALSE, checkpoints = TRUE, tensorboard = TRUE, log = FALSE, serialize_model = FALSE, full_model = FALSE),
  labelVocabulary = c("virus-no-phage","virus-phage"),
  #reverseComplements = FALSE,
  ambiguous_nuc = "discard",
  proportion_per_file = c(0.9,0.9),
 seed = c(645, 456),
  skip_amb_nuc = 0.001,
  lr.plateau.factor = 0.1,
  validation.split = 0.2,
  max_samples=64
  )
