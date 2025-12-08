-- Script d'initialisation des données pour decision_validation
-- À exécuter une seule fois après la création des tables

USE gestion_entreprise;

-- Vérifier et insérer les décisions de validation
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

-- Vérifier et insérer les statuts de demande de congé
INSERT IGNORE INTO statut_demande (libelle) VALUES 
('En attente'),
('Approuvée par chef'),
('Approuvée par RH'),
('Rejetée par chef'),
('Rejetée par RH'),
('Annulée');

-- Afficher les résultats
COMMIT;
SELECT 'Décisions insérées:' AS '';
SELECT * FROM decision_validation ORDER BY id_decision_validation;
