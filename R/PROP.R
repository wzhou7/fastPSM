#' @export
PROP <- function(data_T1, id="AppID", target="Updated",
                 predictors=c("Subcategory_new", "IsFree", "DaysSinceUpdate"),
                 method="wzhou4_logit_default",
                 report="report_file_name"){

    # select method to run

    if(method=="wzhou4_logit_default"){
        scores <- wzhou4_logit_default(data_T1,id,target,predictors,report)
    }

    if(method=="rpart"){
        scores <- mz_rpart(data_T1,id,target,predictors,report)
    }

#    if(method=="svm"){
#        scores <- mz_svm(data_T1,id,target,predictors,report)
#    }

#    if(method=="automl"){
#        scores <- mz_automl(data_T1,id,target,predictors,report)
#    }

    return(scores)
}
