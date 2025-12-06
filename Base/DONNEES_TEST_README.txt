================================================================================
                    DONNÉES DE TEST - SYSTÈME D'AUTHENTIFICATION
                             TABLE PERSONNEL MODIFIÉE
================================================================================

🔐 HASH BCRYPT UTILISÉ:
   Mot de passe: motdepasse123
   Hash: $2a$10$H0d1T5reLbWoQR1FTM8zL.xwmtXjq3xQ8Q5f3q7K0j9w5G1f5Jdha

================================================================================
                         COMPTES DE TEST DISPONIBLES
================================================================================

1. JEAN DUPONT - Développeur Fullstack
   ├─ Username: dupont.j
   ├─ Mot de passe: motdepasse123
   ├─ Poste: Développeur Fullstack
   ├─ Statut: Actif
   └─ Date embauche: 2024-01-20

2. MARIE MARTIN - Analyste Financier
   ├─ Username: martin.m
   ├─ Mot de passe: motdepasse123
   ├─ Poste: Analyste Financier
   ├─ Statut: Actif
   └─ Date embauche: 2024-02-25

3. PIERRE BERNARD - Chef de Projet Marketing
   ├─ Username: bernard.p
   ├─ Mot de passe: motdepasse123
   ├─ Poste: Chef de Projet Marketing
   ├─ Statut: Actif
   └─ Date embauche: 2024-03-15

4. SOPHIE THOMAS - Responsable RH
   ├─ Username: thomas.s
   ├─ Mot de passe: motdepasse123
   ├─ Poste: Responsable RH
   ├─ Statut: Actif
   └─ Date embauche: 2024-04-10

5. MARC LAURENT - Ingénieur Production
   ├─ Username: laurent.m
   ├─ Mot de passe: motdepasse123
   ├─ Poste: Ingénieur Production
   ├─ Statut: Actif
   └─ Date embauche: 2024-05-20

6. ANNE ROUSSEAU - Commercial
   ├─ Username: rousseau.a
   ├─ Mot de passe: motdepasse123
   ├─ Poste: Commercial
   ├─ Statut: Actif
   └─ Date embauche: 2024-06-10

7. LUC LECLERC - Directeur Général (INACTIF - TEST)
   ├─ Username: leclerc.l
   ├─ Mot de passe: motdepasse123
   ├─ Poste: Directeur Général
   ├─ Statut: INACTIF (connexion refusée)
   └─ Date embauche: 2023-01-15

================================================================================
                            PROCÉDURES DE TEST
================================================================================

ÉTAPE 1: Exécuter les scripts SQL
   1. Base/03_ALTER_PERSONNEL_ADD_AUTH.sql  (ajoute colonnes username/password)
   2. Base/04_INSERT_PERSONNEL_ACCOUNTS.sql (exemple simple)
   3. Base/05_DONNEES_TEST_PERSONNEL.sql    (7 comptes de test complets)

ÉTAPE 2: Démarrer l'application
   $ ./mvnw clean install
   $ ./mvnw spring-boot:run
   
   L'app démarre sur http://localhost:8081

ÉTAPE 3: Tester la connexion
   1. Aller sur http://localhost:8081/login
   2. Essayer les comptes de test (ex: dupont.j / motdepasse123)
   3. Vérifier les messages d'erreur pour les comptes inactifs

ÉTAPE 4: Tester la demande de congé
   1. Une fois connecté (ex: dupont.j), redirection vers /mes-demandes
   2. Cliquer "Nouvelle demande"
   3. Le formulaire affiche automatiquement le personnel connecté
   4. Remplir les dates et soumettre
   5. Vérifier que la demande est créée

================================================================================
                        MODIFICATION DES MOT DE PASSE
================================================================================

Pour générer un nouveau hash BCrypt (Java):
   BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
   String hash = encoder.encode("monMotDePasse");

Puis mettre à jour en SQL:
   UPDATE personnel 
   SET password = 'NOUVEAU_HASH' 
   WHERE username = 'dupont.j';

Exemple avec echo (bash/powershell):
   # Générer via un script Java simple ou utiliser un outil en ligne

================================================================================
                      GESTION DES COMPTES (SQL)
================================================================================

Désactiver un compte:
   UPDATE personnel SET actif = 0 WHERE username = 'martin.m';

Réactiver un compte:
   UPDATE personnel SET actif = 1 WHERE username = 'leclerc.l';

Supprimer un compte (décommenter username):
   UPDATE personnel SET username = NULL, password = NULL WHERE username = 'rousseau.a';

Changer le username:
   UPDATE personnel SET username = 'nouveau.username' WHERE username = 'ancien.username';

Voir tous les comptes actifs:
   SELECT id_personnel, username, actif, DATE_FORMAT(date_embauche, '%d/%m/%Y') as date_emb
   FROM personnel 
   WHERE username IS NOT NULL AND actif = 1;

================================================================================
                         POINTS IMPORTANTS
================================================================================

✓ Chaque personnel a un USERNAME UNIQUE
✓ Les mots de passe sont stockés en BCRYPT (jamais en texte clair)
✓ Les personnels INACTIFS (actif=0) ne peuvent pas se connecter
✓ Spring Security valide automatiquement username + mot de passe
✓ Une fois connecté, l'ID du personnel est récupéré via Principal
✓ Les demandes de congé sont liées au personnel connecté (via idPersonnel)

================================================================================
