wzhou4_logit_default <- function(data_T1, id="AppID", target="Updated",
                                 predictors=c("Subcategory_new", "IsFree", "DaysSinceUpdate"),
                                 report="report_file_name"){
    
    scores <- "this is a dummy from wzhou4_logit_default"
    
    # the return value should include [AppID, Updated, PropensityScore] 
    # for each app in the input dataframe
    return(scores)
}
