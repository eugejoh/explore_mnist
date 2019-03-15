# Attempt 1: SVM Method ---------------------------------------------------
# Eugene Joh
# 2019-03-14

# Based on http://yann.lecun.com/exdb/mnist/
# Simple Support Vector Machine using Gaussian Kernel model results in 1.4%

library(here)
# install.packages("e1071")
library(e1071)
library(dplyr)

# Import Data -------------------------------------------------------------
source(here::here("00_import_data.R"))

?e1071::svm

train <- train %>% select(lab, everything()) %>% mutate_if(is.integer, as.numeric) %>% mutate(lab = ordered(lab))
test <- test %>% select(lab, everything()) %>% mutate_if(is.integer, as.numeric)  %>% mutate(lab = ordered(lab))

train %>% count(lab) %>% mutate(prop =n/sum(n))
test %>% count(lab) %>% mutate(prop =n/sum(n))

svm_fit <- svm(lab ~ ., data = train[1:100,1:10], scale=FALSE)
print(svm_fit)
plot(x = svm_fit, data =  train[1:100,], lab ~ X1, fill=TRUE)

plot(svm_fit, data = train[1:100,],lab ~ X1, col=predict(svm_fit))


train %>% head(10000) %>%
  rename(label = X1) %>%
  mutate(instance = row_number()) %>%
  gather(pixel, value, -label, -instance) %>%
  tidyr::extract(pixel, "pixel", "(\\d+)", convert = TRUE) %>%
  mutate(pixel = pixel - 2,
         x = pixel %% 28,
         y = 28 - pixel %/% 28)
