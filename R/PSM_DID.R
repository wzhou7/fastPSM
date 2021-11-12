#' PSM+DID modeling
#' 
#' This function performs PSM and DID
#' @param df1 Data frame at T1
#' @param df2 Data frame at T2
#' @param id The identifier variable name
#' @param dv The dependent variable name
#' @param iv The independent variable name
#' @param cvs The control variables as an array
#' @return 
#' @examples 
#' PSM_DID(df1,df2,id="AppID",dv="aAUR",iv="Updated",cvs=c("IsFree","DaysSinceLastUpdate"))
#' @export 
PSM_DID <- function(df1,df2,id,dv,iv,cvs){
    
    # Stage 1: PSM
    
    # construct a propensity score straining data frame
    df_PSM <- merge(df1,df2[,c(id,iv)],by=id)
    
    # fit predictive model
    score <- PSM_est(df_PSM, method="custom")
    
    # create match
    df_PSM_matched <- PSM_matching(df_PSM, score, method="1NN")
    
    # Stage 2: DID
    # construct a DID format
    df_DID <- DID_format(df_PSM_matched)
    # fit DID and produce report
    result <- DID_fit(df_DID,report_file)
    
    return(1)
    
}