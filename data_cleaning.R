rm(list=ls())
####Chargement de la base de donnees####
rhc<-read.csv2("C:/Users/......Devoir epidemio rhc/rhc.csv",na.strings="")
####DATA MANAGEMENT####
#####Vérifier les variables####
str(rhc)
#####Rectification du format des dates####
rhc$SADMDTE <- as.Date(rhc$SADMDTE, format="%d/%m/%Y")
rhc$DSCHDTE <- as.Date(rhc$DSCHDTE, format="%d/%m/%Y")
rhc$DTHDTE <- as.Date(rhc$DTHDTE, format="%d/%m/%Y")
rhc$LSTCTDTE <- as.Date(rhc$LSTCTDTE, format="%d/%m/%Y")
#####Exploration des dates####
summary(rhc$SADMDTE) #### Période d'inclusion : entre le 11/06/1989 et le 23/01/1994
summary(rhc$DTHDTE) ## Patients décédés entre le 14/06/1989 et le 31/12/1994

2
summary(rhc$LSTCTDTE) #### Dernières nouvelles entre le 13/06/1989 et le 14/08/1994 ce qui n'est pas cohérent
car le dernier patient décédé le 31/12/1994 donc après la dernière date de dernières nouvelles
summary(rhc$DSCHDTE) ## 1 valeur manquante
which(is.na(rhc$DSCHDTE))#Valeur manquante : obervation 4683
rhc$PTID[is.na(rhc$DSCHDTE)] #Valeur manquante :Individu numéro 8382
#####Vérification de la cohérence des dates####
length(which(rhc$SADMDTE < rhc$DTHDTE)) ### Cohérent : 3722 patients décédés après la date d'entrée, ce qui
correspond aux nombre de morts précédemment calculés
length(which(rhc$SADMDTE == rhc$DTHDTE)) ### Cohérent : 0 patient décédé le jour de leur admission
length(which(rhc$SADMDTE > rhc$DTHDTE)) ### Cohérent : 0 patient décédé avant leur admission
#Doit précéder ou être égale à la date de dernières nouvelles
length(which(rhc$SADMDTE < rhc$LSTCTDTE)) ### Cohérent : 5734 patients (5735 après correction)avec date de
dernières nouvelles après l'admission
length(which(rhc$SADMDTE > rhc$LSTCTDTE)) ### Cohérent : 0 patient avec date de dernières nouvelles avant date
d'admission. Doit précéder la date de sortie d'hôpital
length(which(rhc$SADMDTE < rhc$DSCHDTE)) ### Cohérent : 5734 patients admis avant leur sortie
length(which(rhc$SADMDTE == rhc$DSCHDTE)) ### Cohérent : 0 patient sorti le jour de leur admission
length(which(rhc$SADMDTE > rhc$DSCHDTE)) ### Cohérent : 0 patient dont la date de sortie est antérieure à la date
d'admission. ### IL manque un patient cohérent mais il manquait une date de sortie d'hospitalisation, donc OK

# Doit être égale ou postérieure à la date de sortie d'hospitalisation
length(which(rhc$DTHDTE == rhc$DSCHDTE)) ### Cohérent : 2030 patients (2031 après correction) décédés le jours
de leur sortie d'hospitalisation
length(which(rhc$DTHDTE > rhc$DSCHDTE)) ### Cohérent : 1691 patients décédés après leur sortie d'hospitalisation
length(which(rhc$DTHDTE < rhc$DSCHDTE)) ### Cohérent : 0 patients décédés avant la date de sortie
d'hospitalisation (ça aurait été aussi cohérent si
#sortie le lendemain en cas de prélèvement d'organe par exemple)
### Date de sortie d'hospitalisation : doit être antérieure ou égale à la DDN
length(which(rhc$DSCHDTE < rhc$LSTCTDTE)) ### Cohérent : 3659 patients (3689 après correction) dont la date de
sortie est antérieure à la date de dernières nouvelles
length(which(rhc$DSCHDTE == rhc$LSTCTDTE)) ### Cohérent :1020 patients (2045 après correction) dont la date de
sortie est égale à la date de dernières nouvelles
length(which(rhc$DSCHDTE > rhc$LSTCTDTE)) ### Incohérent : 1055 patients dont la date de sortie est postérieure à
la date de dernières nouvelles
### On remplace la DDN anormale par la date de sortie et #verification
rhc$LSTCTDTE<-ifelse(rhc$DSCHDTE>rhc$LSTCTDTE,as.character(rhc$DSCHDTE),as.character(rhc$LSTCTDTE))

3
length(which(rhc$DSCHDTE > rhc$LSTCTDTE)) ### cohérent : 0 patients dont la date de sortie est postérieure à la
date de dernières nouvelles
length(which(rhc$DTHDTE>rhc$LSTCTDTE)) ###Incoherent, 1112 personnes sont notées dcd après la DDN
#Alors on impute la date de DC aux DDN des DCD et #verification
rhc$LSTCTDTE<-ifelse(rhc$DEATH=="Yes",as.character(rhc$DTHDTE),as.character(rhc$LSTCTDTE))
length(which(rhc$DTHDTE>rhc$LSTCTDTE)) ###coherent, 0 personnes sont notées dcd après la DDN
#Vérifiaction de la coherence avec les DDN
length(which(rhc$DTHDTE < rhc$LSTCTDTE | rhc$SADMDTE == rhc$LSTCTDTE | rhc
$DTHDTE > rhc$LSTCTDTE | rhc$DSCHDTE > rhc$LSTCTDTE)) ### 0 DDN incoherentes

table(duplicated(rhc$PTID)) #->Pas de doublon
#####Exploration des missing data####
table(duplicated(rhc))
table(is.na(rhc))
prop.table(table(is.na(rhc)))*100
sapply(rhc[,1:63], function(i){table(is.na(i))})
#####Exploration des variables ADLD3P et URIN1####
str(rhc[,c(59,60)])
summary(rhc[,c(59,60)])
sum(is.na(rhc[,59]))
(4296/5735)*100
sum(is.na(rhc[,60]))
(3028/5735)*100
#####Retrait des colonnes suivantes (inutile ou trop de NA)####
rhc["ROWNAMES"]<-NULL
rhc["URIN1"]<-NULL
rhc["ADLD3P"]<-NULL
rhc["CAT1"]<-NULL
#####Exploration des variables numériques####
install.packages("summarytools")
install.packages("questionr")
library("summarytools")
library("questionr")
descr(rhc[1:58])

4

#####Restreindre les paramètres explorés####
descr(rhc[1:58], stats = c("mean","sd","min","med","max","q1","q3","n.valid","pct.valid"), transpose = TRUE)
#ou bien
descr(rhc[1:58], stats = c("mean","sd","min","med","max","q1","q3"), transpose = TRUE)
#####Attribution des NA aux valeurs numériques = 0####
rhc$HRT1 <- ifelse(rhc$HRT1==0,NA,rhc$HRT1)
rhc$RESP1 <- ifelse(rhc$RESP1 == 0,NA,rhc$RESP1)
rhc$MEANBP1 <- ifelse(rhc$MEANBP1 == 0,NA, rhc$MEANBP1)
rhc$WTKILO1 <- ifelse(rhc$WTKILO1 == 0,NA,rhc$WTKILO1)
#####Imputation des données manquantes par la médiane####
rhc$MEANBP1 <-ifelse(is.na(rhc$MEANBP1), median(rhc$MEANBP1,na.rm=TRUE),rhc$MEANBP1)
rhc$WTKILO1 <-ifelse(is.na(rhc$WTKILO1), median(rhc$WTKILO1,na.rm=TRUE),rhc$WTKILO1)
rhc$HRT1 <-ifelse(is.na(rhc$HRT1), median(rhc$HRT1,na.rm=TRUE),rhc$HRT1)
rhc$ALB1 <-ifelse(is.na(rhc$ALB1), median(rhc$ALB1,na.rm=TRUE),rhc$ALB1)
rhc$RESP1 <-ifelse(is.na(rhc$RESP1), median(rhc$RESP1,na.rm=TRUE),rhc$RESP1)
#####Exploration des variables categorielles####
install.packages("frequency")
library(frequency)
options(frequency_render = TRUE) #Creer un lien html temporaire vers le tableau et graphe
options(frequency_open_output = TRUE) #ouvrir le lien html automatiquement dans navigateur
freq(rhc[1:58])
#####Exploration des variables numériques####
install.packages("summarytools")
install.packages("questionr")
library("summarytools")
library("questionr")
descr(rhc[1:58])
str(rhc)
library(tidyverse)
#####Recodage des variables catégorielles####
rhc$CA<-recode(rhc$CA,Metastatic=2,Yes=1,No=0)
rhc$ORTHO<-recode(rhc$ORTHO,Yes=1,No=0)
rhc$TRAUMA<-recode(rhc$TRAUMA,Yes=1,No=0)
rhc$SEPS<-recode(rhc$SEPS,Yes=1,No=0)

5

rhc$HEMA<-recode(rhc$HEMA,Yes=1,No=0)
rhc$META<-recode(rhc$META,Yes=1,No=0)
rhc$RENAL<-recode(rhc$RENAL,Yes=1,No=0)
rhc$GASTR<-recode(rhc$GASTR,Yes=1,No=0)
rhc$NEURO<-recode(rhc$NEURO,Yes=1,No=0)
rhc$SEX<-recode(rhc$SEX,Female=1,Male=0)
rhc$DEATH<-recode(rhc$DEATH,Yes=1,No=0)
rhc$DTH30<-recode(rhc$DTH30,Yes=1,No=0)
rhc$DNR1<-recode(rhc$DNR1,Yes=1,No=0)
rhc$CARD<-recode(rhc$CARD,Yes=1,No=0)
rhc$RESP<-recode(rhc$RESP,Yes=1,No=0)
rhc$SWANG1<-recode(rhc$SWANG1,"RHC"=1,"No RHC"=0)
rhc$NINSCLAS<-recode(rhc$NINSCLAS,"Private"=2,"Medicaid"=2,"Medicare"=2,"Private & Medicare"=1,"Medicare &
Medicaid"=1,"No insurance"=3)
rhc$INCOME<-recode(rhc$INCOME,"Under $11k"=4,"$11-$25k"=3,"$25-$50k"=2,"> $50k"=1)
rhc$CAT2 <- ifelse(rhc$CAT2 == "", 0, 1)
rhc$CAT2[which(is.na(rhc$CAT2))]<-0 # On considère le NA comme absence de 2nd diagnostic
rhc$RACE<-recode(rhc$RACE,"other"=0,"white"=1,"black"=2)
#####Correction des types de variables####
rhc$CAT2 <- as.factor(rhc$CAT2)
rhc$CA <- as.factor(rhc$CA)
rhc$DEATH <- as.factor(rhc$DEATH)
rhc$DTH30 <- as.factor(rhc$DTH30)
rhc$SEX<- as.factor(rhc$SEX)
rhc$SWANG1<- as.factor(rhc$SWANG1)
for(i in 7:19){rhc[,c(i)] <- as.factor(rhc[,c(i)])}
for(i in 45:58){rhc[,c(i)] <- as.factor(rhc[,c(i)])}
rhc$INCOME <- as.factor(rhc$INCOME)
rhc$SOD1 <- as.numeric(rhc$SOD1)
rhc$HRT1 <- as.numeric(rhc$HRT1)
rhc$T3D30 <- as.numeric(rhc$T3D30)
rhc$APS1 <- as.numeric(rhc$APS1)
rhc$RACE <- as.factor(rhc$RACE)
rhc$SCOMA1 <- as.numeric(rhc$SCOMA1)

6

#####Transformation de la variable Scoma1####
rhc$SCOMA1 <- rhc$SCOMA1*12/100+3
rhc$SCOMA_graph<- cut(rhc$SCOMA1,13,dig.lab = 0,labels = c(15,14,13,12,11,10,9,8,7,6,5,4,3))
#####Transformation de l'age en classes d'age####
summary(rhc$AGE)
rhc$clage<- cut(rhc$AGE, breaks = c(18, 50, 64, 74, 102),include.lowest = TRUE)
#barplot decrivant les classes d'age
