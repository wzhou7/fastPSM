#' @export
getPSM <- function(formula, data, method=c("logit")){

    if("logit" %in% method){
        scores <- PSM_logit(formula, data)
    }

    if("rpart" %in% method){
        scores <- PSM_rpart(formula, data)
    }

    if("svm" %in% method){
        scores <- PSM_svm(formula, data)
    }

    if("automl" %in% method){
        scores <- PSM_automl(formula, data)
    }

    return(scores)
}
