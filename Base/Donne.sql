USE Gestion_entreprise;

-- Supprimer les données existantes pour recommencer
DELETE FROM reponse;
DELETE FROM resultat_qcm;
DELETE FROM choix;
DELETE FROM question;
DELETE FROM qcm;
DELETE FROM evaluation_entretien_2;
DELETE FROM entretien_2;
DELETE FROM evaluation_entretien_1;
DELETE FROM entretien_1;
DELETE FROM diplome_candidat;
DELETE FROM contrat_essai;
DELETE FROM historique_etat;
DELETE FROM personnel;
DELETE FROM candidat;
DELETE FROM user_;
DELETE FROM annonce;
DELETE FROM profil;
DELETE FROM diplome;
DELETE FROM appreciation;
DELETE FROM niveau;
DELETE FROM question_generale;
DELETE FROM lieu;
DELETE FROM poste;
DELETE FROM departement;
DELETE FROM filiere;
DELETE FROM etat_candidat;
DELETE FROM role;

INSERT INTO filiere(libelle) VALUES
('Informatique'),
('Management'),
('Droit'),
('Finance'),
('Marketing'),
('Ressources Humaines'),
('Génie Civil'),
('Biologie'),
('Chimie'),
('Physique');

INSERT INTO niveau(libelle) VALUES
('Licence'),
('Master'),
('Doctorat'),
('DUT'),
('BTS'),
('Certificat'),
('Formation Continue');


-- Réinitialiser les auto-incréments
ALTER TABLE role AUTO_INCREMENT = 1;
ALTER TABLE etat_candidat AUTO_INCREMENT = 1;
ALTER TABLE filiere AUTO_INCREMENT = 1;
ALTER TABLE departement AUTO_INCREMENT = 1;
ALTER TABLE appreciation AUTO_INCREMENT = 1;
ALTER TABLE lieu AUTO_INCREMENT = 1;
ALTER TABLE niveau AUTO_INCREMENT = 1;
ALTER TABLE question_generale AUTO_INCREMENT = 1;
ALTER TABLE user_ AUTO_INCREMENT = 1;
ALTER TABLE candidat AUTO_INCREMENT = 1;
ALTER TABLE poste AUTO_INCREMENT = 1;
ALTER TABLE personnel AUTO_INCREMENT = 1;
ALTER TABLE historique_etat AUTO_INCREMENT = 1;
ALTER TABLE diplome AUTO_INCREMENT = 1;
ALTER TABLE qcm AUTO_INCREMENT = 1;
ALTER TABLE question_generale AUTO_INCREMENT = 1;
ALTER TABLE choix AUTO_INCREMENT = 1;
ALTER TABLE reponse AUTO_INCREMENT = 1;
ALTER TABLE resultat_qcm AUTO_INCREMENT = 1;
ALTER TABLE entretien_1 AUTO_INCREMENT = 1;
ALTER TABLE evaluation_entretien_1 AUTO_INCREMENT = 1;
ALTER TABLE entretien_2 AUTO_INCREMENT = 1;
ALTER TABLE evaluation_entretien_2 AUTO_INCREMENT = 1;
ALTER TABLE contrat_essai AUTO_INCREMENT = 1;
ALTER TABLE diplome_candidat AUTO_INCREMENT = 1;
ALTER TABLE profil AUTO_INCREMENT = 1;
ALTER TABLE annonce AUTO_INCREMENT = 1;

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

-- Insertion choix (CORRIGÉ - suppression des contraintes UNIQUE problématiques)
INSERT INTO choix (libelle, est_correct, Id_question_generale, Id_question) VALUES 
('Même langage', FALSE, 1, 1),
('Langages différents', TRUE, 1, 1),
('Interface de programmation', TRUE, 2, 2),
('Type de base de données', FALSE, 2, 2),
('L''IA générative', TRUE, 3, 3),
('Le fax marketing', FALSE, 3, 3);

-- Insertion réponses
INSERT INTO reponse (Id_candidat, Id_choix) VALUES 
(2, 1),
(2, 3),
(2, 5);

-- Insertion résultats QCM
INSERT INTO resultat_qcm (bonnes_reponses, total_questions, pourcentage, Id_candidat, Id_qcm) VALUES 
(2, 3, 66.67, 2, 1);

-- Insertion entretiens
INSERT INTO entretien_1 (date_entretien, Id_user) VALUES 
('2024-02-05', 3),
('2024-02-06', 2);

INSERT INTO entretien_1 (date_entretien, heure_entretien, id_candidat, id_user)
VALUES 
('2025-09-25', '10:30:00', 1, 2),
('2025-09-26', '14:00:00', 2, 3),
('2025-09-27', '09:15:00', 3, 1);


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
('2024-01-20', 'Analyse financière, reporting, gestion budget', '2024-02-20', 4, 3),
('2025-09-22', 'Analyse Économique, reporting, gestion budget', '2025-10-23', 3, 2);

-- Vérification des données
SELECT 'Données insérées avec succès!' as Status;

INSERT INTO etat_candidat (Id_etat_candidat, libelle) VALUES 
(1, 'Nouvelle candidature'),
(2, 'En attente entretien'),
(3, 'Entretien programmé'),
(4, 'Entretien réalisé'),
(5, 'En attente décision'),
(6, 'Embauche confirmée'),
(7, 'Candidature rejetée');




-- Insertion des QCM
INSERT INTO qcm (titre, description, Id_poste, duree_minutes) VALUES 
('QCM Développeur Java', 'Test de connaissances en Java et technologies associées', 1, 60),
('QCM Développeur Frontend', 'Test de connaissances en HTML, CSS et JavaScript', 2, 45),
('QCM Chef de projet', 'Test de gestion de projet et méthodologies agiles', 3, 75);

INSERT INTO qcm (titre, description, Id_poste, duree_minutes) VALUES 
('QCM Développeur Java', 'Test de connaissances en Java et technologies associées', 4, 60),
('QCM Développeur Frontend', 'Test de connaissances en HTML, CSS et JavaScript', 5, 45),
('QCM Chef de projet', 'Test de gestion de projet et méthodologies agiles', 6, 75),
('QCM Chef de projet', 'Test de gestion de projet et méthodologies agiles', 7, 75);

-- Insertion des questions générales (pour tous les QCM)
INSERT INTO question_generale (libelle, ordre) VALUES 
('Disponible à partir du', 1),
('Prétentions salariales', 2),
('Mobilité géographique', 3);

-- Insertion des choix pour les questions générales
INSERT INTO choix (libelle, est_correct, Id_question_generale, Id_question) VALUES 
('Immédiate', TRUE, 1, NULL),
('Sous 15 jours', TRUE, 1, NULL),
('Sous 1 mois', TRUE, 1, NULL),
('30-35k', TRUE, 2, NULL),
('35-40k', TRUE, 2, NULL),
('40-45k', TRUE, 2, NULL),
('45k+', TRUE, 2, NULL),
('Oui', TRUE, 3, NULL),
('Non', TRUE, 3, NULL);

-- Insertion des questions pour le QCM Java
INSERT INTO question (libelle, Id_qcm, ordre) VALUES 
('Quelle est la différence entre une interface et une classe abstraite en Java?', 1, 1),
('Qu''est-ce que le polymorphisme en Java?', 1, 2),
('Comment gérer les exceptions en Java?', 1, 3),
('Qu''est-ce que le garbage collection en Java?', 1, 4),
('Quelle est la différence entre == et equals() en Java?', 1, 5);

-- Insertion des choix pour les questions Java
INSERT INTO choix (libelle, est_correct, Id_question_generale, Id_question) VALUES 
('Une interface ne peut avoir que des méthodes abstraites', TRUE, NULL, 1),
('Une classe abstraite peut avoir des méthodes implémentées', TRUE, NULL, 1),
('Une interface peut avoir des variables', FALSE, NULL, 1),
('Capacité d''un objet à prendre plusieurs formes', TRUE, NULL, 2),
('Utilisation de l''héritage', TRUE, NULL, 2),
('Utilisation des interfaces', FALSE, NULL, 2),
('Avec try-catch-finally', TRUE, NULL, 3),
('Avec throws', TRUE, NULL, 3),
('Avec return', FALSE, NULL, 3),
('Gestion automatique de la mémoire', TRUE, NULL, 4),
('Suppression des objets non utilisés', TRUE, NULL, 4),
('Compilation du code', FALSE, NULL, 4),
('== compare les références, equals() compare le contenu', TRUE, NULL, 5),
('== compare les valeurs primitives', TRUE, NULL, 5),
('equals() est toujours true', FALSE, NULL, 5);

-- Insertion des questions pour le QCM Frontend
INSERT INTO question (libelle, Id_qcm, ordre) VALUES 
('Quelle est la différence entre let, var et const en JavaScript?', 2, 1),
('Qu''est-ce que le CSS Grid?', 2, 2),
('Comment optimiser les performances d''un site web?', 2, 3),
('Qu''est-ce que React?', 2, 4),
('Quelle est la différence entre padding et margin?', 2, 5);

-- Insertion des choix pour les questions Frontend
INSERT INTO choix (libelle, est_correct, Id_question_generale, Id_question) VALUES 
('let et const ont une portée de bloc, var a une portée de fonction', TRUE, NULL, 6),
('const ne peut pas être réaffecté', TRUE, NULL, 6),
('var est obsolète', FALSE, NULL, 6),
('Système de mise en page bidimensionnel', TRUE, NULL, 7),
('Alternative à Flexbox', TRUE, NULL, 7),
('Ancienne technologie', FALSE, NULL, 7),
('Compression des images', TRUE, NULL, 8),
('Mise en cache', TRUE, NULL, 8),
('Augmentation de la qualité des images', FALSE, NULL, 8),
('Bibliothèque JavaScript pour les interfaces utilisateur', TRUE, NULL, 9),
('Utilise le virtual DOM', TRUE, NULL, 9),
('Langage de programmation', FALSE, NULL, 9),
('Padding: espace intérieur, Margin: espace extérieur', TRUE, NULL, 10),
('Padding: affecte la taille totale de l''élément', TRUE, NULL, 10),
('Margin: espace à l''intérieur de la bordure', FALSE, NULL, 10);

