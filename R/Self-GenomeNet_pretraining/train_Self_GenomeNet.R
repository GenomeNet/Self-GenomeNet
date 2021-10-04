library(keras)
library(deepG)
library(magrittr)
library(tensorflow)
library(tfdatasets)
library(tfautograph)
library(purrr)

train_Self_GenomeNet <-
  function(path,
    path.val,
    encoder,
    context,
    loss_function,
    batch.size,
    epochs,
    steps.per.epoch,
    learningrate,
    run.name,
    tensorboard.log,
    maxlen,
    stepsmin = 1,
    stepsmax = 10,
    file_step = NULL,
    file_max_samples = 64,
    trained_model = NULL,
    savemodels = FALSE,
    proportion_per_file = 0.9,
    save_every_xth_epoch = 12) {
    # Prepare data
    cat("Preparing the data\n")
    if (is.null(file_step)) {
      file_step <- maxlen
    }
    fastrain <-
      fastaFileGenerator(
        path,
        batch.size = batch.size,
        maxlen = maxlen,
        step = fasta_file_step,
        max_samples = file_max_samples,
        randomFiles = TRUE,
        proportion_per_file = proportion_per_file
      )
    fasval <-
      fastaFileGenerator(
        path.val,
        batch.size = batch.size,
        maxlen = maxlen,
        step = fasta_file_step,
        max_samples = file_max_samples,
        randomFiles = TRUE,
        proportion_per_file = proportion_per_file
      )
    
    
    # metrics
    optimizer <- optimizer_adam(lr = learningrate)
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
            batch.size = batch.size,
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
    logdir <- tensorboard.log
    writertrain = tf$summary$create_file_writer(file.path(logdir, run.name, "/train"))
    writerval = tf$summary$create_file_writer(file.path(logdir, run.name, "/validation"))
    
    # batch loop
    training_loop <- function(batches = steps.per.epoch, epoch) {
      #saveloss <- list()
      for (b in seq(batches)) {
        with(tf$GradientTape() %as% tape, {
          a <- fastrain()$X %>% tf$convert_to_tensor()
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
    
    val_loop <- function(batches = steps.per.epoch, epoch) {
      for (b in seq(ceiling(batches * 0.1))) {
        a <- fasval()$X %>% tf$convert_to_tensor()
        a_complement <-
          #a[, tf$convert_to_tensor(seq((dim(a)[2]),1)), tf$convert_to_tensor(seq(4,1))]
          tf$convert_to_tensor(array(as.array(a)[, (dim(a)[2]):1, 4:1], dim = c(dim(a)[1], dim(a)[2], dim(a)[3])))
        a <- tf$concat(list(a, a_complement), axis = 0L)
        #a_complement <- tf$convert_to_tensor(array(as.array(a)[ , (dim(a)[2]):1, 4:1], dim = c(dim(a)[1],dim(a)[2],dim(a)[3])))
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
              "/home/gunduza/projects/cpc_models/",
              run.name,
              "_Epoch_",
              as.array(i),
              "_temp.h5",
              sep = ""
            )
          )
          #file.rename(
          #  paste("/home/gunduza/projects/cpc_models/", run.name, "mid_temp.h5", sep = ""),
          #  paste("/home/gunduza/projects/cpc_models/", run.name, "mid.h5", sep = "")
          #)
          cat("---------- New recent model saved\n")
        }
      }
    }
    return(model)
  }
