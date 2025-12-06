-- =============================================================================
-- VÉRIFICATION DE L'INSTALLATION - SYSTÈME D'AUTHENTIFICATION
-- =============================================================================
-- Exécuter ces requêtes pour vérifier que tout est correctement installé

USE gestion_entreprise;

-- =============================================================================
-- 1. VÉRIFIER LA STRUCTURE DE LA TABLE PERSONNEL
-- =============================================================================

DESCRIBE personnel;

-- Résultat attendu: Les colonnes 'username' et 'password' doivent être présentes
-- Colonnes requises:
--   - id_personnel (INT, PRIMARY KEY)
--   - date_embauche (DATE)
--   - actif (BOOLEAN/TINYINT)
--   - id_candidat (INT)
--   - id_poste (INT)
--   - username (VARCHAR(100), UNIQUE, NOT NULL)
--   - password (VARCHAR(255), NOT NULL)

-- =============================================================================
-- 2. COMPTER LE NOMBRE DE COMPTES CRÉÉS
-- =============================================================================

SELECT COUNT(*) as nombre_comptes 
FROM personnel 
WHERE username IS NOT NULL;

-- Résultat attendu: 7 (ou plus selon vos données)

-- =============================================================================
-- 3. AFFICHER TOUS LES COMPTES AVEC LEURS INFORMATIONS
-- =============================================================================

SELECT 
  p.id_personnel,
  p.username,
  IF(p.actif = 1, 'ACTIF', 'INACTIF') as statut,
  DATE_FORMAT(p.date_embauche, '%d/%m/%Y') as date_embauche,
  CONCAT(c.nom, ' ', c.prenom) as nom_complet,
  po.libelle as poste,
  d.departement as departement
FROM personnel p
LEFT JOIN candidat c ON p.id_candidat = c.id_candidat
LEFT JOIN poste po ON p.id_poste = po.id_poste
LEFT JOIN departement d ON po.id_departement = d.id_departement
WHERE p.username IS NOT NULL
ORDER BY p.id_personnel;

-- =============================================================================
-- 4. VÉRIFIER LES COMPTES ACTIFS vs INACTIFS
-- =============================================================================

SELECT 
  IF(actif = 1, 'ACTIF', 'INACTIF') as statut,
  COUNT(*) as nombre_comptes
FROM personnel
WHERE username IS NOT NULL
GROUP BY actif;

-- Résultat attendu:
--   ACTIF: 6
--   INACTIF: 1

-- =============================================================================
-- 5. VÉRIFIER QUE LES USERNAMES SONT UNIQUES
-- =============================================================================

SELECT username, COUNT(*) as nombre_doublons
FROM personnel
WHERE username IS NOT NULL
GROUP BY username
HAVING COUNT(*) > 1;

-- Résultat attendu: Vide (aucun doublon - contraint par UNIQUE)

-- =============================================================================
-- 6. VÉRIFIER LES MOTS DE PASSE (TOUS DEVRAIENT ÊTRE EN BCRYPT)
-- =============================================================================

SELECT 
  username,
  LENGTH(password) as longueur_hash,
  SUBSTRING(password, 1, 4) as debut_hash
FROM personnel
WHERE username IS NOT NULL;

-- Résultat attendu:
--   - Longueur: 60 (longueur standard d'un hash BCrypt)
--   - Début du hash: $2a$ (préfixe BCrypt)

-- =============================================================================
-- 7. VÉRIFIER LES DONNÉES LIÉES (CANDIDAT, POSTE, DÉPARTEMENT)
-- =============================================================================

SELECT 
  p.id_personnel,
  p.username,
  c.nom,
  c.prenom,
  po.libelle as poste,
  d.departement,
  IF(c.id_candidat IS NOT NULL, '✓', '✗') as candidat_existe,
  IF(po.id_poste IS NOT NULL, '✓', '✗') as poste_existe,
  IF(d.id_departement IS NOT NULL, '✓', '✗') as departement_existe
FROM personnel p
LEFT JOIN candidat c ON p.id_candidat = c.id_candidat
LEFT JOIN poste po ON p.id_poste = po.id_poste
LEFT JOIN departement d ON po.id_departement = d.id_departement
WHERE p.username IS NOT NULL;

-- Résultat attendu: Tous les champs avec ✓

-- =============================================================================
-- 8. TESTER UN LOGIN (SIMULATION)
-- =============================================================================

-- Chercher un utilisateur par username (comme Spring Security)
SELECT 
  id_personnel,
  username,
  password,
  actif
FROM personnel
WHERE username = 'dupont.j';

-- Résultat attendu:
--   id_personnel: [ID du personnel]
--   username: dupont.j
--   password: $2a$10$...
--   actif: 1

-- =============================================================================
-- 9. VÉRIFIER LES COMPTES INACTIFS
-- =============================================================================

SELECT 
  id_personnel,
  username,
  CONCAT(c.nom, ' ', c.prenom) as nom_complet,
  actif,
  DATE_FORMAT(date_embauche, '%d/%m/%Y') as date_embauche
FROM personnel p
LEFT JOIN candidat c ON p.id_candidat = c.id_candidat
WHERE username IS NOT NULL AND actif = 0;

-- Résultat attendu: leclerc.l (inactif)

-- =============================================================================
-- 10. INTÉGRITÉ RÉFÉRENTIELLE - VÉRIFIER LES CLÉS ÉTRANGÈRES
-- =============================================================================

-- Personnels sans candidat associé
SELECT id_personnel, username, id_candidat
FROM personnel
WHERE username IS NOT NULL AND id_candidat IS NULL;

-- Résultat attendu: Vide (tous les personnels doivent avoir un candidat)

-- Personnels sans poste associé
SELECT id_personnel, username, id_poste
FROM personnel
WHERE username IS NOT NULL AND id_poste IS NULL;

-- Résultat attendu: Vide (tous les personnels doivent avoir un poste)

-- =============================================================================
-- 11. RÉSUMÉ GLOBAL - CHECKLIST D'INSTALLATION
-- =============================================================================

SELECT 
  'Colonnes modifiées' as verification,
  CASE 
    WHEN (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='personnel' AND COLUMN_NAME='username') > 0 
    THEN '✓ Column username existe'
    ELSE '✗ Column username MANQUANTE'
  END as resultat
UNION ALL
SELECT 
  'Colonnes modifiées',
  CASE 
    WHEN (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='personnel' AND COLUMN_NAME='password') > 0 
    THEN '✓ Column password existe'
    ELSE '✗ Column password MANQUANTE'
  END
UNION ALL
SELECT 
  'Données de test',
  CONCAT('✓ ', COUNT(*), ' comptes créés')
FROM personnel WHERE username IS NOT NULL
UNION ALL
SELECT 
  'Comptes actifs',
  CONCAT('✓ ', COUNT(*), ' comptes actifs')
FROM personnel WHERE username IS NOT NULL AND actif = 1
UNION ALL
SELECT 
  'Intégrité des données',
  CONCAT('✓ All OK')
FROM personnel p
LEFT JOIN candidat c ON p.id_candidat = c.id_candidat
LEFT JOIN poste po ON p.id_poste = po.id_poste
WHERE p.username IS NOT NULL
HAVING COUNT(c.id_candidat) = COUNT(*);

-- =============================================================================
-- NOTES IMPORTANTES
-- =============================================================================
/*
1. Les mots de passe sont tous identiques pour les tests: "motdepasse123"
   Hash BCrypt: $2a$10$H0d1T5reLbWoQR1FTM8zL.xwmtXjq3xQ8Q5f3q7K0j9w5G1f5Jdha

2. Chaque compte doit:
   - Avoir un username UNIQUE
   - Avoir un mot de passe en BCRYPT (longueur 60)
   - Être lié à un CANDIDAT
   - Être lié à un POSTE
   - Avoir actif = 1 pour pouvoir se connecter

3. Si une vérification échoue:
   - Relancer le script 03_ALTER_PERSONNEL_ADD_AUTH.sql
   - Puis relancer le script 05_DONNEES_TEST_PERSONNEL.sql

4. Pour modifier un mot de passe dans un test:
   UPDATE personnel SET password = 'NOUVEAU_HASH_BCRYPT' WHERE username = 'dupont.j';
*/

-- =============================================================================
