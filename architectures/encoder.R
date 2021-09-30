# add your encoder-network architecture
inp <- layer_input(c(2,2))

encoder <- keras_model(inputs = inp, outputs = inp %>% layer_conv_1d(4,2))
