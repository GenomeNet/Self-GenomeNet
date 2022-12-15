loss_functionCPC <- function(latents,
  context,
  target_dim = NULL,
  steps_to_ignore = 3,
  steps_to_predict = 4,
  steps_skip = 1,
  batch_size = 32) {
  # define empty lists for metrics
  loss <- list()
  acc <- list()
  
  # create context tensor
  ctx <- context(latents)
  c_dim <- latents$shape[[2]]
  # loop for different distances of predicted patches
  for (i in seq(steps_to_ignore, (steps_to_predict - 1), steps_skip)) {
      c_dim <- latents$shape[[2]]
      target_dim <- latents$shape[[3]]
      # define patches to be deleted
      c_dim_i <- c_dim - i - 1
      # define total number of elements in context tensor
      total_elements <- batch_size * c_dim_i
      # add conv layer and reshape tensor for matrix multiplication
      targets <- latents %>% k_reshape(c(-1, target_dim))
      # add conv layer and reshape for matrix multiplication
      preds_i <-
        ctx %>% layer_conv_1d(kernel_size = 1, filters = target_dim)
      preds_i <- preds_i[, (1:(c_dim - i - 1)),]
      preds_i <- k_reshape(preds_i, c(-1, target_dim))
      # define logits normally
      logits <- tf$matmul(preds_i, tf$transpose(targets))
      # get position of labels
      b <- floor(seq(0, total_elements - 1) / c_dim_i)
      col <- seq(0, total_elements - 1) %% c_dim_i
      # define labels
      labels <- b * c_dim + col + (i + 1)
      labels <- as.integer(labels)
    
    # calculate loss and accuracy for each step
    loss[[length(loss) + 1]] <-
      tf$nn$sparse_softmax_cross_entropy_with_logits(labels, logits) %>%
      tf$stack(axis = 0) %>% tf$reduce_mean()
    acc[[length(acc) + 1]] <-
      tf$keras$metrics$sparse_top_k_categorical_accuracy(tf$cast(labels, dtype = "int64"), logits, as.integer(1)) %>%
      tf$stack(axis = 0) %>% tf$reduce_mean()
  }
  
  # convert to tensor for output
  loss <- loss %>% tf$stack(axis = 0) %>% tf$reduce_mean()
  acc <- acc %>% tf$stack(axis = 0) %>% tf$reduce_mean()
  
  return(tf$stack(list(loss, acc)))
}
