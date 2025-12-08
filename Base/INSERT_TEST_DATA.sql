-- Script pour insérer les données de test pour tester la demande de congé
-- Username: dupont.j / Mot de passe: dupont12

USE gestion_entreprise;

-- 1. Vérifier/Corriger les collations
ALTER TABLE candidat CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
ALTER TABLE poste CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
ALTER TABLE personnel CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

-- 2. Nettoyer les anciens enregistrements
DELETE FROM personnel WHERE username IN ('dupont.j', 'martin.m');
DELETE FROM candidat WHERE nom IN ('DUPONT', 'MARTIN');

-- 3. Insérer les candidats
INSERT INTO candidat (nom, prenom, email, telephone, date_candidature, id_etat_candidat) 
VALUES 
  ('DUPONT', 'Jean', 'jean.dupont@techmail.com', '0601020304', '2024-01-15', 1),
  ('MARTIN', 'Marie', 'marie.martin@financemail.com', '0605060708', '2024-02-20', 1);

-- 4. Insérer les personnels avec comptes
-- Récupérer les IDs de candidat et poste
INSERT INTO personnel (date_embauche, actif, id_candidat, id_poste, username, password)
SELECT 
  '2024-01-20', 1, c.id_candidat, p.id_poste, 'dupont.j', '$2a$10$slYQmyNdGzin7olVN3p5..zw7wIi88k0Oe/VsP0GRE.BjZrGGPrY.'
FROM candidat c, poste p 
WHERE c.nom = 'DUPONT' AND p.libelle LIKE '%Developpeur%' 
LIMIT 1;

INSERT INTO personnel (date_embauche, actif, id_candidat, id_poste, username, password)
SELECT 
  '2024-02-25', 1, c.id_candidat, p.id_poste, 'martin.m', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcg7b3XeKeUxWdeS86E36P4/e9.'
FROM candidat c, poste p 
WHERE c.nom = 'MARTIN' AND p.libelle LIKE '%Analyste%' 
LIMIT 1;

-- 5. Créer les soldes de congé pour ces personnels
INSERT INTO solde_conge (solde_annuel, solde_restant, date_initialisation, id_personnel)
SELECT 25, 25, NOW(), p.id_personnel
FROM personnel p
WHERE p.username = 'dupont.j' AND NOT EXISTS (
  SELECT 1 FROM solde_conge sc WHERE sc.id_personnel = p.id_personnel
);

INSERT INTO solde_conge (solde_annuel, solde_restant, date_initialisation, id_personnel)
SELECT 25, 25, NOW(), p.id_personnel
FROM personnel p
WHERE p.username = 'martin.m' AND NOT EXISTS (
  SELECT 1 FROM solde_conge sc WHERE sc.id_personnel = p.id_personnel
);

-- 6. Vérifier l'insertion
SELECT 
  per.id_personnel,
  CONCAT(c.nom, ' ', c.prenom) AS nom_complet,
  per.username,
  IF(per.actif = 1, 'Actif', 'Inactif') AS statut,
  p.libelle AS poste,
  sc.solde_restant AS solde_conge_restant
FROM personnel per
LEFT JOIN candidat c ON per.id_candidat = c.id_candidat
LEFT JOIN poste p ON per.id_poste = p.id_poste
LEFT JOIN solde_conge sc ON sc.id_personnel = per.id_personnel
WHERE per.username IS NOT NULL
ORDER BY per.id_personnel;
