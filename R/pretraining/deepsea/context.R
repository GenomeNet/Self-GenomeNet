context_deepsea_pretraining <- function(latents) {
  output_tensor <-
    latents %>% keras::layer_lstm(units = 512, return_sequences = TRUE)
  return(output_tensor)
}
