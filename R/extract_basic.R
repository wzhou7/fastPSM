######################################
#### Process Other Basic Features ####
######################################

# category/subcategories, price/isfree

proc_basic <- function(df,cate_file){
    
    # Cleaned app categories
    df_cate <- read.delim(cate_file, stringsAsFactors = FALSE)
    df_cate$AppURL <- NULL
    df_cate$Subcategory <- gsub(" &amp; ", " and ", df_cate$Subcategory)
    df_cate$Subcategory[df_cate$Subcategory==""] <- df_cate$Category[df_cate$Subcategory==""]
    df_cate$Category <- tolower(df_cate$Category)
    df_cate$Subcategory <- tolower(df_cate$Subcategory)
    names(df_cate)[2:3] <- paste0(names(df_cate)[2:3],"_new")
    df <- merge(df, df_cate, by="AppID", all.x=TRUE, all.y=FALSE)
    
    # Whether the app is free
    df$IsFree <- ifelse(tolower(df$Price)=="free", TRUE,
                        ifelse(df$Price=="", NA, FALSE))
    
    return(df)
}

################################
#### Run Processing on Data ####
################################

df1 <- read.delim("2_appIDs_T1_data_dates.txt", stringsAsFactors = FALSE)
df2 <- read.delim("2_appIDs_T2_data_dates.txt", stringsAsFactors = FALSE)

# A small number of records are missing price information.
AppID1 <- df1$AppID[df1$Price==""]
AppID2 <- df2$AppID[df2$Price==""]
AppIDs <- union(AppID1,AppID2)
df1p <- df1[,c("AppID","AppName","Price")]
df2p <- df2[,c("AppID","AppName","Price")]
df1p2 <- subset(df1p,AppID %in% AppIDs)
df2p2 <- subset(df2p,AppID %in% AppIDs)
df <- merge(df1p2,df2p2,by="AppID")

# fill in T2 price if T1 price is missing
df2p$AppName <- NULL
df1 <- merge(df1,df2p,by="AppID",all.x=TRUE,all.y=FALSE)
df1$Price <- ifelse(df1$Price.x=="", df1$Price.y, df1$Price.x)
df1$Price.x <- NULL
df1$Price.y <- NULL

# fill in T1 price if T2 price is missing
df1p$AppName <- NULL
df2 <- merge(df2,df1p,by="AppID",all.x=TRUE,all.y=FALSE)
df2$Price <- ifelse(df2$Price.x=="", df2$Price.y, df2$Price.x)
df2$Price.x <- NULL
df2$Price.y <- NULL

# Process price/isfree, compatile/optimized, and category/subcategories
cate_file <- "../1_extracted/appIDs_categorized.txt"
df1 <- proc_basic(df1, cate_file)
df2 <- proc_basic(df2, cate_file)

write.table(df1, file="3_appIDs_T1_data_basic.txt", na="", row.names = FALSE, sep="\t")
write.table(df2, file="3_appIDs_T2_data_basic.txt", na="", row.names = FALSE, sep="\t")
