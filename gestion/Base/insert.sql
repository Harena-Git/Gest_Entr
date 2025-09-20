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
INSERT INTO poste (libelle, salaire, Id_departement) VALUES
('Dveloppeur Java', 1200000, 1),
('Comptable', 900000, 2),
('Chef de projet', 1800000, 1),
('Responsable RH', 1500000, 4),
('Analyste financier', 1700000, 5),
('Logisticien', 1000000, 6);

INSERT INTO filiere (libelle) VALUES
('Informatique'),
('Gestion'),
('Ressources Humaines'),
('Marketing'),
('Finance'),
('Logistique'),
('Droit'),
('Communication');