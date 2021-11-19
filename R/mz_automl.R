require(h2o)

mz_automl <- function(data_T1, id="AppID", target="Updated",
                      predictors=c("Subcategory_new", "IsFree", "DaysSinceUpdate"),
                      report="aml.model"){

  # ---- fit automl with default parameters ---- #
  train = data_T1[,c(id,target,predictors)]

  # start h2o cluster
  invisible(h2o.init())

  # convert data as h2o type
  train_h = as.h2o(train)

  # set label type
  y = target

  # convert variables to factors
  train[,y] = as.factor(train[,y])

  # Run AutoML for 20 base models
  aml = h2o.automl(x = predictors, y = y,
                   training_frame = train_h,
                   max_models = 20,
                   seed = 1,
                   max_runtime_secs = 20
  )

  # optionally, save model in a file
  save(file=paste0(report,".RData"), list = c("aml"))

  # # AutoML Leaderboard
  # lb = aml@leaderboard

  # prediction result on test data
  prediction <- h2o.predict(aml@leader, train_h)
  prediction <- as.data.frame(prediction)

  # return required output
  data_T1$pred <- prediction$predict
  data_T1$score <- prediction$TRUE.
  df <- data_T1[,c(id,"pred","score")]

  # the return value should include [AppID, Updated, PropensityScore]
  # for each app in the input dataframe
  return(df)
}
