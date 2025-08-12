####SCORE DE PROPENSION#####
library(optmatch)
library(cobalt)
sp1 <- glm ( SWANG1 ~ AGE + SEX + RACE + EDU + INCOME + NINSCLAS + TEMP1 + #CAT1 +
CARDIOHX + CHFHX + DEMENTHX + PSYCHHX + CHRPULHX + RENALHX + LIVERHX + GIBLEDHX
+ MALIGHX + IMMUNHX + TRANSHX + AMIHX + DAS2D3PC + DNR1 + CA + SURV2MD1 +
APS1 + SCOMA1 + WTKILO1 + MEANBP1 + RESP1 + HRT1 + PAFI1 + PACO21 + PH1 +
WBLC1 + HEMA1 + SOD1 + CREA1 + BILI1 + ALB1 + RESP + CARD + NEURO + GASTR
+ RENAL + META + HEMA + SEPS + TRAUMA, family=binomial,data = rhc)
summary(sp1)
rhc$sp1 <- sp1$fitted.values
#####Description du score de propension####
summary(rhc$sp1)
by(rhc$sp1, rhc$SWANG1, summary, na.rm=T)

10
hist(rhc$sp1,ylab = "Nombre de patient", xlab="score de propension",main = "Distribution de la variable SP1")
boxplot(rhc$sp1, ylab = "score de propension", main="Paramètres de SP1 dans la population de patients")
boxplot(rhc$sp1~rhc$SWANG1, ylab = "score de propension", xlab="Recours à la sonde", main="Paramètres de SP1
dans les groupes")
##### Modele logistique brut####
str(rhc$DTH30)
rhc$DTH30 <- as.factor(rhc$DTH30)
str(rhc$DTH30)
mod_log30 <- glm(DTH30 ~ SWANG1 + sp1, data = rhc, family = binomial)
summary(mod_log30)
exp(coefficients(mod_log30))
exp(confint(mod_log30))
#####Ratio matching (Nearest Neighbor Matching)####
library(MatchIt)
library(Matching)
match.obj <- matchit(SWANG1 ~ sp1, data = rhc, method = "nearest", ratio = 1)
summary(match.obj)
matched_data_1 <- match.data(match.obj)
model1 <- glm(DTH30 ~ SWANG1 + sp1, data = matched_data_1, family = binomial)
summary(model1)
exp(coef(model1))
exp(confint(model1))
#####Meth. Caliper####
match.obj_cal <- matchit(SWANG1 ~ sp1, data = rhc, distance = "logit", method = "nearest", caliper = 0.05)
summary(match.obj_cal)
matched_data_2 <- match.data(match.obj_cal)
model_cal <- glm(DTH30 ~ SWANG1 + sp1, data = matched_data_2, family = binomial)
summary(model_cal)
exp(coef(model_cal))
exp(confint(model_cal))
#####Stratification####
### creation des stracts ( SP pour les 10 strates)
strat_10 <- matchit(SWANG1 ~ AGE + SEX + RACE + EDU + INCOME + NINSCLAS + TEMP1 + #CAT1 +
CARDIOHX + CHFHX + DEMENTHX + PSYCHHX + CHRPULHX + RENALHX + LIVERHX + GIBLEDHX

11

+ MALIGHX + IMMUNHX + TRANSHX + AMIHX + DAS2D3PC + DNR1 + CA + SURV2MD1 +
APS1 + SCOMA1 + WTKILO1 + MEANBP1 + RESP1 + HRT1 + PAFI1 + PACO21 + PH1 +
WBLC1 + HEMA1 + SOD1 + CREA1 + BILI1 + ALB1 + RESP + CARD + NEURO + GASTR
+ RENAL + META + HEMA + SEPS + TRAUMA,
method= "subclass", data=rhc, subclass = 10)
strat_10 <- matchit(SWANG1 ~ sp1, method= "subclass", data=rhc, subclass = 10)
summary(strat_10) ### On a une amélioration en moyenne sur les 10 strates d environ 97%
summary(strat_10, exact = T)### Tous les individus sont appariés
data_strate <- match.data(strat_10)
data_strate
####Visualisation de la répartition du score de propension au sein des déciles, en fonction de la swan ganz
boxplot(sp1~SWANG1+subclass,col=c("grey","royalblue")
,data=data_strate
,main="Score de propension selon la pose de Swan Ganz par strate"
,xlab="Strates", ylab="Score de Propension")
legend("topleft",c("Non","Oui"),fill=c("grey","royalblue")
, title="Pose de Swang", cex=0.7, inset= 0.07)
#Régression logistique entre décès et strates
reg.str<-glm(DTH30 ~ subclass, data = data_strate, family=binomial)
summary(reg.str)
exp(coef(reg.str))
exp(confint(reg.str))
#### Coefficients à chaque strate
##### Strate 1
glm_s1 <- glm(DTH30 ~ SWANG1, data = data_strate, subset = subclass == 1, family = binomial)
exp(coef(glm_s1))
exp(confint(glm_s1))
summary(glm_s1)
confint(glm_s1)
##### Strate 2
glm_s2 <- glm(DTH30 ~ SWANG1, data = data_strate, subset = subclass == 2, family = binomial)
exp(coef(glm_s2))
exp(confint(glm_s2))
##### Strate 3

12

glm_s3 <- glm(DTH30 ~ SWANG1, data = data_strate, subset = subclass == 3, family = binomial)
exp(coef(glm_s3))
exp(confint(glm_s3))
##### Strate 4
glm_s4 <- glm(DTH30 ~ SWANG1, data = data_strate, subset = subclass == 4, family = binomial)
exp(coef(glm_s4))
exp(confint(glm_s4))
##### Strate 5
glm_s5 <- glm(DTH30 ~ SWANG1, data = data_strate, subset = subclass == 5, family = binomial)
exp(coef(glm_s5))
exp(confint(glm_s5))
##### Strate 6
glm_s6 <- glm(DTH30 ~ SWANG1, data = data_strate, subset = subclass == 6, family = binomial)
exp(coef(glm_s6))
exp(confint(glm_s6))
##### Strate 7
glm_s7 <- glm(DTH30 ~ SWANG1, data = data_strate, subset = subclass == 7, family = binomial)
exp(coef(glm_s7))
exp(confint(glm_s7))
##### Strate 8
glm_s8 <- glm(DTH30 ~ SWANG1, data = data_strate, subset = subclass == 8, family = binomial)
exp(coef(glm_s8))
exp(confint(glm_s8))
##### Strate 9
glm_s9 <- glm(DTH30 ~ SWANG1, data = data_strate, subset = subclass == 9, family = binomial)
exp(coef(glm_s9))
exp(confint(glm_s9))
##### Strate 10
glm_s10 <- glm(DTH30 ~ SWANG1, data = data_strate, subset = subclass == 10, family = binomial)
exp(coef(glm_s10))
exp(confint(glm_s10))
### Total
glm.s <- glm(DTH30 ~ SWANG1, data = data_strate, family = binomial)
exp(coef(glm.s))

13

exp(confint(glm.s))
#Recherche d'intéraction entre strate et sonde
inter<-glm(DTH30 ~ SWANG1 + subclass+SWANG1*subclass, data = data_strate, family=binomial)
exp(coef(inter))
exp(confint(inter))
### Boxplots des différentes strates
library(ggplot2)
data_strate$SWANG1 <- as.factor(data_strate$SWANG1)
data_strate$subclass <- as.factor(data_strate$subclass)
data_strate$Sonde <- ifelse(rhc$SWANG1 == 1, "Avec Swang1", "Sans Swang1")
boxplot <- ggplot(data_strate, aes(x = subclass, y = distance, fill=Sonde)) +
geom_boxplot()
boxplot + scale_fill_manual(values=c("lightskyblue3", "lightskyblue4")) +
theme(panel.background = element_rect(fill = "white", colour = "black")) +
xlab ("Les strates") + ylab ("Score de propension")
