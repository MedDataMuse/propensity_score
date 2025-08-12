# Clear workspace
rm(list = ls())

# Load dataset
rhc <- read.csv2("C:/Users/......Devoir epidemio rhc/rhc.csv", na.strings = "")

# Inspect variables
str(rhc)

# Convert date columns to Date format
date_columns <- c("SADMDTE", "DSCHDTE", "DTHDTE", "LSTCTDTE")
for (col in date_columns) {
  rhc[[col]] <- as.Date(rhc[[col]], format = "%d/%m/%Y")
}

# Summarize key date columns
summary(rhc$SADMDTE)   # Inclusion period
summary(rhc$DTHDTE)    # Death dates
summary(rhc$LSTCTDTE)  # Last contact dates
summary(rhc$DSCHDTE)   # Discharge dates

# Identify missing discharge dates
missing_dschdte <- which(is.na(rhc$DSCHDTE))
missing_ptid <- rhc$PTID[missing_dschdte]

# Check date consistency
stopifnot(
  all(rhc$SADMDTE <= rhc$LSTCTDTE | is.na(rhc$SADMDTE)),
  all(rhc$SADMDTE <= rhc$DSCHDTE | is.na(rhc$SADMDTE)),
  all(rhc$DTHDTE >= rhc$DSCHDTE | is.na(rhc$DTHDTE)),
  all(rhc$DSCHDTE <= rhc$LSTCTDTE | is.na(rhc$DSCHDTE))
)

# Fix inconsistencies in last contact date
rhc$LSTCTDTE <- ifelse(rhc$DSCHDTE > rhc$LSTCTDTE, as.character(rhc$DSCHDTE), as.character(rhc$LSTCTDTE))
rhc$LSTCTDTE <- ifelse(rhc$DEATH == "Yes", as.character(rhc$DTHDTE), as.character(rhc$LSTCTDTE))
rhc$LSTCTDTE <- as.Date(rhc$LSTCTDTE)

# Remove duplicates and unnecessary columns
rhc <- rhc[!duplicated(rhc$PTID), ]
cols_to_remove <- c("ROWNAMES", "URIN1", "ADLD3P", "CAT1")
rhc[cols_to_remove] <- list(NULL)

# Explore missing data
missing_data_summary <- sapply(rhc, function(x) sum(is.na(x)))
print(missing_data_summary)

# Summarize numeric variables
if (!requireNamespace("summarytools", quietly = TRUE)) install.packages("summarytools")
if (!requireNamespace("questionr", quietly = TRUE)) install.packages("questionr")
library(summarytools)
library(questionr)

descr(rhc[ ,sapply(rhc, is.numeric)], stats = c("mean", "sd", "min", "med", "max", "q1", "q3", "n.valid", "pct.valid"), transpose = TRUE)

# Set zero values to NA for selected variables
num_vars <- c("HRT1", "RESP1", "MEANBP1", "WTKILO1")
for (var in num_vars) {
  rhc[[var]][rhc[[var]] == 0] <- NA
}

# Impute missing numeric data with median
for (var in c("MEANBP1", "WTKILO1", "HRT1", "ALB1", "RESP1")) {
  rhc[[var]][is.na(rhc[[var]])] <- median(rhc[[var]], na.rm = TRUE)
}

# Explore categorical variables
if (!requireNamespace("frequency", quietly = TRUE)) install.packages("frequency")
library(frequency)
options(frequency_render = TRUE, frequency_open_output = TRUE)
freq(rhc[ ,sapply(rhc, is.factor)])

# Recode categorical variables for analysis
library(tidyverse)

rhc <- rhc %>%
  mutate(
    CA       = recode(CA, "Metastatic" = 2L, "Yes" = 1L, "No" = 0L),
    ORTHO    = recode(ORTHO, "Yes" = 1L, "No" = 0L),
    TRAUMA   = recode(TRAUMA, "Yes" = 1L, "No" = 0L),
    SEPS     = recode(SEPS, "Yes" = 1L, "No" = 0L),
    HEMA     = recode(HEMA, "Yes" = 1L, "No" = 0L),
    META     = recode(META, "Yes" = 1L, "No" = 0L),
    RENAL    = recode(RENAL, "Yes" = 1L, "No" = 0L),
    GASTR    = recode(GASTR, "Yes" = 1L, "No" = 0L),
    NEURO    = recode(NEURO, "Yes" = 1L, "No" = 0L),
    SEX      = recode(SEX, "Female" = 1L, "Male" = 0L),
    DEATH    = recode(DEATH, "Yes" = 1L, "No" = 0L),
    DTH30    = recode(DTH30, "Yes" = 1L, "No" = 0L),
    DNR1     = recode(DNR1, "Yes" = 1L, "No" = 0L),
    CARD     = recode(CARD, "Yes" = 1L, "No" = 0L),
    RESP     = recode(RESP, "Yes" = 1L, "No" = 0L),
    SWANG1   = recode(SWANG1, "RHC" = 1L, "No RHC" = 0L),
    NINSCLAS = recode(NINSCLAS,
                      "Private" = 2L, "Medicaid" = 2L, "Medicare" = 2L,
                      "Private & Medicare" = 1L, "Medicare & Medicaid" = 1L,
                      "No insurance" = 3L),
    INCOME   = recode(INCOME,
                      "Under $11k" = 4L, "$11-$25k" = 3L, "$25-$50k" = 2L, "> $50k" = 1L),
    CAT2     = ifelse(CAT2 == "", 0L, 1L),
    CAT2     = replace(CAT2, is.na(CAT2), 0L),
    RACE     = recode(RACE, "other" = 0L, "white" = 1L, "black" = 2L)
  )

# Convert variables to appropriate types
factor_vars <- c("CAT2", "CA", "DEATH", "DTH30", "SEX", "SWANG1", "INCOME", "RACE")
rhc[factor_vars] <- lapply(rhc[factor_vars], as.factor)

for (i in 7:19) rhc[[i]] <- as.factor(rhc[[i]])
for (i in 45:58) rhc[[i]] <- as.factor(rhc[[i]])

num_vars2 <- c("SOD1", "HRT1", "T3D30", "APS1", "SCOMA1")
rhc[num_vars2] <- lapply(rhc[num_vars2], as.numeric)

# Transform SCOMA1 variable
rhc$SCOMA1 <- rhc$SCOMA1 * 12 / 100 + 3
rhc$SCOMA_graph <- cut(rhc$SCOMA1, 13, labels = as.character(15:3))

# Transform AGE into age classes
rhc$clage <- cut(rhc$AGE, breaks = c(18, 50, 64, 74, 102), include.lowest = TRUE)

# Example: plot age classes
# barplot(table(rhc$clage), main = "Age Class Distribution", xlab = "Age Class", ylab = "Count")
