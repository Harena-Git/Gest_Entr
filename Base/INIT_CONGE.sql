-- ============================================================================
-- SCRIPT D'INITIALISATION DES DONNÉES DE GESTION DES CONGÉS
-- ============================================================================
-- Exécuter après la création des tables

-- 1. INSÉRER LES STATUTS DE DEMANDE DE CONGÉ
-- ============================================================================
INSERT INTO statut_demande (libelle) VALUES 
('En attente'),
('Approuvée par chef'),
('Approuvée par RH'),
('Rejetée par chef'),
('Rejetée par RH'),
('Annulée')
ON CONFLICT DO NOTHING;

-- 2. INSÉRER LES DÉCISIONS DE VALIDATION
-- ============================================================================
INSERT INTO decision_validation (libelle) VALUES 
('Approuvée'),
('Rejetée'),
('Approuvée avec modifications'),
('En attente'),
('À reviser'),
('Conditionnel'),
('Reportée'),
('Annulée'),
('Automatiquement approuvée'),
('Nécessite approbation supérieure')
ON CONFLICT DO NOTHING;

-- 3. EXEMPLE DE CRÉATION D'UN SOLDE DE CONGÉ (à adapter)
-- ============================================================================
-- Ce script suppose que vous avez déjà des enregistrements dans personnel
-- Décommentez et adaptez selon vos besoins :

/*
INSERT INTO solde_conge (solde_annuel, solde_restant, date_initialisation, Id_personnel)
SELECT 25, 25, CURRENT_DATE, Id_personnel
FROM personnel p
WHERE NOT EXISTS (
    SELECT 1 FROM solde_conge sc WHERE sc.Id_personnel = p.Id_personnel
);
*/

-- ============================================================================
-- FIN DU SCRIPT D'INITIALISATION
-- ============================================================================
