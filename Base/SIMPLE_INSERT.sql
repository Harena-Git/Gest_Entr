-- Script simple pour insérer rapidement des données de test
USE gestion_entreprise;

-- Afficher les données existantes
SELECT 'PERSONNELS EXISTANTS:' as status;
SELECT id_personnel, username, actif FROM personnel LIMIT 10;

SELECT 'NOMBRE TOTAL DE PERSONNELS:' as status;
SELECT COUNT(*) as total FROM personnel;

-- Si aucun personnel, insérer un test
INSERT IGNORE INTO candidat (id_candidat, nom, prenom, email, telephone, date_candidature, id_etat_candidat)
VALUES (999, 'TEST', 'User', 'test@test.com', '0000000000', NOW(), 1);

INSERT IGNORE INTO poste (id_poste, libelle)
VALUES (999, 'Poste Test');

INSERT IGNORE INTO personnel (id_personnel, date_embauche, actif, id_candidat, id_poste, username, password)
VALUES (999, NOW(), 1, 999, 999, 'test', '$2a$10$slYQmyNdGzin7olVN3p5..zw7wIi88k0Oe/VsP0GRE.BjZrGGPrY.');

INSERT IGNORE INTO solde_conge (id_solde, solde_annuel, solde_restant, date_initialisation, id_personnel)
VALUES (999, 25, 25, NOW(), 999);

-- Vérifier l'insertion
SELECT 'VÉRIFICATION:' as status;
SELECT p.id_personnel, p.username, c.prenom, c.nom, p.actif FROM personnel p 
LEFT JOIN candidat c ON p.id_candidat = c.id_candidat 
WHERE p.id_personnel = 999;

SELECT 'SOLDE CONGÉ:' as status;
SELECT * FROM solde_conge WHERE id_personnel = 999;
