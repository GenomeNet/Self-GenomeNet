context_bacteria_pretraining <- function(latents) {
  output_tensor <-
    latents %>% keras::layer_lstm(units = 256, return_sequences = TRUE)
  return(output_tensor)
}