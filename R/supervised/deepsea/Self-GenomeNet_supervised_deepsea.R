model<-load_model_hdf5("/home/gunduza/projects/cpc_models/deepsea_acgt_z6_210909_1617_Epoch_600_temp.h5",compile=FALSE)


model <- deepG::remove_add_layers(model, layer_name="lstm", freeze_base_model=TRUE, dense_layers=NULL,compile=FALSE)
output_tensor <- model$output %>% keras::layer_flatten()
output_tensor <- output_tensor %>% keras::layer_dropout(0.5)
output_tensor <- output_tensor %>% keras::layer_dense(units = 925,activation = "relu")
output_tensor <- output_tensor %>% keras::layer_dense(units = 919,activation = "sigmoid")

model <- tf$keras$Model(inputs=model$input, outputs=output_tensor)
optimizer <-  keras::optimizer_rmsprop(lr=0.0001)
model %>% keras::compile(loss = "binary_crossentropy",
                              optimizer = optimizer, metrics = c("acc"))

trainNetwork(train_type = "label_rds",
             model = model,
             path = "/home/gunduza/deepsea_train/train_10_2",
             path.val = "/home/gunduza/deepsea_train/validation",
             checkpoint_path = "/home/gunduza/projects/checkpoints_deepsea",
             validation.split = 0.01,
             run.name = "semisupervisedpaper_deepsea_acgt_z6_10percent_spe1000_freezed",
             batch.size = 512,
             epochs = 100,
             patience = 50,
             lr.plateau.factor=0.1,
             proportion_per_file = NULL,
             max_samples = NULL,
             steps.per.epoch = 1000,
             tensorboard.log = "/home/gunduza/projects/tensorboard",
             output = list(none = FALSE,
                           checkpoints = TRUE,
                           tensorboard = TRUE,
                           log = FALSE,
                           serialize_model = FALSE,
                           full_model = FALSE)
)
