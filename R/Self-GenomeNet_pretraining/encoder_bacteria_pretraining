 
encoder_bacteria_pretraining <- function(maxlen){

  input_tensor <- keras::layer_input(shape = c(maxlen, 4))

  output_tensor <- input_tensor %>%
  keras::layer_conv_1d(
            kernel_size = 40,
            filters = 1024,
            strides = 20,
            )
        
  #output_tensor <- output_tensor %>% keras::layer_max_pooling_1d(pool_size = 3, strides = 3)

keras_model(inputs = input_tensor, outputs = output_tensor)
}
