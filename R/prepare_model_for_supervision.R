prepare_model_for_supervision <- function(model, number_of_classes = 2, lr = 0.0001, trainable = TRUE, layer = 3){
  output <- model$layers[[layer]]$output[,-1,]
  model$trainable <- trainable
  output <- output %>% keras::layer_dense(units = number_of_classes, activation = "softmax")
  model <- tf$keras$Model(inputs = model$input, outputs = output)
  optimizer <-  optimizer_adam(learning_rate = lr)
  model %>% compile(loss = "categorical_crossentropy", optimizer = optimizer, metrics = c("acc"))
  return(model)
}
