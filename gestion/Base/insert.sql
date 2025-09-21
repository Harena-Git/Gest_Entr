--table role
insert  into role (libelle) values
('Admin'),
('RH'),
('Manager');

--table user_
insert into user_ (nom, mot_de_passe, Id_departement, Id_role) values
('admin', 'admin', 1, 1); -- mot_de_passe = 'admin'

--table departement
insert into departement (departement) values
('Informatique'),
('Gestion'),
('Marketing'),
('Ressources Humaines'),
('Finance'),
('Logistique');

--table lieu
insert into lieu (lieu) values
('Antananarivo'),
('Antsiranana'),
('Fianarantsoa'),
('Mahajanga'),
('Toamasina'),
('Toliara');

--table niveau
insert into niveau (libelle) values
('Debutant'),
('Intermediaire'),
('Expert'),
('Avancé');

--table poste
INSERT INTO poste (libelle, salaire, Id_departement) VALUES ('Responsable marketing', 1600000, 3);
('Dveloppeur Java', 1200000, 1),
('Comptable', 900000, 2),
('Chef de projet', 1800000, 1),
('Responsable RH', 1500000, 4),
('Analyste financier', 1700000, 5),
('Logisticien', 1000000, 6),
('Responsable marketing', 1600000, 3);

--table filiere
-- Insertion des données manquantes si nécessaire
INSERT INTO filiere (Id_filiere, libelle) VALUES
(1, 'Informatique'),
(2, 'Gestion'),
(3, 'Ressources Humaines'),
(4, 'Marketing'),
(5, 'Finance'),
(6, 'Logistique'),
(7, 'Droit'),
(8, 'Communication');

INSERT INTO diplome (Id_niveau, Id_filiere) VALUES
(2, 1), -- Intermédiaire en Informatique
(3, 1), -- Expert en Informatique
(4, 1), -- Avancé en Informatique
(2, 2), -- Intermédiaire en Gestion
(3, 2), -- Expert en Gestion
(4, 2), -- Avancé en Gestion
(2, 3), -- Intermédiaire en Ressources Humaines
(3, 3), -- Expert en Ressources Humaines
(2, 4), -- Intermédiaire en Marketing
(3, 4), -- Expert en Marketing
(2, 5), -- Intermédiaire en Finance
(3, 5), -- Expert en Finance
(2, 6), -- Intermédiaire en Logistique
(3, 6), -- Expert en Logistique
(2, 7), -- Intermédiaire en Droit
(3, 7), -- Expert en Droit
(2, 8), -- Intermédiaire en Communication
(3, 8); -- Expert en Communication`;
