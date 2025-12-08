-- Script pour insérer les décisions de validation manquantes
-- Exécuter avec: mysql -u root -p gestion_entreprise < insert_decisions.sql

USE gestion_entreprise;

-- Insérer les décisions de validation s'ils n'existent pas
INSERT IGNORE INTO decision_validation (libelle) VALUES 
('Approuvée'),
('Rejetée'),
('Approuvée avec modifications'),
('En attente'),
('À reviser'),
('Conditionnel'),
('Reportée'),
('Annulée'),
('Automatiquement approuvée'),
('Nécessite approbation supérieure');

-- Insérer les statuts de demande s'ils n'existent pas
INSERT IGNORE INTO statut_demande (libelle) VALUES 
('En attente'),
('Approuvée par chef'),
('Approuvée par RH'),
('Rejetée par chef'),
('Rejetée par RH'),
('Annulée');

-- Vérifier les insertions
SELECT 'Décisions de validation:' AS '';
SELECT * FROM decision_validation;
SELECT 'Statuts de demande:' AS '';
SELECT * FROM statut_demande;
