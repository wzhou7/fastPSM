wzhou4_logit_default <- function(data_T1, id="AppID", target="Updated",
                                 predictors=c("Subcategory_new", "IsFree", "DaysSinceUpdate"),
                                 report="report_file_name"){
    
    # Initialize the propensity scores as NAs
    scores <- rep(NA, NROW(data_T1))
  
    # Since regression models do not handle missing values well, yet we need a prediction for every record,
    # we use some heuristics to manage missing values.
  
  
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

require("stargazer")
stargazer(fit.lm11, fit.lm10, fit.lm01, fit.lm00,
          type="html", title="Update Propensity", 
          out="T1_PSM_VOL/PSM_models.html")

  
  
    # find missingness of each variable
    n_miss <- apply(data_T1[,predictors],2,sum(is.na()))
    pct_miss <- n_miss/NROW(data_T1)
  
    # if >15% missing, partition data into missing vs. not missing
    # if <5% missing, impute
  
    # fit a separate logistic model within each partition
    
    # the return value should include [AppID, Updated, PropensityScore] 
    # for each app in the input dataframe
    return(scores)
}
