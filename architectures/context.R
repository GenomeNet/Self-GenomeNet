# add your context-network architecture
inp <- layer_input(c(2,2))

context <- keras_model(inputs = inp, outputs = inp %>% layer_lstm(4))
