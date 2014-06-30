rankall <- function(outcome, num = "best") {
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
  
  rows <- !is.na(hospitalData[[outcomeColumn]]) # valid rows only
  
  hospitalRanks <- hospitalData[rows, c('State', 'Hospital', outcomeColumn)]
  hospitalRanks <- hospitalRanks[order(hospitalRanks[, 'State'], hospitalRanks[, outcomeColumn], hospitalRanks[, 'Hospital']),]
  
  getHospitalWithRank <- function(rankData)
  {
    result <- NA
    if (is.character(num))
    {
      if (num == 'best') num <- 1 else if (num == 'worst') num <- nrow(rankData)
    }
    if (is.numeric(num)){
      if ( num >= 1 & num <= nrow(rankData)) {
        #result <- c(as.character(rankData[num, 'Hospital']), as.character(rankData[num, 'State']))
        result <- as.character(rankData[num, 'Hospital'])
      }
    }
    #print(result)
    result
  }
  #getHospitalWithRank(hospitalRanks[hospitalRanks$State == 'NY',])
  result <- by(hospitalRanks, hospitalRanks$State, getHospitalWithRank, simplify=FALSE)
  
  #result <- cbind(result)
  ## For each state, find the hospital of the given rank
  ## Return a data frame with the hospital names and the
  ## (abbreviated) state name
  states <- rownames(result)
  rownames(result) <- NULL
  result = data.frame(hospital=as.character(result), state=states, row.names=states)
  result
}

