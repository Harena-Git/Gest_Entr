-- Initialization script for MySQL (gestion database)
USE `gestion`;

-- Ensure unique constraints on libelle columns exist (they were created in schema)

-- Insert statut_demande values (ignore duplicates)
INSERT IGNORE INTO statut_demande (libelle) VALUES
('En attente'),
('Approuvée par chef'),
('Approuvée par RH'),
('Rejetée par chef'),
('Rejetée par RH'),
('Annulée');

-- Insert decision_validation values
INSERT IGNORE INTO decision_validation (libelle) VALUES
('Approuvée'),
('Rejetée'),
('En attente'),
('Modifiée');

-- Example data for testing (adjust IDs as needed)
-- Insert a department
INSERT INTO departement (departement) VALUES ('Informatique') ON DUPLICATE KEY UPDATE departement = departement;

-- Insert a poste linked to department id 1 (or the actual generated id)
INSERT IGNORE INTO poste (libelle, salaire, Id_departement)
SELECT 'Dev', 0, d.Id_departement FROM departement d WHERE d.departement = 'Informatique' LIMIT 1;

-- Insert a candidate
INSERT IGNORE INTO candidat (nom, prenom, email, date_candidature)
VALUES ('Doe','John','john.doe@example.com', CURDATE());

-- Insert personnel linked to candidate 1 and poste 1 (you may need to adjust ids)
INSERT IGNORE INTO personnel (date_embauche, actif, Id_candidat, Id_poste)
SELECT CURDATE(), TRUE, c.Id_candidat, p.Id_poste
FROM candidat c, poste p
WHERE c.email = 'john.doe@example.com' AND p.libelle = 'Dev'
LIMIT 1;

-- Insert roles
INSERT IGNORE INTO `role` (libelle) VALUES ('CHEF'), ('RH'), ('PERSONNEL');

-- Insert users (chef, rh, personnel) - adapt passwords (plain text here for testing)
INSERT IGNORE INTO user_ (nom, mot_de_passe, Id_departement, Id_role)
SELECT 'chef1','secret', d.Id_departement, r.Id_role FROM departement d, `role` r WHERE d.departement = 'Informatique' AND r.libelle = 'CHEF' LIMIT 1;

INSERT IGNORE INTO user_ (nom, mot_de_passe, Id_departement, Id_role)
SELECT 'rh1','secret', d.Id_departement, r.Id_role FROM departement d, `role` r WHERE d.departement = 'Informatique' AND r.libelle = 'RH' LIMIT 1;

INSERT IGNORE INTO user_ (nom, mot_de_passe, Id_departement, Id_role)
SELECT 'pers1','secret', d.Id_departement, r.Id_role FROM departement d, `role` r WHERE d.departement = 'Informatique' AND r.libelle = 'PERSONNEL' LIMIT 1;

-- Create a solde_conge entry for the created personnel
INSERT INTO solde_conge (solde_annuel, solde_restant, date_initialisation, Id_personnel)
SELECT 25,25,CURRENT_TIMESTAMP, p.Id_personnel FROM personnel p
LEFT JOIN solde_conge sc ON sc.Id_personnel = p.Id_personnel
WHERE p.Id_personnel IS NOT NULL AND sc.Id_personnel IS NULL
LIMIT 1;

-- Done
SELECT 'INIT_CONGE_mysql executed' AS message;
