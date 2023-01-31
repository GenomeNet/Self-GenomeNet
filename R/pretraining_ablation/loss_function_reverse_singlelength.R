loss_function_reverse <- function(latents,
  context,
  target_dim = NULL,
  steps_to_ignore = 1,
  steps_to_predict = 2,
  steps_skip = 1,
  batch_size = 128,
  value = NULL,
  layer = NULL) {
  # define empty lists for metrics
  loss <- list()
  acc <- list()
  
  # create context tensor
  ctx <- context(latents)
  target_dim <- ctx$shape[[3]]
  context_length <- ctx$shape[[2]]
  #batch.size <- as.integer(ctx$shape[[1]]/2)
  # loop for different distances of predicted patches
  for (i in seq(steps_to_ignore, (steps_to_predict - 1), steps_skip)) {
    ctx1 <-
      ctx %>% layer_conv_1d(kernel_size = 1, filters = target_dim)
    ctx2 <- ctx
    logits_flag <- FALSE
    j <- 24
    #for (j in seq_len(context_length - (i + 1))) {
    preds_ij <- ctx1[, j,]# %>% k_reshape(c(-1, target_dim))
      revcompl_j <-
        ctx2[, (context_length - j - i), ] #%>% k_reshape(c(-1, target_dim))
      logitsnew <- tf$matmul(preds_ij, tf$transpose(revcompl_j))
      logitsnew <- logitsnew - 1000*tf$eye(as.integer(2*batch.size))
      logitsnew <- logitsnew
      if (isTRUE(logits_flag)) {
        logits <- tf$concat(list(logits, logitsnew), axis = 0L)
      } else {
        logits <- logitsnew
        logits_flag <- TRUE
      }
    #}
    # labels
    labels <-
      c(seq(batch.size, (2 * batch.size - 1)), (seq(0, (batch.size - 1)))) %>% as.integer()
    
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
