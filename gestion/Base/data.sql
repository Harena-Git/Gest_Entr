INSERT INTO departement (departement) VALUES
('Informatique'),
('Ressources Humaines'),
('Comptabilité'),
('Marketing'),
('Logistique'),
('Production'),
('Commercial');

INSERT INTO poste (libelle, salaire, Id_departement) VALUES
('Développeur Java', 1200000, 1),
('Administrateur Système', 1500000, 1),
('Responsable RH', 1300000, 2),
('Comptable Senior', 1000000, 3);
('Assistant Marketing', 800000, 4),
('Responsable Logistique', 1100000, 5),
('Chef d’Atelier', 1400000, 6),
('Commercial Terrain', 900000, 7);

INSERT INTO lieu (lieu) VALUES
('Antananarivo'),
('Fianarantsoa'),
('Toamasina'),
('Mahajanga'),
('Toliara'),
('Antsiranana');

INSERT INTO niveau (libelle) VALUES
('BTS'),
('Licence'),
('Master'),
('Doctorat'),
('Expert');

INSERT INTO filiere (libelle) VALUES
('Informatique'),
('Gestion'),
('Comptabilité et Finance'),
('Marketing'),
('Logistique et Transport'),
('Droit'),
('Médecine'),
('Agronomie'),
('Génie Civil');

-- Informatique
INSERT INTO diplome (Id_niveau, Id_filiere) VALUES
(2, 1), -- Licence Informatique
(3, 1), -- Master Informatique
(4, 1), -- Doctorat Informatique

-- Gestion
(1, 2), -- BTS Gestion
(2, 2), -- Licence Gestion
(3, 2), -- Master Gestion

-- Comptabilité et Finance
(2, 3), -- Licence Comptabilité
(5, 3); -- Expert Comptabilité


INSERT INTO profil (genre, age, annee_experience, Id_lieu, Id_diplome) VALUES
(NULL, 28, 5, 1, 2),
('Homme', 18, 3 , 2, 5),
(NULL, 24, 2 , 3, 4),
('Homme', 20, 0 , 1, 1),
('Femme', 25, 15, 5, 1);

INSERT INTO annonce (date_annonce, responsabilite, date_fin, Id_poste, Id_profil) VALUES
('2025-09-01', 'Développement et maintenance des applications Java', '2025-09-30', 1, 1),
('2025-09-03', 'Gestion des serveurs et réseaux internes', '2025-10-03', 2, 2);

