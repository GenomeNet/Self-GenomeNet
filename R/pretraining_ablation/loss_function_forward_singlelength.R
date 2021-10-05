#loss function for single-length forward ablation study
loss_function_forward <- function(latents,
  context,
  target_dim = NULL,
  steps_to_ignore = 3,
  steps_to_predict = NULL,
  steps_skip = 1,
  batch.size = 32,
  value = NULL,
  layer = NULL) {
  # define empty lists for metrics
  loss <- list()
  acc <- list()
  
  # create context tensor
  ctx <- context(latents)
  target_dim <- ctx$shape[[3]]
  # loop for different distances of predicted patches
  for (i in seq(steps_to_ignore, (steps_to_predict - 1), steps_skip)) {
    layer <- layer_conv_1d(kernel_size = 1, filters = target_dim)
    ctx1 <- ctx[(1:batch.size), ,] %>% layer
    ctx2 <- ctx[(1 + batch.size):(batch.size * 2), ,]
    logits <- tf$matmul(ctx1[, 10,], tf$transpose(ctx2[, 9,]))
    labels <- floor(seq(0, (batch.size - 1))) %>% as.integer()
    # calculate loss and accuracy for each step
    loss[[length(loss) + 1]] <-
      tf$nn$sparse_softmax_cross_entropy_with_logits(labels, logits) %>%
      tf$stack(axis = 0) %>% tf$reduce_mean()
    acc[[length(acc) + 1]] <-
      tf$keras$metrics$sparse_top_k_categorical_accuracy(tf$cast(labels, dtype = "int64"),
        logits, 1L) %>%
      tf$stack(axis = 0) %>% tf$reduce_mean()
  }
  # convert to tensor for output
  loss <- loss %>% tf$stack(axis = 0) %>% tf$reduce_mean()
  acc <- acc %>% tf$stack(axis = 0) %>% tf$reduce_mean()
  
  return(tf$stack(list(loss, acc)))
  
}
