# table one 
library(tableone)
library(survival)
data(pbc)

CreateTableOne(data = pbc)

dput(names(pbc))
myVars <- c("id", "time", "status", "trt", "age", "sex", "ascites", "hepato", 
            "spiders", "edema", "bili", "chol", "albumin", "copper", "alk.phos", 
            "ast", "trig", "platelet", "protime", "stage")
catVars <- c("status", "trt", "ascites", "hepato", 
             "spiders", "edema", "stage" )
tab2 <- CreateTableOne(vars = myVars, data =pbc, factorVars = catVars )
print(tab2, showAllLevels = TRUE, formatOptions = list(big.mark = ","))

summary(tab2)


biomarkers <- c("bili","chol","copper","alk.phos","ast","trig","protime")
print(tab2, nonnormal = biomarkers, showAllLevels = TRUE, formatOptions = list(big.mark = ","))

tab3 <- CreateTableOne(vars = myVars, data = pbc, strata = "trt", factorVars = catVars)
print(tab3, nonnormal = biomarkers, showAllLevels = TRUE, formatOptions = list(big.mark = ","))
print(tab3, nonnormal = biomarkers, exact = "stage", smd = TRUE)
print(tab3, nonnormal = biomarkers, exact = "stage", quote = TRUE, noSpaces = TRUE)
tab3Mat <- print(tab3, nonnormal = biomarkers, exact = "stage", quote = FALSE, noSpaces = TRUE, printToggle = FALSE)
write.csv(tab3Mat, file = "myVars.cvs")

#create HTML
library(survival)
library(boot)
melanoma2 <- melanoma
melanoma2$status
melanoma2$status <- factor(melanoma2$status,
                           levels = c(2, 1, 3),
                           labels = c("Alive", 
                                      "Melanoma death",
                                      "Non-melanoma death")
                           labels = TRUE)
x_ord <- factor(c("low", "medium", "high"),
                levels = c("low", "medium", "high"))

x_ord
# [1] low    medium high  
# Levels: low < medium < high
table()
install.packages("table1")
library(table1)
table1(~ factor(sex) + age + factor(ulcer) + thickness | status, data=melanoma2)
?table1

# 把 ulcer 转换成因子
melanoma2$ulcer <- factor(melanoma2$ulcer,
                          levels = c(0, 1),
                          labels = c("No ulcer", "Ulcer present"))

# --- 双层分层：先按 status，再按 ulcer ---
table1(~ age + sex + thickness | status + ulcer,
       data = melanoma2)
melanoma2$sex <- 
  factor(melanoma2$sex, levels=c(1,0),
         labels=c("Male", 
                  "Female"))

melanoma2$ulcer <- 
  factor(melanoma2$ulcer, levels=c(0,1),
         labels=c("Absent", 
                  "Present"))

label(melanoma2$sex)       <- "Sex"
label(melanoma2$age)       <- "Age"
label(melanoma2$ulcer)     <- "Ulceration"
label(melanoma2$thickness) <- "Thicknessᵃ"

units(melanoma2$age)       <- "years"
units(melanoma2$thickness) <- "mm"

caption  <- "Basic stats"
footnote <- "ᵃ Also known as Breslow thickness"
install.packages(c("table1", "survival", "dplyr"))
library(table1)
table1(~ sex + age + ulcer + thickness | status, 
       data=melanoma2, 
       overall = c(left = "Total"),
       caption = caption, 
       footnote = footnote)

#First, we set up our labels differently, using a list:

labels <- list(
    variables=list(sex="Sex",
                   age="Age (years)",
                   ulcer="Ulceration",
                   thickness="Thicknessᵃ (mm)"),
    groups=list("", "", "Death"))

# Remove the word "death" from the labels, since it now appears above

levels(melanoma2$status) <- c("Alive", "Melanoma", "Non-melanoma")

