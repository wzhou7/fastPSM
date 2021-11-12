##############################
#### Process Update Dates ####
##############################

proc_dates_str <- function(df,tp_date_str){
    
    # Calculate the number of days from the most recent update to the data 
    # collection date (tp_date_str). 
    data_Date <- as.Date(tp_date_str)
    
    # If the app was never updated, set it as NA
    DaysSinceUpdate <- ifelse(df[,"UpdateDate"]=="", NA, 
                              difftime(as.Date(tp_date_str),
                                       as.Date(df[,"UpdateDate"]),
                                       units="days"))
    df$DaysSinceUpdate <- as.numeric(DaysSinceUpdate)
    
    # create other variations - log, sqrt, ordinal
    df$DaysSinceUpdate_log <- log(df$DaysSinceUpdate+1)
    df$DaysSinceUpdate_sqr <- sqrt(df$DaysSinceUpdate)
    df$DaysSinceUpdate_ord <- cut(df$DaysSinceUpdate, 
                                  c(-1, 14, 30, 60, 90, 120, 180, 240, 360, 720, 99999))
    
    # number of ratings per day (for current version)
    df[,"RateC_nPerDay"] <- ifelse(df[,"DaysSinceUpdate"] >0, 
                                   df[,"RateC_n"] / 
                                       df[,"DaysSinceUpdate"], 
                                   ifelse(df[,"DaysSinceUpdate"]==0, 
                                          df[,"RateC_n"], NA))
    
    return(df)
    
}

################################
#### Run Processing on Data ####
################################

df1 <- read.delim("1_appIDs_T1_data_stars.txt", stringsAsFactors = FALSE)
df2 <- read.delim("1_appIDs_T2_data_stars.txt", stringsAsFactors = FALSE)

# Two data collection points:
# T1: 6/7/2015
# T2: 9/7/2015
df1 <- proc_dates_str(df1, "2015-06-07")
df2 <- proc_dates_str(df2, "2015-09-07")

write.table(df1, file="2_appIDs_T1_data_dates.txt", na="", row.names = FALSE, sep="\t")
write.table(df2, file="2_appIDs_T2_data_dates.txt", na="", row.names = FALSE, sep="\t")


