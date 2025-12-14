# 🚀 Guide de Démarrage Rapide

## ✅ Prérequis

- ☑️ Java 21
- ☑️ Maven 3.x
- ☑️ MySQL 8.x
- ☑️ Git

## 📦 Installation

### 1. Démarrer MySQL
```powershell
net start MySQL
```

### 2. Créer la base de données
```sql
CREATE DATABASE gestion_entreprise CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

### 3. Exécuter les scripts SQL (dans l'ordre)
```bash
# Se connecter à MySQL
mysql -u root -p gestion_entreprise

# Exécuter les scripts
source Base/Script.sql
source Base/Script_Extension.sql
source Base/data_Harena.sql
```

### 4. Compiler et lancer
```bash
mvn clean install
mvn spring-boot:run
```

### 5. Accéder à l'application
```
🌐 http://localhost:8080/admin/dashboard
```

## 🎯 Fonctionnalités Disponibles

### 📝 Gestion des Contrats de Travail
- **URL** : http://localhost:8080/admin/contrats
- **Actions** : Créer, Modifier, Supprimer
- **Alertes** : Contrats expirant dans moins de 15 jours

### 📈 Historique des Postes
- **URL** : http://localhost:8080/admin/historique-postes
- **Actions** : Enregistrer promotions, mutations, affectations
- **Vue** : Timeline chronologique

### 📂 Documents RH
- **URL** : http://localhost:8080/admin/documents
- **Actions** : Upload, Modifier, Supprimer
- **Suivi** : Dates d'expiration

### 👥 Fiches Employés
- **URL** : http://localhost:8080/personnel/list
- **Action** : Cliquer "Fiche complète" sur un employé
- **Vue** : Agrégation complète (contrats + historique + documents)

## 🧪 Tester avec les Données de Test

### Employés disponibles :
1. **Ando Rakoto** (id=1) - Directeur Commercial - CDI
2. **Maria Razafy** (id=2) - Développeur Senior - CDI avec promotions
3. **Harena Andrianina** (id=3) - Comptable - CDD expirant bientôt ⚠️
4. **Faly Rasoamanana** (id=4) - Technicien Support - CDD renouvelé
5. **Toky Randriamihaja** (id=5) - Stagiaire Marketing - Stage

### Scénarios de test :

#### ✅ Test 1 : Voir les alertes de contrats
```
1. Aller sur http://localhost:8080/admin/contrats
2. Vérifier la section "⚠️ Alertes - Contrats expirant bientôt"
3. Harena Andrianina doit apparaître (CDD expire 31/12/2024)
```

#### ✅ Test 2 : Voir l'historique de carrière
```
1. Aller sur http://localhost:8080/admin/historique-postes
2. Chercher Maria Razafy
3. Voir la promotion : Développeur Junior → Développeur Senior
```

#### ✅ Test 3 : Consulter les documents
```
1. Aller sur http://localhost:8080/admin/documents
2. Filtrer par employé (ex: Ando Rakoto)
3. Voir : CIN, Diplôme Master, Certificat médical, Contrat de travail
```

#### ✅ Test 4 : Fiche employé complète
```
1. Aller sur http://localhost:8080/personnel/list
2. Cliquer "📋 Fiche complète" sur Maria Razafy
3. Vérifier toutes les sections :
   - Informations personnelles avec photo
   - Contrats de travail
   - Historique de carrière (timeline)
   - Documents RH
```

## 🔧 Configuration

### application.properties
```properties
# Base de données
spring.datasource.url=jdbc:mysql://localhost:3306/gestion_entreprise?useSSL=false&serverTimezone=UTC
spring.datasource.username=root
spring.datasource.password=votre_mot_de_passe

# JPA
spring.jpa.hibernate.ddl-auto=none
spring.jpa.show-sql=true

# Upload fichiers
spring.servlet.multipart.max-file-size=10MB
spring.servlet.multipart.max-request-size=10MB
```

## 📊 Structure des Données

### Contrats de Travail
```
Types : CDI, CDD, Stage, Freelance
Alertes : 15 jours avant expiration
Statuts : Actif, Terminé, Renouvelé
```

### Historique Postes
```
Types : Promotion, Mutation, Affectation initiale, Rétrogradation
Suivi : Dates début/fin, salaires, motifs
```

### Documents RH
```
Types : CIN, Diplôme, Certificat médical, Certificat travail, etc.
Métadonnées : Numéro, dates délivrance/expiration
Stockage : Upload avec chemin fichier
```

## 🐛 Dépannage Express

### MySQL ne démarre pas
```powershell
sc query MySQL
net start MySQL
```

### Port 8080 déjà utilisé
```properties
# Dans application.properties
server.port=8081
```

### Erreur "Table doesn't exist"
```bash
# Réexécuter les scripts dans l'ordre
mysql -u root -p gestion_entreprise < Base/Script.sql
mysql -u root -p gestion_entreprise < Base/Script_Extension.sql
mysql -u root -p gestion_entreprise < Base/data_Harena.sql
```

## 📚 Documentation Complète

Voir [IMPLEMENTATION_GUIDE.md](IMPLEMENTATION_GUIDE.md) pour :
- Architecture détaillée
- Structure du code
- API des contrôleurs
- Modèles de données
- Évolutions futures

## ✨ Aide-mémoire URLs

| Fonctionnalité | URL |
|----------------|-----|
| Dashboard Admin | `/admin/dashboard` |
| Contrats de Travail | `/admin/contrats` |
| Nouveau Contrat | `/admin/contrats/nouveau` |
| Historique Postes | `/admin/historique-postes` |
| Documents RH | `/admin/documents` |
| Liste Personnel | `/personnel/list` |
| Fiche Employé | `/admin/personnel/{id}/fiche` |

---

**🎉 Tout est prêt ! Bon développement !**
