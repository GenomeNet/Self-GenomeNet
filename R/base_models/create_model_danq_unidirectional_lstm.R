create_model_danq_unidirectional_lstm <- function(
  maxlen = 1000,
  num_targets = 919,
  vocabulary.size = 4,
  learning.rate = 0.0001) {
  
    
  input_tensor <- keras::layer_input(shape = c(maxlen, vocabulary.size))
  
  output_tensor <- input_tensor %>%
  keras::layer_conv_1d(
            kernel_size = 26,
            filters = 320,
            strides = 1,
            )
        
  output_tensor <- output_tensor %>% keras::layer_max_pooling_1d(pool_size = 13, strides = 13)
  output_tensor <- output_tensor %>% keras::layer_dropout(rate=0.2)
  output_tensor <- output_tensor %>% keras::layer_lstm(units = 320,return_sequences = TRUE)
  output_tensor <- output_tensor %>% keras::layer_dropout(rate=0.5)
  output_tensor <- output_tensor %>% keras::layer_flatten()
  output_tensor <- output_tensor %>% keras::layer_dense(units = 925,activation = "relu")
  output_tensor <- output_tensor %>% keras::layer_dense(units = 919,activation = "sigmoid")
  model <- keras::keras_model(inputs = input_tensor, outputs = output_tensor)
  
  optimizer <-  keras::optimizer_rmsprop(lr = learning.rate)
  model %>% keras::compile(loss = "binary_crossentropy", optimizer = optimizer, metrics = c("acc"))
  model
  }
model <- create_model_danq()
