-- Fiche de paie pour le personnel 2
INSERT INTO fiche_paie (
    annee, mois, salaire_base, salaire_brut, salaire_imposable, salaire_net,
    total_heure_sup, total_prime, total_retenus, id_personnel
) VALUES
(
    2025, 11, 1200.00, 1350.00, 1250.00, 1100.00,
    50.00, 100.00, 150.00, 5
);

INSERT INTO fiche_paie (
    annee, mois, salaire_base, salaire_brut, salaire_imposable, salaire_net,
    total_heure_sup, total_prime, total_retenus, id_personnel
) VALUES
(
    2025, 10, 1200.00, 1350.00, 1250.00, 1100.00,
    50.00, 100.00, 150.00, 5
);

-- Fiche de paie pour le personnel 3
INSERT INTO fiche_paie (
    annee, mois, salaire_base, salaire_brut, salaire_imposable, salaire_net,
    total_heure_sup, total_prime, total_retenus, id_personnel
) VALUES
(
    2025, 11, 1500.00, 1700.00, 1600.00, 1400.00,
    80.00, 120.00, 200.00, 6
);

INSERT INTO complement_salaire (annee, mois, indemnite, rappels, autres, id_personnel, avance)
VALUES 
(2025, 11, 50000, 10000, 5000, 5, 700000),   -- Personnel 2 pour novembre 2025
(2025, 11, 40000, 0, 3000, 6, 600000),       -- Personnel 3 pour novembre 2025
(2025, 10, 30000, 5000, 2000, 5, 80000),    -- Personnel 2 pour octobre 2025
(2025, 10, 35000, 2000, 1000, 6, 9000000);    -- Personnel 3 pour octobre 2025

INSERT INTO type_retenu (libelle, taux, type_enum) VALUES
('CNaPS', 1.0, 'EMPLOYE'),
('CNaPS', 13.0, 'PATRONIAL'),
('OSTIE', 1.0, 'EMPLOYE'),
('OSTIE', 5.0, 'PATRONIAL'),
('ABSENCE', 100.0, 'ABSENCE'),
('Autres', 100.0, 'AUTRE');

INSERT INTO retenu (annee, mois, id_personnel, id_plafond, id_type_retenu, montant_defaut) VALUES
(2025, 10, 5, 1, 1, 0), -- CNAPS employé pour le personnel 2
(2025, 10, 5, 1, 2, 0), -- CNAPS patronal pour le personnel 2
(2025, 10, 6, 1, 1, 0), -- CNAPS employé pour le personnel 3
(2025, 10, 6, 1, 2, 0), -- CNAPS patronal pour le personnel 3
(2025, 10, 5, 1, 3, 0), -- OSTIE employé pour le personnel 2
(2025, 10, 5, 1, 4, 0), -- OSTIE patronal pour le personnel 2
(2025, 10, 6, 1, 3, 0), -- OSTIE employé pour le personnel 3
(2025, 10, 6, 1, 4, 0), -- OSTIE patronal pour le personnel 3
(2025, 11, 5, 1, 6, 10500), -- Autres retenus pour le personnel 2
(2025, 11, 6, 1, 6, 5000); -- Autres retenus pour le personnel 3

MariaDB [gestion_entreprise]> select * from retenu;
+-----------+-------+------+----------------+--------------+------------+----------------+
| id_retenu | annee | mois | montant_defaut | id_personnel | id_plafond | id_type_retenu |
+-----------+-------+------+----------------+--------------+------------+----------------+
|         9 |  2025 |   10 |              0 |            2 |          1 |              1 |
|        10 |  2025 |   10 |              0 |            2 |          1 |              2 |
|        11 |  2025 |   10 |              0 |            3 |          1 |              1 |
|        12 |  2025 |   10 |              0 |            3 |          1 |              2 |
|        13 |  2025 |   10 |              0 |            2 |          1 |              3 |
|        14 |  2025 |   10 |              0 |            2 |          1 |              4 |
|        15 |  2025 |   10 |              0 |            3 |          1 |              3 |
|        16 |  2025 |   10 |              0 |            3 |          1 |              4 |
|        19 |  2025 |   10 |           6050 |            2 |          1 |              5 |
|        20 |  2025 |   10 |          20040 |            3 |          1 |              5 |
|        39 |  2025 |   11 |              0 |            2 |          1 |              1 |
|        40 |  2025 |   11 |              0 |            2 |          1 |              2 |
|        41 |  2025 |   11 |              0 |            3 |          1 |              1 |
|        42 |  2025 |   11 |              0 |            3 |          1 |              2 |
|        43 |  2025 |   11 |              0 |            2 |          1 |              3 |
|        44 |  2025 |   11 |              0 |            2 |          1 |              4 |
|        45 |  2025 |   11 |              0 |            3 |          1 |              3 |
|        46 |  2025 |   11 |              0 |            3 |          1 |              4 |
|        47 |  2025 |   11 |          10500 |            2 |          1 |              5 |
|        48 |  2025 |   11 |           5000 |            3 |          1 |              5 |
|        49 |  2025 |   12 |              0 |            2 |          2 |              1 |
|        50 |  2025 |   12 |              0 |            2 |          2 |              2 |
|        51 |  2025 |   12 |              0 |            3 |          2 |              1 |
|        52 |  2025 |   12 |              0 |            3 |          2 |              2 |
|        53 |  2025 |   12 |              0 |            2 |          2 |              3 |
|        54 |  2025 |   12 |              0 |            2 |          2 |              4 |
|        55 |  2025 |   12 |              0 |            3 |          2 |              3 |
|        56 |  2025 |   12 |              0 |            3 |          2 |              4 |
|        57 |  2025 |   12 |          10500 |            2 |          2 |              5 |
|        58 |  2025 |   12 |           5000 |            3 |          2 |              5 |
+-----------+-------+------+----------------+--------------+------------+----------------+

INSERT INTO retenu (annee, mois, id_personnel, id_plafond, id_type_retenu, montant_defaut) VALUES
(2025, 12, 5, 1, 1, 0), -- CNAPS employé pour le personnel 2
(2025, 12, 5, 1, 2, 0), -- CNAPS patronal pour le personnel 2
(2025, 12, 6, 1, 1, 0), -- CNAPS employé pour le personnel 3
(2025, 12, 6, 1, 2, 0), -- CNAPS patronal pour le personnel 3
(2025, 12, 5, 1, 3, 0), -- OSTIE employé pour le personnel 2
(2025, 12, 5, 1, 4, 0), -- OSTIE patronal pour le personnel 2
(2025, 12, 6, 1, 3, 0), -- OSTIE employé pour le personnel 3
(2025, 12, 6, 1, 4, 0), -- OSTIE patronal pour le personnel 3
(2025, 12, 5, 1, 5, 10500), -- Autres retenus pour le personnel 2
(2025, 12, 6, 1, 5, 5000); -- Autres retenus pour le personnel 3

INSERT INTO plafond (date_, montant) VALUES
('2025-11-01', 1000000);

-- Impôts pour MAT001 (Razafimanjato Elodie) - Novembre 2025
INSERT INTO impot (annee, autres_impots, enfant_chargenbr, enfant_chargepu, igrnet, impot_du, mois, id_personnel) 
VALUES 
(2025, 50000.0, 2.0, 10000.0, 150000.0, 500000.0, 12, 5),
(2025, 30000.0, 1.0, 8000.0, 120000.0, 450000.0, 10, 5);

-- Impôts pour MAT002 (Bakomalala Fenitra) - Novembre 2025
INSERT INTO impot (annee, autres_impots, enfant_chargenbr, enfant_chargepu, igrnet, impot_du, mois, id_personnel) 
VALUES 
(2025, 40000.0, 3.0, 12000.0, 180000.0, 600000.0, 12, 6),
(2025, 25000.0, 2.0, 9000.0, 140000.0, 480000.0, 10, 6);

-- Données d'exemple
INSERT INTO IRSA (tranche_min, tranche_max, taux, date_debut, date_fin, est_actif) VALUES
(0, 350000, 0.0000, '2025-01-01', '2025-12-31', TRUE),
(350001, 400000, 0.0500, '2025-01-01', '2025-12-31', TRUE),
(400001, 500000, 0.1000, '2025-01-01', '2025-12-31', TRUE),
(500001, 600000, 0.1500, '2025-01-01', '2025-12-31', TRUE),
(600001, 999999999, 0.2000, '2025-01-01', '2025-12-31', TRUE);

-- Insérer des types d'heures supplémentaires
INSERT INTO heures_sup_type (libelle, taux) VALUES 
('Heures de nuit', 1.25),
('Heures du weekend', 1.50),
('Heures fériées', 2.00),
('Heures supplémentaires simples', 1.10);

-- Heures supplémentaires pour le personnel MAT001 (id_personnel = 2)
INSERT INTO heures_supplementaire (nb_heures, montant, date_heure_sup, id_heures_sup, id_personnel) VALUES
(4, 120000, '2025-12-15', 1, 5),   -- 4 heures de nuit
(8, 300000, '2025-12-20', 2, 5),   -- 8 heures weekend
(6, 360000, '2025-12-25', 3, 5);   -- 6 heures fériées

-- Heures supplémentaires pour le personnel MAT002 (id_personnel = 3)  
INSERT INTO heures_supplementaire (nb_heures, montant, date_heure_sup, id_heures_sup, id_personnel) VALUES
(5, 137500, '2025-12-10', 1, 6),   -- 5 heures de nuit
(3, 112500, '2025-12-18', 2, 6),   -- 3 heures weekend
(4, 160000, '2025-12-22', 3, 6),   -- 4 heures fériées
(10, 220000, '2025-12-28', 4, 6);  -- 10 heures simples

-- Vérifier l'insertion
SELECT * FROM heures_supplementaire; 




mysql> SELECT * FROM fiche_paie;
+---------------+-------+------+-------------+--------------+--------------+-------------------+-------------+---------------+-----------------+--------------+-------------+---------------+----------+--------------+
| id_fiche_paie | annee | mois | net_a_payer | salaire_base | salaire_brut | salaire_imposable | salaire_net | total_absence | total_heure_sup | total_impots | total_prime | total_retenus | id_impot | id_personnel |
+---------------+-------+------+-------------+--------------+--------------+-------------------+-------------+---------------+-----------------+--------------+-------------+---------------+----------+--------------+
|             6 |  2025 |   11 |        NULL |         1200 |         1350 |              1250 |        1100 |             0 |              50 |         NULL |         100 |           150 |        6 |            5 |
|             7 |  2025 |   10 |        NULL |         1200 |         1350 |              1250 |        1100 |             0 |              50 |         NULL |         100 |           150 |        5 |            5 |
|             8 |  2025 |   11 |        NULL |         1500 |         1700 |              1600 |        1400 |             0 |              80 |         NULL |         120 |           200 |        7 |            6 |
+---------------+-------+------+-------------+--------------+--------------+-------------------+-------------+---------------+-----------------+--------------+-------------+---------------+----------+--------------+
3 rows in set (0.00 sec)

mysql> SELECT * FROM impot;
+----------+-------+---------------+------------------+-----------------+--------+----------+------+--------------+
| id_impot | annee | autres_impots | enfant_chargenbr | enfant_chargepu | igrnet | impot_du | mois | id_personnel |
+----------+-------+---------------+------------------+-----------------+--------+----------+------+--------------+
|        5 |  2025 |         30000 |                1 |            8000 | 120000 |   450000 |   10 |            5 |
|        6 |  2025 |         50000 |                2 |           10000 | 150000 |   500000 |   11 |            5 |
|        7 |  2025 |         35000 |                2 |            9000 | 160000 |   520000 |   11 |            6 |
|        8 |  2025 |         50000 |                2 |           10000 | 150000 |   500000 |   12 |            5 |
|        9 |  2025 |         40000 |                3 |           12000 | 180000 |   600000 |   12 |            6 |
+----------+-------+---------------+------------------+-----------------+--------+----------+------+--------------+
5 rows in set (0.00 sec)

mysql>