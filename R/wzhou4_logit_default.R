#' @export
wzhou4_logit_default <- function(data_T1, id="AppID", target="Updated",
                                 predictors=c("Subcategory_new", "IsFree", "DaysSinceUpdate"),
                                 report="report_file_name", miss_cut=0.05){

  # Since regression models do not handle missing values well, yet we need a prediction for every record,
  # we use some heuristics to manage missing values.

  # find missingness of each variable
  n_miss <- apply(data_T1[,predictors],2,function(x){sum(is.na(x))})
  pct_miss <- n_miss/NROW(data_T1)

  # if >5% missing, partition data into missing vs. not missing
  miss_cut <- max(miss_cut, 30/NROW(data_T1)) # minimum n=30 for regression
  seg_vars <- predictors[pct_miss>miss_cut]
  num_seg_vars <- length(seg_vars)
  num_segs <- 2^num_seg_vars
  segs <- data.frame(c(1,0))
  names(segs)[1] <- seg_vars[1]
  if(num_seg_vars>1){
    for(j in 2:num_seg_vars){
      seg_df <- data.frame(c(1,0))
      names(seg_df)[1] <- seg_vars[j]
      segs <- merge(x = segs, y = seg_df, by = NULL)
    }
  }

  # fit a separate logistic model within each partition
  df <- NULL
  for(i in 1:NROW(segs)){

    # extract records within the i-th segment
    cond <- rep(TRUE,NROW(data_T1))
    for(j in 1:NCOL(segs)){
      cond_temp <- as.numeric(!is.na(data_T1[,seg_vars[j]]))==segs[i,j]
      cond <- cond & cond_temp
    }
    df11 <- subset(data_T1, cond) # n= 13,957

    # df11 = apps that had a prior update and at least one rating at T1 (n=13,957)
    required_vars <- seg_vars[segs[i,]==1]
    other_predictors <- setdiff(predictors, required_vars)
    form11 <- paste(target, "~", paste(c(required_vars,other_predictors), collapse = " + "), sep=" ")
    fit.lm11 <- glm(as.formula(form11), family = binomial(link = "logit"), data=df11)
    # summary(fit.lm00)
    save(paste0(report,"_seg",i,".RData"), list("fit.lm11"))

    # calculate and save probability to update
    df11$fitted_prob <- fitted(fit.lm11)

    # calculate and save update prediction
    df11$pred <- df11$fitted_prob>0.5

    # calculate and save propensity scored
    df11$score <- predict(fit.lm11)

    # create return version
    df11 <- df11[,c(id,"pred","score")]
    df <- rbind(df,df11)
  }

  # the return value should include [AppID, Updated, PropensityScore]
  # for each app in the input dataframe
  return(df)
}
