
# Étude : Impact de la Sonde de Swan Ganz en Réanimation

**Contexte**  
Étude rétrospective analysant 5735 observations en unité de soins intensifs. L'objectif est d'évaluer si la pose d'une sonde de Swan Ganz (RHC) est associée à une augmentation du risque de décès comparé à sa non-utilisation, en fonction de l'état clinique des patients.

---

### **Variables Analysées**  
| Type               | Exemples (Unités) |  
|--------------------|-------------------|  
| **Temporelles**    | Date d'admission, sortie, décès, dernières nouvelles |  
| **Catégorielles**  | Sexe, ethnie, statut RHC, diagnostic (respiratoire/cardiaque/neurologique...), comorbidités (insuffisance cardiaque, néoplasie...), statut de survie (30/180 jours) |  
| **Numériques**     | Âge (années), scores APACHE/Glasgow, paramètres biologiques (pression artérielle, fréquence cardiaque, créatininémie...) |  

---

### **Traitement des Données**  
1. **Nettoyage initial** :  
   - Suppression des variables non informatives :  
     - `ADL` et `diurèse` (52-75% de données manquantes).  
     - `CAT1` (variable constante à 100%).  
     - `ROWNAMES` (identifiants surnuméraires).  
   - Recodage des variables :  
     - Variables binaires (`RHC`, diagnostics) : `1` (oui) / `0` (non).  
     - `CAT2` : `NA` → `0` (absence de second diagnostic).  
     - Score de Glasgow : conversion de l'échelle 0-100 → 3-15.  

2. **Gestion des valeurs manquantes** :  
   - Valeurs numériques à `0` → `NA` → imputées par la **médiane**.  
   - Taux global de données manquantes : 3.84%.  

3. **Correction des incohérences** :  
   - Pour 1055 patients : `date de dernières nouvelles` < `date de sortie` → remplacement par la date de sortie.  
   - Pour 1112 patients décédés après la `date de dernières nouvelles` → imputation de la `date de décès` à cette date.  

4. **Variables ordinales** :  
   - Recodées en ordre **ascendant** (gravité/désavantage croissant).  

---

## Contexte
Étude rétrospective sur 5735 patients en soins intensifs évaluant l'association entre l'utilisation d'une sonde de Swan Ganz et la mortalité à 30 jours.

## Méthodologie
- **Score de propension** : Modèle logistique intégrant 52 covariables cliniques/démographiques.
- **Techniques d'ajustement** :  
  - Appariement par plus proche voisin (caliper=0.05)  
  - Stratification en déciles  
  - Modèles de régression logistique/Cox ajustés  
- **Critères de jugement**: Analyse de Survie. Décès à 30 jours (principal) et 180 jours (exploratoire).

## Résultats
| Méthode d'Ajustement       | Risque Relatif (IC 95%)   |  
|----------------------------|---------------------------|  
| Régression (SP)            | OR = 1.27 [1.11–1.44]     |  
| Appariement                | OR = 1.28 [1.10–1.48]     |  
| Stratification             | OR = 1.38 [1.24–1.55]     |  
| Modèle de Cox (SP)         | HR = 1.21 [1.10–1.34]     |  

**Conclusion clinique** : Utilisation associée à une augmentation significative du risque de décès à court terme.

## Fichiers du Projet
- `/data` : Jeux de données nettoyés  
- `/scripts` :  
  - `data_cleaning.R` (prétraitement)  
  - `propensity_score.R` (modélisation SP)  
  - `survival_analysis.R` (modèles de survie)  
- `/results` :  
  - Figures (distributions SP, courbes KM)  
  - Tables (odds ratios, tests)  
