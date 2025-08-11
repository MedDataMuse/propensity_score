# propensity_score

### Résumé de l'Étude : Impact de la Sonde de Swan Ganz en Réanimation  

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

### **Analyse de Survie**  
- **Périodes de suivi** :  
  - Principale : **30 jours** après l'admission.  
  - Exploratoire : 180 jours.  

---

### **Fichiers et Dépôt GitHub**  
- **Jeu de données** : `[nom_du_fichier.csv]` (après prétraitement).  
- **Scripts d'analyse** :  
  - `data_cleaning.R` (nettoyage et imputation).  
  - `survival_analysis.R` (modèles de survie).  
- **Résultats clés** : À inclure dans le rapport final (voir dossier `/results`).  

---  
**Objectif Final** : Fournir une analyse robuste de l'impact de la sonde de Swan Ganz sur la mortalité en réanimation, ajustée aux caractéristiques cliniques des patients.
