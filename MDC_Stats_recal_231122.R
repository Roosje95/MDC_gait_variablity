## MDC Project - Stats ST

# Navrag Singh, Michelle Gwerder, Rosa Visscher
# April. 2022

# Codes connected to Visscher et al. Can developmental trajectories in gait variability provide prognostic clues in motor adaptation among children with mild cerebral palsy? A retrospective observational cohort study.

# Linear model with log transformation and a mixture of continuous and factorial predictors

# ATTENTION: Slight changes need to be made depending if you want to analyse data from TDC vs CwCP or GMFCS level I vs GMFCS level II

#FOR TDC VS CwCP:
# load MDC_TDCP_ST_RECAL (contains spatiotemporal variablity and asymmetry parameters) or MDC_TDCP_k_RECAL (contains meanSD from the sagittal joint angles hip/knee/ankle)
# adapt naming everywhere to MDC_TDCP.data

#FOR GMFCS LEVEL I VS GMFCS LEVEL II
# load MDC_GMFCS_recal (contains spatiotemporal variablity and asymmetry parameters as well as meanSD from the sagittal joint angles hip/knee/ankle) 

# FYI: For calculation of CV and meanSD, we first took the mean for each side and then an overall average was calculated
# DO NOT FORGET TO SET YOUR WORKING DIRECTORY
setwd("...")

#Load required libraries
# most unusual is the sfsmisc package from CRAN repository - https://rdrr.io/cran/sfsmisc/man/TA.plot.html
library(nlme)
library(sfsmisc)
library(ggplot2)

# Load R data frame
#load("MDC_GMFCS.Rda")

# Build linear models
lm_SL = lm(log(MDC_GMFCS.data$SL_CV) ~ log(MDC_GMFCS.data$Age) + MDC_GMFCS.data$Cat + log(MDC_GMFCS.data$Age):MDC_GMFCS.data$Cat)
lm_ST = lm(log(MDC_GMFCS.data$ST_CV) ~ log(MDC_GMFCS.data$Age) + MDC_GMFCS.data$Cat + log(MDC_GMFCS.data$Age):MDC_GMFCS.data$Cat)
lm_WS=lm(log(MDC_GMFCS.data$WS_CV) ~ log(MDC_GMFCS.data$Age) + MDC_GMFCS.data$Cat + log(MDC_GMFCS.data$Age):MDC_GMFCS.data$Cat)
lm_SS=lm(log(MDC_GMFCS.data$SS_CV) ~ log(MDC_GMFCS.data$Age) + MDC_GMFCS.data$Cat + log(MDC_GMFCS.data$Age):MDC_GMFCS.data$Cat)
lm_CD=lm(log(MDC_GMFCS.data$CD_CV) ~ log(MDC_GMFCS.data$Age) + MDC_GMFCS.data$Cat + log(MDC_GMFCS.data$Age):MDC_GMFCS.data$Cat)

lm_HF = lm(log(MDC_GMFCS.data$meanSD_HF) ~ log(MDC_GMFCS.data$Age) + MDC_GMFCS.data$Cat + log(MDC_GMFCS.data$Age):MDC_GMFCS.data$Cat)
lm_KF=lm(log(MDC_GMFCS.data$meanSD_KF) ~ log(MDC_GMFCS.data$Age) + MDC_GMFCS.data$Cat + log(MDC_GMFCS.data$Age):MDC_GMFCS.data$Cat)
lm_AF=lm(log(MDC_GMFCS.data$meanSD_AF) ~ log(MDC_GMFCS.data$Age) + MDC_GMFCS.data$Cat + log(MDC_GMFCS.data$Age):MDC_GMFCS.data$Cat)

# Safe summary of each model
sum_SL=summary(lm_SL)
sum_ST=summary(lm_ST)
sum_WS=summary(lm_WS)
sum_SS=summary(lm_SS)
sum_CD=summary(lm_CD)

sum_HF=summary(lm_HF)
sum_KF=summary(lm_KF)
sum_AF=summary(lm_AF)
sum_FP=summary(lm_FP)

# Residual plot - Tukey-Anscombe 
TA.plot(lm_SL,
        fit= fitted(lm_SL), res= residuals(lm_SL, type="pearson"),
        xlab = "Fitted values")

# If there seems to be an odd outlyer, check its effect on the model
# you will get Residuals vs Fitted, QQ-plot, Scale location, 
# and the most important one Residuals vs Leverage also known as Coock plot
plot(lm_SL)#press enter 4x

group <- ifelse(MDC_GMFCS.data$Cat < 1.1, "Group 1",
                ifelse(MDC_GMFCS.data$Cat>1.2, "Group 2","Group 3"))

# TEST SL
anova(lm_SL) #p-value from F-test
coef(lm_SL) #provides coefficient

plot(log(MDC_GMFCS.data$Age),log(MDC_GMFCS.data$SL_CV),pch = 20,col = factor(group))
myPredict <- predict(lm_SL) 
ix <- sort(log(MDC_GMFCS.data$Age),index.return=T)$ix
lines(log(MDC_GMFCS.data$Age)[ix], myPredict[ix], col=2, lwd=2 )  
coeff <- round(lm_SL$coefficients , 2)
text(2.4, 3 , paste("lm_SL: ",coeff[1] , " + " , coeff[2] , "*x"  , "+" , coeff[3] , "*x^2" , "+" , coeff[4] , "*x^3" , "\n\n" , "R-squared adjusted = ",round(summary(lm_SL)$adj.r.squared,2)))

# TEST ST
anova(lm_ST) #p-value from F-test
coef(lm_ST) #provides coefficient

plot(log(MDC_GMFCS.data$Age),log(MDC_GMFCS.data$ST_CV),pch = 20,col = factor(group))
myPredict <- predict(lm_ST) 
ix <- sort(log(MDC_GMFCS.data$Age),index.return=T)$ix
lines(log(MDC_GMFCS.data$Age)[ix], myPredict[ix], col=2, lwd=2 )  
coeff <- round(lm_ST$coefficients , 2)
text(2.4, 3 , paste("lm_ST: ",coeff[1] , " + " , coeff[2] , "*x"  , "+" , coeff[3] , "*x^2" , "+" , coeff[4] , "*x^3" , "\n\n" , "R-squared adjusted = ",round(summary(lm_ST)$adj.r.squared,2)))

# TEST WS
anova(lm_WS) #p-value from F-test
coef(lm_WS) #provides coefficient

plot(log(MDC_GMFCS.data$Age),log(MDC_GMFCS.data$WS_CV),pch = 20,col = factor(group))
myPredict <- predict(lm_WS) 
ix <- sort(log(MDC_GMFCS.data$Age),index.return=T)$ix
lines(log(MDC_GMFCS.data$Age)[ix], myPredict[ix], col=2, lwd=2 )  
coeff <- round(lm_ST$coefficients , 2)
text(2.4, 3 , paste("lm_WS: ",coeff[1] , " + " , coeff[2] , "*x"  , "+" , coeff[3] , "*x^2" , "+" , coeff[4] , "*x^3" , "\n\n" , "R-squared adjusted = ",round(summary(lm_WS)$adj.r.squared,2)))

# TEST SS
anova(lm_SS) #p-value from F-test
coef(lm_SS) #provides coefficient

plot(log(MDC_GMFCS.data$Age),log(MDC_GMFCS.data$SS_CV),pch = 20,col = factor(group))

myPredict <- predict(lm_SS) 
ix <- sort(log(MDC_GMFCS.data$Age),index.return=T)$ix
lines(log(MDC_GMFCS.data$Age)[ix], myPredict[ix], col=2, lwd=2 )  
coeff <- round(lm_SS$coefficients , 2)
text(2.4, 3 , paste("lm_SS: ",coeff[1] , " + " , coeff[2] , "*x"  , "+" , coeff[3] , "*x^2" , "+" , coeff[4] , "*x^3" , "\n\n" , "R-squared adjusted = ",round(summary(lm_SS)$adj.r.squared,2)))

# TEST CD
anova(lm_CD) #p-value from F-test
coef(lm_CD) #provides coefficient

plot(log(MDC_GMFCS.data$Age),log(MDC_GMFCS.data$CD_CV),pch = 20,col = factor(group))
myPredict <- predict(lm_CD) 
ix <- sort(log(MDC_GMFCS.data$Age),index.return=T)$ix
lines(log(MDC_GMFCS.data$Age)[ix], myPredict[ix], col=2, lwd=2 )  
coeff <- round(lm_CD$coefficients , 2)
text(2.4, 3 , paste("lm_CD: ",coeff[1] , " + " , coeff[2] , "*x"  , "+" , coeff[3] , "*x^2" , "+" , coeff[4] , "*x^3" , "\n\n" , "R-squared adjusted = ",round(summary(lm_CD)$adj.r.squared,2)))

# TEST meanSD_HF
anova(lm_HF) #p-value from F-test
coef(lm_HF) #provides coefficient

plot(log(MDC_GMFCS.data$Age),log(MDC_GMFCS.data$meanSD_HF),pch = 20,col = factor(group))
myPredict <- predict(lm_HF) 
ix <- sort(log(MDC_GMFCS.data$Age),index.return=T)$ix
lines(log(MDC_GMFCS.data$Age)[ix], myPredict[ix], col=2, lwd=2 )  
coeff <- round(lm_HF$coefficients , 2)
text(2.4, 0 , paste("lm_HF: ",coeff[1] , " + " , coeff[2] , "*x"  , "+" , coeff[3] , "*x^2" , "+" , coeff[4] , "*x^3" , "\n\n" , "R-squared adjusted = ",round(summary(lm_HF)$adj.r.squared,2)))

# TEST meanSD_KF
anova(lm_KF) #p-value from F-test
coef(lm_KF) #provides coefficient

plot(log(MDC_GMFCS.data$Age),log(MDC_GMFCS.data$meanSD_KF),pch = 20,col = factor(group))
myPredict <- predict(lm_KF) 
ix <- sort(log(MDC_GMFCS.data$Age),index.return=T)$ix
lines(log(MDC_GMFCS.data$Age)[ix], myPredict[ix], col=2, lwd=2 )  
coeff <- round(lm_KF$coefficients , 2)
text(2.4, 0 , paste("lm_KF: ",coeff[1] , " + " , coeff[2] , "*x"  , "+" , coeff[3] , "*x^2" , "+" , coeff[4] , "*x^3" , "\n\n" , "R-squared adjusted = ",round(summary(lm_KF)$adj.r.squared,2)))

# TEST meanSD_AF
anova(lm_AF) #p-value from F-test
coef(lm_AF) #provides coefficient

plot(log(MDC_GMFCS.data$Age),log(MDC_GMFCS.data$meanSD_AF),pch = 20,col = factor(group))
myPredict <- predict(lm_AF) 
ix <- sort(log(MDC_GMFCS.data$Age),index.return=T)$ix
lines(log(MDC_GMFCS.data$Age)[ix], myPredict[ix], col=2, lwd=2 )  
coeff <- round(lm_AF$coefficients , 2)
text(2.4, 0 , paste("lm_AF: ",coeff[1] , " + " , coeff[2] , "*x"  , "+" , coeff[3] , "*x^2" , "+" , coeff[4] , "*x^3" , "\n\n" , "R-squared adjusted = ",round(summary(lm_AF)$adj.r.squared,2)))

# TEST meanSD_FP
anova(lm_FP) #p-value from F-test
coef(lm_FP) #provides coefficient

plot(log(MDC_GMFCS.data$Age),log(MDC_GMFCS.data$meanSD_FP),pch = 20,col = factor(group))
myPredict <- predict(lm_FP) 
ix <- sort(log(MDC_GMFCS.data$Age),index.return=T)$ix
lines(log(MDC_GMFCS.data$Age)[ix], myPredict[ix], col=2, lwd=2 )  
coeff <- round(lm_FP$coefficients , 2)
text(2.4, 0.5 , paste("lm_FP: ",coeff[1] , " + " , coeff[2] , "*x"  , "+" , coeff[3] , "*x^2" , "+" , coeff[4] , "*x^3" , "\n\n" , "R-squared adjusted = ",round(summary(lm_FP)$adj.r.squared,2)))

