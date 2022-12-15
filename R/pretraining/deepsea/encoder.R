encoder_deepsea_pretraining <- function(maxlen) {
  input_tensor <- keras::layer_input(shape = c(maxlen, 4))
  output_tensor <- input_tensor %>%
    keras::layer_conv_1d(kernel_size = 26,
                         filters = 320,
                         strides = 1)
  output_tensor <-
    output_tensor %>% keras::layer_max_pooling_1d(pool_size = 13, strides = 13)
  keras_model(inputs = input_tensor, outputs = output_tensor)
}