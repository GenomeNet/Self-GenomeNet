encoder_virus_pretraining <- function(maxlen) {
  input_tensor <- keras::layer_input(shape = c(maxlen, 4))
  output_tensor <- input_tensor %>%
    keras::layer_conv_1d(kernel_size = 24,
                         filters = 1024,
                         strides = 6)
  keras_model(inputs = input_tensor, outputs = output_tensor)
}