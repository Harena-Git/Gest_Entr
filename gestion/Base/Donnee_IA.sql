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
('CV en étude'),
('Entretien 1 planifié'),
('Entretien 1 réalisé'),
('Entretien 2 planifié'),
('Entretien 2 réalisé'),
('Contrat d''essai'),
('Embauché'),
('Refusé'),
('Archivé');

-- Insertion des filières
INSERT INTO filiere (libelle) VALUES 
('Informatique'),
('Commerce'),
('Marketing'),
('Ressources Humaines'),
('Finance'),
('Production'),
('Logistique'),
('Juridique');

-- Insertion des QCM
INSERT INTO qcm (titre, description) VALUES 
('Test techniques Développeur', 'Évaluation des compétences techniques en développement'),
('Test de logique', 'Évaluation des capacités de raisonnement logique'),
('Test de personnalité', 'Évaluation des traits de personnalité'),
('Test anglais technique', 'Évaluation du niveau d''anglais technique'),
('Test management', 'Évaluation des compétences managériales');

-- Insertion des départements
INSERT INTO departement (departement) VALUES 
('Direction'),
('Ressources Humaines'),
('Informatique'),
('Commercial'),
('Marketing'),
('Finance'),
('Production'),
('Logistique');

-- Insertion des lieux
INSERT INTO lieu (lieu) VALUES 
('Paris'),
('Lyon'),
('Marseille'),
('Toulouse'),
('Nantes'),
('Bordeaux'),
('Lille'),
('Télétravail');

-- Insertion des appréciations
INSERT INTO appreciation (libelle, note) VALUES 
('Excellent', 5),
('Très bon', 4),
('Bon', 3),
('Moyen', 2),
('Insuffisant', 1),
('Non présenté', 0);

-- Insertion des utilisateurs
INSERT INTO user_ (nom, mot_de_passe, Id_departement, Id_role) VALUES 
('admin', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 1, 1), -- password: password
('marie.dupont', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2, 2),
('pierre.martin', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 3, 3),
('sophie.leroy', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 4, 4),
('jean.dubois', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 5, 5);

-- Insertion des postes
INSERT INTO poste (libelle, salaire, Id_departement) VALUES 
('Directeur Général', 80000, 1),
('DRH', 65000, 2),
('Développeur Senior', 50000, 3),
('Commercial', 45000, 4),
('Chef de Projet', 55000, 3),
('Analyste Financier', 48000, 6),
('Responsable Production', 52000, 7),
('Assistant Marketing', 35000, 5);

-- Insertion des candidats
INSERT INTO candidat (nom, prenom, email, photo, telephone, adresse, date_candidature, annee_experience, Id_lieu, Id_etat_candidat) VALUES 
('Martin', 'Thomas', 'thomas.martin@email.com', NULL, '0612345678', '15 Rue de Paris, 75001 Paris', '2024-01-15', 5, 1, 8),
('Bernard', 'Julie', 'julie.bernard@email.com', NULL, '0623456789', '22 Avenue Victor Hugo, 69002 Lyon', '2024-02-20', 3, 2, 4),
('Dubois', 'Michel', 'michel.dubois@email.com', NULL, '0634567890', '8 Rue de la République, 13001 Marseille', '2024-03-10', 7, 3, 6),
('Petit', 'Sophie', 'sophie.petit@email.com', NULL, '0645678901', '45 Cours Balguerie, 33000 Bordeaux', '2024-04-05', 2, 6, 3),
('Leroy', 'David', 'david.leroy@email.com', NULL, '0656789012', '12 Place du Commerce, 44000 Nantes', '2024-05-12', 4, 5, 1),
('Moreau', 'Caroline', 'caroline.moreau@email.com', NULL, '0667890123', '30 Rue Nationale, 59000 Lille', '2024-06-18', 6, 7, 9),
('Simon', 'Nicolas', 'nicolas.simon@email.com', NULL, '0678901234', '18 Allées Jean Jaurès, 31000 Toulouse', '2024-07-22', 1, 4, 7);

-- Insertion du personnel
INSERT INTO personnel (date_embauche, actif, Id_candidat, Id_poste) VALUES 
('2024-02-01', TRUE, 1, 3),
('2024-03-15', TRUE, 2, 8);

-- Insertion historique des états
INSERT INTO historique_etat (date_changement, Id_candidat, Id_etat_candidat) VALUES 
('2024-01-15 09:30:00', 1, 1),
('2024-01-16 14:15:00', 1, 2),
('2024-01-20 10:00:00', 1, 3),
('2024-01-25 11:30:00', 1, 4),
('2024-01-28 16:45:00', 1, 5),
('2024-02-01 09:00:00', 1, 8);

-- Insertion des diplômes
INSERT INTO diplome (niveau, Id_filiere) VALUES 
('Bac+5', 1),
('Bac+3', 1),
('Bac+5', 4),
('Bac+2', 2),
('Bac+4', 3),
('Bac+5', 6),
('Bac+3', 5);

-- Insertion des questions
INSERT INTO question (libelle, Id_qcm) VALUES 
('Quelle est la différence entre Java et JavaScript?', 1),
('Qu''est-ce qu''une closure en JavaScript?', 1),
('Comment optimiser les performances d''une base de données?', 1),
('Quelle est la prochaine valeur dans la série: 2, 4, 8, 16...?', 2),
('Si tous les hommes sont mortels et que Socrate est un homme, alors...', 2);

-- Insertion des choix
INSERT INTO choix (libelle, est_correct, Id_question) VALUES 
('Java est compilé, JavaScript est interprété', TRUE, 1),
('JavaScript est un langage backend', FALSE, 1),
('Une fonction avec accès à son scope parent', TRUE, 2),
('Une boucle infinie', FALSE, 2),
('Indexation des tables', TRUE, 3),
('Augmenter la RAM', FALSE, 3),
('32', TRUE, 4),
('24', FALSE, 4),
('Socrate est immortel', FALSE, 5),
('Socrate est mortel', TRUE, 5);

-- Insertion des entretiens
INSERT INTO entretien_1 (date_entretien, Id_user) VALUES 
('2024-01-25', 2),
('2024-03-20', 3),
('2024-06-25', 2),
('2024-08-15', 3);

-- Insertion des évaluations entretien 1
INSERT INTO evaluation_entretien_1 (presence, Id_appreciation, Id_entretien_) VALUES 
(TRUE, 4, 1),
(TRUE, 5, 2),
(FALSE, 6, 3),
(TRUE, 3, 4);

-- Insertion des entretiens 2
INSERT INTO entretien_2 (date_entretien, Id_user, Id_entretien_) VALUES 
('2024-01-28', 1, 1),
('2024-03-25', 2, 2);

-- Insertion des évaluations entretien 2
INSERT INTO evaluation_entretien_2 (presence, Id_appreciation, Id_entretien_2) VALUES 
(TRUE, 5, 1),
(TRUE, 4, 2);

-- Insertion des contrats d'essai
INSERT INTO contrat_essai (date_debut, date_fin, Id_candidat) VALUES 
('2024-02-01', '2024-05-01', 1),
('2024-06-01', '2024-09-01', 7);

-- Insertion des diplômes candidats
INSERT INTO diplome_candidat (etablissement, annee_obtention, Id_diplome, Id_candidat) VALUES 
('École Polytechnique', 2019, 1, 1),
('Université Lyon 2', 2021, 3, 2),
('HEC Paris', 2018, 6, 3),
('IUT Bordeaux', 2022, 4, 4);

-- Insertion des profils
INSERT INTO profil (genre, age, annee_experience, Id_lieu, Id_diplome) VALUES 
('Homme', 28, '3-5 ans', 1, 1),
('Femme', 25, '1-3 ans', 2, 3),
('Homme', 32, '5-10 ans', 3, 6),
('Femme', 23, '0-1 an', 6, 4);

-- Insertion des annonces
INSERT INTO annonce (date_annonce, responsabilite, date_fin, Id_poste, Id_profil) VALUES 
('2024-01-10', 'Développement applications web, maintenance code, collaboration équipe agile', '2024-02-10', 3, 1),
('2024-02-15', 'Prospection clients, négociation contrats, suivi portefeuille clients', '2024-03-15', 4, 2),
('2024-03-01', 'Gestion projets informatiques, coordination équipes, respect délais et budget', '2024-04-01', 5, 3),
('2024-04-10', 'Support marketing, organisation événements, gestion réseaux sociaux', '2024-05-10', 8, 4);

-- Insertion des profils QCM
INSERT INTO profil_qcm (Id_profil, Id_qcm) VALUES 
(1, 1),
(1, 2),
(2, 3),
(3, 1),
(3, 4),
(4, 5);

-- Insertion des réponses
INSERT INTO reponse (Id_profil, Id_question, Id_choix) VALUES 
(1, 1, 1),
(1, 2, 3),
(1, 4, 7),
(2, 5, 10);

-- Insertion des résultats QCM
INSERT INTO resultat_qcm (bonnes_reponses, total_questions, pourcentage, Id_qcm, Id_profil) VALUES 
(3, 3, 100.00, 1, 1),
(2, 2, 100.00, 2, 1),
(1, 1, 100.00, 3, 2),
(2, 3, 66.67, 1, 3);