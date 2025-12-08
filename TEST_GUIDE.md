# Guide de test pour la redirection vers le formulaire de demande de congé

## 1. Démarrer l'application

```bash
cd "d:\S5\Mr Tovo\Gest_Entr"
mvn spring-boot:run
```

L'application démarre sur `http://localhost:8081`

## 2. Test 1: Accès à la racine (/)

**URL**: `http://localhost:8081/`

**Résultat attendu**: 
- La page redirige automatiquement vers `/public/conge/nouvelle-demande?id=X`
- Affichage du formulaire de demande de congé avec les informations de l'employé

**Statut HTTP**: 200 (page s'affiche correctement)

## 3. Test 2: Accès direct au formulaire

**URL**: `http://localhost:8081/public/conge/nouvelle-demande?id=1`

**Résultat attendu**:
- Affichage du formulaire de demande de congé
- Informations de l'employé avec ID 1
- Solde de congés restants
- Pas de demande d'authentification

**Formulaire inclut**:
- [ ] Date de début
- [ ] Date de fin
- [ ] Motif de congé
- [✅] Calculateur du nombre de jours (JavaScript)
- [✅] Bouton "Envoyer la demande"
- [✅] Bouton "Annuler"

## 4. Test 3: Remplir et envoyer le formulaire

**Étapes**:
1. Sélectionner une date de début: `2025-12-15`
2. Sélectionner une date de fin: `2025-12-20`
3. Entrer un motif: `Vacances annuelles`
4. Cliquer sur "Envoyer la demande"

**Résultat attendu**:
- La demande est créée en base de données
- Redirection vers `/public/conge/mes-demandes?id=1`
- Message de succès: "Demande de congé créée avec succès!"

## 5. Test 4: Voir les demandes de congé

**URL**: `http://localhost:8081/public/conge/mes-demandes?id=1`

**Résultat attendu**:
- Liste de toutes les demandes de l'employé
- Colonnes: ID, Date début, Date fin, Jours, Statut, Actions
- Bouton "Créer une nouvelle demande"
- Bouton "Retour"

## 6. Test 5: Validation des dates (optionnel)

**Test**: Envoyer une demande avec une date de fin antérieure à la date de début

**Résultat attendu**:
- Message d'erreur: "La date de fin doit être après la date de début"
- Redirection vers le formulaire

## 7. Test 6: Vérifier le solde de congés

**Vérification**:
- Chaque formulaire affiche le solde de congés restants
- Le calcul du nombre de jours est correct
- La validation du solde fonctionne (refuser si > solde disponible)

## 8. Test 7: Accès sans authentification (Principal)

**Test**: Accéder à `/public/conge/nouvelle-demande?id=1` sans session authentifiée

**Résultat attendu**: ✅ Accès autorisé
- Aucune redirection vers `/login`
- Formulaire affiché normalement

**Test**: Accéder à `/personnel/conge/nouvelle-demande` sans session

**Résultat attendu**: ⚠️ Redirection vers login (route protégée)

## 9. Points clés à valider

- ✅ Page racine `/` redirige vers `/public/conge/nouvelle-demande?id=1`
- ✅ Routes `/public/**` sont accessibles sans authentification
- ✅ Les ressources CSS et images se chargent
- ✅ Le calcul JavaScript du nombre de jours fonctionne
- ✅ La création de demandes fonctionne
- ✅ L'affichage de mes demandes fonctionne
- ✅ Les validations métier fonctionnent
- ✅ Le solde de congés s'affiche correctement

## 10. Dépannage

### Erreur: "Employé non trouvé"
- Vérifier qu'il y a au moins un enregistrement dans la table `personnel`
- Vérifier que `personnel.actif = true`
- Utiliser une URL avec un ID valide: `/public/conge/nouvelle-demande?id=1`

### Erreur: "Redirection vers login"
- Vérifier la configuration Spring Security dans `SecurityConfig.java`
- S'assurer que `/public/**` est dans les routes permitAll()

### Page CSS/Style cassée
- Vérifier que les fichiers CSS sont dans `/src/main/webapp/css/`
- Vérifier que le contexte racine est correct dans les URL: `/css/styles.css`

## 11. Commandes curl pour tester (optionnel)

```bash
# Test accès à la racine
curl -v http://localhost:8081/

# Test accès au formulaire
curl -v http://localhost:8081/public/conge/nouvelle-demande?id=1

# Test POST (créer une demande)
curl -X POST http://localhost:8081/public/conge/creer \
  -d "id=1&dateDebut=2025-12-15&dateFin=2025-12-20&motif=Vacances"

# Test affichage des demandes
curl -v http://localhost:8081/public/conge/mes-demandes?id=1
```

## 12. Logs attendus au démarrage

```
[INFO] Starting GestionApplication
[INFO] HikariPool-1 - Starting...
[INFO] HikariPool-1 - Added connection
[INFO] Tomcat started on port 8081 (http) with context path ''
[INFO] Started GestionApplication
```

✅ **Si tous ces tests passent, la migration vers l'accès public est réussie!**
