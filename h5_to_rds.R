# Script to split up deepSea h5 train file (http://deepsea.princeton.edu/media/code/deepsea_train_bundle.v0.9.tar.gz) into 40 rds files
# Creates files called x_1.rds, ..., x_40.rds in target folder

library(hdf5r)

train_path <- "/path/to/deepSea/train/h5/file"
rds_folder <- "/path/to/rds/output"
train_array <- hdf5r::H5File$new(train_path, mode = "r")

count <- 1
for (j in 1:10) {
  num_samples <- 440000
  sample_index <- 1:num_samples
  subset_index <- (1:num_samples) + (j - 1) * num_samples
  train_x <- train_array[["x"]][subset_index, , ]
  train_y <- train_array[["y"]][subset_index, ]
  for (i in 1:4) {
    index <- sample(sample_index, num_samples/4)
    cat("sample_index length: ", length(sample_index), "\n")
    sample_index <- setdiff(sample_index, index)
    x_subset <- train_x[index,,] 
    x_subset <- aperm(x_subset, perm = c(1,3,2))
    y_subset <- train_y[index, ]
    rds_list <- list(x_subset, y_subset)
    rds_path <- paste0(rds_folder, "/x_", count, ".rds")
    saveRDS(rds_list, rds_path)
    count <- count + 1
  }
}  