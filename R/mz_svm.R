mz_svm <- function(data_T1, id="AppID", target="Updated",
                   predictors=c("Subcategory_new", "IsFree", "DaysSinceUpdate"),
                   report="report_file_name"){
  
  scores <- ""
  data_T1 <- na.omit(data_T1[,c("AppID","Updated","Subcategory_new", "IsFree", "DaysSinceUpdate")])
  data_T1[["Updated"]] = factor(data_T1[["Updated"]])  # make the outcome column a factor
  
  formula <- paste(target, "~", paste(predictors, collapse = " + "), sep=" ")
  trctrl <- trainControl(method = "repeatedcv", number = 10, repeats = 3)
  svm_Linear <- train(as.formula(formula), 
                      data = data_T1, method = "svmLinear",
                      trControl=trctrl,
                      preProcess = c("center", "scale"),
                      tuneLength = 10)
  
  save("svm_Linear", file = "SVM_Model")
  
  data_T1$pred <- predict(svm_Linear, newdata = data_T1)
  data_T1$score <- predict(svm_Linear, newdata = data_T1, type = "prob")[,"TRUE"] # has double rows
  df <- data_T1[,c(id,"pred","score")]
  
  # the return value should include [AppID, Updated, PropensityScore] 
  # for each app in the input dataframe
  return(df)
}
