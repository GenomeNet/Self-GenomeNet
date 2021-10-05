model<-load_model_hdf5("/home/gunduza/projects/cpc_models/acgt_z5_bacteria_1k_selfsup_210910_2341_Epoch_1000_temp.h5", compile=FALSE)

model <- deepG::remove_add_layers(model, layer_name="lstm", freeze_base_model=FALSE, dense_layers=2,compile=FALSE)
model <- tf$keras$Model(inputs=model$input, outputs=model$output[,-1,])
optimizer <-  keras::optimizer_adam(lr = 0.0001)
model %>% keras::compile(loss = "categorical_crossentropy",
                              optimizer = optimizer, metrics = c("acc"))

deepG::trainNetwork(
  train_type = "label_folder",
  model = model,
  path = c("/home/gunduza/viral-no-phage_1_3/train", "/home/gunduza/viral-phage_1_3/train"),
  path.val = c("/home/gunduza/viral-no-phage_1_3/validation", "/home/gunduza/viral-phage_1_3/validation"),
  checkpoint_path = "/home/gunduza/projects/cpc_models",
  run.name = "semisupervised_paper_acgt_z5_bacteriapretrained_train100percent_supervised_spe_bs_vs_linearev",
  batch.size = 2048,
  epochs = 1000,
  patience = 3,
  cooldown = 1,
  steps.per.epoch = 400,
  step = 1000,
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
  #pprmetaEncoding = FALSE,
  #reverseComplementEncoding = FALSE
  )
