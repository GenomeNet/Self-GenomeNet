library(keras)
library(deepG)
library(magrittr)
library(tensorflow)
library(tfdatasets)
library(tfautograph)
library(purrr)

train_Self_GenomeNet <-
  function(path,
           path_val,
           encoder,
           context,
           loss_function,
           batch_size,
           epochs,
           steps_per_epoch,
           learningrate,
           deepSea = F,
           run_name,
           path_tensorboard,
           maxlen,
           stepsmin = 2,
           stepsmax = 20,
           file_step = NULL,
           file_max_samples = 64,
           trained_model = NULL,
           savemodels = FALSE,
           proportion_per_seq = 0.1,
           save_every_xth_epoch = 100) {
    # Prepare data
    cat("Preparing the data\n")
    if (is.null(file_step)) {
      file_step <- maxlen
    }
    if (deepSea) {
      fastrain <-
        generator_fasta_lm(
          path,
          batch_size = batch_size,
          maxlen = maxlen,
          step = file_step,
          max_samples = file_max_samples,
          shuffle_file_order = TRUE,
          proportion_per_seq = proportion_per_seq
        )
      fasval <-
        generator_fasta_lm(
          path_val,
          batch_size = batch_size,
          maxlen = maxlen,
          step = file_step,
          max_samples = file_max_samples,
          shuffle_file_order = TRUE,
          proportion_per_seq = proportion_per_seq
        )
    } else {
      fastrain <-
        gen_rds(path,
                batch_size = batch_size)
      fasval <-
        gen_rds(path_val,
                batch_size = batch_size)
    }
    # metrics
    optimizer <- optimizer_adam(learning_rate = learningrate)
    train_loss <- tf$keras$metrics$Mean(name = 'train_loss')
    val_loss <- tf$keras$metrics$Mean(name = 'val_loss')
    train_acc <- tf$keras$metrics$Mean(name = 'train_acc')
    val_acc <- tf$keras$metrics$Mean(name = 'val_acc')
    
    # model
    cat("Creating the model\n")
    if (is.null(trained_model)) {
      model <-
        keras_model(
          encoder$input,
          loss_function(
            encoder$output,
            context,
            batch_size = batch_size,
            steps_to_ignore = stepsmin,
            steps_to_predict = stepsmax
          )
        )
    } else {
      cat(
        format(Sys.time(), "%F %R"),
        ": Loading the trained model; will be compiled manually.\n"
      )
      model <- load_model_hdf5(trained_model)
    }
    
    # connect tensorboard
    logdir <- path_tensorboard
    writertrain = tf$summary$create_file_writer(file.path(logdir, run_name, "/train"))
    writerval = tf$summary$create_file_writer(file.path(logdir, run_name, "/validation"))
    
    # batch loop
    training_loop <- function(batches = steps_per_epoch, epoch) {
      for (b in seq(batches)) {
        with(tf$GradientTape() %as% tape, {
          if (deepSea) {
            a <- fastrain()[[1]] %>% tf$convert_to_tensor()
          } else {
            a <- fastrain()$X %>% tf$convert_to_tensor()
          }
          a_complement <-
            tf$convert_to_tensor(array(as.array(a)[, (dim(a)[2]):1, 4:1], dim = c(dim(a)[1], dim(a)[2], dim(a)[3])))
          a <- tf$concat(list(a, a_complement), axis = 0L)
          out <- model(a)
          l <- out[1]
          acc <- out[2]
        })
        
        gradients <- tape$gradient(l, model$trainable_variables)
        optimizer$apply_gradients(purrr::transpose(list(
          gradients, model$trainable_variables
        )))
        train_loss(l)
        train_acc(acc)
      }
      
      with(writertrain$as_default(), {
        tf$summary$scalar('epoch_loss',
                          train_loss$result(),
                          step = tf$cast(epoch, "int64"))
        tf$summary$scalar('epoch_accuracy',
                          train_acc$result(),
                          step = tf$cast(epoch, "int64"))
      })
      
      tf$print("Train Loss",
               train_loss$result(),
               ", Train Acc",
               train_acc$result())
      train_loss$reset_states()
      train_acc$reset_states()
    }
    
    val_loop <- function(batches = steps_per_epoch, epoch) {
      for (b in seq(ceiling(batches * 0.1))) {
        if (deepSea) {
          a <- fasval()[[1]] %>% tf$convert_to_tensor()
        } else {
          a <- fasval()$X %>% tf$convert_to_tensor()
        }
        a_complement <-
          tf$convert_to_tensor(array(as.array(a)[, (dim(a)[2]):1, 4:1], dim = c(dim(a)[1], dim(a)[2], dim(a)[3])))
        a <- tf$concat(list(a, a_complement), axis = 0L)
        out <- model(a)
        l <- out[1]
        acc <- out[2]
        
        val_loss(l)
        val_acc(acc)
      }
      
      with(writerval$as_default(), {
        tf$summary$scalar('epoch_loss',
                          val_loss$result(),
                          step = tf$cast(epoch, "int64"))
        tf$summary$scalar('epoch_accuracy',
                          val_acc$result(),
                          step = tf$cast(epoch, "int64"))
      })
      tf$print("Validation Loss",
               val_loss$result(),
               ", Validation Acc",
               val_acc$result())
      
      val_loss$reset_states()
      val_acc$reset_states()
    }
    
    # epoch loop
    cat("Starting Training\n")
    for (i in 1:epochs) {
      cat("Epoch: ", i, " -----------\n")
      training_loop(epoch = i)
      val_loop(epoch = i)
      if (savemodels) {
        if (i %% save_every_xth_epoch == 0) {
          model %>% save_model_hdf5(
            paste(
              "pretrained_models/",
              run_name,
              "_Epoch_",
              as.array(i),
              "_temp.h5",
              sep = ""
            )
          )
          cat("---------- New recent model saved\n")
        }
      }
    }
    return(model)
  }
