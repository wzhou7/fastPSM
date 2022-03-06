#' @export
PSM_logit <- function(formula, df){

  fit.lm11 <- glm(formula, family = binomial(link = "logit"), data=df)

  # calculate and return propensity scored
  score <- predict(fit.lm11)

  return(score)
}
