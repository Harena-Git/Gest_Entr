-- ========================================================================
-- DONNÉES DE TEST PERSONNEL - VERSION CORRIGÉE (COLLATION UTF8MB4)
-- ========================================================================
-- Corrige les erreurs de collation en convertissant les tables à utf8mb4
-- Les données ne s'inséraient pas à cause d'un mélange de collations

USE gestion_entreprise;

-- ========================================================================
-- ÉTAPE 0: CORRIGER LES COLLATIONS
-- ========================================================================
-- Convertir les tables à utf8mb4_general_ci pour éviter les conflits

ALTER TABLE candidat CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
ALTER TABLE poste CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
ALTER TABLE personnel CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

-- ========================================================================
-- ÉTAPE 1: NETTOYER LES DOUBLONS (si des INSERT IGNORE ont échoué)
-- ========================================================================

DELETE FROM personnel WHERE username IN ('dupont.j', 'martin.m', 'bernard.p', 'thomas.s', 'laurent.m', 'rousseau.a', 'leclerc.l');
DELETE FROM candidat WHERE nom IN ('DUPONT', 'MARTIN', 'BERNARD', 'THOMAS', 'LAURENT', 'ROUSSEAU', 'LECLERC');

-- ========================================================================
-- ÉTAPE 2: VÉRIFIER LES ÉTATS CANDIDAT DISPONIBLES
-- ========================================================================

-- Afficher les ID disponibles pour etat_candidat
SELECT 'ID États Candidat disponibles:' AS info;
SELECT id_etat_candidat, libelle FROM etat_candidat;

-- ========================================================================
-- ÉTAPE 2B: INSÉRER LES CANDIDATS
-- ========================================================================
-- Utiliser l'ID d'état candidat le plus courant (généralement 1 ou le premier disponible)

INSERT INTO candidat (nom, prenom, email, telephone, date_candidature, id_etat_candidat) 
VALUES 
  ('DUPONT', 'Jean', 'jean.dupont@techmail.com', '0601020304', '2024-01-15', 
   (SELECT id_etat_candidat FROM etat_candidat LIMIT 1)),
  ('MARTIN', 'Marie', 'marie.martin@financemail.com', '0605060708', '2024-02-20', 
   (SELECT id_etat_candidat FROM etat_candidat LIMIT 1)),
  ('BERNARD', 'Pierre', 'pierre.bernard@marketingmail.com', '0609101112', '2024-03-10', 
   (SELECT id_etat_candidat FROM etat_candidat LIMIT 1)),
  ('THOMAS', 'Sophie', 'sophie.thomas@rhmail.com', '0613141516', '2024-04-05', 
   (SELECT id_etat_candidat FROM etat_candidat LIMIT 1)),
  ('LAURENT', 'Marc', 'marc.laurent@productionmail.com', '0617181920', '2024-05-12', 
   (SELECT id_etat_candidat FROM etat_candidat LIMIT 1)),
  ('ROUSSEAU', 'Anne', 'anne.rousseau@commercialmail.com', '0621222324', '2024-06-01', 
   (SELECT id_etat_candidat FROM etat_candidat LIMIT 1)),
  ('LECLERC', 'Luc', 'luc.leclerc@email.com', '0625262728', '2024-07-01', 
   (SELECT id_etat_candidat FROM etat_candidat LIMIT 1));

-- ========================================================================
-- ÉTAPE 3: INSÉRER LES PERSONNELS AVEC COMPTES
-- ========================================================================
-- Utilisation de CAST pour forcer la collation utf8mb4

INSERT INTO personnel (date_embauche, actif, id_candidat, id_poste, username, password)
VALUES 
  ('2024-01-20', 1, 
   (SELECT id_candidat FROM candidat WHERE nom = CAST('DUPONT' AS CHAR CHARACTER SET utf8mb4) LIMIT 1),
   (SELECT id_poste FROM poste WHERE libelle = CAST('Developpeur Fullstack' AS CHAR CHARACTER SET utf8mb4) LIMIT 1),
   'dupont.j', 'dupont12'),
   
  ('2024-02-25', 1,
   (SELECT id_candidat FROM candidat WHERE nom = CAST('MARTIN' AS CHAR CHARACTER SET utf8mb4) LIMIT 1),
   (SELECT id_poste FROM poste WHERE libelle = CAST('Analyste Financier' AS CHAR CHARACTER SET utf8mb4) LIMIT 1),
   'martin.m', 'martin34'),
   
  ('2024-03-15', 1,
   (SELECT id_candidat FROM candidat WHERE nom = CAST('BERNARD' AS CHAR CHARACTER SET utf8mb4) LIMIT 1),
   (SELECT id_poste FROM poste WHERE libelle LIKE CAST('%Marketing%' AS CHAR CHARACTER SET utf8mb4) LIMIT 1),
   'bernard.p', 'bernard56'),
   
  ('2024-04-10', 1,
   (SELECT id_candidat FROM candidat WHERE nom = CAST('THOMAS' AS CHAR CHARACTER SET utf8mb4) LIMIT 1),
   (SELECT id_poste FROM poste WHERE libelle LIKE CAST('%RH%' AS CHAR CHARACTER SET utf8mb4) LIMIT 1),
   'thomas.s', 'thomas78'),
   
  ('2024-05-20', 1,
   (SELECT id_candidat FROM candidat WHERE nom = CAST('LAURENT' AS CHAR CHARACTER SET utf8mb4) LIMIT 1),
   (SELECT id_poste FROM poste WHERE libelle LIKE CAST('%Production%' AS CHAR CHARACTER SET utf8mb4) LIMIT 1),
   'laurent.m', 'laurent90'),
   
  ('2024-06-10', 1,
   (SELECT id_candidat FROM candidat WHERE nom = CAST('ROUSSEAU' AS CHAR CHARACTER SET utf8mb4) LIMIT 1),
   (SELECT id_poste FROM poste WHERE libelle = CAST('Commercial' AS CHAR CHARACTER SET utf8mb4) LIMIT 1),
   'rousseau.a', 'rousseau12'),
   
  ('2023-01-15', 0,
   (SELECT id_candidat FROM candidat WHERE nom = CAST('LECLERC' AS CHAR CHARACTER SET utf8mb4) LIMIT 1),
   (SELECT id_poste FROM poste WHERE libelle = CAST('Directeur General' AS CHAR CHARACTER SET utf8mb4) LIMIT 1),
   'leclerc.l', 'leclerc34');

-- ========================================================================
-- ÉTAPE 4: VÉRIFIER L'INSERTION
-- ========================================================================

SELECT 
  per.id_personnel,
  CONCAT(c.nom, ' ', c.prenom) AS nom_complet,
  per.username,
  IF(per.actif = 1, 'Actif', 'Inactif') AS statut,
  DATE_FORMAT(per.date_embauche, '%d/%m/%Y') AS date_embauche,
  p.libelle AS poste
FROM personnel per
LEFT JOIN candidat c ON per.id_candidat = c.id_candidat
LEFT JOIN poste p ON per.id_poste = p.id_poste
WHERE per.username IS NOT NULL
ORDER BY per.id_personnel;

-- ========================================================================
-- ÉTAPE 5: COMPTES DE TEST DISPONIBLES
-- ========================================================================
-- Username: dupont.j / Mot de passe: dupont12
-- Username: martin.m / Mot de passe: martin34
-- Username: bernard.p / Mot de passe: bernard56
-- Username: thomas.s / Mot de passe: thomas78
-- Username: laurent.m / Mot de passe: laurent90
-- Username: rousseau.a / Mot de passe: rousseau12
-- Username: leclerc.l / Mot de passe: leclerc34 (INACTIF - connexion refusée)
