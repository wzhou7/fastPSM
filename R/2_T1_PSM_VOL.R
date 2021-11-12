df <- read.delim("1_T1_apps_VOL.tsv", stringsAsFactors = FALSE) 
names(df)

########################################
#### Features for Update Propensity ####
########################################

# Extract additional features if needed

# hist(df$SinceUpdate)
# hist(df$RateC_n)
# hist(df$RateC_avg)

df$Popularity <- log(df$RateC_n+1)
#df$Rate_gap <- df$RateC_avg - df$RateP_avg 
# Rate_gap insignificant thus removed

df$IsFree <- as.factor(df$IsFree)
df$Category_new <- as.factor(df$Category_new)
df$Subcategory_new <- as.factor(df$Subcategory_new)

###################################
#### Split Data into 4 Subsets ####
###################################

#sum(complete.cases(df)) # 13,957 complete cases
#df <- df[complete.cases(df),]
sum(is.na(df$DaysSinceUpdate)) #  68,387 missing
sum(is.na(df$RateC_avg))   # 172,929 missing
#sum(is.na(df$Rate_gap))   # 180,291 missing

# Train logistic models by subgroup
table(is.na(df$DaysSinceUpdate),is.na(df$RateC_avg))
#        FALSE   TRUE
# FALSE  13957 111039
# TRUE    6497  61890
df11 <- subset(df, (!is.na(df$DaysSinceUpdate)) & (!is.na(df$RateC_avg))) # n= 13,957
df10 <- subset(df, (!is.na(df$DaysSinceUpdate)) & ( is.na(df$RateC_avg))) # n=111,039
df01 <- subset(df, ( is.na(df$DaysSinceUpdate)) & (!is.na(df$RateC_avg))) # n=  6,497
df00 <- subset(df, ( is.na(df$DaysSinceUpdate)) & ( is.na(df$RateC_avg))) # n= 61,890

write.table(df11, file="T1_PSM_VOL/df11.tsv", na="", row.names = FALSE, sep="\t", quote = FALSE)
write.table(df10, file="T1_PSM_VOL/df10.tsv", na="", row.names = FALSE, sep="\t", quote = FALSE)
write.table(df01, file="T1_PSM_VOL/df01.tsv", na="", row.names = FALSE, sep="\t", quote = FALSE)
write.table(df00, file="T1_PSM_VOL/df00.tsv", na="", row.names = FALSE, sep="\t", quote = FALSE)

####################################
#### Baseline Update Propensity ####
####################################

# df11 = apps that had a prior update and at least one rating at T1 (n=13,957)
df11 <- read.delim("T1_PSM_VOL/df11.tsv", stringsAsFactors = FALSE) 
fit.lm11 <- glm(Updated ~ IsFree + Category_new + Subcategory_new + 
                  DaysSinceUpdate_sqr + DaysSinceUpdate + 
                  Popularity + RateC_avg,
                family = binomial(link = "logit"), data=df11)
summary(fit.lm11)

df11$fitted_prob <- fitted(fit.lm11)     # probability to update
df11$update_prob <- df11$fitted_prob>0.5 # update prediction
df11$logit_scores <- predict(fit.lm11)   # propensity scores

# df10 = apps that had a prior update but no rating at T1 (n=111,039)
df10 <- read.delim("T1_PSM_VOL/df10.tsv", stringsAsFactors = FALSE) 
fit.lm10 <- glm(Updated ~ IsFree + Category_new + Subcategory_new + 
                  DaysSinceUpdate_sqr + DaysSinceUpdate,
                family = binomial(link = "logit"), data=df10)
summary(fit.lm10)

df10$fitted_prob  <- fitted(fit.lm10)     # probability to update
df10$update_prob  <- df10$fitted_prob>0.5 # update prediction
df10$logit_scores <- predict(fit.lm10)    # propensity scores

# df01 = apps that had no prior update but at least one rating at T1 (n=6,497)
df01 <- read.delim("T1_PSM_VOL/df01.tsv", stringsAsFactors = FALSE) 
fit.lm01 <- glm(Updated ~ IsFree + Category_new + Subcategory_new
                + Popularity + RateC_avg,
                family = binomial(link = "logit"), data=df01)
summary(fit.lm01)

df01$fitted_prob  <- fitted(fit.lm01)     # probability to update
df01$update_prob  <- df01$fitted_prob>0.5 # update prediction
df01$logit_scores <- predict(fit.lm01)    # propensity scores

# df00 = apps that had no prior update and no rating at T1 (n=61,890)
df00 <- read.delim("T1_PSM_VOL/df00.tsv", stringsAsFactors = FALSE) 
fit.lm00 <- glm(Updated ~  IsFree + Category_new + Subcategory_new,
                family = binomial(link = "logit"), data=df00)
summary(fit.lm00)

df00$fitted_prob  <- fitted(fit.lm00)     # probability to update
df00$update_prob  <- df00$fitted_prob>0.5 # update prediction
df00$logit_scores <- predict(fit.lm00)    # propensity scores

# save the models
save("T1_PSM_VOL/glm_models.RData", list(fit.lm11, fit.lm10, fit.lm01, fit.lm00))

library("stargazer")
stargazer(fit.lm11, fit.lm10, fit.lm01, fit.lm00,
          type="html", title="Update Propensity", 
          out="T1_PSM_VOL/PSM_models.html")

# combine and save the data
df_new <- rbind(df00,df01,df10,df11)

df_updated <- subset(df_new, Updated) # n=29,686
df_not_updated <- subset(df_new, !Updated) # n=163,684

# find top 10 matching not_updated for each updated
df_updated$match1 <- NA
df_updated$match2 <- NA
df_updated$match3 <- NA
df_updated$match4 <- NA
df_updated$match5 <- NA
df_updated$match6 <- NA
df_updated$match7 <- NA
df_updated$match8 <- NA
df_updated$match9 <- NA
df_updated$match10 <- NA

df_updated$score1 <- NA
df_updated$score2 <- NA
df_updated$score3 <- NA
df_updated$score4 <- NA
df_updated$score5 <- NA
df_updated$score6 <- NA
df_updated$score7 <- NA
df_updated$score8 <- NA
df_updated$score9 <- NA
df_updated$score10 <- NA

for(i in 1:NROW(df_updated)){ 
  updated_propensity <- df_updated$logit_scores[i]
  diff <- abs(df_not_updated$logit_scores - updated_propensity)
  idx <- order(diff) # want min difference
  sorted_appIDs <- df_not_updated$AppID[idx]
  sorted_scores <- diff[idx]
  
  df_updated$match1[i]  <- sorted_appIDs[1]
  df_updated$match2[i]  <- sorted_appIDs[2]
  df_updated$match3[i]  <- sorted_appIDs[3]
  df_updated$match4[i]  <- sorted_appIDs[4]
  df_updated$match5[i]  <- sorted_appIDs[5]
  df_updated$match6[i]  <- sorted_appIDs[6]
  df_updated$match7[i]  <- sorted_appIDs[7]
  df_updated$match8[i]  <- sorted_appIDs[8]
  df_updated$match9[i]  <- sorted_appIDs[9]
  df_updated$match10[i] <- sorted_appIDs[10]
  
  df_updated$score1[i]  <- sorted_scores[1]
  df_updated$score2[i]  <- sorted_scores[2]
  df_updated$score3[i]  <- sorted_scores[3]
  df_updated$score4[i]  <- sorted_scores[4]
  df_updated$score5[i]  <- sorted_scores[5]
  df_updated$score6[i]  <- sorted_scores[6]
  df_updated$score7[i]  <- sorted_scores[7]
  df_updated$score8[i]  <- sorted_scores[8]
  df_updated$score9[i]  <- sorted_scores[9]
  df_updated$score10[i] <- sorted_scores[10]
}

write.table(df_updated, file="T1_PSM_VOL_matches.tsv",
            na="", row.names = FALSE, sep="\t", quote = FALSE)

