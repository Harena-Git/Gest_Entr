-- ========================================
-- DONNÉES DE TEST POUR HARENA - GESTION DU PERSONNEL
-- ========================================
-- Ce fichier contient des données de test pour les fonctionnalités
-- de gestion du personnel décrites dans My_Task.txt
-- ========================================

USE gestion_entreprise;

-- Insertion des types de contrat
INSERT INTO type_contrat (libelle) VALUES 
('CDI'),
('CDD'),
('Stage'),
('Freelance'),
('Contrat Pro');

-- Insertion des types de document
INSERT INTO type_document (libelle) VALUES 
('CIN'),
('Diplôme'),
('Certificat'),
('Attestation'),
('Lettre de recommandation'),
('CV'),
('Justificatif de domicile'),
('RIB'),
('Photo d''identité');

-- Insertion de candidats pour test
INSERT INTO candidat (nom, prenom, email, telephone, adresse, date_candidature, annee_experience, id_lieu, id_etat_candidat, genre, date_naissance, competences_personnelles) VALUES 
('Rakoto', 'Ando', 'ando.rakoto@email.com', '034 12 345 67', 'Antananarivo, Madagascar', '2024-01-05', 3, 1, 6, 'Homme', '1995-03-15', 'Java, Spring Boot, MySQL'),
('Razafy', 'Maria', 'maria.razafy@email.com', '034 23 456 78', 'Antananarivo, Madagascar', '2024-01-10', 5, 1, 6, 'Femme', '1990-07-22', 'Comptabilité, Excel, SAP'),
('Andrianina', 'Harena', 'harena.andrianina@email.com', '034 34 567 89', 'Antananarivo, Madagascar', '2023-11-20', 2, 1, 6, 'Homme', '1997-05-10', 'JavaScript, React, Node.js'),
('Rasoamanana', 'Faly', 'faly.rasoamanana@email.com', '034 45 678 90', 'Antananarivo, Madagascar', '2023-12-15', 7, 1, 6, 'Femme', '1988-09-30', 'Marketing digital, SEO, Analytics'),
('Randriamihaja', 'Toky', 'toky.randriamihaja@email.com', '034 56 789 01', 'Antananarivo, Madagascar', '2024-02-01', 4, 1, 6, 'Homme', '1992-11-18', 'Gestion de projet, Agile, Scrum');

-- Insertion du personnel (employés confirmés)
INSERT INTO personnel (date_embauche, actif, id_candidat, id_poste) VALUES 
('2024-02-05', TRUE, 1, 3), -- Ando Rakoto - Développeur Fullstack
('2024-02-15', TRUE, 2, 4), -- Maria Razafy - Analyste Financier
('2024-01-10', TRUE, 3, 3), -- Harena Andrianina - Développeur Fullstack
('2024-01-20', TRUE, 4, 5), -- Faly Rasoamanana - Chef de Projet Marketing
('2024-03-01', TRUE, 5, 5); -- Toky Randriamihaja - Chef de Projet Marketing

-- Insertion des contrats de travail
-- Contrat CDI pour Ando Rakoto
INSERT INTO contrat_travail (id_personnel, id_type_contrat, date_debut, date_fin, duree_mois, date_fin_periode_essai, renouvele, date_alerte, statut, remarques) VALUES 
(1, 1, '2024-02-05', NULL, NULL, '2024-05-05', FALSE, NULL, 'Actif', 'Période d''essai de 3 mois réussie'),

-- Contrat CDD pour Maria Razafy (expire bientôt)
(2, 2, '2024-02-15', '2025-12-31', 6, '2024-04-15', FALSE, '2025-12-16', 'Actif', 'CDD de 6 mois, possibilité de renouvellement'),

-- Contrat CDI pour Harena Andrianina
(3, 1, '2024-01-10', NULL, NULL, '2024-04-10', FALSE, NULL, 'Actif', 'Embauche en CDI après stage'),

-- Contrat CDD pour Faly Rasoamanana (renouvelé)
(4, 2, '2024-01-20', '2025-06-20', 12, '2024-03-20', TRUE, '2025-06-05', 'Actif', 'Premier CDD renouvelé'),

-- Contrat Stage pour Toky (converti en CDI)
(5, 3, '2024-03-01', '2024-08-31', 6, NULL, FALSE, NULL, 'Terminé', 'Stage de 6 mois converti en CDI'),
(5, 1, '2024-09-01', NULL, NULL, '2024-12-01', FALSE, NULL, 'Actif', 'CDI après stage réussi');

-- Insertion de l'historique des postes (carrière des employés)
-- Carrière de Harena Andrianina (promotions)
INSERT INTO historique_poste (id_personnel, id_poste, date_debut, date_fin, type_mouvement, motif, salaire) VALUES 
(3, 3, '2024-01-10', '2024-06-30', 'Affectation initiale', 'Première embauche en tant que Développeur Junior', 35000),
(3, 3, '2024-07-01', NULL, 'Promotion', 'Promotion Développeur Senior suite à excellentes performances', 45000),

-- Carrière de Maria Razafy
(2, 4, '2024-02-15', NULL, 'Affectation initiale', 'Embauche en tant qu''Analyste Financier', 42000),

-- Carrière de Faly Rasoamanana (mutation)
(4, 7, '2024-01-20', '2024-05-31', 'Affectation initiale', 'Embauche en tant que Commercial', 40000),
(4, 5, '2024-06-01', NULL, 'Mutation', 'Mutation au service Marketing - Nouvelles compétences', 48000),

-- Carrière de Ando Rakoto
(1, 3, '2024-02-05', NULL, 'Affectation initiale', 'Développeur Backend confirmé', 45000),

-- Carrière de Toky Randriamihaja
(5, 3, '2024-03-01', '2024-08-31', 'Affectation initiale', 'Stage développement', 25000),
(5, 5, '2024-09-01', NULL, 'Promotion', 'Promotion Chef de Projet après stage brillant', 48000);

-- Insertion des documents RH
-- Documents pour Ando Rakoto (Personnel ID 1)
INSERT INTO document_personnel (id_personnel, id_type_document, nom_fichier, chemin_fichier, date_upload, numero_document, date_delivrance, date_expiration, remarques) VALUES 
(1, 1, 'CIN_Ando_Rakoto.pdf', '/employes/001/RAKOTO/CIN.pdf', '2024-02-01', '101234567890', '2020-01-15', '2030-01-15', 'CIN valide'),
(1, 2, 'Diplome_Master_Informatique.pdf', '/employes/001/RAKOTO/diplome.pdf', '2024-02-01', 'M-2022-INF-123', '2022-07-20', NULL, 'Master en Informatique - Université d''Antananarivo'),
(1, 3, 'Certificat_Java_Oracle.pdf', '/employes/001/RAKOTO/cert_java.pdf', '2024-02-01', 'OCA-2023-4567', '2023-03-10', NULL, 'Oracle Certified Associate Java Programmer'),
(1, 9, 'Photo_Ando.jpg', '/employes/001/RAKOTO/photo.jpg', '2024-02-01', NULL, NULL, NULL, 'Photo d''identité professionnelle'),

-- Documents pour Maria Razafy (Personnel ID 2)
(2, 1, 'CIN_Maria_Razafy.pdf', '/employes/002/RAZAFY/CIN.pdf', '2024-02-10', '101234567891', '2019-05-20', '2029-05-20', 'CIN valide'),
(2, 2, 'Diplome_Master_Finance.pdf', '/employes/002/RAZAFY/diplome.pdf', '2024-02-10', 'M-2018-FIN-456', '2018-06-15', NULL, 'Master en Finance et Comptabilité'),
(2, 3, 'Certificat_Expert_Comptable.pdf', '/employes/002/RAZAFY/cert_comptable.pdf', '2024-02-10', 'EC-2020-789', '2020-09-25', NULL, 'Certificat Expert Comptable'),
(2, 8, 'RIB_Maria.pdf', '/employes/002/RAZAFY/rib.pdf', '2024-02-10', NULL, NULL, NULL, 'RIB pour virement salaire'),

-- Documents pour Harena Andrianina (Personnel ID 3)
(3, 1, 'CIN_Harena.pdf', '/employes/003/ANDRIANINA/CIN.pdf', '2024-01-05', '101234567892', '2021-03-10', '2031-03-10', 'CIN valide'),
(3, 2, 'Diplome_Licence_Info.pdf', '/employes/003/ANDRIANINA/diplome.pdf', '2024-01-05', 'L-2021-INF-789', '2021-07-30', NULL, 'Licence en Informatique'),
(3, 5, 'Lettre_Recommandation_Stage.pdf', '/employes/003/ANDRIANINA/recommandation.pdf', '2024-01-05', NULL, '2023-12-15', NULL, 'Lettre de recommandation de son ancien stage'),
(3, 6, 'CV_Harena_2024.pdf', '/employes/003/ANDRIANINA/cv.pdf', '2024-01-05', NULL, NULL, NULL, 'CV actualisé'),

-- Documents pour Faly Rasoamanana (Personnel ID 4)
(4, 1, 'CIN_Faly.pdf', '/employes/004/RASOAMANANA/CIN.pdf', '2024-01-15', '101234567893', '2020-07-12', '2030-07-12', 'CIN valide'),
(4, 2, 'Diplome_Master_Marketing.pdf', '/employes/004/RASOAMANANA/diplome.pdf', '2024-01-15', 'M-2016-MKT-234', '2016-06-20', NULL, 'Master en Marketing Digital'),
(4, 3, 'Certificat_Google_Analytics.pdf', '/employes/004/RASOAMANANA/cert_google.pdf', '2024-01-15', 'GA-2022-5678', '2022-11-05', NULL, 'Certification Google Analytics'),
(4, 7, 'Justificatif_Domicile.pdf', '/employes/004/RASOAMANANA/domicile.pdf', '2024-01-15', NULL, '2024-01-10', NULL, 'Facture JIRAMA'),

-- Documents pour Toky Randriamihaja (Personnel ID 5)
(5, 1, 'CIN_Toky.pdf', '/employes/005/RANDRIAMIHAJA/CIN.pdf', '2024-02-25', '101234567894', '2021-08-20', '2031-08-20', 'CIN valide'),
(5, 2, 'Diplome_Master_Gestion_Projet.pdf', '/employes/005/RANDRIAMIHAJA/diplome.pdf', '2024-02-25', 'M-2019-GP-567', '2019-07-10', NULL, 'Master en Gestion de Projet'),
(5, 3, 'Certificat_Scrum_Master.pdf', '/employes/005/RANDRIAMIHAJA/cert_scrum.pdf', '2024-02-25', 'CSM-2021-9012', '2021-04-15', NULL, 'Certified Scrum Master'),
(5, 3, 'Certificat_PMP.pdf', '/employes/005/RANDRIAMIHAJA/cert_pmp.pdf', '2024-02-25', 'PMP-2023-3456', '2023-09-20', NULL, 'Project Management Professional');

-- Insertion de contrats d'essai (table existante)
INSERT INTO contrat_essai (date_debut, date_fin, id_candidat) VALUES 
('2024-02-05', '2024-05-05', 1), -- Ando Rakoto - période d'essai terminée avec succès
('2024-02-15', '2024-04-15', 2), -- Maria Razafy - période d'essai terminée avec succès
('2024-01-10', '2024-04-10', 3), -- Harena Andrianina - période d'essai terminée avec succès
('2024-09-01', '2024-12-01', 5); -- Toky Randriamihaja - période d'essai CDI en cours

-- ========================================
-- RÉSUMÉ DES DONNÉES INSÉRÉES :
-- ========================================
-- ✅ 5 Types de contrat (CDI, CDD, Stage, Freelance, Contrat Pro)
-- ✅ 9 Types de document (CIN, Diplôme, Certificat, etc.)
-- ✅ 5 Candidats devenus employés
-- ✅ 5 Personnels actifs
-- ✅ 6 Contrats de travail (incluant renouvellements et conversions)
-- ✅ 9 Mouvements dans l'historique des postes (promotions, mutations)
-- ✅ 19 Documents RH stockés
-- ✅ 4 Contrats d'essai

-- ========================================
-- SCÉNARIOS DE TEST COUVERTS :
-- ========================================
-- 1. ✅ Fiche employé complète : Toutes les données personnelles et professionnelles
-- 2. ✅ Suivi du contrat de travail : CDD, CDI, Stage, renouvellements, alertes
-- 3. ✅ Historique postes/promotions : Évolution de carrière d'Harena (Junior → Senior)
-- 4. ✅ Gestion documents RH : CIN, diplômes, certificats, attestations

-- Pour tester les alertes de contrats expirants :
-- SELECT * FROM contrat_travail WHERE date_alerte <= CURDATE() AND statut = 'Actif';

-- Pour voir la carrière complète d'un employé (ex: Harena) :
-- SELECT * FROM historique_poste WHERE id_personnel = 3 ORDER BY date_debut DESC;

-- Pour lister tous les documents d'un employé (ex: Ando) :
-- SELECT * FROM document_personnel WHERE id_personnel = 1;
