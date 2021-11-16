mz_automl <- function(data_T1, id="AppID", target="Updated",
                                 predictors=c("Subcategory_new", "IsFree", "DaysSinceUpdate"),
                                 report="report_file_name"){
    
    # initialize scored as all missing
    scores <- rep(NA,NROW(data_T1))
  
    # fit automl with default parameters
  
    # start h2o cluster
    invisible(h2o.init())
  
  # convert data as h2o type
  train_h = as.h2o(train)
  test_h = as.h2o(test)
  
  # set label type
  y = 'Update'
  pred = setdiff(names(train), y)
  
  #convert variables to factors
  train[,y] = as.factor(train[,y])
  test[,y] = as.factor(test[,y])
  
  # Run AutoML for 20 base models
  aml = h2o.automl(x = pred, y = y,
                   training_frame = train_h,
                   max_models = 20,
                   seed = 1,
                   max_runtime_secs = 20
  )
  
  # AutoML Leaderboard
  lb = aml@leaderboard
  
  # prediction result on test data
  prediction = h2o.predict(aml@leader, test_h[,-5]) %>%
    as.data.frame()
  
    
    # the return value should include [AppID, Updated, PropensityScore] 
    # for each app in the input dataframe
    return(scores)
}
