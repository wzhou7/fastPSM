#############################################################
#### Version N: to study number of ratings (all-version) ####
#############################################################

# Identify all apps listed at both T1 and T2
# Indicate their Update Status

data1 <- read.delim("../../4_extract_info/3_appIDs_T1_data_basic.txt", 
                    stringsAsFactors = FALSE) # n=212,465
data2 <- read.delim("../../4_extract_info/3_appIDs_T2_data_basic.txt", 
                    stringsAsFactors = FALSE) # n=222,550
data2 <- data2[,c("AppID","UpdateDate")]

# The **Update** indicator: whether there is an update between 
# T1 and T2 (do not need update description)
dfN <- merge(data1,data2,by="AppID") # n=193,383
dfN$Updated <- (dfN$UpdateDate.x != dfN$UpdateDate.y)
sum(dfN$Updated==TRUE) # 29,695

write.table(dfN, file="1_T1_apps_VOL.tsv",
            na="", row.names = FALSE, sep="\t", quote = FALSE)
