rankhospital <- function(state, outcome, num = "best") {
  ## Read outcome data and convert necessary columns to numeric
  hospitalDataRaw <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
  hospitalData <- data.frame(State = hospitalDataRaw$State, 
                             Hospital = hospitalDataRaw$Hospital.Name,
                             HeartAttackMortality = suppressWarnings(as.numeric(hospitalDataRaw[, 11])),
                             HeartFailureMortality = suppressWarnings(as.numeric(hospitalDataRaw[, 17])),
                             PneumoniaMortality = suppressWarnings(as.numeric(hospitalDataRaw[, 23])))
  
  # Get list of valid states
  validStates <- levels(hospitalData$State)
  
  ## Check if inputs are valid
  if (!(state %in% validStates)) {
    stop("invalid state")
  }
  
  if (!(outcome %in% names(validOutcomes))) {
    stop("invalid outcome")
  }
  
  outcomeColumn <- validOutcomes[[outcome]]
  
  rows <- (hospitalData$State == state) # rows for the given state
  rows <- rows & !is.na(hospitalData[[outcomeColumn]]) #valid rows for the given state 
  
  ## Return hospital name in that state with the given rank
  ## 30-day death rate
  hospitalRanks <- hospitalData[rows, c('State', 'Hospital', outcomeColumn)]
  hospitalRanks <- hospitalRanks[order(hospitalRanks[, outcomeColumn], hospitalRanks[, 'Hospital']),]
  
  result <- NA
  if (is.character(num))
  {
    if (num == 'best') num <- 1 else if (num == 'worst') num <- nrow(hospitalRanks)
  }
  if (is.numeric(num)){
    if ( num >= 1 & num <= nrow(hospitalRanks)) {
      result <- as.character(hospitalRanks[num, 'Hospital'])
    }
  }
  result
}
