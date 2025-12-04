# Guide d'Implémentation - Gestion des Congés

## 1. Corrections Apportées à la Base de Données

### 1.1 Table `demande_conge`
**Améliorations :**
- Renommée `dateDebut` → `date_debut` et ajoutée `date_fin` (pour une meilleure cohérence)
- Type `VARCHAR(50)` → `DATE` pour `date_fin`
- Allongé `motif` de `VARCHAR(50)` à `VARCHAR(255)`
- Ajout de contraintes `CHECK` :
  - `date_fin >= date_debut` (validation logique)
  - `nombre_jours > 0` (validation métier)
- Ajout de `ON DELETE RESTRICT ON UPDATE CASCADE` pour les clés étrangères
- Changé `date_demande` et `date_debut` comme `NOT NULL`

### 1.2 Table `solde_conge`
**Améliorations :**
- Ajout d'une contrainte `UNIQUE(Id_personnel)` pour garantir un seul solde par personnel
- Changé `solde_annuel` et `solde_restant` comme `NOT NULL` avec `DEFAULT 25`
- Ajoutées colonnes :
  - `date_initialisation` (DATE NOT NULL DEFAULT CURRENT_DATE) - Traçabilité
  - `date_renouvellement` (DATE) - Pour le renouvellement annuel des congés
- Ajout de contraintes `CHECK` :
  - `solde_restant >= 0`
  - `solde_annuel >= 0`

### 1.3 Table `validation_conge_chef`
**Améliorations :**
- Corrigé typo : `date_validaton` → `date_validation`
- Changé `date_validation` comme `NOT NULL DEFAULT CURRENT_DATE`
- Ajoutée colonne `commentaire VARCHAR(255)` pour justifier les décisions
- Ajout d'une contrainte `UNIQUE(Id_demande_conge)` pour éviter plusieurs validations
- Ajout de `ON DELETE RESTRICT ON UPDATE CASCADE` pour les clés étrangères

### 1.4 Table `remplacement`
**Améliorations majeures :**
- Ajoutée colonne `date_creation DATE NOT NULL DEFAULT CURRENT_DATE` - Traçabilité
- Ajoutée colonne `remplacant_accepte BOOLEAN DEFAULT FALSE` - État d'acceptation
- Ajoutée colonne `notifiee BOOLEAN DEFAULT FALSE` - Notification
- Ajoutée colonne `commentaire_remplacant VARCHAR(255)` - Feedback du remplaçant
- Ajout d'une contrainte `UNIQUE(Id_demande_conge)` pour un remplaçant par congé
- Ajout de `ON DELETE RESTRICT ON UPDATE CASCADE` pour les clés étrangères

### 1.5 Table `validation_conge_RH`
**Améliorations :**
- Changé `date_validation` comme `NOT NULL DEFAULT CURRENT_DATE`
- Allongé `commentaire` de `VARCHAR(50)` à `VARCHAR(255)`
- Ajoutée contrainte `UNIQUE(Id_validation_conge_chef)` pour une validation RH par demande
- Ajout de `ON DELETE RESTRICT ON UPDATE CASCADE` pour les clés étrangères

---

## 2. Flux Fonctionnel de Gestion des Congés

### 2.1 Côté Personnel (Demandeur)

```
1. Vérifier le solde de congé (solde_conge.solde_restant)
   ↓
2. Créer une demande_conge
   - date_demande = CURRENT_DATE
   - date_debut = date du début souhaité
   - date_fin = date de fin souhaitée
   - nombre_jours = calcul : DATE_PART('day', date_fin - date_debut) + 1
   - motif = raison du congé
   - id_statut_demande = "En attente"
   ↓
3. Vérifier si solde_restant >= nombre_jours
   - Si NON : Rejeter la demande avec raison insuffisance de solde
   - Si OUI : Procéder à l'étape 4
   ↓
4. La demande est créée et attend la validation du chef
```

### 2.2 Côté Chef de Département

```
1. Récupérer les demandes_conge avec id_statut_demande = "En attente"
   du département du chef (via personnee → poste → departement)
   ↓
2. Pour chaque demande :
   - Consulter les détails (dates, motif, personnel)
   - Créer un enregistrement validation_conge_chef
     - date_validation = CURRENT_DATE
     - commentaire = raison d'approbation/rejet
     - id_user = id du chef
     - id_demande_conge = demande concernée
     - id_decision_validation = "Approuvée" ou "Rejetée par chef"
   ↓
3. Si Approuvée :
   - Mettre à jour demande_conge.id_statut_demande = "Approuvée par chef"
   - Proposer un remplaçant automatique
     ↓ (voir 2.3)
   ↓
4. Si Rejetée :
   - Mettre à jour demande_conge.id_statut_demande = "Rejetée par chef"
```

### 2.3 Recherche Automatique du Remplaçant

```
1. Sélectionner les candidats remplaçants :
   - MÊME département que le personnel demandant congé
   - ACTIFS (personnel.actif = TRUE)
   - QUI N'ONT PAS de congé pendant les mêmes dates
   - EXCLURE : le demandeur lui-même
   ↓
2. Créer un enregistrement remplacement :
   - date_creation = CURRENT_DATE
   - remplacant_accepte = FALSE
   - notifiee = FALSE
   - commentaire_remplacant = NULL
   - id_personnel = id du remplaçant proposé
   - id_demande_conge = demande concernée
   ↓
3. Envoyer une notification au remplaçant :
   - Notifier de sa sélection en tant que remplaçant
   - Demander acceptation/modification/rejet
   - Mettre à jour notifiee = TRUE après envoi
```

### 2.4 Côté RH (Validation Finale)

```
1. Récupérer les demandes_conge avec id_statut_demande = "Approuvée par chef"
   ↓
2. Vérifier l'état du remplaçant :
   a. Si remplacant_accepte = TRUE :
      - La demande peut être validée
      ↓
   b. Si remplacant_accepte = FALSE (pas encore répondu) :
      - Attendre la réponse du remplaçant
      - Proposer d'autres remplaçants si nécessaire
      ↓
   c. Si remplacant_accepte = FALSE après délai :
      - Proposer RH de : Accepter sans remplaçant / Proposer autre
   ↓
3. Créer un enregistrement validation_conge_RH :
   - date_validation = CURRENT_DATE
   - commentaire = observations de la RH
   - id_validation_conge_chef = ref à validation du chef
   - id_user = id du RH
   - id_decision_validation = "Approuvée" ou "Rejetée par RH"
   ↓
4. Si Approuvée par RH :
   - Mettre à jour demande_conge.id_statut_demande = "Approuvée par RH"
   - METTRE À JOUR LE SOLDE :
     UPDATE solde_conge 
     SET solde_restant = solde_restant - nombre_jours
     WHERE id_personnel = (
       SELECT id_personnel FROM demande_conge WHERE id_demande_conge = ?
     )
   - Envoyer une notification au personnel : CONGÉ APPROUVÉ
   ↓
5. Si Rejetée par RH :
   - Mettre à jour demande_conge.id_statut_demande = "Rejetée par RH"
   - Envoyer une notification au personnel : CONGÉ REJETÉ
```

---

## 3. Modèles JPA à Créer (Sans Modifier les Classes Existantes)

### 3.1 DemandeConge.java
```java
@Entity
@Table(name = "demande_conge")
public class DemandeConge {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id_demande_conge;
    
    @Temporal(TemporalType.DATE)
    private Date date_demande;
    
    @Temporal(TemporalType.DATE)
    private Date date_debut;
    
    @Temporal(TemporalType.DATE)
    private Date date_fin;
    
    private Integer nombre_jours;
    private String motif;
    
    @ManyToOne
    @JoinColumn(name = "id_personnel")
    private Personnel personnel;
    
    @ManyToOne
    @JoinColumn(name = "id_statut_demande")
    private StatutDemande statutDemande;
    
    // getters/setters
}
```

### 3.2 SoldeConge.java
```java
@Entity
@Table(name = "solde_conge")
public class SoldeConge {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id_solde_conge;
    
    private Integer solde_annuel;
    private Integer solde_restant;
    
    @Temporal(TemporalType.DATE)
    private Date date_initialisation;
    
    @Temporal(TemporalType.DATE)
    private Date date_renouvellement;
    
    @OneToOne
    @JoinColumn(name = "id_personnel", unique = true)
    private Personnel personnel;
    
    // getters/setters
}
```

### 3.3 ValidationCongeChef.java
```java
@Entity
@Table(name = "validation_conge_chef")
public class ValidationCongeChef {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id_validation_conge_chef;
    
    @Temporal(TemporalType.DATE)
    private Date date_validation;
    
    private String commentaire;
    
    @ManyToOne
    @JoinColumn(name = "id_user")
    private User user;
    
    @OneToOne
    @JoinColumn(name = "id_demande_conge", unique = true)
    private DemandeConge demandeConge;
    
    @ManyToOne
    @JoinColumn(name = "id_decision_validation")
    private DecisionValidation decisionValidation;
    
    // getters/setters
}
```

### 3.4 Remplacement.java
```java
@Entity
@Table(name = "remplacement")
public class Remplacement {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id_remplacement;
    
    @Temporal(TemporalType.DATE)
    private Date date_creation;
    
    private Boolean remplacant_accepte;
    private Boolean notifiee;
    private String commentaire_remplacant;
    
    @ManyToOne
    @JoinColumn(name = "id_personnel")
    private Personnel personnel;
    
    @OneToOne
    @JoinColumn(name = "id_demande_conge", unique = true)
    private DemandeConge demandeConge;
    
    // getters/setters
}
```

### 3.5 ValidationCongeRH.java
```java
@Entity
@Table(name = "validation_conge_rh")
public class ValidationCongeRH {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id_validation_conge_rh;
    
    @Temporal(TemporalType.DATE)
    private Date date_validation;
    
    private String commentaire;
    
    @OneToOne
    @JoinColumn(name = "id_validation_conge_chef", unique = true)
    private ValidationCongeChef validationCongeChef;
    
    @ManyToOne
    @JoinColumn(name = "id_user")
    private User user;
    
    @ManyToOne
    @JoinColumn(name = "id_decision_validation")
    private DecisionValidation decisionValidation;
    
    // getters/setters
}
```

### 3.6 StatutDemande.java et DecisionValidation.java
```java
// StatutDemande.java
@Entity
@Table(name = "statut_demande")
public class StatutDemande {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id_statut_demande;
    private String libelle;
    // getters/setters
}

// DecisionValidation.java
@Entity
@Table(name = "decision_validation")
public class DecisionValidation {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id_decision_validation;
    private String libelle;
    // getters/setters
}
```

---

## 4. Repositories à Créer

```java
// DemandeCongeRepository.java
public interface DemandeCongeRepository extends JpaRepository<DemandeConge, Integer> {
    List<DemandeConge> findByPersonnelAndStatutDemande(Personnel personnel, StatutDemande statut);
    List<DemandeConge> findByPersonnelIdAndDateDebutBetween(Integer idPersonnel, Date debut, Date fin);
    List<DemandeConge> findByPersonnelPostedepartementAndStatutDemande(Departement dept, StatutDemande statut);
}

// SoldeCongeRepository.java
public interface SoldeCongeRepository extends JpaRepository<SoldeConge, Integer> {
    Optional<SoldeConge> findByPersonnel(Personnel personnel);
}

// RemplacementRepository.java
public interface RemplacementRepository extends JpaRepository<Remplacement, Integer> {
    Optional<Remplacement> findByDemandeConge(DemandeConge demandeConge);
    List<Remplacement> findByPersonnelAndRemplacantAccepte(Personnel personnel, Boolean accepte);
    List<Remplacement> findByNotifiee(Boolean notifiee);
}

// ValidationCongeChefRepository.java
public interface ValidationCongeChefRepository extends JpaRepository<ValidationCongeChef, Integer> {
    Optional<ValidationCongeChef> findByDemandeConge(DemandeConge demandeConge);
}

// ValidationCongeRHRepository.java
public interface ValidationCongeRHRepository extends JpaRepository<ValidationCongeRH, Integer> {
    Optional<ValidationCongeRH> findByValidationCongeChef(ValidationCongeChef validationChef);
}
```

---

## 5. Logique Métier (Services)

Les services implémentent les règles métier suivantes :

### DemandeCongeService
- `creerDemande()` : Créer avec vérification du solde
- `verifierDisponibilité()` : Contrôler si date disponible
- `mettreAJourStatut()` : Changer statut de la demande

### SoldeCongeService
- `initialiserSolde()` : Créer solde pour nouveau personnel
- `diminuerSolde()` : Après approbation RH
- `renouvelerSolde()` : Annuellement
- `verifierSoldeSuffisant()` : Avant création demande

### ValidationService
- `validerParChef()` : Approbation/rejet chef
- `validerParRH()` : Approbation/rejet RH final
- `mettreAJourSoldeApresValidation()` : Appel après validation RH

### RemplacementService
- `proposerRemplacant()` : Recherche automatique
- `envoyerNotification()` : Au remplaçant proposé
- `traiterReponseRemplacant()` : Acceptation/rejet du remplaçant

---

## 6. Exemple d'Utilisation (Vue Utilisateur)

### Personnel demande congé :
1. Consulter son solde via `SoldeCongeService.obtenirSoldePersonnel(idPersonnel)`
2. Créer une demande via `DemandeCongeService.creerDemande(debut, fin, motif)`
3. Voir statut de ses demandes

### Chef valide :
1. Voir liste des demandes en attente de son département
2. Approuver/rejeter chacune
3. Un remplaçant est automatiquement proposé si approuvé

### RH finalise :
1. Voir demandes approuvées par chef
2. Vérifier statut du remplaçant
3. Approuver/rejeter la demande
4. Le solde du personnel est automatiquement mis à jour si approuvé

---

## 7. Commandes SQL Utiles pour le Déploiement

```sql
-- Vérifier les congés d'un département
SELECT dc.id_demande_conge, p.nom, p.prenom, dc.date_debut, dc.date_fin, 
       dc.nombre_jours, sd.statut_demande
FROM demande_conge dc
JOIN personnel per ON dc.id_personnel = per.id_personnel
JOIN poste pos ON per.id_poste = pos.id_poste
JOIN departement dep ON pos.id_departement = dep.id_departement
WHERE dep.id_departement = ? AND dc.date_debut >= CURRENT_DATE;

-- Conflits de remplacement (deux congés simultanés)
SELECT COUNT(*) FROM demande_conge dc1
WHERE EXISTS (
    SELECT 1 FROM demande_conge dc2
    WHERE dc2.id_personnel = dc1.id_personnel
    AND dc1.id_demande_conge != dc2.id_demande_conge
    AND dc1.date_debut <= dc2.date_fin
    AND dc2.date_debut <= dc1.date_fin
    AND dc1.id_statut_demande IN (2, 3)
    AND dc2.id_statut_demande IN (2, 3)
);
```

---

## ✅ Résumé des Corrections

| Problème | Solution | Impact |
|----------|----------|--------|
| Colonne typo `date_validaton` | Renommée en `date_validation` | ✓ Cohérence |
| `date_fin` en VARCHAR | Changée en DATE | ✓ Requêtes SQL |
| Pas de contrainte unique sur solde | Ajout UNIQUE(Id_personnel) | ✓ Intégrité données |
| Manque info remplaçant | Ajout colonnes acceptation + notification | ✓ Traçabilité |
| Motif limité à 50 chars | Augmenté à 255 chars | ✓ Flexibilité |
| Clés étrangères faibles | Ajout ON DELETE RESTRICT ON UPDATE CASCADE | ✓ Sécurité |

