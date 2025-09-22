CREATE DATABASE Gestion_entreprise;

USE Gestion_entreprise;

CREATE TABLE role(
   Id_role INT AUTO_INCREMENT,
   libelle VARCHAR(50) NOT NULL,
   PRIMARY KEY(Id_role),
   UNIQUE(libelle)
);

CREATE TABLE etat_candidat(
   Id_etat_candidat INT AUTO_INCREMENT,
   libelle VARCHAR(50) NOT NULL,
   PRIMARY KEY(Id_etat_candidat),
   UNIQUE(libelle)
);

CREATE TABLE filiere(
   Id_filiere INT AUTO_INCREMENT,
   libelle VARCHAR(50),
   PRIMARY KEY(Id_filiere)
);

CREATE TABLE departement(
   Id_departement INT AUTO_INCREMENT,
   departement VARCHAR(50),
   PRIMARY KEY(Id_departement)
);

CREATE TABLE appreciation(
   Id_appreciation INT AUTO_INCREMENT,
   libelle VARCHAR(50),
   note INT,
   PRIMARY KEY(Id_appreciation)
);

CREATE TABLE lieu(
   Id_lieu INT AUTO_INCREMENT,
   lieu VARCHAR(50),
   PRIMARY KEY(Id_lieu)
);

CREATE TABLE niveau(
   Id_niveau INT AUTO_INCREMENT,
   libelle VARCHAR(50),
   PRIMARY KEY(Id_niveau)
);

CREATE TABLE question_generale(
   Id_question_generale INT AUTO_INCREMENT,
   libelle VARCHAR(50),
   ordre INT DEFAULT 0,
   PRIMARY KEY(Id_question_generale)
);

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
   PRIMARY KEY(Id_candidat),
   UNIQUE(email),
   FOREIGN KEY(Id_lieu) REFERENCES lieu(Id_lieu),
   FOREIGN KEY(Id_etat_candidat) REFERENCES etat_candidat(Id_etat_candidat)
);

CREATE TABLE poste(
   Id_poste INT AUTO_INCREMENT,
   libelle VARCHAR(50),
   salaire INT,
   Id_departement INT NOT NULL,
   PRIMARY KEY(Id_poste),
   FOREIGN KEY(Id_departement) REFERENCES departement(Id_departement)
);

CREATE TABLE personnel(
   Id_personnel INT AUTO_INCREMENT,
   date_embauche DATE NOT NULL,
   actif LOGICAL,
   Id_candidat INT NOT NULL,
   Id_poste INT NOT NULL,
   PRIMARY KEY(Id_personnel),
   UNIQUE(Id_candidat),
   FOREIGN KEY(Id_candidat) REFERENCES candidat(Id_candidat),
   FOREIGN KEY(Id_poste) REFERENCES poste(Id_poste)
);

CREATE TABLE historique_etat(
   Id_historique_etat INT AUTO_INCREMENT,
   date_changement VARCHAR(50),
   Id_candidat INT NOT NULL,
   Id_etat_candidat INT NOT NULL,
   PRIMARY KEY(Id_historique_etat),
   FOREIGN KEY(Id_candidat) REFERENCES candidat(Id_candidat),
   FOREIGN KEY(Id_etat_candidat) REFERENCES etat_candidat(Id_etat_candidat)
);

CREATE TABLE diplome(
   Id_diplome INT AUTO_INCREMENT,
   Id_niveau INT NOT NULL,
   Id_filiere INT NOT NULL,
   PRIMARY KEY(Id_diplome),
   FOREIGN KEY(Id_niveau) REFERENCES niveau(Id_niveau),
   FOREIGN KEY(Id_filiere) REFERENCES filiere(Id_filiere)
);

CREATE TABLE qcm(
   Id_qcm INT AUTO_INCREMENT,
   titre VARCHAR(50),
   description TEXT,
   Id_poste INT NOT NULL,
   duree_minutes INT DEFAULT 60,
   PRIMARY KEY(Id_qcm),
   UNIQUE(Id_poste),
   FOREIGN KEY(Id_poste) REFERENCES poste(Id_poste)
);

CREATE TABLE question(
   Id_question INT AUTO_INCREMENT,
   libelle TEXT,
   Id_qcm INT NOT NULL,
   ordre INT DEFAULT 0, 
   PRIMARY KEY(Id_question),
   FOREIGN KEY(Id_qcm) REFERENCES qcm(Id_qcm)
);

CREATE TABLE choix(
   Id_choix INT AUTO_INCREMENT,
   libelle VARCHAR(50),
   est_correct BOOLEAN NOT NULL,
   Id_question_generale INT NOT NULL,
   Id_question INT NOT NULL,
   PRIMARY KEY(Id_choix),
   FOREIGN KEY(Id_question_generale) REFERENCES question_generale(Id_question_generale),
   FOREIGN KEY(Id_question) REFERENCES question(Id_question)
   CHECK (
      (Id_question_generale IS NOT NULL AND Id_question IS NULL) OR
      (Id_question_generale IS NULL AND Id_question IS NOT NULL)
   )
);

CREATE TABLE reponse(
   Id_reponse INT AUTO_INCREMENT,
   Id_candidat INT NOT NULL,
   Id_choix INT NULL,
   PRIMARY KEY(Id_reponse),
   FOREIGN KEY(Id_candidat) REFERENCES candidat(Id_candidat),
   FOREIGN KEY(Id_choix) REFERENCES choix(Id_choix)
);

CREATE TABLE resultat_qcm(
   Id_resultat_qcm INT AUTO_INCREMENT,
   bonnes_reponses INT,
   total_questions INT,
   pourcentage DECIMAL(15,2),
   Id_candidat INT NOT NULL,
   Id_qcm INT NOT NULL,
   est_reussi BOOLEAN DEFAULT FALSE
   date_reponse TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
   PRIMARY KEY(Id_resultat_qcm),
   FOREIGN KEY(Id_candidat) REFERENCES candidat(Id_candidat),
   FOREIGN KEY(Id_qcm) REFERENCES qcm(Id_qcm)
);

CREATE TABLE entretien_1(
   Id_entretien_ INT AUTO_INCREMENT,
   date_entretien DATE,
   Id_candidat INT NOT NULL,
   Id_user INT NOT NULL,
   heure_entretien TIME,
   PRIMARY KEY(Id_entretien_),
   FOREIGN KEY(Id_candidat) REFERENCES candidat(Id_candidat),
   FOREIGN KEY(Id_user) REFERENCES user_(Id_user)
);

CREATE TABLE evaluation_entretien_1(
   Id_evaluation_entretien_1 INT AUTO_INCREMENT,
   presence LOGICAL,
   Id_appreciation INT NOT NULL,
   Id_entretien_ INT NOT NULL,
   PRIMARY KEY(Id_evaluation_entretien_1),
   UNIQUE(Id_entretien_),
   FOREIGN KEY(Id_appreciation) REFERENCES appreciation(Id_appreciation),
   FOREIGN KEY(Id_entretien_) REFERENCES entretien_1(Id_entretien_)
);

CREATE TABLE entretien_2(
   Id_entretien_2 INT AUTO_INCREMENT,
   date_entretien DATE,
   Id_user INT NOT NULL,
   Id_entretien_ INT NOT NULL,
   heure_entretien TIME,
   PRIMARY KEY(Id_entretien_2),
   UNIQUE(Id_entretien_),
   FOREIGN KEY(Id_user) REFERENCES user_(Id_user),
   FOREIGN KEY(Id_entretien_) REFERENCES entretien_1(Id_entretien_)
);

CREATE TABLE evaluation_entretien_2(
   Id_evaluation_appreciation_2 INT AUTO_INCREMENT,
   presence LOGICAL,
   Id_appreciation INT NOT NULL,
   Id_entretien_2 INT NOT NULL,
   PRIMARY KEY(Id_evaluation_appreciation_2),
   UNIQUE(Id_entretien_2),
   FOREIGN KEY(Id_appreciation) REFERENCES appreciation(Id_appreciation),
   FOREIGN KEY(Id_entretien_2) REFERENCES entretien_2(Id_entretien_2)
);

CREATE TABLE contrat_essai(
   Id_contrat_essai INT AUTO_INCREMENT,
   date_debut DATE,
   date_fin VARCHAR(50),
   Id_candidat INT NOT NULL,
   PRIMARY KEY(Id_contrat_essai),
   UNIQUE(Id_candidat),
   FOREIGN KEY(Id_candidat) REFERENCES candidat(Id_candidat)
);

CREATE TABLE diplome_candidat(
   Id_diplome_candidat INT AUTO_INCREMENT,
   etablissement VARCHAR(150),
   annee_obtention INT,
   Id_diplome INT NOT NULL,
   Id_candidat INT NOT NULL,
   PRIMARY KEY(Id_diplome_candidat),
   FOREIGN KEY(Id_diplome) REFERENCES diplome(Id_diplome),
   FOREIGN KEY(Id_candidat) REFERENCES candidat(Id_candidat)
);

CREATE TABLE profil(
   Id_profil INT AUTO_INCREMENT,
   genre VARCHAR(50),
   age INT,
   annee_experience VARCHAR(50),
   Id_lieu INT NOT NULL,
   Id_diplome INT NOT NULL,
   PRIMARY KEY(Id_profil),
   FOREIGN KEY(Id_lieu) REFERENCES lieu(Id_lieu),
   FOREIGN KEY(Id_diplome) REFERENCES diplome(Id_diplome)
);

CREATE TABLE annonce(
   Id_annonce INT AUTO_INCREMENT,
   date_annonce VARCHAR(50),
   responsabilite TEXT,
   date_fin DATE,
   Id_poste INT NOT NULL,
   Id_profil INT NOT NULL,
   PRIMARY KEY(Id_annonce),
   FOREIGN KEY(Id_poste) REFERENCES poste(Id_poste),
   FOREIGN KEY(Id_profil) REFERENCES profil(Id_profil)
);

CREATE TABLE plage_horaire_entretien (
   Id_plage INT AUTO_INCREMENT,
   heure_debut TIME NOT NULL,
   heure_fin TIME NOT NULL,
   duree_entretien_minutes INT DEFAULT 45,
   jours_travail SET('Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi'),
   PRIMARY KEY(Id_plage)
);

-- Insertion des plages par défaut
INSERT INTO plage_horaire_entretien (heure_debut, heure_fin, duree_entretien_minutes, jours_travail) VALUES 
('08:00:00', '12:00:00', 45, 'Lundi,Mardi,Mercredi,Jeudi,Vendredi'),
('14:00:00', '17:00:00', 45, 'Lundi,Mardi,Mercredi,Jeudi,Vendredi');-- 1. Vérifier si un candidat a réussi le QCM

DELIMITER $$
CREATE FUNCTION verifier_reussite_qcm(p_id_candidat INT, p_id_qcm INT) 
RETURNS BOOLEAN
READS SQL DATA
BEGIN
    DECLARE v_pourcentage DECIMAL(15,2);
    
    SELECT pourcentage INTO v_pourcentage
    FROM resultat_qcm
    WHERE Id_candidat = p_id_candidat AND Id_qcm = p_id_qcm
    ORDER BY date_reponse DESC LIMIT 1;
    
    IF v_pourcentage >= 50 THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END$$
DELIMITER ;

-- 2. Trouver le prochain créneau disponible
-- Supprimer la fonction existante
DROP FUNCTION IF EXISTS trouver_creneau_disponible;

-- Recréer la fonction avec des corrections
DELIMITER $$
CREATE FUNCTION trouver_creneau_disponible(p_date_base DATE) 
RETURNS DATETIME
READS SQL DATA
BEGIN
    DECLARE v_date_entretien DATE;
    DECLARE v_heure_debut TIME;
    DECLARE v_heure_fin TIME;
    DECLARE v_duree_entretien INT;
    DECLARE v_derniere_heure TIME;
    DECLARE v_nom_jour VARCHAR(20);
    DECLARE v_plage_trouvee BOOLEAN DEFAULT FALSE;
    
    -- Initialiser la date à 5 jours après la date de base
    SET v_date_entretien = DATE_ADD(p_date_base, INTERVAL 5 DAY);
    
    -- Chercher un jour ouvré avec des plages horaires disponibles
    WHILE NOT v_plage_trouvee DO
        -- Vérifier que c'est un jour ouvré (lundi-vendredi)
        WHILE DAYOFWEEK(v_date_entretien) IN (1, 7) DO
            SET v_date_entretien = DATE_ADD(v_date_entretien, INTERVAL 1 DAY);
        END WHILE;
        
        -- Obtenir le nom du jour en français
        SET v_nom_jour = CASE DAYOFWEEK(v_date_entretien)
            WHEN 2 THEN 'Lundi'
            WHEN 3 THEN 'Mardi'
            WHEN 4 THEN 'Mercredi'
            WHEN 5 THEN 'Jeudi'
            WHEN 6 THEN 'Vendredi'
            ELSE 'Samedi'
        END;
        
        -- Vérifier s'il y a des plages horaires pour ce jour
        IF EXISTS (
            SELECT 1 FROM plage_horaire_entretien 
            WHERE FIND_IN_SET(v_nom_jour, jours_travail) > 0
        ) THEN
            SET v_plage_trouvee = TRUE;
        ELSE
            SET v_date_entretien = DATE_ADD(v_date_entretien, INTERVAL 1 DAY);
        END IF;
    END WHILE;
    
    -- Trouver la première plage horaire disponible pour ce jour
    SELECT heure_debut, heure_fin, duree_entretien_minutes 
    INTO v_heure_debut, v_heure_fin, v_duree_entretien
    FROM plage_horaire_entretien
    WHERE FIND_IN_SET(v_nom_jour, jours_travail) > 0
    ORDER BY heure_debut
    LIMIT 1;
    
    -- Trouver le dernier entretien planifié pour cette date
    SELECT MAX(heure_entretien) INTO v_derniere_heure
    FROM entretien_1
    WHERE date_entretien = v_date_entretien;
    
    -- Si aucun entretien ce jour-là, commencer à la première heure
    IF v_derniere_heure IS NULL THEN
        SET v_heure_debut = v_heure_debut;
    ELSE
        -- Ajouter la durée d'un entretien à la dernière heure
        SET v_heure_debut = ADDTIME(v_derniere_heure, SEC_TO_TIME(v_duree_entretien * 60));
        
        -- Si on dépasse l'heure de fin de la plage horaire actuelle
        IF v_heure_debut >= v_heure_fin THEN
            -- Passer au jour suivant
            SET v_date_entretien = DATE_ADD(v_date_entretien, INTERVAL 1 DAY);
            
            -- S'assurer que c'est un jour ouvré
            WHILE DAYOFWEEK(v_date_entretien) IN (1, 7) DO
                SET v_date_entretien = DATE_ADD(v_date_entretien, INTERVAL 1 DAY);
            END WHILE;
            
            -- Obtenir le nom du jour
            SET v_nom_jour = CASE DAYOFWEEK(v_date_entretien)
                WHEN 2 THEN 'Lundi'
                WHEN 3 THEN 'Mardi'
                WHEN 4 THEN 'Mercredi'
                WHEN 5 THEN 'Jeudi'
                WHEN 6 THEN 'Vendredi'
                ELSE 'Samedi'
            END;
            
            -- Trouver la première plage horaire du nouveau jour
            SELECT heure_debut INTO v_heure_debut
            FROM plage_horaire_entretien
            WHERE FIND_IN_SET(v_nom_jour, jours_travail) > 0
            ORDER BY heure_debut
            LIMIT 1;
        END IF;
    END IF;
    
    -- Retourner le datetime combiné
    RETURN TIMESTAMP(v_date_entretien, v_heure_debut);
END$$
DELIMITER ;

-- 3. Trouver le prochain utilisateur RH disponible
DELIMITER $$
CREATE FUNCTION trouver_utilisateur_rh(p_date_entretien DATE) 
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE v_id_user INT;
    DECLARE v_min_id INT;
    DECLARE v_max_id INT;
    DECLARE v_last_used_id INT;
    
    -- Trouver les IDs min et max des utilisateurs RH
    SELECT MIN(u.Id_user), MAX(u.Id_user) INTO v_min_id, v_max_id
    FROM user_ u
    JOIN departement d ON u.Id_departement = d.Id_departement
    WHERE d.departement = 'Ressources Humaines';
    
    -- Trouver le dernier utilisateur qui a eu un entretien à cette date
    SELECT Id_user INTO v_last_used_id
    FROM entretien_1
    WHERE date_entretien = p_date_entretien
    ORDER BY Id_entretien_ DESC
    LIMIT 1;
    
    -- Si aucun utilisateur n'a été utilisé cette date, commencer par le premier
    IF v_last_used_id IS NULL THEN
        SET v_id_user = v_min_id;
    ELSE
        -- Passer à l'utilisateur suivant
        SET v_id_user = v_last_used_id + 1;
        
        -- Si on dépasse le max, revenir au premier
        IF v_id_user > v_max_id THEN
            SET v_id_user = v_min_id;
        END IF;
    END IF;
    
    RETURN v_id_user;
END$$
DELIMITER ;

-- Supprimer la procédure existante
DROP PROCEDURE IF EXISTS planifier_entretien_apres_qcm;

-- Recréer la procédure sans retourner de résultat (pour usage dans l'application)
DELIMITER $$
CREATE PROCEDURE planifier_entretien_apres_qcm(IN p_id_candidat INT, IN p_id_qcm INT)
BEGIN
    DECLARE v_est_reussi BOOLEAN;
    DECLARE v_date_entretien DATETIME;
    DECLARE v_id_user INT;
    DECLARE v_id_entretien INT;
    DECLARE v_date_reponse TIMESTAMP;
    
    -- Vérifier si le candidat a réussi le QCM
    SET v_est_reussi = verifier_reussite_qcm(p_id_candidat, p_id_qcm);
    
    IF v_est_reussi THEN
        -- Récupérer la date de réponse pour calculer la date d'entretien
        SELECT date_reponse INTO v_date_reponse
        FROM resultat_qcm
        WHERE Id_candidat = p_id_candidat AND Id_qcm = p_id_qcm
        ORDER BY date_reponse DESC LIMIT 1;
        
        -- Trouver le prochain créneau disponible (5 jours après)
        SET v_date_entretien = trouver_creneau_disponible(DATE(v_date_reponse));
        
        -- Trouver le prochain utilisateur RH disponible
        SET v_id_user = trouver_utilisateur_rh(DATE(v_date_entretien));
        
        -- Insérer l'entretien
        INSERT INTO entretien_1 (date_entretien, heure_entretien, Id_candidat, Id_user)
        VALUES (DATE(v_date_entretien), TIME(v_date_entretien), p_id_candidat, v_id_user);
        
        -- Mettre à jour l'état du candidat (état "Entretien programmé" = 7)
        UPDATE candidat SET Id_etat_candidat = 7 WHERE Id_candidat = p_id_candidat;
        
        -- Ajouter une entrée dans l'historique des états
        INSERT INTO historique_etat (date_changement, Id_candidat, Id_etat_candidat)
        VALUES (NOW(), p_id_candidat, 7);
    END IF;
END$$
DELIMITER ;


-- Supprimer le déclencheur existant s'il existe
DROP TRIGGER IF EXISTS after_resultat_qcm_insert;

-- Recréer le déclencheur sans appeler la procédure qui retourne un résultat
DELIMITER $$
CREATE TRIGGER after_resultat_qcm_insert
AFTER INSERT ON resultat_qcm
FOR EACH ROW
BEGIN
    -- Vérifier si le pourcentage est >= 50% ET si l'entretien n'a pas déjà été planifié
    IF NEW.pourcentage >= 50 AND NOT EXISTS (
        SELECT 1 FROM entretien_1 WHERE Id_candidat = NEW.Id_candidat
    ) THEN
        -- Mettre à jour l'état du candidat directement (état "En attente entretien" = 6)
        UPDATE candidat SET Id_etat_candidat = 6 WHERE Id_candidat = NEW.Id_candidat;
        
        -- Ajouter une entrée dans l'historique des états
        INSERT INTO historique_etat (date_changement, Id_candidat, Id_etat_candidat)
        VALUES (NOW(), NEW.Id_candidat, 6);
        
        -- Note: La planification effective de l'entretien se fera via un job batch
        -- ou sera déclenchée manuellement pour éviter les problèmes dans le trigger
    END IF;
END$$
DELIMITER ;


