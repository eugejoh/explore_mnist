# Extract Data ------------------------------------------------------------
# Eugene JOh
# 2019-03-14

# Data were downloaded from http://yann.lecun.com/exdb/mnist/
# http://yann.lecun.com/exdb/publis/pdf/lecun-98.pdf
# Four files: two training, two testing datasets

# Import to R script: https://gist.github.com/daviddalpiaz/ae62ae5ccd0bada4b9acd6dbc9008706
# Import to R SO: https://stackoverflow.com/questions/21521571/how-to-read-mnist-database-in-r

# Videos:
# https://www.youtube.com/watch?v=si4HSgneKY0
# https://www.youtube.com/watch?v=ZD_tfNpKzHY
# https://www.youtube.com/watch?v=s8q_OQBJpwU #Support Vector Machine Learning MNIST Handwritten Digits
library(here)
library(dplyr)
library(purrr)
library(R.utils)


# Unzip Files -------------------------------------------------------------
unzip <- FALSE
if (unzip) walk(list.files(here::here("data"), pattern = "\\.gz$", full.names = TRUE), ~R.utils::gunzip(., remove=FALSE))

# Import Binary Files -----------------------------------------------------

# # Import as an Array
# f_con <- file(here::here("data","train-images-idx3-ubyte"), "rb")
# h <- readBin(f_con, "int", n = 4, size = 4, endian = "big") #get header
# i <- h[2]
# nrows <- h[3]
# ncols <- h[4]
# train <- replicate(i, matrix(readBin(f_con, "int", n = nrows*ncols, size = 1, endian = "big", signed = FALSE), nrows, ncols))
# close(f_con)
# class(train) #how to add labels?

# Import as Data Frame # see https://gist.github.com/daviddalpiaz/ae62ae5ccd0bada4b9acd6dbc9008706
# load image files
load_image_file <- function(filename) {
  f <- file(filename, 'rb')
  readBin(f, 'integer', n = 1, size = 4, endian = 'big')
  n    <- readBin(f, 'integer', n = 1, size = 4, endian = 'big')
  nrows <- readBin(f, 'integer', n = 1, size = 4, endian = 'big')
  ncols <- readBin(f, 'integer', n = 1, size = 4, endian = 'big')
  x <- readBin(f, 'integer', n = n*nrows*ncols, size = 1, signed = FALSE)
  close(f)
  data.frame(matrix(x, ncol = nrows*ncols, byrow = TRUE))
}

# load label files
load_label_file <- function(filename) {
  f <- file(filename, 'rb')
  readBin(f, 'integer', n = 1, size = 4, endian = 'big')
  n <- readBin(f, 'integer', n = 1, size = 4, endian = 'big')
  y <- readBin(f, 'integer', n = n, size = 1, signed = FALSE)
  close(f)
  y
}

# load images
train <- load_image_file(here::here("data","train-images-idx3-ubyte"))
test <- load_image_file(here::here("data","t10k-images-idx3-ubyte"))

# load labels
train$lab <- as.factor(load_label_file(here::here("data","train-labels-idx1-ubyte")))
test$lab <- as.factor(load_label_file(here::here("data","t10k-labels-idx1-ubyte")))

show_digit = function(df, col = gray(12:1 / 12), ...) {
  image(matrix(as.matrix(df[-785]), nrow = 28)[, 28:1], col = col, ...)
  message("label: ",df[,"lab"])
}
#
# i <- sample(nrow(train), 1)
# show_digit(train[i,])
