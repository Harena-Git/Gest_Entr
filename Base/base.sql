CREATE TABLE role(
   Id_role INT AUTO_INCREMENT,
   libelle VARCHAR(50) NOT NULL,
   PRIMARY KEY(Id_role),
   UNIQUE(libelle)
);

INSERT INTO role (Id_role, libelle) VALUES 
(1,'Administrateur'),
(3,'Responsable RH'),
(5,'Chef de département');

CREATE TABLE lieu(
   Id_lieu INT AUTO_INCREMENT,
   lieu VARCHAR(50),
   PRIMARY KEY(Id_lieu)
);

INSERT INTO lieu (Id_lieu, lieu) VALUES
(1,'Antananarivo'),
(3,'Mahajanga'),
(5,'Toamasina');

CREATE TABLE etat_candidat(
   Id_etat_candidat INT AUTO_INCREMENT,
   libelle VARCHAR(50) NOT NULL,
   PRIMARY KEY(Id_etat_candidat),
   UNIQUE(libelle)
);

INSERT INTO etat_candidat (Id_etat_candidat, libelle) VALUES 
(1, 'Nouvelle candidature'),
(2, 'En attente entretien'),
(3, 'Entretien programmé'),
(4, 'Entretien réalisé'),
(5, 'En attente décision'),
(6, 'Embauche confirmée'),
(7, 'Candidature rejetée'),
(8, 'CV accepte');

CREATE TABLE candidat(
   Id_candidat INT AUTO_INCREMENT,
   nom VARCHAR(100) NOT NULL,
   prenom VARCHAR(100) NOT NULL,
   email VARCHAR(150) NOT NULL,
   photo TEXT,
   telephone VARCHAR(20),
   adresse TEXT,
   date_candidature DATE NOT NULL,
   annee_experience INT,
   Id_lieu INT NOT NULL,
   Id_etat_candidat INT NOT NULL,
   competences_personnelles TEXT,
   genre VARCHAR(10),
   date_naissance DATE,
   PRIMARY KEY(Id_candidat),
   UNIQUE(email),
   FOREIGN KEY(Id_lieu) REFERENCES lieu(Id_lieu),
   FOREIGN KEY(Id_etat_candidat) REFERENCES etat_candidat(Id_etat_candidat)
);

INSERT INTO candidat (Id_candidat, nom, prenom, email, photo, telephone, adresse, date_candidature, annee_experience, Id_lieu, Id_etat_candidat, competences_personnelles, genre, date_naissance) VALUES
(49,'Randria', 'Mickael', 'mickael.r@test.com', NULL, '0341234567', 'Lot II A', '2025-01-10', 3, 1, 8, 'Java, SQL', 'Homme', '1998-03-12'),
(51,'Rasoa', 'Anita', 'anita.r@test.com', NULL, '0349876543', 'Lot IVC', '2025-01-08', 2, 5, 8, 'Gestion, RH', 'Femme', '1995-07-19'),
(53,'Rakoto', 'Tojo', 'tojo.r@test.com', NULL, '0324455667', 'Analakely', '2025-01-12', 5, 3, 6, 'Pilotage projet', 'Homme', '1992-02-20'),
(55,'Andry', 'Sarah', 'sarah.a@test.com', NULL, '0345566778', 'Ambatonakanga', '2025-01-05', 1, 3, 8, 'Comptabilité', 'Femme', '2000-06-01');


CREATE TABLE departement(
   Id_departement INT AUTO_INCREMENT,
   departement VARCHAR(50),
   PRIMARY KEY(Id_departement)
);

INSERT INTO departement (Id_departement, departement) VALUES
(1,'Informatique'),
(3,'Ressources Humaines'),
(5,'Comptabilité');


CREATE TABLE poste(
   Id_poste INT AUTO_INCREMENT,
   libelle VARCHAR(50),
   salaire INT,
   Id_departement INT NOT NULL,
   PRIMARY KEY(Id_poste),
   FOREIGN KEY(Id_departement) REFERENCES departement(Id_departement)
);

INSERT INTO poste (libelle, salaire, Id_departement) VALUES
(6,'Développeur Junior', 800000, 1),
(7,'Développeur Senior', 1500000, 1),
(8,'Assistante RH', 600000, 3),
(9,'Chargée Paie', 750000, 3),
(10,'Comptable', 700000, 5);


CREATE TABLE user_(
   Id_user INT AUTO_INCREMENT,
   nom VARCHAR(50) NOT NULL,
   mot_de_passe VARCHAR(250) NOT NULL,
   Id_departement INT NOT NULL,
   Id_role INT NOT NULL,
   PRIMARY KEY(Id_user),
   UNIQUE(nom),
   FOREIGN KEY(Id_departement) REFERENCES departement(Id_departement),
   FOREIGN KEY(Id_role) REFERENCES role(Id_role)
);

INSERT INTO user_ (Id_user, nom, mot_de_passe, Id_departement, Id_role) VALUES
(9,'admin', 'admin123', 1, 1),
(10,'rh_marie', 'rh123', 3, 3),
(11,'chef_compta', 'chefcompta23', 5, 5),
(12,'chef_informatique', 'chefinfo123', 1, 5),
(13,'chef_rh', 'chefrh123', 3, 3);


CREATE TABLE personnel(
   Id_personnel INT AUTO_INCREMENT,
   date_embauche DATE NOT NULL,
   actif BOOLEAN,
   Id_candidat INT NOT NULL,
   Id_poste INT NOT NULL,
   PRIMARY KEY(Id_personnel),
   UNIQUE(Id_candidat),
   FOREIGN KEY(Id_candidat) REFERENCES candidat(Id_candidat),
   FOREIGN KEY(Id_poste) REFERENCES poste(Id_poste)
);

INSERT INTO personnel (id_personnel, date_embauche, actif, Id_candidat, Id_poste) VALUES
(4,'2025-02-01', TRUE, 49, 6),
(5,'2025-02-05', TRUE, 51, 8),
(6,'2025-02-10', TRUE, 55, 10);


-- Table des présences / absences
CREATE TABLE presence_absence (
   Id_presence_absence INT AUTO_INCREMENT PRIMARY KEY,
   date_ DATE,
   heure_depart TIME,
   heure_arrivee TIME,
   present BOOLEAN,
   Id_personnel INT,
   Id_user INT,
   FOREIGN KEY (Id_personnel) REFERENCES personnel(Id_personnel),
   FOREIGN KEY (Id_user) REFERENCES user_(Id_user),
   CONSTRAINT chk_employe CHECK (
      (Id_user IS NOT NULL AND Id_personnel IS NULL) OR
      (Id_user IS NULL AND Id_personnel IS NOT NULL)
   )
);

INSERT INTO presence_absence (date_, heure_arrivee, present, Id_personnel, Id_user) VALUES
-- Mickael (Dev) arrive à l'heure
('2025-12-01', '08:00:00', TRUE, 4, NULL),
-- Anita (RH) arrive avec 30 min de retard
('2025-12-01', '08:30:00', TRUE, 5, NULL),
-- Tojo (Compta) arrive à l'heure
('2025-12-01', '08:00:00', TRUE, 6, NULL);

INSERT INTO presence_absence (date_, heure_arrivee, present, Id_personnel, Id_user) VALUES
-- Chef informatique
('2025-12-01', '08:10:00', TRUE, NULL, 12),
-- Chef RH
('2025-12-01', '08:05:00', TRUE, NULL, 13);

UPDATE presence_absence 
SET heure_depart = '18:00:00'
WHERE Id_personnel = 4 AND date_ = '2025-12-01';

UPDATE presence_absence 
SET heure_depart = '17:00:00'
WHERE Id_personnel = 5 AND date_ = '2025-12-01';

UPDATE presence_absence 
SET heure_depart = '19:00:00'
WHERE Id_personnel = 6 AND date_ = '2025-12-01';

UPDATE presence_absence 
SET heure_depart = '17:00:00'
WHERE Id_user IN (12, 13) AND date_ = '2025-12-01';

-- Table des justifications d'absence
CREATE TABLE justification_absence (
   Id_justification_absence INT AUTO_INCREMENT PRIMARY KEY,
   date_demande DATE,
   fichier_justification TEXT,
   date_absence DATE,
   est_justifie BOOLEAN DEFAULT FALSE,
   Id_personnel INT NOT NULL,
   FOREIGN KEY (Id_personnel) REFERENCES personnel(Id_personnel)
);

INSERT INTO justification_absence (
    date_demande, 
    fichier_justification, 
    date_absence, 
    est_justifie, 
    Id_personnel
) VALUES (
    '2025-12-02',
    'certificat_medical_mickael.pdf',
    '2025-12-02',
    FALSE,
    4
);

INSERT INTO justification_absence (
    date_demande, 
    date_absence, 
    est_justifie, 
    Id_personnel
) VALUES (
    '2025-12-03',
    '2025-12-03',
    FALSE,
    6
);

-- Table des justifications de retard
CREATE TABLE justification_retard (
   Id_justification_retard INT AUTO_INCREMENT PRIMARY KEY,
   Id_personnel INT NOT NULL,
   date_retard DATE NOT NULL,
   minutes_retard INT NOT NULL,
   fichier_justification TEXT,
   est_justifie BOOLEAN DEFAULT FALSE,
   FOREIGN KEY (Id_personnel) REFERENCES personnel(Id_personnel)
);

INSERT INTO justification_retard (
    Id_personnel,
    date_retard,
    minutes_retard,
    fichier_justification,
    est_justifie
) VALUES (
    5,
    '2025-12-04',
    45,
    'attestation_retard_transport.pdf',
    FALSE
);

-- Table des décisions possibles (accepté / refusé)
CREATE TABLE decision_validation (
   Id_decision_validation INT AUTO_INCREMENT PRIMARY KEY,
   libelle VARCHAR(50) NOT NULL -- ex: 'accepté', 'refusé'
);

-- Table de validation par le chef
CREATE TABLE validation_abs_chef (
   Id_validation_abs_chef INT AUTO_INCREMENT PRIMARY KEY,
   date_validation DATE,
   Id_user INT NOT NULL,
   Id_presence_absence INT NOT NULL,
   Id_justification_absence INT,
   Id_justification_retard INT,
   Id_decision_validation INT NOT NULL,
   FOREIGN KEY (Id_user) REFERENCES user_(Id_user),
   FOREIGN KEY (Id_justification_absence) REFERENCES justification_absence(Id_justification_absence),
   FOREIGN KEY (Id_justification_retard) REFERENCES justification_retard(Id_justification_retard),
   FOREIGN KEY (Id_decision_validation) REFERENCES decision_validation(Id_decision_validation),
   CONSTRAINT chk_justification CHECK (
      (Id_justification_absence IS NOT NULL AND Id_justification_retard IS NULL) OR
      (Id_justification_absence IS NULL AND Id_justification_retard IS NOT NULL)
   )
);

-- Table de validation finale par les RH
CREATE TABLE validation_abs_rh (
   Id_validation_abs_rh INT AUTO_INCREMENT PRIMARY KEY,
   date_validation DATE,
   Id_user INT NOT NULL,
   Id_validation_abs_chef INT NOT NULL,
   Id_decision_validation INT NOT NULL,
   FOREIGN KEY (Id_user) REFERENCES user_(Id_user),
   FOREIGN KEY (Id_validation_abs_chef) REFERENCES validation_abs_chef(Id_validation_abs_chef),
   FOREIGN KEY (Id_decision_validation) REFERENCES decision_validation(Id_decision_validation)
);

-- Table des horaires de l'entreprise
CREATE TABLE horaire_entreprise (
   Id_horaire INT AUTO_INCREMENT PRIMARY KEY,
   heure_debut TIME NOT NULL,
   heure_fin TIME NOT NULL,
   pause_debut TIME,
   pause_fin TIME
);

CREATE TABLE heures_sup_type (
   Id_heures_sup INT AUTO_INCREMENT PRIMARY KEY,
   libelle VARCHAR(50) NOT NULL,
   taux DECIMAL(5,2) NOT NULL
);


CREATE TABLE heures_supplementaire(
   Id_heures_supplementaire INT AUTO_INCREMENT,
   nb_heures INT,
   montant DECIMAL(15,2)  ,
   Id_heures_sup INT NOT NULL,
   PRIMARY KEY(Id_heures_supplementaire),
   FOREIGN KEY(Id_heures_sup) REFERENCES heures_sup_type(Id_heures_sup)
);

CREATE TABLE personnel_heure_supp(
   Id_personnel_heure_supp INT AUTO_INCREMENT PRIMARY KEY,
   Id_personnel INT,
   Id_user INT,
   Id_heures_supplementaire INT,
   FOREIGN KEY(Id_personnel) REFERENCES personnel(Id_personnel),
   FOREIGN KEY(Id_user) REFERENCES user_(Id_user),
   FOREIGN KEY(Id_heures_supplementaire) REFERENCES heures_supplementaire(Id_heures_supplementaire)
);

CREATE TABLE IF NOT EXISTS audit_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    table_name VARCHAR(50) NOT NULL,
    record_id INT NOT NULL,
    action VARCHAR(50) NOT NULL,
    user_id INT,
    user_type ENUM('personnel', 'user') DEFAULT 'user',
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    details TEXT,
    INDEX idx_table_record (table_name, record_id),
    INDEX idx_user (user_id, user_type),
    INDEX idx_timestamp (timestamp)
);

-- Insérer les décisions de validation
INSERT INTO decision_validation (libelle) VALUES ('accepté'), ('refusé');

-- Insérer un horaire d'entreprise par défaut si la table est vide
INSERT INTO horaire_entreprise (heure_debut, heure_fin, pause_debut, pause_fin)
SELECT '08:00:00', '17:00:00', '12:00:00', '13:00:00'
WHERE NOT EXISTS (SELECT 1 FROM horaire_entreprise LIMIT 1);

INSERT IGNORE INTO heures_sup_type (libelle, taux) VALUES 
('normales', 1.25),
('nocturnes', 1.50),
('feries', 2.00);

-- ============================================================================
-- VUES SQL POUR OPTIMISATION DES REQUÊTES (RESPECTING ORIGINAL SCHEMA)
-- ============================================================================

-- Vue 1: Présences journalières (personnel + responsables)
CREATE OR REPLACE VIEW view_presence_journaliere AS
SELECT 
    pa.Id_presence_absence,
    pa.date_,
    pa.heure_arrivee,
    pa.heure_depart,
    pa.present,
    -- Informations personnel
    pa.Id_personnel,
    CASE 
        WHEN pa.Id_personnel IS NOT NULL THEN c.nom
        ELSE NULL
    END as personnel_nom,
    CASE 
        WHEN pa.Id_personnel IS NOT NULL THEN c.prenom
        ELSE NULL
    END as personnel_prenom,
    CASE 
        WHEN pa.Id_personnel IS NOT NULL THEN c.email
        ELSE NULL
    END as personnel_email,
    -- Informations user (chef/RH)
    pa.Id_user,
    CASE 
        WHEN pa.Id_user IS NOT NULL THEN u.nom
        ELSE NULL
    END as user_nom,
    -- Département
    CASE 
        WHEN pa.Id_personnel IS NOT NULL THEN po.Id_departement
        WHEN pa.Id_user IS NOT NULL THEN u.Id_departement
    END as Id_departement,
    d.departement as nom_departement,
    -- Rôle (pour les users)
    CASE 
        WHEN pa.Id_user IS NOT NULL THEN r.libelle
        ELSE 'Personnel'
    END as role_libelle,
    -- Vérifier si validé par chef
    CASE 
        WHEN EXISTS (
            SELECT 1 FROM validation_abs_chef vc 
            WHERE vc.Id_presence_absence = pa.Id_presence_absence
            AND vc.Id_decision_validation = (SELECT Id_decision_validation FROM decision_validation WHERE libelle = 'accepté')
        ) THEN TRUE
        ELSE FALSE
    END as validation_chef,
    -- Vérifier si validé par RH
    CASE 
        WHEN EXISTS (
            SELECT 1 FROM validation_abs_rh vr 
            INNER JOIN validation_abs_chef vc ON vr.Id_validation_abs_chef = vc.Id_validation_abs_chef
            WHERE vc.Id_presence_absence = pa.Id_presence_absence
            AND vr.Id_decision_validation = (SELECT Id_decision_validation FROM decision_validation WHERE libelle = 'accepté')
        ) THEN TRUE
        ELSE FALSE
    END as validation_rh
FROM presence_absence pa
LEFT JOIN personnel p ON pa.Id_personnel = p.Id_personnel
LEFT JOIN candidat c ON p.Id_candidat = c.Id_candidat
LEFT JOIN poste po ON p.Id_poste = po.Id_poste
LEFT JOIN user_ u ON pa.Id_user = u.Id_user
LEFT JOIN departement d ON (po.Id_departement = d.Id_departement OR u.Id_departement = d.Id_departement)
LEFT JOIN role r ON u.Id_role = r.Id_role;

-- Vue 2: Justifications d'absence en attente
CREATE OR REPLACE VIEW view_justifs_absence_en_attente AS
SELECT 
    ja.Id_justification_absence,
    ja.date_demande,
    ja.date_absence,
    ja.fichier_justification,
    ja.est_justifie,
    ja.Id_personnel,
    c.nom,
    c.prenom,
    c.email,
    c.telephone,
    po.Id_departement,
    d.departement,
    po.libelle as poste_libelle,
    po.salaire as salaire_base
FROM justification_absence ja
INNER JOIN personnel p ON ja.Id_personnel = p.Id_personnel
INNER JOIN candidat c ON p.Id_candidat = c.Id_candidat
INNER JOIN poste po ON p.Id_poste = po.Id_poste
INNER JOIN departement d ON po.Id_departement = d.Id_departement
WHERE ja.est_justifie = FALSE
AND NOT EXISTS (
    SELECT 1 FROM validation_abs_chef vc 
    WHERE vc.Id_justification_absence = ja.Id_justification_absence
);

-- Vue 3: Justifications de retard en attente
CREATE OR REPLACE VIEW view_justifs_retard_en_attente AS
SELECT 
    jr.Id_justification_retard,
    jr.date_retard,
    jr.minutes_retard,
    jr.fichier_justification,
    jr.est_justifie,
    jr.Id_personnel,
    c.nom,
    c.prenom,
    c.email,
    c.telephone,
    po.Id_departement,
    d.departement,
    po.libelle as poste_libelle
FROM justification_retard jr
INNER JOIN personnel p ON jr.Id_personnel = p.Id_personnel
INNER JOIN candidat c ON p.Id_candidat = c.Id_candidat
INNER JOIN poste po ON p.Id_poste = po.Id_poste
INNER JOIN departement d ON po.Id_departement = d.Id_departement
WHERE jr.est_justifie = FALSE
AND NOT EXISTS (
    SELECT 1 FROM validation_abs_chef vc 
    WHERE vc.Id_justification_retard = jr.Id_justification_retard
);

-- Vue 4: Heures supplémentaires possibles (présences dépassant horaires)
CREATE OR REPLACE VIEW view_heures_sup_possibles AS
SELECT 
    pa.Id_presence_absence,
    pa.date_,
    pa.heure_arrivee,
    pa.heure_depart,
    pa.Id_personnel,
    pa.Id_user,
    CASE 
        WHEN pa.Id_personnel IS NOT NULL THEN c.nom
        WHEN pa.Id_user IS NOT NULL THEN u.nom
    END as nom,
    CASE 
        WHEN pa.Id_personnel IS NOT NULL THEN c.prenom
        ELSE NULL
    END as prenom,
    CASE 
        WHEN pa.Id_personnel IS NOT NULL THEN po.Id_departement
        WHEN pa.Id_user IS NOT NULL THEN u.Id_departement
    END as Id_departement,
    he.heure_debut,
    he.heure_fin,
    he.pause_debut,
    he.pause_fin,
    -- Calcul des minutes travaillées (sans pause)
    TIMESTAMPDIFF(MINUTE, pa.heure_arrivee, pa.heure_depart) - 
    COALESCE(TIMESTAMPDIFF(MINUTE, he.pause_debut, he.pause_fin), 0) as minutes_travaillees,
    -- Calcul des minutes théoriques (sans pause)
    TIMESTAMPDIFF(MINUTE, he.heure_debut, he.heure_fin) - 
    COALESCE(TIMESTAMPDIFF(MINUTE, he.pause_debut, he.pause_fin), 0) as minutes_theoriques,
    -- Heures supplémentaires en minutes
    (TIMESTAMPDIFF(MINUTE, pa.heure_arrivee, pa.heure_depart) - 
    COALESCE(TIMESTAMPDIFF(MINUTE, he.pause_debut, he.pause_fin), 0)) -
    (TIMESTAMPDIFF(MINUTE, he.heure_debut, he.heure_fin) - 
    COALESCE(TIMESTAMPDIFF(MINUTE, he.pause_debut, he.pause_fin), 0)) as minutes_supplementaires,
    -- Vérifier si déjà enregistré comme heure sup
    CASE 
        WHEN EXISTS (
            SELECT 1 FROM personnel_heure_supp phs
            INNER JOIN heures_supplementaire hs ON phs.Id_heures_supplementaire = hs.Id_heures_supplementaire
            WHERE (phs.Id_personnel = pa.Id_personnel OR phs.Id_user = pa.Id_user)
            AND pa.date_ = pa.date_
        ) THEN TRUE
        ELSE FALSE
    END as deja_enregistre
FROM presence_absence pa
LEFT JOIN personnel p ON pa.Id_personnel = p.Id_personnel
LEFT JOIN candidat c ON p.Id_candidat = c.Id_candidat
LEFT JOIN poste po ON p.Id_poste = po.Id_poste
LEFT JOIN user_ u ON pa.Id_user = u.Id_user
CROSS JOIN horaire_entreprise he
WHERE pa.heure_depart IS NOT NULL
AND pa.present = TRUE
AND (
    TIMESTAMPDIFF(MINUTE, pa.heure_arrivee, pa.heure_depart) - 
    COALESCE(TIMESTAMPDIFF(MINUTE, he.pause_debut, he.pause_fin), 0)
) > (
    TIMESTAMPDIFF(MINUTE, he.heure_debut, he.heure_fin) - 
    COALESCE(TIMESTAMPDIFF(MINUTE, he.pause_debut, he.pause_fin), 0)
);

-- Vue 5: Résumé des validations en attente pour les chefs
CREATE OR REPLACE VIEW view_validations_chef_en_attente AS
SELECT 
    'absence' as type_justification,
    ja.Id_justification_absence as id_justification,
    NULL as Id_justification_retard,
    ja.date_absence as date_concerne,
    ja.date_demande,
    ja.fichier_justification,
    ja.Id_personnel,
    c.nom,
    c.prenom,
    po.Id_departement,
    d.departement
FROM justification_absence ja
INNER JOIN personnel p ON ja.Id_personnel = p.Id_personnel
INNER JOIN candidat c ON p.Id_candidat = c.Id_candidat
INNER JOIN poste po ON p.Id_poste = po.Id_poste
INNER JOIN departement d ON po.Id_departement = d.Id_departement
WHERE ja.est_justifie = FALSE
AND NOT EXISTS (
    SELECT 1 FROM validation_abs_chef vc 
    WHERE vc.Id_justification_absence = ja.Id_justification_absence
)
UNION ALL
SELECT 
    'retard' as type_justification,
    NULL as Id_justification_absence,
    jr.Id_justification_retard,
    jr.date_retard as date_concerne,
    jr.date_retard as date_demande,
    jr.fichier_justification,
    jr.Id_personnel,
    c.nom,
    c.prenom,
    po.Id_departement,
    d.departement
FROM justification_retard jr
INNER JOIN personnel p ON jr.Id_personnel = p.Id_personnel
INNER JOIN candidat c ON p.Id_candidat = c.Id_candidat
INNER JOIN poste po ON p.Id_poste = po.Id_poste
INNER JOIN departement d ON po.Id_departement = d.Id_departement
WHERE jr.est_justifie = FALSE
AND NOT EXISTS (
    SELECT 1 FROM validation_abs_chef vc 
    WHERE vc.Id_justification_retard = jr.Id_justification_retard
);

-- Vue 6: Historique complet des validations (pour RH/Audit)
CREATE OR REPLACE VIEW view_historique_validations AS
SELECT 
    vc.Id_validation_abs_chef,
    vc.date_validation as date_validation_chef,
    uc.nom as chef_nom,
    uc.Id_departement as chef_departement,
    dc.libelle as decision_chef,
    vc.Id_justification_absence,
    vc.Id_justification_retard,
    vc.Id_presence_absence,
    -- Info personnel concerné
    CASE 
        WHEN vc.Id_justification_absence IS NOT NULL THEN ja.Id_personnel
        WHEN vc.Id_justification_retard IS NOT NULL THEN jr.Id_personnel
        WHEN pa.Id_personnel IS NOT NULL THEN pa.Id_personnel
    END as Id_personnel,
    CASE 
        WHEN vc.Id_justification_absence IS NOT NULL THEN ca.nom
        WHEN vc.Id_justification_retard IS NOT NULL THEN cr.nom
        WHEN pa.Id_personnel IS NOT NULL THEN cp.nom
    END as personnel_nom,
    CASE 
        WHEN vc.Id_justification_absence IS NOT NULL THEN ca.prenom
        WHEN vc.Id_justification_retard IS NOT NULL THEN cr.prenom
        WHEN pa.Id_personnel IS NOT NULL THEN cp.prenom
    END as personnel_prenom,
    -- Validation RH
    vr.Id_validation_abs_rh,
    vr.date_validation as date_validation_rh,
    ur.nom as rh_nom,
    dr.libelle as decision_rh
FROM validation_abs_chef vc
INNER JOIN user_ uc ON vc.Id_user = uc.Id_user
INNER JOIN decision_validation dc ON vc.Id_decision_validation = dc.Id_decision_validation
LEFT JOIN validation_abs_rh vr ON vc.Id_validation_abs_chef = vr.Id_validation_abs_chef
LEFT JOIN user_ ur ON vr.Id_user = ur.Id_user
LEFT JOIN decision_validation dr ON vr.Id_decision_validation = dr.Id_decision_validation
LEFT JOIN justification_absence ja ON vc.Id_justification_absence = ja.Id_justification_absence
LEFT JOIN personnel pa_ja ON ja.Id_personnel = pa_ja.Id_personnel
LEFT JOIN candidat ca ON pa_ja.Id_candidat = ca.Id_candidat
LEFT JOIN justification_retard jr ON vc.Id_justification_retard = jr.Id_justification_retard
LEFT JOIN personnel pr ON jr.Id_personnel = pr.Id_personnel
LEFT JOIN candidat cr ON pr.Id_candidat = cr.Id_candidat
LEFT JOIN presence_absence pa ON vc.Id_presence_absence = pa.Id_presence_absence
LEFT JOIN personnel pp ON pa.Id_personnel = pp.Id_personnel
LEFT JOIN candidat cp ON pp.Id_candidat = cp.Id_candidat;

-- ============================================================================
-- CORRECTION DE LA TABLE validation_abs_chef (erreur de nom de colonne)
-- ============================================================================

-- Votre table a une erreur: Id_justif_retard au lieu de Id_justification_retard
ALTER TABLE validation_abs_chef 
CHANGE COLUMN Id_justif_retard Id_justification_retard INT;

-- ============================================================================
-- TRIGGERS - RÈGLES MÉTIER AUTOMATIQUES
-- ============================================================================

-- Trigger 1: Empêcher double entrée pour même personne/date
DELIMITER //
DROP TRIGGER IF EXISTS prevent_double_entry//
CREATE TRIGGER prevent_double_entry 
BEFORE INSERT ON presence_absence
FOR EACH ROW
BEGIN
    DECLARE count_entries INT DEFAULT 0;
    
    -- Vérifier pour personnel
    IF NEW.Id_personnel IS NOT NULL AND NEW.heure_arrivee IS NOT NULL THEN
        SELECT COUNT(*) INTO count_entries
        FROM presence_absence
        WHERE Id_personnel = NEW.Id_personnel
        AND date_ = NEW.date_
        AND heure_arrivee IS NOT NULL;
        
        IF count_entries > 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Une entrée existe déjà pour ce personnel à cette date';
        END IF;
    END IF;
    
    -- Vérifier pour user
    IF NEW.Id_user IS NOT NULL AND NEW.heure_arrivee IS NOT NULL THEN
        SELECT COUNT(*) INTO count_entries
        FROM presence_absence
        WHERE Id_user = NEW.Id_user
        AND date_ = NEW.date_
        AND heure_arrivee IS NOT NULL;
        
        IF count_entries > 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Une entrée existe déjà pour cet utilisateur à cette date';
        END IF;
    END IF;
END//
DELIMITER ;

-- Trigger 2: Empêcher sortie sans entrée
DELIMITER //
DROP TRIGGER IF EXISTS prevent_exit_without_entry//
CREATE TRIGGER prevent_exit_without_entry 
BEFORE UPDATE ON presence_absence
FOR EACH ROW
BEGIN
    DECLARE count_entries INT DEFAULT 0;
    
    -- Si on tente d'ajouter une sortie alors qu'il n'y a pas d'entrée
    IF NEW.heure_depart IS NOT NULL AND OLD.heure_arrivee IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Impossible d enregistrer une sortie sans entrée préalable';
    END IF;
END//
DELIMITER ;

-- Trigger 3: Calculer retard et créer justification automatiquement si >= 15 min
DELIMITER //
DROP TRIGGER IF EXISTS calc_retard_on_insert//
CREATE TRIGGER calc_retard_on_insert 
AFTER INSERT ON presence_absence
FOR EACH ROW
BEGIN
    DECLARE heure_debut_entreprise TIME;
    DECLARE minutes_retard_calc INT DEFAULT 0;
    
    -- Ne traiter que si c'est un personnel (pas un user/responsable)
    IF NEW.Id_personnel IS NOT NULL AND NEW.heure_arrivee IS NOT NULL THEN
        -- Récupérer l'heure de début de l'entreprise
        SELECT heure_debut INTO heure_debut_entreprise
        FROM horaire_entreprise
        LIMIT 1;
        
        IF heure_debut_entreprise IS NOT NULL THEN
            -- Calculer le retard en minutes
            SET minutes_retard_calc = TIMESTAMPDIFF(MINUTE, heure_debut_entreprise, NEW.heure_arrivee);
            
            -- Si retard >= 15 minutes, créer automatiquement une demande de justification
            IF NOT EXISTS (
                SELECT 1 
                FROM justification_retard 
                WHERE Id_personnel = NEW.Id_personnel 
                AND date_retard = NEW.date_
            ) AND minutes_retard_calc >= 15 THEN
                INSERT INTO justification_retard (
                    Id_personnel,
                    date_retard,
                    minutes_retard,
                    est_justifie
                ) VALUES (
                    NEW.Id_personnel,
                    NEW.date_,
                    minutes_retard_calc,
                    FALSE
                );
            END IF;
        END IF;
    END IF;
END//
DELIMITER ;

-- Trigger 4: Validation chef - mise à jour justification + vérifications
DELIMITER //
DROP TRIGGER IF EXISTS on_validation_chef_insert//
CREATE TRIGGER on_validation_chef_insert
BEFORE INSERT ON validation_abs_chef
FOR EACH ROW
BEGIN
    DECLARE decision_libelle VARCHAR(50);
    DECLARE id_departement_chef INT;
    DECLARE id_departement_personnel INT;
    DECLARE id_user_presence INT;
    
    -- Récupérer la décision
    SELECT libelle INTO decision_libelle
    FROM decision_validation
    WHERE Id_decision_validation = NEW.Id_decision_validation;
    
    -- Récupérer le département du chef
    SELECT Id_departement INTO id_departement_chef
    FROM user_
    WHERE Id_user = NEW.Id_user;
    
    -- VÉRIFICATION 1: Anti-auto-validation pour les présences
    IF NEW.Id_presence_absence IS NOT NULL THEN
        SELECT Id_user INTO id_user_presence
        FROM presence_absence
        WHERE Id_presence_absence = NEW.Id_presence_absence;
        
        IF id_user_presence = NEW.Id_user THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Un responsable ne peut pas valider sa propre présence';
        END IF;
    END IF;
    
    -- VÉRIFICATION 2: Chef valide seulement son département (pour absences)
    IF NEW.Id_justification_absence IS NOT NULL THEN
        SELECT po.Id_departement INTO id_departement_personnel
        FROM justification_absence ja
        INNER JOIN personnel p ON ja.Id_personnel = p.Id_personnel
        INNER JOIN poste po ON p.Id_poste = po.Id_poste
        WHERE ja.Id_justification_absence = NEW.Id_justification_absence;
        
        IF id_departement_chef != id_departement_personnel THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Le chef ne peut valider que les absences de son département';
        END IF;
    END IF;
    
    -- VÉRIFICATION 3: Chef valide seulement son département (pour retards)
    IF NEW.Id_justification_retard IS NOT NULL THEN
        SELECT po.Id_departement INTO id_departement_personnel
        FROM justification_retard jr
        INNER JOIN personnel p ON jr.Id_personnel = p.Id_personnel
        INNER JOIN poste po ON p.Id_poste = po.Id_poste
        WHERE jr.Id_justification_retard = NEW.Id_justification_retard;
        
        IF id_departement_chef != id_departement_personnel THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Le chef ne peut valider que les retards de son département';
        END IF;
    END IF;
END//
DELIMITER ;

-- Trigger 5: Après validation chef - mise à jour des justifications
DELIMITER //
DROP TRIGGER IF EXISTS after_validation_chef_insert//
CREATE TRIGGER after_validation_chef_insert
AFTER INSERT ON validation_abs_chef
FOR EACH ROW
BEGIN
    DECLARE decision_libelle VARCHAR(50);
    
    -- Récupérer la décision
    SELECT libelle INTO decision_libelle
    FROM decision_validation
    WHERE Id_decision_validation = NEW.Id_decision_validation;
    
    -- Si accepté, mettre à jour est_justifie
    IF decision_libelle = 'accepté' THEN
        IF NEW.Id_justification_absence IS NOT NULL THEN
            UPDATE justification_absence
            SET est_justifie = TRUE
            WHERE Id_justification_absence = NEW.Id_justification_absence;
        END IF;
        
        IF NEW.Id_justification_retard IS NOT NULL THEN
            UPDATE justification_retard
            SET est_justifie = TRUE
            WHERE Id_justification_retard = NEW.Id_justification_retard;
        END IF;
    END IF;
END//
DELIMITER ;

-- Trigger 6: Validation RH - décision finale
DELIMITER //
DROP TRIGGER IF EXISTS on_validation_rh_insert//
CREATE TRIGGER on_validation_rh_insert
AFTER INSERT ON validation_abs_rh
FOR EACH ROW
BEGIN
    DECLARE decision_libelle VARCHAR(50);
    DECLARE id_justif_absence INT;
    DECLARE id_justif_retard INT;
    
    -- Récupérer la décision RH
    SELECT libelle INTO decision_libelle
    FROM decision_validation
    WHERE Id_decision_validation = NEW.Id_decision_validation;
    
    -- Récupérer les IDs depuis la validation chef
    SELECT 
        Id_justification_absence,
        Id_justification_retard
    INTO 
        id_justif_absence,
        id_justif_retard
    FROM validation_abs_chef
    WHERE Id_validation_abs_chef = NEW.Id_validation_abs_chef;
    
    -- Si RH refuse, inverser la décision du chef
    IF decision_libelle = 'refusé' THEN
        IF id_justif_absence IS NOT NULL THEN
            UPDATE justification_absence
            SET est_justifie = FALSE
            WHERE Id_justification_absence = id_justif_absence;
        END IF;
        
        IF id_justif_retard IS NOT NULL THEN
            UPDATE justification_retard
            SET est_justifie = FALSE
            WHERE Id_justification_retard = id_justif_retard;
        END IF;
    END IF;
    -- Si RH accepte, les justifications sont déjà marquées comme justifiées par le trigger chef
END//
DELIMITER ;

DELIMITER //

DROP TRIGGER IF EXISTS trg_calcul_heures_sup//

CREATE TRIGGER trg_calcul_heures_sup
AFTER UPDATE ON presence_absence
FOR EACH ROW
BEGIN
    DECLARE heure_fin TIME;
    DECLARE nb_heures DECIMAL(5,2) DEFAULT 0;
    DECLARE salaire INT DEFAULT 0;
    DECLARE taux_horaire DECIMAL(10,2) DEFAULT 0;
    DECLARE id_heures_sup INT DEFAULT 1;
    DECLARE taux_maj DECIMAL(5,2) DEFAULT 1.25;
    DECLARE personnel_id INT;
    DECLARE montant_calc DECIMAL(15,2) DEFAULT 0;
    DECLARE exists_record INT DEFAULT 0;

    -- Récupérer l'heure officielle de fin de journée
    SELECT COALESCE(heure_fin, TIME('17:00:00')) INTO heure_fin
    FROM horaire_entreprise
    LIMIT 1;

    -- Déterminer l'ID personnel
    SET personnel_id = NEW.id_personnel;

    -- CONDITION: Heures sup SEULEMENT si:
    -- 1. C'est un personnel (pas un user/chef)
    -- 2. Présent = TRUE
    -- 3. Heure départ renseignée
    -- 4. Départ > horaire officiel
    IF personnel_id IS NOT NULL
       AND NEW.present = TRUE
       AND NEW.heure_depart IS NOT NULL
       AND NEW.heure_depart > heure_fin
    THEN

        -- RÉCUPÉRER LE SALAIRE DU PERSONNEL
        SELECT COALESCE(po.salaire, 0) INTO salaire
        FROM personnel p
        JOIN poste po ON p.id_poste = po.id_poste
        WHERE p.id_personnel = personnel_id
        LIMIT 1;

        -- Si salaire trouvé, calculer les heures sup
        IF salaire > 0 THEN

            -- Calcul du nombre d'heures supplémentaires
            SET nb_heures = ROUND(
                TIMESTAMPDIFF(MINUTE, heure_fin, NEW.heure_depart) / 60.0,
                2
            );

            -- Taux horaire = salaire mensuel / 173 heures
            SET taux_horaire = ROUND(salaire / 173.0, 2);

            -- Déterminer le type (normal ou nocturne)
            IF NEW.heure_depart >= TIME('22:00:00') THEN
                -- Heures nocturnes
                SELECT id_heures_sup, taux INTO id_heures_sup, taux_maj
                FROM heures_sup_type
                WHERE libelle = 'nocturnes'
                LIMIT 1;
            ELSE
                -- Heures normales
                SELECT id_heures_sup, taux INTO id_heures_sup, taux_maj
                FROM heures_sup_type
                WHERE libelle = 'normales'
                LIMIT 1;
            END IF;

            -- Calculer le montant: heures * taux_horaire * majoration
            SET montant_calc = ROUND(nb_heures * taux_horaire * taux_maj, 2);

            -- Vérifier si ce personnel n'a pas déjà une entrée pour cette journée
            SELECT COUNT(*) INTO exists_record
            FROM personnel_heure_supp phs
            JOIN heures_supplementaire hs 
              ON phs.id_heures_supplementaire = hs.id_heures_supplementaire
            WHERE phs.id_personnel = personnel_id
              AND DATE(NEW.date_) = NEW.date_;

            -- Insérer SEULEMENT s'il n'y a pas déjà de record
            IF exists_record = 0 THEN

                -- Insérer dans heures_supplementaire
                INSERT INTO heures_supplementaire (
                    nb_heures,
                    montant,
                    id_heures_sup
                ) VALUES (
                    nb_heures,
                    montant_calc,
                    id_heures_sup
                );

                -- Insérer dans personnel_heure_supp
                INSERT INTO personnel_heure_supp (
                    id_personnel,
                    id_user,
                    id_heures_supplementaire
                ) VALUES (
                    personnel_id,
                    NULL,
                    LAST_INSERT_ID()
                );

            END IF; -- fin si pas de record existant

        END IF; -- fin si salaire > 0

    END IF; -- fin conditions heures sup

END//

DELIMITER ;


-- Ts atao , juste au cas ou

-- Activer le scheduler si ce n'est pas déjà fait
SET GLOBAL event_scheduler = ON;

-- Créer l'event
DELIMITER //

CREATE EVENT IF NOT EXISTS event_absence_midi
ON SCHEDULE EVERY 1 DAY
STARTS CONCAT(CURDATE(), ' 14:00:00')
DO
BEGIN
    INSERT INTO justification_absence (Id_personnel, date_absence, est_justifie, fichier_justification)
    SELECT p.Id_personnel, CURDATE(), FALSE, NULL
    FROM personnel p
    LEFT JOIN presence_absence pa
        ON p.Id_personnel = pa.Id_personnel
        AND pa.date_ = CURDATE()
    WHERE pa.Id_personnel IS NULL;
END//

DELIMITER ;
