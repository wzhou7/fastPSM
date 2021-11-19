#' @export
mz_rpart <- function(data_T1, id="AppID", target="Updated",
                                 predictors=c("Subcategory_new", "IsFree", "DaysSinceUpdate"),
                                 report="rpart.model", my.cp=0.05){

    # fit model
    form11 <- paste(target, "~", paste(predictors, collapse = " + "), sep=" ")
    fit <- rpart::rpart(as.formula(form11), data = data_T1,
                 control = rpart::rpart.control(cp = my.cp), method = "class")

    # optionally, save model in a file
    save(file=paste0(report,".RData"), list = c("fit"))

    # return required output
    data_T1$pred <- predict(fit, newdata = data_T1, type = "class")
    data_T1$score <- predict(fit, newdata = data_T1, type = "prob")[,"TRUE"]
    df <- data_T1[,c(id,"pred","score")]

    # the return value should include [AppID, Updated, PropensityScore]
    # for each app in the input dataframe
    return(df)
}
