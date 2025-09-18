-- Insertion des rôles
INSERT INTO role (libelle) VALUES 
('Administrateur'),
('Recruteur'),
('Manager'),
('RH');

-- Insertion des états candidats
INSERT INTO etat_candidat (libelle) VALUES 
('Nouvelle candidature'),
('En attente d''entretien'),
('Entretien 1 programmé'),
('Entretien 1 réalisé'),
('Entretien 2 programmé'),
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
('Production');

-- Insertion des départements
INSERT INTO departement (departement) VALUES 
('IT'),
('Ventes'),
('Comptabilité'),
('RH'),
('Marketing'),
('Production');

-- Insertion des lieux
INSERT INTO lieu (lieu) VALUES 
('Paris'),
('Lyon'),
('Marseille'),
('Toulouse'),
('Bordeaux'),
('Nantes');

-- Insertion des postes
INSERT INTO poste (libelle, salaire, Id_departement) VALUES 
('Développeur Web', 40000, 1),
('Commercial', 35000, 2),
('Comptable', 38000, 3),
('Recruteur', 37000, 4),
('Chef de projet', 50000, 1),
('Responsable marketing', 45000, 5);

-- Insertion des utilisateurs
INSERT INTO user_ (nom, mot_de_passe, Id_departement, Id_role) VALUES 
('admin', 'admin123', 1, 1),
('marie.dupont', 'mdp123', 4, 2),
('pierre.martin', 'mdp123', 1, 3),
('sophie.durand', 'mdp123', 4, 4);

-- Insertion des candidats
INSERT INTO candidat (nom, prenom, email, telephone, adresse, date_candidature, annee_experience, Id_lieu, Id_etat_candidat) VALUES 
('Martin', 'Jean', 'jean.martin@email.com', '0123456789', '15 Rue de Paris, 75001 Paris', '2024-01-15', 3, 1, 1),
('Dubois', 'Marie', 'marie.dubois@email.com', '0234567891', '20 Avenue Lyon, 69002 Lyon', '2024-01-20', 5, 2, 2),
('Bernard', 'Pierre', 'pierre.bernard@email.com', '0345678912', '30 Boulevard Marseille, 13003 Marseille', '2024-02-01', 2, 3, 3),
('Moreau', 'Sophie', 'sophie.moreau@email.com', '0456789123', '40 Rue Toulouse, 31000 Toulouse', '2024-02-10', 4, 4, 4);

-- Insertion des diplômes
INSERT INTO diplome (niveau, Id_filiere) VALUES 
('Bac+2', 1),
('Bac+3', 1),
('Bac+5', 1),
('Bac+2', 2),
('Bac+5', 2),
('Bac+3', 3);

-- Insertion des diplômes candidats
INSERT INTO diplome_candidat (etablissement, annee_obtention, Id_diplome, Id_candidat) VALUES 
('Université Paris-Saclay', 2020, 3, 1),
('EM Lyon', 2019, 5, 2),
('IUT Lyon 1', 2021, 1, 3),
('Toulouse Business School', 2018, 5, 4);

-- Insertion des QCM
INSERT INTO qcm (titre, description) VALUES 
('Test technique Développeur', 'QCM évaluant les compétences techniques en développement'),
('Test commercial', 'QCM évaluant les aptitudes commerciales'),
('Test culture d''entreprise', 'QCM évaluant l''adéquation avec la culture d''entreprise');

-- Insertion des questions
INSERT INTO question (libelle, Id_qcm) VALUES 
('Qu''est-ce qu''une classe en POO ?', 1),
('Quel langage utilise le framework Django ?', 1),
('Qu''est-ce que le SEO ?', 2),
('Comment abordez-vous une prospection ?', 2);

-- Insertion des choix de réponses
INSERT INTO choix (libelle, est_correct, Id_question) VALUES 
('Une fonction', FALSE, 1),
('Un blueprint pour créer des objets', TRUE, 1),
('Une variable', FALSE, 1),
('Python', TRUE, 2),
('Java', FALSE, 2),
('Search Engine Optimization', TRUE, 3),
('Social Engagement Optimization', FALSE, 3),
('Par téléphone', FALSE, 4),
('En personnalisant l''approche', TRUE, 4);

-- Insertion des appréciations
INSERT INTO appreciation (libelle, note) VALUES 
('Excellent', 5),
('Très bon', 4),
('Bon', 3),
('Moyen', 2),
('Insuffisant', 1);

-- Insertion des profils
INSERT INTO profil (genre, age, annee_experience, Id_lieu, Id_diplome) VALUES 
('Homme', 28, '3-5 ans', 1, 3),
('Femme', 32, '5-7 ans', 2, 5),
('Homme', 25, '1-3 ans', 3, 1),
('Femme', 30, '3-5 ans', 4, 5);

-- Insertion des annonces
INSERT INTO annonce (date_annonce, responsabilite, date_fin, Id_poste, Id_profil) VALUES 
('2024-01-10', 'Développement front-end et back-end, maintenance des applications', '2024-02-15', 1, 1),
('2024-01-12', 'Prospection clientèle, vente de solutions, suivi des clients', '2024-02-20', 2, 2);

-- Insertion des entretiens
INSERT INTO entretien_1 (date_entretien, Id_user) VALUES 
('2024-02-05', 2),
('2024-02-08', 2);

-- Insertion des évaluations entretien 1
INSERT INTO evaluation_entretien_1 (presence, Id_appreciation, Id_entretien_) VALUES 
(TRUE, 4, 1),
(TRUE, 5, 2);

-- Insertion des entretiens 2
INSERT INTO entretien_2 (date_entretien, Id_user, Id_entretien_) VALUES 
('2024-02-12', 3, 1),
('2024-02-15', 3, 2);

-- Insertion des évaluations entretien 2
INSERT INTO evaluation_entretien_2 (presence, Id_appreciation, Id_entretien_2) VALUES 
(TRUE, 4, 1),
(TRUE, 5, 2);

-- Insertion des contrats d'essai
INSERT INTO contrat_essai (date_debut, date_fin, Id_candidat) VALUES 
('2024-03-01', '2024-05-31', 1),
('2024-03-15', '2024-06-14', 2);

-- Insertion des historiques d'état
INSERT INTO historique_etat (date_changement, Id_candidat, Id_etat_candidat) VALUES 
('2024-01-15', 1, 1),
('2024-01-20', 2, 1),
('2024-02-01', 3, 3),
('2024-02-10', 4, 4);

-- Mise à jour de l'état des candidats après entretiens
UPDATE candidat SET Id_etat_candidat = 7 WHERE Id_candidat = 1;
UPDATE candidat SET Id_etat_candidat = 7 WHERE Id_candidat = 2;

-- Insertion du personnel (embauche)
INSERT INTO personnel (date_embauche, actif, Id_candidat, Id_poste) VALUES 
('2024-03-01', TRUE, 1, 1),
('2024-03-15', TRUE, 2, 2);