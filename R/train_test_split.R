missingness_partition <- function(data, Y, X0, X1, X2){
    df11 <- X[,c(X0, X1, X2)]
    df10 <- X[,c(X0, X1)]
    df01 <- X[,c(X0, X2)]
    df00 <- X[,c(X0)]
    
    df11 <- cbind(Y,df11)
    return(data_partitions)
}

train_test_split <- function(Y, X0, X1, X2, train_ratio=0.7){

    return(data_partitions)
}
