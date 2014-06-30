
## Working with columns:
##[2] "Hospital.Name"
##[11] "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack"   
##[17] "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure"
##[23] "Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia"

# Load state dataset
validOutcomes <- c("heart attack" = "HeartAttackMortality", 
                   "heart failure" = "HeartFailureMortality", 
                   "pneumonia"="PneumoniaMortality")
heartAttackIndex <- 11
heartFailureIndex <- 17
pneumoniaIndex <- 23

best <- function(state, outcome) 
{
  
  ## Read outcome data and convert necessary columns to numeric
  hospitalDataRaw <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
  hospitalData <- data.frame(State = hospitalDataRaw$State, 
                             Hospital = hospitalDataRaw$Hospital.Name,
                             HeartAttackMortality = suppressWarnings(as.numeric(hospitalDataRaw[, 11])),
                             HeartFailureMortality = suppressWarnings(as.numeric(hospitalDataRaw[, 17])),
                             PneumoniaMortality = suppressWarnings(as.numeric(hospitalDataRaw[, 23])))
  
  # Get list of valid states
  validStates <- unique(hospitalData$State)
  
  ## Check if inputs are valid
  if (!(state %in% validStates)) {
    stop("invalid state")
  }
  
  if (!(outcome %in% names(validOutcomes))) {
    stop("invalid outcome")
  }
  
  outcomeColumn <- validOutcomes[[outcome]]
  
  ## Return hospital name in that state with lowest 30-day death rate
  rows <- (hospitalData$State == state) # rows for the given state
  rows <- rows & !is.na(hospitalData[[outcomeColumn]]) #valid rows for the given state
  
  minMortalityRate <- min(hospitalData[rows, outcomeColumn])
  bestHospitalRows <- rows & hospitalData[[outcomeColumn]] == minMortalityRate
  bestHospitals <- as.character(hospitalData$Hospital[bestHospitalRows])
  min(bestHospitals)
}


