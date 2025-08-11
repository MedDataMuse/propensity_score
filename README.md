
# Étude : Impact de la Sonde de Swan Ganz en Réanimation

**Contexte**  
Étude rétrospective analysant 5735 observations en unité de soins intensifs. L'objectif est d'évaluer si la pose d'une sonde de Swan Ganz (RHC) est associée à une augmentation du risque de décès comparé à sa non-utilisation, en fonction de l'état clinique des patients.

#### Explication simple de la notion de score de propension [ici](https://meddatamuse.github.io/propensity_score/)
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

### **Méthodes Clés**  
1. **Analyse Préliminaire**  
   - **Odds Ratio brut** : 1.39 (décès à 30j avec RHC vs sans RHC).  
   - **Courbes de Kaplan-Meier** :  
     - Survie médiane : 98 jours (avec RHC) vs 180 jours (sans RHC).  

2. **Score de Propension (SP)**  
   - Modèle logistique prédictif de l'utilisation de RHC (52 covariables cliniques/démographiques).  
   - Distribution équilibrée entre groupes (bon recouvrement).  

3. **Techniques d'Ajustement**  
   | Méthode                     | Résultat (décès à 30j)       |  
   |-----------------------------|-----------------------------|  
   | **Régression logistique (SP)** | OR = 1.27 [1.11-1.44], p<0.001 |  
   | **Appariement (caliper=0.05)** | OR = 1.28 [1.10-1.48]        |  
   | **Stratification (10 déciles)**| OR = 1.38 [1.24-1.55]        |  
   | **Modèle de Cox (ajusté SP)**  | HR = 1.21 [1.1-1.34]          |  

---

### **Résultats Clés**  
- **Association significative** : Toutes les méthodes convergent vers un risque accru de décès à 30j avec RHC (OR/HR > 1).  
- **Effet indépendant de la gravité** :  
  - Le surrisque persiste après ajustement par SP (synthèse des covariables).  
  - Confirmé par l'analyse stratifiée : effet délétère de RHC observé dans plusieurs déciles de gravité.  
- **Validation des modèles** :  
  - Hypothèse des risques proportionnels respectée (modèle de Cox).  
  - Taille d'échantillon adéquate (≥ 10 événements par variable).  

---

### **Conclusion**  
> **La sonde de Swan Ganz est associée à une augmentation de 21 à 38% du risque de décès à 30 jours**, indépendamment de l'état clinique des patients.  
> Cet effet délétère est robuste à travers différentes méthodes d'ajustement (score de propension, appariement, stratification).

---
## Fichiers du Projet
- `/data` : Jeux de données nettoyés  
- `/scripts` :  
  - `data_cleaning.R` (prétraitement)  
  - `propensity_score.R` (modélisation SP)  
  - `survival_analysis.R` (modèles de survie)  
