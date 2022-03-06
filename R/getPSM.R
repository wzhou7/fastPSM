#' @export
getPSM <- function(formula, data, method=c("logit")){

    scores <- NULL
    
    if("logit" %in% method){
        logit_score <- PSM_logit(formula, data)
        scores <- cbind(scores, logit_score)
    }

    if("rpart" %in% method){
        rpart_score <- PSM_rpart(formula, data)
        scores <- cbind(scores, rpart_score)
    }

    if("svm" %in% method){
        svm_score <- PSM_svm(formula, data)
        scores <- cbind(scores, svm_score)
    }

    if("nb" %in% method){
        nb_score <- PSM_nb(formula, data)
        scores <- cbind(scores, nb_score)
    }

    if("ann" %in% method){
        ann_score <- PSM_ann(formula, data)
        scores <- cbind(scores, ann_score)
    }
    
    if("automl" %in% method){
        automl_score <- PSM_automl(formula, data)
        scores <- cbind(scores, automl_score)
    }

    # re-arrange the output columns
    scores <- as.data.frame(scores)
    scores <- scores[,method]
    return(scores)
}
