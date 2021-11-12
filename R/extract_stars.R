#########################
#### Process Ratings ####
#########################

extract_stars <- function(x){
    items <- strsplit(x[1]," ")[[1]]
    stars <- paste0(items[-length(items)], collapse = " ")
    stars <- gsub(" and a half$",".5",stars)
    return(stars)
}

proc_ratings_str <- function(df){
    
    # if RateCurrentVersion is not empty while RateAllVersions is, 
    # fill RateCurrentVersion value into RateAllVersions
    cond <- df[,"RateCurrentVersion",]!="" & df[,"RateAllVersions"]==""
    df[,"RateAllVersions"] <- ifelse(cond,
                                     df[,"RateCurrentVersion"],
                                     df[,"RateAllVersions"])
    
    # extract ratings info (current version)
    ratings_listC <- strsplit(df[,"RateCurrentVersion"],", ")
    df[,"RateC_avg"] <- as.numeric(sapply(ratings_listC, extract_stars))
    df[,"RateC_n"] <- as.numeric(sapply(ratings_listC, function(x){strsplit(x[2]," ")[[1]][1]}))
    df[,"RateC_n"] <- ifelse(is.na(df[,"RateC_n"]), 0, df[,"RateC_n"])
    
    # extract ratings info (all versions)
    ratings_listA <- strsplit(df[,"RateAllVersions"],", ")
    df[,"RateA_avg"] <- as.numeric(sapply(ratings_listA, extract_stars))
    df[,"RateA_n"] <- as.numeric(sapply(ratings_listA, function(x){strsplit(x[2]," ")[[1]][1]}))
    df[,"RateA_n"] <- ifelse(is.na(df[,"RateA_n"]), 0, df[,"RateA_n"])
    
    # weight of the current version rating relative to all version ratings
    #df <- df[,setdiff(names(df),c("RateCurrentVersion","RateAllVersions"))]
    df[,"CurrentVersion_wt"] <- ifelse(df[,"RateA_n"]>0, 
                                       df[,"RateC_n"]/df[,"RateA_n"], NA)
    
    # calculate past version ratings data
    df[,"RateP_n"] <- df[,"RateA_n"] - df[,"RateC_n"]
    val2 <- (df[,"RateA_avg"] * df[,"RateA_n"] - 
                 df[,"RateC_avg"] * df[,"RateC_n"]) / df[,"RateP_n"]
    df[,"RateP_avg"] <- ifelse(df[,"RateP_n"]<=0, NA, # no past ratings
                               ifelse(df[,"RateP_n"]>=df[,"RateA_n"], df[,"RateA_avg"], # only past ratings
                                      val2))
    return(df)
}

################################
#### Run Processing on Data ####
################################

df1 <- read.delim("../2_T1_apps/appIDs_T1_data.txt", stringsAsFactors = FALSE)
df2 <- read.delim("../3_T2_apps/appIDs_T2_data.txt", stringsAsFactors = FALSE)

# Process ratings information
df1 <- proc_ratings_str(df1) 
df2 <- proc_ratings_str(df2) 

write.table(df1, file="1_appIDs_T1_data_stars.txt", na="", row.names = FALSE, sep="\t")
write.table(df2, file="1_appIDs_T2_data_stars.txt", na="", row.names = FALSE, sep="\t")


