#this function is to reshape input for a given model, used in language modelling for deepsea dataset
reshape_input <- function(model, input_shape) {
  
  in_layer <- layer_input(shape = input_shape) 
  for (i in 2:length(model$layers)) {
    layer_name <- model$layers[[i]]$name
    if (i == 2) {
      out_layer <- in_layer %>% model$get_layer(layer_name)()
    } else {
      out_layer <- out_layer %>% model$get_layer(layer_name)()
    }
  }
  new_model <- tensorflow::tf$keras$Model(in_layer, out_layer)
  return(new_model)
}
