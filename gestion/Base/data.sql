-- Insertion des rôles
INSERT INTO role (libelle) VALUES 
('Administrateur'),
('Responsable RH'),
('Recruteur'),
('Manager');

-- Insertion des états candidat
INSERT INTO etat_candidat (libelle) VALUES 
('Nouvelle candidature'),
('CV en étude'),
('En attente QCM'),
('QCM en cours'),
('QCM terminé'),
('En attente entretien'),
('Entretien programmé'),
('Entretien réalisé'),
('En attente décision'),
('Embauche confirmée'),
('Candidature rejetée');

-- Insertion des départements
INSERT INTO departement (departement) VALUES 
('Direction'),
('Ressources Humaines'),
('Informatique'),
('Marketing'),
('Finance');

-- Insertion des lieux
INSERT INTO lieu (lieu) VALUES 
('Paris'),
('Lyon'),
('Marseille'),
('Toulouse'),
('Nantes'),
('Télétravail');

-- Insertion des appréciations
INSERT INTO appreciation (libelle, note) VALUES 
('Excellent', 5),
('Très bon', 4),
('Bon', 3),
('Moyen', 2),
('Insuffisant', 1);

-- Insertion des niveaux
INSERT INTO niveau (libelle) VALUES 
('Bac'),
('Bac+2'),
('Bac+3'),
('Bac+5'),
('Doctorat');

-- Insertion des filières
INSERT INTO filiere (libelle) VALUES 
('Informatique'),
('Commerce'),
('Marketing'),
('Finance'),
('Droit');

-- Insertion des utilisateurs RH
INSERT INTO user_ (nom, mot_de_passe, Id_departement, Id_role) VALUES 
('marie.dubois', '$2a$10$r3dACTpVKq6/6QwJkYzQe.FVn7kLmNpQY8zWqR2sT3uVxYzA1bCdE', 2, 2), -- motdepasse123
('pierre.martin', '$2a$10$r3dACTpVKq6/6QwJkYzQe.FVn7kLmNpQY8zWqR2sT3uVxYzA1bCdE', 2, 2),
('sophie.leroy', '$2a$10$r3dACTpVKq6/6QwJkYzQe.FVn7kLmNpQY8zWqR2sT3uVxYzA1bCdE', 2, 2);

-- Insertion des postes
INSERT INTO poste (libelle, salaire, Id_departement) VALUES 
('Développeur Java', 45000, 3),
('Développeur Frontend', 42000, 3),
('Chef de projet', 50000, 3),
('Data Analyst', 43000, 3),
('Responsable Marketing', 48000, 4);

-- Insertion des diplômes
INSERT INTO diplome (Id_niveau, Id_filiere) VALUES 
(3, 1), -- Bac+3 Informatique
(4, 1), -- Bac+5 Informatique
(3, 3), -- Bac+3 Marketing
(4, 3), -- Bac+5 Marketing
(4, 4); -- Bac+5 Finance

-- Insertion des candidats
INSERT INTO candidat (nom, prenom, email, telephone, adresse, date_candidature, annee_experience, Id_lieu, Id_etat_candidat) VALUES 
('Dupont', 'Jean', 'jean.dupont@email.com', '0123456789', '15 Rue de la Paix, Paris', '2024-01-15', 3, 1, 4),
('Martin', 'Sophie', 'sophie.martin@email.com', '0234567891', '22 Avenue des Champs, Lyon', '2024-01-16', 2, 2, 4),
('Bernard', 'Luc', 'luc.bernard@email.com', '0345678912', '5 Rue du Commerce, Marseille', '2024-01-17', 5, 3, 4),
('Petit', 'Marie', 'marie.petit@email.com', '0456789123', '8 Boulevard Voltaire, Toulouse', '2024-01-18', 1, 4, 4),
('Moreau', 'Thomas', 'thomas.moreau@email.com', '0567891234', '12 Place de la République, Nantes', '2024-01-19', 4, 5, 4);

-- Insertion des diplômes candidats
INSERT INTO diplome_candidat (etablissement, annee_obtention, Id_diplome, Id_candidat) VALUES 
('Université Paris-Saclay', 2020, 2, 1),
('Université Lyon 1', 2021, 2, 2),
('Aix-Marseille Université', 2018, 2, 3),
('Université Toulouse III', 2022, 2, 4),
('Université de Nantes', 2019, 2, 5);




-- Insertion des QCM
INSERT INTO qcm (titre, description, Id_poste, duree_minutes) VALUES 
('QCM Développeur Java', 'Test de connaissances en Java et technologies associées', 1, 60),
('QCM Développeur Frontend', 'Test de connaissances en HTML, CSS et JavaScript', 2, 45),
('QCM Chef de projet', 'Test de gestion de projet et méthodologies agiles', 3, 75);

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
('Une interface ne peut avoir que des méthodes abstraites', TRUE, NULL, 6),
('Une classe abstraite peut avoir des méthodes implémentées', TRUE, NULL, 6),
('Une interface peut avoir des variables', FALSE, NULL, 6),
('Capacité d''un objet à prendre plusieurs formes', TRUE, NULL, 7),
('Utilisation de l''héritage', TRUE, NULL, 7),
('Utilisation des interfaces', FALSE, NULL, 7),
('Avec try-catch-finally', TRUE, NULL, 8),
('Avec throws', TRUE, NULL, 8),
('Avec return', FALSE, NULL, 8),
('Gestion automatique de la mémoire', TRUE, NULL, 9),
('Suppression des objets non utilisés', TRUE, NULL, 9),
('Compilation du code', FALSE, NULL, 9),
('== compare les références, equals() compare le contenu', TRUE, NULL, 10),
('== compare les valeurs primitives', TRUE, NULL, 10),
('equals() est toujours true', FALSE, NULL, 10);

-- Insertion des questions pour le QCM Frontend
INSERT INTO question (libelle, Id_qcm, ordre) VALUES 
('Quelle est la différence entre let, var et const en JavaScript?', 2, 1),
('Qu''est-ce que le CSS Grid?', 2, 2),
('Comment optimiser les performances d''un site web?', 2, 3),
('Qu''est-ce que React?', 2, 4),
('Quelle est la différence entre padding et margin?', 2, 5);

-- Insertion des choix pour les questions Frontend
INSERT INTO choix (libelle, est_correct, Id_question_generale, Id_question) VALUES 
('let et const ont une portée de bloc, var a une portée de fonction', TRUE, NULL, 11),
('const ne peut pas être réaffecté', TRUE, NULL, 11),
('var est obsolète', FALSE, NULL, 11),
('Système de mise en page bidimensionnel', TRUE, NULL, 12),
('Alternative à Flexbox', TRUE, NULL, 12),
('Ancienne technologie', FALSE, NULL, 12),
('Compression des images', TRUE, NULL, 13),
('Mise en cache', TRUE, NULL, 13),
('Augmentation de la qualité des images', FALSE, NULL, 13),
('Bibliothèque JavaScript pour les interfaces utilisateur', TRUE, NULL, 14),
('Utilise le virtual DOM', TRUE, NULL, 14),
('Langage de programmation', FALSE, NULL, 14),
('Padding: espace intérieur, Margin: espace extérieur', TRUE, NULL, 15),
('Padding: affecte la taille totale de l''élément', TRUE, NULL, 15),
('Margin: espace à l''intérieur de la bordure', FALSE, NULL, 15);

-- Insertion des réponses pour le candidat 1 (QCM Java)
INSERT INTO reponse (Id_candidat, Id_choix) VALUES 
(1, 10), (1, 13), (1, 16), (1, 34), (1, 37), -- Réponses correctes
(1, 11), (1, 15); -- Réponses aux questions générales

-- Insertion du résultat QCM pour le candidat 1 (réussi avec 80%)
INSERT INTO resultat_qcm (bonnes_reponses, total_questions, pourcentage, Id_candidat, Id_qcm, est_reussi, date_reponse) 
VALUES (4, 5, 80.00, 1, 1, TRUE, NOW() - INTERVAL 1 DAY);

-- Insertion des réponses pour le candidat 2 (QCM Java)
INSERT INTO reponse (Id_candidat, Id_choix) VALUES 
(2, 10), (2, 14), (2, 17), (2, 35), (2, 38), -- Réponses correctes
(2, 12), (2, 15); -- Réponses aux questions générales

-- Insertion du résultat QCM pour le candidat 2 (réussi avec 60%)
INSERT INTO resultat_qcm (bonnes_reponses, total_questions, pourcentage, Id_candidat, Id_qcm, est_reussi, date_reponse) 
VALUES (3, 5, 60.00, 2, 1, TRUE, NOW() - INTERVAL 2 DAY);

-- Insertion des réponses pour le candidat 3 (QCM Java)
INSERT INTO reponse (Id_candidat, Id_choix) VALUES 
(3, 11), (3, 14), (3, 17), (3, 35), (3, 38), -- Réponses (2 correctes)
(3, 12), (3, 15); -- Réponses aux questions générales

-- Insertion du résultat QCM pour le candidat 3 (échoué avec 40%)
INSERT INTO resultat_qcm (bonnes_reponses, total_questions, pourcentage, Id_candidat, Id_qcm, est_reussi, date_reponse) 
VALUES (2, 5, 40.00, 3, 1, FALSE, NOW() - INTERVAL 3 DAY);

-- Mise à jour des états des candidats
UPDATE candidat SET Id_etat_candidat = 6 WHERE Id_candidat = 1; -- En attente entretien
UPDATE candidat SET Id_etat_candidat = 6 WHERE Id_candidat = 2; -- En attente entretien
UPDATE candidat SET Id_etat_candidat = 11 WHERE Id_candidat = 3; -- Candidature rejetée


