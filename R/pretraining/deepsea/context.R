context_deepsea_pretraining <- function(output_tensor) {
  output_tensor <- output_tensor %>% keras::layer_dropout_lstm(0.2)
  output_tensor <- output_tensor %>% keras::layer_lstm(units = 320,return_sequences = TRUE)
  return(output_tensor)
}
