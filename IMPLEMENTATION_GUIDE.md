# 📘 Guide d'Implémentation - Système de Gestion du Personnel

## 🎯 Vue d'ensemble

Ce guide décrit l'implémentation complète du module de gestion du personnel basé sur les spécifications du fichier `My_Task.txt`. Le système inclut :

1. **Fiche employé complète** - Vue consolidée de toutes les informations d'un employé
2. **Suivi des contrats de travail** - Gestion des CDI, CDD, Stages avec alertes d'expiration
3. **Historique des postes et promotions** - Suivi de la carrière des employés
4. **Gestion des documents RH** - Stockage et suivi des documents administratifs

---

## 📁 Structure du Projet

### 1. **Modèles (Entities)**

#### TypeContrat.java
```
Attributs :
- id_type_contrat (Integer, @Id, Auto)
- libelle (String) - CDI, CDD, Stage, Freelance

Localisation : src/main/java/com/example/gestion/models/TypeContrat.java
```

#### ContratTravail.java
```
Attributs :
- id_contrat (Integer, @Id, Auto)
- personnel (ManyToOne → Personnel)
- typeContrat (ManyToOne → TypeContrat)
- date_debut (Date)
- date_fin (Date) - nullable pour CDI
- duree_mois (Integer)
- periode_essai_mois (Integer)
- date_alerte (Date) - auto-calculé (date_fin - 15 jours)
- statut (String) - Actif, Terminé, Renouvelé
- remarques (String)

Localisation : src/main/java/com/example/gestion/models/ContratTravail.java
```

#### HistoriquePoste.java
```
Attributs :
- id_historique (Integer, @Id, Auto)
- personnel (ManyToOne → Personnel)
- poste (ManyToOne → Poste)
- date_debut (Date)
- date_fin (Date) - nullable pour poste actuel
- type_mouvement (String) - Promotion, Mutation, Affectation initiale, Rétrogradation
- salaire (BigDecimal)
- motif (String)

Localisation : src/main/java/com/example/gestion/models/HistoriquePoste.java
```

#### TypeDocument.java
```
Attributs :
- id_type_document (Integer, @Id, Auto)
- libelle (String) - CIN, Diplôme, Certificat médical, etc.

Localisation : src/main/java/com/example/gestion/models/TypeDocument.java
```

#### DocumentPersonnel.java
```
Attributs :
- id_document (Integer, @Id, Auto)
- personnel (ManyToOne → Personnel)
- typeDocument (ManyToOne → TypeDocument)
- nom_fichier (String)
- chemin_fichier (String) - path du fichier uploadé
- numero_document (String)
- date_upload (Date)
- date_delivrance (Date)
- date_expiration (Date)
- remarques (String)

Localisation : src/main/java/com/example/gestion/models/DocumentPersonnel.java
```

---

### 2. **Repositories**

```
TypeContratRepository - CRUD sur type_contrat
ContratTravailRepository - CRUD + findByPersonnel, findByStatut, findContratsExpirantAvant
HistoriquePosteRepository - CRUD + findByPersonnelOrderByDateDebutDesc
TypeDocumentRepository - CRUD sur type_document
DocumentPersonnelRepository - CRUD + findByPersonnel

Localisation : src/main/java/com/example/gestion/repository/
```

---

### 3. **Services**

#### ContratTravailService.java
```
Méthodes :
- getAllContrats() - Liste tous les contrats
- getContratById(id) - Récupère un contrat
- saveContrat(contrat) - Sauvegarde avec calcul auto de date_alerte
- deleteContrat(id) - Suppression
- getContratsByPersonnel(personnel) - Contrats d'un employé
- getContratsExpirantAvant(date) - Contrats expirant avant une date

Logique métier :
- Auto-calcul date_alerte = date_fin - 15 jours
- Validation : CDI ne peut pas avoir date_fin

Localisation : src/main/java/com/example/gestion/services/ContratTravailService.java
```

#### HistoriquePosteService.java
```
Méthodes :
- getAllHistoriques()
- getHistoriqueById(id)
- saveHistorique(historique)
- deleteHistorique(id)
- getHistoriquesByPersonnel(personnel) - Trié par date_debut DESC

Localisation : src/main/java/com/example/gestion/services/HistoriquePosteService.java
```

#### DocumentPersonnelService.java
```
Méthodes :
- getAllDocuments()
- getDocumentById(id)
- saveDocument(document)
- deleteDocument(id)
- getDocumentsByPersonnel(personnel)

Localisation : src/main/java/com/example/gestion/services/DocumentPersonnelService.java
```

---

### 4. **Contrôleurs**

#### AdminContratTravailController.java
```
Routes :
GET  /admin/contrats - Liste des contrats avec alertes
GET  /admin/contrats/nouveau - Formulaire création
POST /admin/contrats/enregistrer - Sauvegarde
GET  /admin/contrats/modifier/{id} - Formulaire modification
GET  /admin/contrats/supprimer/{id} - Suppression

Localisation : src/main/java/com/example/gestion/controllers/AdminContratTravailController.java
```

#### AdminHistoriquePosteController.java
```
Routes :
GET  /admin/historique-postes - Liste historiques
GET  /admin/historique-postes/nouveau - Formulaire
POST /admin/historique-postes/enregistrer - Sauvegarde
GET  /admin/historique-postes/modifier/{id} - Modification
GET  /admin/historique-postes/supprimer/{id} - Suppression

Localisation : src/main/java/com/example/gestion/controllers/AdminHistoriquePosteController.java
```

#### AdminDocumentPersonnelController.java
```
Routes :
GET  /admin/documents - Liste documents
GET  /admin/documents/nouveau - Formulaire upload
POST /admin/documents/enregistrer - Upload + sauvegarde
GET  /admin/documents/modifier/{id} - Modification
GET  /admin/documents/supprimer/{id} - Suppression

Fonctionnalité spéciale : Upload de fichiers

Localisation : src/main/java/com/example/gestion/controllers/AdminDocumentPersonnelController.java
```

#### AdminPersonnelDetailController.java
```
Routes :
GET /admin/personnel/{id}/fiche - Fiche employé complète

Fonctionnalité :
- Agrège toutes les informations d'un employé
- Affiche contrats, historique, documents

Localisation : src/main/java/com/example/gestion/controllers/AdminPersonnelDetailController.java
```

---

### 5. **Vues JSP**

#### Contrats de Travail
```
admin/contrats/list.jsp - Tableau des contrats avec section alertes
admin/contrats/form.jsp - Formulaire création/modification

Localisation : src/main/webapp/WEB-INF/views/admin/contrats/
```

#### Historique Postes
```
admin/historique-postes/list.jsp - Timeline des mouvements
admin/historique-postes/form.jsp - Formulaire mouvement

Localisation : src/main/webapp/WEB-INF/views/admin/historique-postes/
```

#### Documents RH
```
admin/documents/list.jsp - Liste documents avec expirations
admin/documents/form.jsp - Upload de fichiers

Localisation : src/main/webapp/WEB-INF/views/admin/documents/
```

#### Fiche Employé
```
admin/personnel/fiche.jsp - Vue consolidée complète

Sections :
1. Informations personnelles avec photo
2. Contrats de travail
3. Historique carrière (timeline)
4. Documents RH

Localisation : src/main/webapp/WEB-INF/views/admin/personnel/
```

---

### 6. **Scripts SQL**

#### Script_Extension.sql
```sql
-- Création des tables
CREATE TABLE type_contrat (...)
CREATE TABLE contrat_travail (...)
CREATE TABLE historique_poste (...)
CREATE TABLE type_document (...)
CREATE TABLE document_personnel (...)

-- Contraintes FK
ALTER TABLE contrat_travail ADD FOREIGN KEY (id_personnel) REFERENCES personnel(id_personnel)
...

Localisation : Base/Script_Extension.sql
```

#### data_Harena.sql
```sql
-- Données de test
INSERT INTO type_contrat VALUES (1, 'CDI'), (2, 'CDD'), ...
INSERT INTO type_document VALUES (1, 'CIN'), (2, 'Diplôme'), ...

-- 5 employés test :
- Ando Rakoto (id=1) - Directeur Commercial
- Maria Razafy (id=2) - Développeur Senior
- Harena Andrianina (id=3) - Comptable
- Faly Rasoamanana (id=4) - Technicien Support
- Toky Randriamihaja (id=5) - Stagiaire Marketing

-- 6 contrats, 9 mouvements carrière, 19 documents

Localisation : Base/data_Harena.sql
```

---

## 🚀 Installation et Déploiement

### Étape 1 : Démarrer MySQL
```powershell
net start MySQL
```

### Étape 2 : Exécuter les scripts SQL (dans l'ordre)
```sql
1. Script.sql          -- Schéma de base
2. Script_Extension.sql -- Tables personnel management
3. data_Harena.sql     -- Données de test
```

### Étape 3 : Compiler le projet
```bash
mvn clean install
```

### Étape 4 : Lancer l'application
```bash
mvn spring-boot:run
```

### Étape 5 : Accéder à l'application
```
URL : http://localhost:8080/admin/dashboard
```

---

## 📋 Navigation Admin

Le dashboard admin contient maintenant la section **"GESTION DU PERSONNEL"** avec :

```
📝 Contrats de Travail (/admin/contrats)
   - Créer, modifier, supprimer des contrats
   - Voir les alertes d'expiration (<15 jours)

📈 Historique Postes (/admin/historique-postes)
   - Enregistrer promotions, mutations
   - Suivre l'évolution de carrière

📂 Documents RH (/admin/documents)
   - Upload de documents (CIN, diplômes, etc.)
   - Suivi des dates d'expiration

👥 Fiches Employés (/personnel/list puis "Fiche complète")
   - Vue consolidée de toutes les informations
   - Timeline de carrière visuelle
```

---

## 🧪 Tests

### Données de test disponibles (data_Harena.sql)

#### Employé 1 : Ando Rakoto (Directeur Commercial)
- Contrat : CDI depuis 01/02/2020
- Promotions : Assistant Commercial → Directeur Commercial
- Documents : CIN, Diplôme Master, Certificat médical, Contrat de travail

#### Employé 2 : Maria Razafy (Développeur Senior)
- Contrat : CDI depuis 15/06/2019
- Promotions : Junior → Senior Développeur
- Documents : CIN, Diplôme Licence, Certificats formations

#### Employé 3 : Harena Andrianina (Comptable)
- Contrat : CDD (expire 31/12/2024) → ALERTE
- Documents : CIN, Diplôme, Attestation travail

#### Employé 4 : Faly Rasoamanana (Technicien Support)
- Contrat : CDD renouvelé
- Documents : CIN, Certificat professionnel

#### Employé 5 : Toky Randriamihaja (Stagiaire)
- Contrat : Stage (expire 28/02/2025)
- Documents : CIN, Lettre motivation

### Scénarios de test

1. **Alertes contrats**
   - Accéder à /admin/contrats
   - Vérifier la section "⚠️ Alertes - Contrats expirant bientôt"
   - Harena Andrianina doit apparaître (expire 31/12/2024)

2. **Timeline carrière**
   - Accéder à /admin/historique-postes
   - Voir les promotions de Maria Razafy (Junior → Senior)

3. **Documents expirés**
   - Accéder à /admin/documents
   - Vérifier les documents avec dates d'expiration

4. **Fiche employé complète**
   - Liste personnel → Cliquer "Fiche complète" sur Maria Razafy
   - Vérifier : photo, infos perso, contrats, historique, documents

---

## 🔧 Personnalisation

### Modifier les types de contrats
```sql
INSERT INTO type_contrat (libelle) VALUES ('Contrat saisonnier');
```

### Ajouter un type de document
```sql
INSERT INTO type_document (libelle) VALUES ('Permis de conduire');
```

### Modifier la période d'alerte (défaut : 15 jours)
```java
// Dans ContratTravailService.java
Calendar cal = Calendar.getInstance();
cal.setTime(contrat.getDate_fin());
cal.add(Calendar.DAY_OF_MONTH, -15); // Modifier ici
contrat.setDate_alerte(cal.getTime());
```

---

## 📊 Fonctionnalités Implémentées

### ✅ A. Gestion du Personnel

#### 1. Fiche employé complète
- [x] Informations personnelles (nom, prénom, genre, naissance)
- [x] Coordonnées (téléphone, email, adresse)
- [x] Poste actuel et département
- [x] Date d'embauche et expérience
- [x] Photo de profil
- [x] Statut actif/inactif
- [x] Agrégation contrats + historique + documents

#### 2. Suivi du contrat de travail
- [x] Types de contrats (CDI, CDD, Stage, Freelance)
- [x] Dates de début et fin
- [x] Durée en mois
- [x] Période d'essai
- [x] Alertes d'expiration (15 jours avant)
- [x] Statut (Actif, Terminé, Renouvelé)
- [x] Remarques/notes
- [x] CRUD complet
- [x] Vue liste avec filtrage
- [x] Formulaire validation

#### 3. Historique postes, promotions, mobilités
- [x] Enregistrement de tous les mouvements
- [x] Types : Promotion, Mutation, Affectation initiale, Rétrogradation
- [x] Dates début/fin par poste
- [x] Suivi des salaires
- [x] Motif du mouvement
- [x] Vue timeline chronologique
- [x] CRUD complet

#### 4. Gestion des documents RH
- [x] Types de documents (CIN, Diplôme, Certificat, etc.)
- [x] Upload de fichiers
- [x] Métadonnées (numéro, dates)
- [x] Date de délivrance
- [x] Date d'expiration avec alertes
- [x] Remarques
- [x] CRUD complet
- [x] Stockage fichiers

---

## 🎨 Interface Utilisateur

### Design Pattern
- **Responsive** : Adapté mobile et desktop
- **Bootstrap-like** : Badges, boutons, tableaux stylisés
- **Icons** : Emojis pour améliorer UX
- **Colors** :
  - CDI : Vert (stable)
  - CDD : Jaune (temporaire)
  - Promotion : Vert (positif)
  - Mutation : Bleu (changement)
  - Alertes : Rouge (urgent)

### Badges de statut
```
Actif    → badge-success (vert)
Terminé  → badge-secondary (gris)
Renouvelé → badge-info (bleu)
CDI      → badge-success (vert)
CDD/Stage → badge-warning (jaune)
```

---

## 📚 Documentation Technique

### Technologies utilisées
- **Backend** : Spring Boot 3.2.1, Java 21
- **ORM** : JPA/Hibernate
- **Base de données** : MySQL 8
- **Frontend** : JSP + JSTL
- **Build** : Maven
- **Tests** : H2 in-memory database

### Architecture
```
MVC Pattern :
- Models (Entities) → JPA
- Repositories → Spring Data JPA
- Services → Business Logic
- Controllers → HTTP Routing
- Views → JSP
```

### Sécurité
- Upload de fichiers : validation type/taille (TODO)
- Paths fichiers : stockage hors webroot recommandé
- SQL Injection : protégé par JPA/Hibernate

---

## 🐛 Dépannage

### Problème : "MySQL ne démarre pas"
```powershell
# Vérifier le statut
sc query MySQL

# Démarrer le service
net start MySQL

# Si échec, vérifier le port 3306
netstat -an | findstr 3306
```

### Problème : "Table doesn't exist"
```
Solution : Exécuter les scripts SQL dans l'ordre
1. Script.sql
2. Script_Extension.sql
3. data_Harena.sql
```

### Problème : "Tests échouent"
```
Solution : H2 est configuré pour les tests
Vérifier : test/resources/application.properties existe
```

### Problème : "Upload échoue"
```java
// Vérifier la configuration dans application.properties
spring.servlet.multipart.max-file-size=10MB
spring.servlet.multipart.max-request-size=10MB
```

---

## 📈 Évolutions Futures

### Fonctionnalités suggérées
1. **Dashboard statistiques**
   - Graphiques pyramide des âges
   - Taux de turnover
   - Distribution des contrats

2. **Notifications**
   - Emails automatiques pour expirations
   - Rappels période d'essai

3. **Rapports**
   - Export PDF fiche employé
   - Génération automatique contrats

4. **Workflow**
   - Validation hiérarchique promotions
   - Circuit approbation documents

5. **Intégration**
   - API REST pour mobile
   - Intégration calendrier (Google Calendar)

---

## 👥 Contact & Support

Pour toute question ou assistance :
1. Consulter ce guide
2. Vérifier les scripts SQL de test
3. Examiner les logs : `target/logs/application.log`

---

## 📝 Historique des Modifications

**Version 1.0** - Date : Décembre 2024
- Implémentation complète My_Task.txt
- 5 nouvelles entités
- 5 repositories
- 3 services
- 4 contrôleurs
- 7 vues JSP
- 2 scripts SQL
- Documentation complète

---

**Développé dans le cadre du projet Gestion_Entreprise**  
**Framework** : Spring Boot 3.2.1  
**Auteur** : Équipe Gestion RH  
**Dernière mise à jour** : Décembre 2024
