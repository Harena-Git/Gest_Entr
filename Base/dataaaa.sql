CREATE DATABASE gestion_entreprise;
USE gestion_entreprise;

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

INSERT INTO appreciation (libelle, note) VALUES 
('Excellent', 5),
('Très bon', 4),
('Bon', 3),
('Moyen', 2),
('Insuffisant', 1);

INSERT INTO departement (departement) VALUES 
('Direction'),
('Ressources Humaines'),
('Informatique'),
('Finance'),
('Marketing'),
('Production'),
('Commercial');



INSERT INTO niveau(libelle) VALUES
('Licence'),
('Master'),
('Doctorat'),
('DUT'),
('BTS'),
('Certificat'),
('Formation Continue');

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

INSERT INTO diplome (Id_niveau, Id_filiere) VALUES 
(4, 1), -- Bac+5 Informatique
(3, 2), -- Bac+3 Commerce
(4, 3), -- Bac+5 Finance
(3, 4), -- Bac+3 RH
(4, 5); -- Bac+5 Marketing

INSERT INTO etat_candidat (Id_etat_candidat, libelle) VALUES 
(1, 'Nouvelle candidature'),
(2, 'En attente entretien'),
(3, 'Entretien programmé'),
(4, 'Entretien réalisé'),
(5, 'En attente décision'),
(6, 'Embauche confirmée'),
(7, 'Candidature rejetée'),
(8, 'CV accepte');

INSERT INTO lieu (lieu) VALUES 
('Paris'),
('Lyon'),
('Marseille'),
('Toulouse'),
('Bordeaux'),
('Nantes'),
('Lille'),
('Télétravail');

CREATE TABLE plage_horaire_entretien (
   Id_plage INT AUTO_INCREMENT,
   heure_debut TIME NOT NULL,
   heure_fin TIME NOT NULL,
   duree_entretien_minutes INT DEFAULT 45,
   jours_travail SET('Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi'),
   PRIMARY KEY(Id_plage)
);

CREATE TABLE entretien_qcm (
    id_entretien_qcm INT PRIMARY KEY AUTO_INCREMENT,
    id_entretien INT,
    id_qcm INT,
    id_candidat INT,
    FOREIGN KEY (id_entretien) REFERENCES entretien_1(id_entretien_),
    FOREIGN KEY (id_qcm) REFERENCES qcm(id_qcm),
    FOREIGN KEY (id_candidat) REFERENCES candidat(Id_candidat)
);

INSERT INTO plage_horaire_entretien (heure_debut, heure_fin, duree_entretien_minutes, jours_travail) VALUES 
('08:00:00', '12:00:00', 45, 'Lundi,Mardi,Mercredi,Jeudi,Vendredi'),
('14:00:00', '17:00:00', 45, 'Lundi,Mardi,Mercredi,Jeudi,Vendredi');-- 1. Vérifier si un candidat a réussi le QCM

INSERT INTO poste (libelle, salaire, Id_departement) VALUES 
('Directeur Général', 80000, 1),
('Responsable RH', 50000, 2),
('Développeur Fullstack', 45000, 3),
('Analyste Financier', 42000, 5),
('Chef de Projet Marketing', 48000, 4),
('Ingénieur Production', 46000, 6),
('Commercial', 40000, 7);

INSERT INTO profil (genre, age, annee_experience, Id_lieu, Id_diplome) VALUES 
('les deux', 30, 4, 1, 1),
('Femme', 28, 3, 2, 4),
('Homme', 35, 6, 3, 3);

INSERT INTO qcm (titre, description, Id_poste) VALUES 
('QCM Développeur Java', 'Test de connaissances en Java et technologies associées', 1),
('QCM Développeur Frontend', 'Test de connaissances en HTML, CSS et JavaScript', 3),
('QCM Chef de projet', 'Test de gestion de projet et méthodologies agiles', 2);

INSERT INTO question (libelle, Id_qcm) VALUES 
('Quelle est la différence entre une interface et une classe abstraite en Java?', 1),
('Qu''est-ce que le polymorphisme en Java?', 1),
('Comment gérer les exceptions en Java?', 1),
('Qu''est-ce que le garbage collection en Java?', 1),
('Quelle est la différence entre == et equals() en Java?', 1);

INSERT INTO question (libelle, Id_qcm) VALUES 
('Quelle est la différence entre let, var et const en JavaScript?', 2),
('Qu''est-ce que le CSS Grid?', 2),
('Comment optimiser les performances d''un site web?', 2),
('Qu''est-ce que React?', 2),
('Quelle est la différence entre padding et margin?', 2);

INSERT INTO question_generale (libelle) VALUES 
('Disponible à partir du'),
('Prétentions salariales'),
('Mobilité géographique');

-- ATTENTION: La table choix a des contraintes UNIQUE et NOT NULL sur Id_question et Id_question_generale
-- Ces insertions ne fonctionneront pas avec la structure actuelle de la table
-- Il faut modifier la table ou les données pour résoudre ce problème
-- INSERT INTO choix commenté pour éviter les erreurs

-- Ces insertions sont également commentées en raison des contraintes de la table choix

-- Ces insertions sont également commentées

INSERT INTO role (libelle) VALUES 
('Administrateur'),
('Responsable RH'),
('Recruteur'),
('Manager'),
('Collaborateur');

INSERT INTO user_ (nom, mot_de_passe, Id_departement, Id_role) VALUES 
('admin', 'admin123', 1, 1),
('martin.dupont', 'mdp123', 2, 2),
('sarah.leroy', 'sarah456', 3, 3),
('pierre.martin', 'pierre789', 4, 4),
('lucie.dubois', 'lucie012', 5, 5);

-- Maintenant que profil a été inséré correctement, cette insertion devrait fonctionner
INSERT INTO annonce (date_annonce, responsabilite, date_fin, Id_poste, Id_profil) VALUES 
('2024-01-10', 'Développement applications web, maintenance code, collaboration équipe', '2026-02-10', 3, 1);

-- ATTENTION: Il n'y a pas de candidat avec Id_candidat=8 dans les données
-- Vous devez d'abord insérer le candidat ou changer l'ID
-- INSERT INTO personnel commenté pour éviter l'erreur de clé étrangère

