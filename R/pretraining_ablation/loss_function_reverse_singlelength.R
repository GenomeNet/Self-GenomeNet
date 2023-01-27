loss_function_reverse <- function(latents,
  context,
  target_dim = NULL,
  steps_to_ignore = 3,
  steps_to_predict = NULL,
  steps_skip = 1,
  batch_size = 32,
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
    ctx1 <- ctx[(1:batch_size), ,] %>% layer
    ctx2 <- ctx[(1 + batch_size):(batch_size * 2), ,]
    logits <- tf$matmul(ctx1[, 10,], tf$transpose(ctx2[, 9,]))
    labels <- floor(seq(0, (batch_size - 1))) %>% as.integer()
    # calculate loss and accuracy for each step
    loss[[length(loss) + 1]] <-
      tf$nn$sparse_softmax_cross_entropy_with_logits(labels, logits) %>%
      tf$stack(axis = 0) %>% tf$reduce_mean()
    acc[[length(acc) + 1]] <-
      tf$keras$metrics$sparse_top_k_categorical_accuracy(tf$cast(labels, dtype = "int64"),
        logits) %>%
      tf$stack(axis = 0) %>% tf$reduce_mean()
    ctx1 <- ctx[(1 + batch_size):(batch_size * 2), ,] %>% layer
    ctx2 <- ctx[(1:batch_size), ,]

    logits <- tf$matmul(ctx1[, 9,], tf$transpose(ctx2[, 10,]))
    # always the patch from the same batch is the true one
    #labels <- floor(seq(0,(batch_size-1)))%>% as.integer()#((dim(revcompl1)[[2]] - (i + 1))*2)) %>% as.integer()

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
