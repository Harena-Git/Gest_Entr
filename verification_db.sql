-- Script de vérification des données après validation de congés
-- Exécutez ce script dans MySQL Workbench ou en ligne de commande

USE gestion_entreprise;

-- 1. VÉRIFIER LES DÉCISIONS CRÉÉES PAR LE DATA INITIALIZER
SELECT '=== DECISION_VALIDATION ===' as Titre;
SELECT id_decision_validation, libelle FROM decision_validation ORDER BY id_decision_validation;

-- 2. VÉRIFIER LES STATUTS CRÉÉS
SELECT '=== STATUT_DEMANDE ===' as Titre;
SELECT id_statut_demande, libelle FROM statut_demande ORDER BY id_statut_demande;

-- 3. VÉRIFIER LES UTILISATEURS CRÉÉS AUTOMATIQUEMENT (après validation)
SELECT '=== UTILISATEURS (avec Personnel) ===' as Titre;
SELECT 
    u.id_user,
    u.nom,
    u.username,
    u.personnel_id,
    p.username as personnel_username
FROM user_ u
LEFT JOIN personnel p ON u.personnel_id = p.id_personnel
ORDER BY u.id_user DESC
LIMIT 10;

-- 4. VÉRIFIER LES DEMANDES DE CONGÉ
SELECT '=== DEMANDES DE CONGÉ ===' as Titre;
SELECT 
    dc.id_demande_conge,
    dc.date_debut,
    dc.date_fin,
    dc.nombre_jours,
    dc.id_personnel,
    sd.libelle as statut
FROM demande_conge dc
JOIN statut_demande sd ON dc.id_statut_demande = sd.id_statut_demande
ORDER BY dc.id_demande_conge DESC
LIMIT 10;

-- 5. VÉRIFIER LES VALIDATIONS DU CHEF
SELECT '=== VALIDATION_CONGE_CHEF ===' as Titre;
SELECT 
    vcc.id_validation_conge_chef,
    vcc.id_user,
    vcc.id_demande_conge,
    u.nom as chef_nom,
    u.username as chef_username,
    dv.libelle as decision,
    vcc.date_validation
FROM validation_conge_chef vcc
JOIN user_ u ON vcc.id_user = u.id_user
JOIN decision_validation dv ON vcc.id_decision_validation = dv.id_decision_validation
ORDER BY vcc.date_validation DESC
LIMIT 10;

-- 6. VÉRIFIER LES VALIDATIONS DU RH
SELECT '=== VALIDATION_CONGE_RH ===' as Titre;
SELECT 
    vcr.id_validation_conge_rh,
    vcr.id_user,
    vcr.id_validation_conge_chef,
    u.nom as rh_nom,
    u.username as rh_username,
    dv.libelle as decision,
    vcr.date_validation
FROM validation_conge_rh vcr
JOIN user_ u ON vcr.id_user = u.id_user
JOIN decision_validation dv ON vcr.id_decision_validation = dv.id_decision_validation
ORDER BY vcr.date_validation DESC
LIMIT 10;

-- 7. VÉRIFIER LES SOLDES DE CONGÉ (vérifier réduction après approbation RH)
SELECT '=== SOLDE_CONGE ===' as Titre;
SELECT 
    sc.id_solde_conge,
    sc.id_personnel,
    p.username,
    sc.solde_annuel,
    sc.solde_restant,
    sc.date_renouvellement
FROM solde_conge sc
JOIN personnel p ON sc.id_personnel = p.id_personnel
ORDER BY sc.id_personnel
LIMIT 10;

-- 8. VÉRIFIER LE FLUX COMPLET D'UNE DEMANDE (depuis demande jusqu'à RH)
SELECT '=== FLUX COMPLET D''UNE DEMANDE ===' as Titre;
SELECT 
    dc.id_demande_conge,
    p.username as demandeur,
    dc.date_debut,
    dc.nombre_jours,
    sd.libelle as statut_actuel,
    vcc.id_validation_conge_chef as chef_validation_id,
    u_chef.username as chef_validation_par,
    CASE WHEN vcr.id_validation_conge_rh IS NOT NULL THEN 'OUI' ELSE 'NON' END as valide_par_rh
FROM demande_conge dc
JOIN personnel p ON dc.id_personnel = p.id_personnel
JOIN statut_demande sd ON dc.id_statut_demande = sd.id_statut_demande
LEFT JOIN validation_conge_chef vcc ON dc.id_demande_conge = vcc.id_demande_conge
LEFT JOIN user_ u_chef ON vcc.id_user = u_chef.id_user
LEFT JOIN validation_conge_rh vcr ON vcc.id_validation_conge_chef = vcr.id_validation_conge_chef
ORDER BY dc.id_demande_conge DESC
LIMIT 10;

-- 9. RÉSUMÉ : Nombre de validations par étape
SELECT '=== RÉSUMÉ DES VALIDATIONS ===' as Titre;
SELECT 
    'Demandes totales' as Description,
    COUNT(*) as Nombre
FROM demande_conge
UNION ALL
SELECT 
    'Validées par Chef',
    COUNT(DISTINCT id_validation_conge_chef)
FROM validation_conge_chef
UNION ALL
SELECT 
    'Validées par RH',
    COUNT(DISTINCT id_validation_conge_rh)
FROM validation_conge_rh
UNION ALL
SELECT 
    'Utilisateurs (Personnel attaché)',
    COUNT(DISTINCT personnel_id)
FROM user_
WHERE personnel_id IS NOT NULL;
