dat <- read.csv("/Users/seventh/Desktop/All class-25 fall/702/ex1.2 consort/data.csv")
dat$Gender <- factor(dat$Gender, labels = c("Male", "Female"))
dat$ECOG <- factor(dat$ECOG, labels = "0","1", "2")
dat$CNS <- factor(dat$CNS, labels = c("No", "Yes"))
dat$BCR <- factor(dat$BCR, labels = c("p210", "p190"))
dat$CV1 <- factor(dat$CV1, labels = c("No", "Yes"))
dat$CV2 <- factor(dat$CV2, labels = c("No", "Yes"))
dat$Hypertension <- factor(dat$Hypertension, labels = c("No", "Yes") )
dat$Obesity <- factor(dat$Obesity, labels = c("No", "Yes") )
dat$Dyslipidemia <- factor(dat$Dyslipidemia, labels = c("No", "Yes") )
dat$Smoking <- factor(dat$Smoking, labels = c("No", "Yes") )
dat$Treatment <- factor(dat$Treatment, labels = c("Ponatinib", "Imatinib"))

library(labelled)
var_label(dat$Age) <- "Age (years)"
var_label(dat$Gender) <- "Gender"
var_label(dat$ECOG) <- "ECOG Performance Status"
var_label(dat$CNS) <- "CNS/Extramedullary disease"
var_label(dat$BCR) <- "BCR::ABL1 Isoform"
var_label(dat$CV1) <- ">=1 Cardivascular Comorbidity"
var_label(dat$CV2) <- ">=2 Caradivascular Comorbidty"
var_label(dat$Hypertension) <- "Hypertension"
var_label(dat$Diabetes) <- "Diabetes"
var_label(dat$Obesity) <- "Obesity"
var_label(dat$Dyslipidemia) <- "Dyslipidemia"
var_label(dat$Smoking) <- "History of Smoking"

library(tableone) 

vars <- c("Age", "Gender", "ECOG", "CNS", "BCR", 
          "CV1", "CV2", "Hypertension", "Diabetes", 
          "Obesity", "Dyslipidemia", "Smoking")
comparsionTable <- CreateTableOne(vars = vars, strata = "Treatment",data = dat)
kableone(print(comparsionTable), smd = TRUE, varLabels = TRUE,
         showAlllevels = TRUE, printToogle = FALSE)


table1 <- CreateTableOne(vars = vars, strata = "Treatment", 
                         data = dat, test = TRUE, smd = TRUE)

