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
('Comptable Senior', 1000000, 3),
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

INSERT INTO diplome (niveau, Id_filiere) VALUES
('Licence', 1),
('Master', 1),
('Doctorat', 1),

('BTS', 2),
('Licence', 2),
('Master', 2),

('Licence', 3),
('Expert', 3);

INSERT INTO profil (genre, age, annee_experience, Id_lieu, Id_diplome) VALUES
(NULL, 28, 5, 1, 2),
('Homme', 18, 3 , 2, 5),
(NULL, 24, 2 , 3, 4),
('Homme', 20, 0 , 1, 1),
('Femme', 25, 15, 5, 1);

INSERT INTO annonce (date_annonce, responsabilite, date_fin, Id_poste, Id_profil) VALUES
('2025-09-01', 'Développement et maintenance des applications Java', '2025-09-30', 1, 11),
('2025-09-03', 'Gestion des serveurs et réseaux internes', '2025-10-03', 2, 15);

