####ANALYSE DE SURVIE####
library(survival)
library(ggplot2)
library(survminer)
#####Kaplan Meyer####
#évènement=DTH30
#Duree=T3D30
#Groupe=SWANG1
rhc30<- cbind(rhc[,c(7,25,26,43,59)])
rhc30$dur30<- difftime(rhc$LSTCTDTE,rhc$SADMDTE,units = "days")
#création date de censure à 30j
rhc30$DTH30<-ifelse(rhc30$dur30<=30,1,0)
#censure à 30j pour les exclus vivants
rhc30$dur30<-ifelse(rhc30$dur30>=30,30,rhc30$dur30)
KM30 <- survfit(Surv(rhc30$dur30, rhc30$DTH30,type=c("right"))~ rhc30$SWANG1)
plot((KM30), col=c("black","red"),ylim=c(0,1),xlim=c(0,30),main="Risque de décès à 30j en fonction de swan
ganz",conf.int = TRUE)
ggsurvplot(KM30,data = rhc30, conf.int = 0.95, censor= F,ggtheme = theme_minimal())#mettre DTH30 en num

#évènement=DTH180
#Duree=dur180
#Groupe=SWANG1
rhc$dur180<- difftime(rhc$LSTCTDTE,rhc$SADMDTE,units = "days")
#assignation de la duree"180" aux sujets avec NA à la durée
rhc$dur180[which(is.na(rhc$dur180))]<- 180
#creation nouvelle table
rhc180<- cbind(rhc[,c(7,43,59,62)])
#création date de censure à 180j
rhc180$DTH180<-ifelse(rhc180$dur180<=180,1,0)
#censure à 180j pour les exclus vivants
rhc180$dur180<-ifelse(rhc180$dur180>=180,180,rhc180$dur180)
KM180 <- survfit(Surv(rhc180$dur180, rhc180$DTH180,type=c("right") )~ rhc180$SWANG1)
plot(KM180)
#on s'arrette à 180 parce que c'est ce qu'on veut explorer
plot((KM180), col=c("black","red"),ylim=c(0,1),xlim=c(0,180),main="Risque de décès à 180j en fonction de swan
ganz",conf.int = TRUE)
ggsurvplot(KM180,data=rhc180,conf.int = 0.95, censor= F,ggtheme = theme_minimal())#mettre DTH180 en num

####MODELE DE COX####
#Vérification risques proportionnels
#Vérification nombre d'évènement par variable explicatives
# censure 30
rhc30$sp1 <- rhc$sp1
cox_1 <- coxph ( Surv ( dur30 , DTH30 ) ~ SWANG1 + sp1, data = rhc30)
summary (cox_1)
plot( cox.zph ( cox_1 ) [1]) ; abline ( h =0 , col = " blue " )
# censure 180# EXPLORATOIRE....
rhc180$sp1 <- rhc$sp1
cox_2 <- coxph ( Surv ( dur180 , DEATH ) ~ SWANG1 + sp1, data = rhc180)
summary (cox_2)
plot( cox.zph ( cox_2 ) [1]) ; abline ( h =0 , col = " blue " )
