USE Gestion_entreprise;

-- Insertion des rôles
INSERT INTO role (libelle) VALUES 
('Administrateur'),
('Responsable RH'),
('Recruteur'),
('Manager'),
('Collaborateur');

-- Insertion des états candidats
INSERT INTO etat_candidat (libelle) VALUES 
('Nouvelle candidature'),
('CV examiné'),
('QCM envoyé'),
('QCM complété'),
('Entretien 1 planifié'),
('Entretien 1 réalisé'),
('Entretien 2 planifié'),
('Entretien 2 réalisé'),
('Contrat d''essai'),
('Embauché'),
('Refusé');

-- Insertion des filières
INSERT INTO filiere (libelle) VALUES 
('Informatique'),
('Commerce'),
('Finance'),
('Ressources Humaines'),
('Marketing'),
('Ingénierie'),
('Design');

-- Insertion des départements
INSERT INTO departement (departement) VALUES 
('Direction'),
('Ressources Humaines'),
('Informatique'),
('Finance'),
('Marketing'),
('Production'),
('Commercial');

-- Insertion des appréciations
INSERT INTO appreciation (libelle, note) VALUES 
('Excellent', 5),
('Très bon', 4),
('Bon', 3),
('Moyen', 2),
('Insuffisant', 1);

-- Insertion des lieux
INSERT INTO lieu (lieu) VALUES 
('Paris'),
('Lyon'),
('Marseille'),
('Toulouse'),
('Bordeaux'),
('Nantes'),
('Lille'),
('Télétravail');

-- Insertion des niveaux
INSERT INTO niveau (libelle) VALUES 
('Bac'),
('Bac+2'),
('Bac+3'),
('Bac+5'),
('Doctorat');

-- Insertion des questions générales
INSERT INTO question_generale (libelle) VALUES 
('Question de compétence technique'),
('Question de culture générale'),
('Question de comportement'),
('Question de motivation'),
('Question de situation professionnelle');

-- Insertion des utilisateurs
INSERT INTO user_ (nom, mot_de_passe, Id_departement, Id_role) VALUES 
('admin', 'admin123', 1, 1),
('martin.dupont', 'mdp123', 2, 2),
('sarah.leroy', 'sarah456', 3, 3),
('pierre.martin', 'pierre789', 4, 4),
('lucie.dubois', 'lucie012', 5, 5);

-- Insertion des candidats
INSERT INTO candidat (nom, prenom, email, photo, telephone, adresse, date_candidature, annee_experience, Id_lieu, Id_etat_candidat) VALUES 
('Dupont', 'Jean', 'jean.dupont@email.com', NULL, '0612345678', '15 Rue de Paris, 75001 Paris', '2024-01-15', 5, 1, 1),
('Martin', 'Sophie', 'sophie.martin@email.com', NULL, '0623456789', '20 Avenue Lyon, 69002 Lyon', '2024-01-20', 3, 2, 3),
('Bernard', 'Luc', 'luc.bernard@email.com', NULL, '0634567890', '30 Boulevard Marseille, 13001 Marseille', '2024-02-01', 7, 3, 5),
('Petit', 'Marie', 'marie.petit@email.com', NULL, '0645678901', '40 Rue Toulouse, 31000 Toulouse', '2024-02-10', 2, 4, 10),
('Durand', 'Thomas', 'thomas.durand@email.com', NULL, '0656789012', '50 Cours Bordeaux, 33000 Bordeaux', '2024-02-15', 4, 5, 11);

-- Insertion des postes
INSERT INTO poste (libelle, salaire, Id_departement) VALUES 
('Directeur Général', 80000, 1),
('Responsable RH', 50000, 2),
('Développeur Fullstack', 45000, 3),
('Analyste Financier', 42000, 4),
('Chef de Projet Marketing', 48000, 5),
('Ingénieur Production', 46000, 6),
('Commercial', 40000, 7);

-- Insertion du personnel
INSERT INTO personnel (date_embauche, actif, Id_candidat, Id_poste) VALUES 
('2024-02-01', TRUE, 4, 3);

-- Insertion historique état
INSERT INTO historique_etat (date_changement, Id_candidat, Id_etat_candidat) VALUES 
('2024-01-15', 1, 1),
('2024-01-16', 1, 2),
('2024-01-20', 2, 1),
('2024-01-21', 2, 3);

-- Insertion des diplômes
INSERT INTO diplome (Id_niveau, Id_filiere) VALUES 
(4, 1), -- Bac+5 Informatique
(3, 2), -- Bac+3 Commerce
(4, 3), -- Bac+5 Finance
(3, 4), -- Bac+3 RH
(4, 5); -- Bac+5 Marketing

-- Insertion QCM
INSERT INTO qcm (titre, description, Id_poste) VALUES 
('Test Technique Développeur', 'Évaluation des compétences techniques en développement', 3),
('Test Culture Marketing', 'Évaluation de la culture marketing', 5),
('Test RH', 'Évaluation des connaissances RH', 2);

-- Insertion questions
INSERT INTO question (libelle, Id_qcm) VALUES 
('Quelle est la différence entre Java et JavaScript?', 1),
('Qu''est-ce qu''une API REST?', 1),
('Quelle est la dernière tendance en marketing digital?', 2);

-- Insertion choix
INSERT INTO choix (libelle, est_correct, Id_question_generale, Id_question) VALUES 
('Même langage', FALSE, 1, 1),
('Langages différents', TRUE, 1, 1),
('Interface de programmation', TRUE, 1, 2),
('Type de base de données', FALSE, 1, 2),
('L''IA générative', TRUE, 1, 3),
('Le fax marketing', FALSE, 1, 3);

-- Insertion réponses
INSERT INTO reponse (Id_candidat, Id_choix) VALUES 
(2, 2),
(2, 3),
(2, 5);

-- Insertion résultats QCM
INSERT INTO resultat_qcm (bonnes_reponses, total_questions, pourcentage, Id_candidat, Id_qcm) VALUES 
(3, 3, 100.00, 2, 1);

-- Insertion entretiens
INSERT INTO entretien_1 (date_entretien, Id_user) VALUES 
('2024-02-05', 3),
('2024-02-06', 2);

-- Insertion évaluations entretien 1
INSERT INTO evaluation_entretien_1 (presence, Id_appreciation, Id_entretien_) VALUES 
(TRUE, 4, 1),
(TRUE, 3, 2);

-- Insertion entretiens 2
INSERT INTO entretien_2 (date_entretien, Id_user, Id_entretien_) VALUES 
('2024-02-12', 2, 1);

-- Insertion évaluations entretien 2
INSERT INTO evaluation_entretien_2 (presence, Id_appreciation, Id_entretien_2) VALUES 
(TRUE, 5, 1);

-- Insertion contrat essai
INSERT INTO contrat_essai (date_debut, date_fin, Id_candidat) VALUES 
('2024-02-01', '2024-05-01', 4);

-- Insertion diplômes candidats
INSERT INTO diplome_candidat (etablissement, annee_obtention, Id_diplome, Id_candidat) VALUES 
('École d''Ingénieurs Paris', 2020, 1, 1),
('Université Lyon 3', 2021, 2, 2),
('HEC Paris', 2019, 3, 3);

-- Insertion profils
INSERT INTO profil (genre, age, annee_experience, Id_lieu, Id_diplome) VALUES 
('Mixte', 30, '3-5 ans', 1, 1),
('Féminin', 28, '2-4 ans', 2, 4),
('Masculin', 35, '5-7 ans', 3, 3);

-- Insertion annonces
INSERT INTO annonce (date_annonce, responsabilite, date_fin, Id_poste, Id_profil) VALUES 
('2024-01-10', 'Développement applications web, maintenance code, collaboration équipe', '2024-02-10', 3, 1),
('2024-01-15', 'Gestion recrutement, formation personnel, gestion carrières', '2024-02-15', 2, 2),
('2024-01-20', 'Analyse financière, reporting, gestion budget', '2024-02-20', 4, 3);