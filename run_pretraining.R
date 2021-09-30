Packages <- c("deepG", "keras", "magrittr", "microseq", "purrr", "tensorflow", "tfautograph", "tfdatasets")
suppressMessages(lapply(Packages, library, character.only = TRUE))

source("architectures/encoder.R")
source("architectures/context.R")
source("architectures/cpcloss.R")
source("train.R")

# edit code to run self-supervised model like you did 
trainCPC(
  path = list("data/viral_phage/train", "data/viral_no_phage/train"),
  path.val = list("data/viral_phage/val", "data/viral_no_phage/val"),
  context = context,
  encoder = encoder,
  cpcloss = cpcloss,
  ...)