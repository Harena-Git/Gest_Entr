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


DROP FUNCTION IF EXISTS trouver_creneau_disponible;

DELIMITER $$
CREATE FUNCTION trouver_creneau_disponible(p_id_candidat INT, p_date_reussite DATE) 
RETURNS DATETIME
READS SQL DATA
BEGIN
    DECLARE v_derniere_date_entretien DATE;
    DECLARE v_date_entretien DATE;
    DECLARE v_heure_entretien TIME;
    DECLARE v_creneau_trouve BOOLEAN DEFAULT FALSE;
    
    -- 1. Trouver la dernière date d'entretien planifiée dans le système
    SELECT MAX(date_entretien) INTO v_derniere_date_entretien
    FROM entretien_1
    WHERE date_entretien >= CURDATE();
    
    -- 2. Si aucune entretien planifié OU si la dernière date est antérieure à la réussite du candidat
    IF v_derniere_date_entretien IS NULL OR v_derniere_date_entretien < p_date_reussite THEN
        -- Utiliser la date par défaut (5 jours après la réussite)
        SET v_date_entretien = DATE_ADD(p_date_reussite, INTERVAL 5 DAY);
        SET v_date_entretien = trouver_prochain_jour_ouvrable(v_date_entretien);
    ELSE
        -- 3. La dernière date d'entretien est POSTERIEURE à la réussite du candidat
        -- Vérifier s'il reste des créneaux disponibles sur cette date
        IF existe_creneau_sur_date(v_derniere_date_entretien) THEN
            SET v_date_entretien = v_derniere_date_entretien;
            SET v_creneau_trouve = TRUE;
        ELSE
            -- 4. Si la dernière date est complète, prendre la date par défaut
            SET v_date_entretien = DATE_ADD(p_date_reussite, INTERVAL 5 DAY);
            SET v_date_entretien = trouver_prochain_jour_ouvrable(v_date_entretien);
        END IF;
    END IF;
    
    -- 5. Trouver l'heure précise du créneau
    SET v_heure_entretien = trouver_prochaine_heure_disponible(v_date_entretien);
    
    RETURN TIMESTAMP(v_date_entretien, v_heure_entretien);
END$$
DELIMITER ;

DELIMITER $$
CREATE FUNCTION trouver_prochain_jour_ouvrable(p_date DATE) 
RETURNS DATE
READS SQL DATA
BEGIN
    DECLARE v_date_result DATE;
    
    SET v_date_result = p_date;
    
    -- Avancer d'un jour jusqu'à trouver un jour ouvrable (lundi-vendredi)
    WHILE DAYOFWEEK(v_date_result) IN (1, 7) DO
        SET v_date_result = DATE_ADD(v_date_result, INTERVAL 1 DAY);
    END WHILE;
    
    RETURN v_date_result;
END$$
DELIMITER ;

DELIMITER $$
CREATE FUNCTION existe_creneau_sur_date(p_date DATE) 
RETURNS BOOLEAN
READS SQL DATA
BEGIN
    DECLARE v_nom_jour VARCHAR(20);
    DECLARE v_plages_count INT;
    DECLARE v_entretiens_count INT;
    DECLARE v_duree_entretien INT;
    DECLARE v_plage_minutes INT;
    DECLARE v_capacite_max INT;
    
    -- Obtenir le nom du jour
    SET v_nom_jour = CASE DAYOFWEEK(p_date)
        WHEN 2 THEN 'Lundi'
        WHEN 3 THEN 'Mardi'
        WHEN 4 THEN 'Mercredi'
        WHEN 5 THEN 'Jeudi'
        WHEN 6 THEN 'Vendredi'
        ELSE NULL
    END;
    
    -- Si ce n'est pas un jour ouvrable, retourner FALSE
    IF v_nom_jour IS NULL THEN
        RETURN FALSE;
    END IF;
    
    -- Compter le nombre d'entretiens déjà planifiés ce jour-là
    SELECT COUNT(*) INTO v_entretiens_count
    FROM entretien_1
    WHERE date_entretien = p_date;
    
    -- Calculer la capacité maximale pour ce jour
    SELECT SUM(TIMESTAMPDIFF(MINUTE, heure_debut, heure_fin) / duree_entretien_minutes)
    INTO v_capacite_max
    FROM plage_horaire_entretien
    WHERE FIND_IN_SET(v_nom_jour, jours_travail) > 0;
    
    -- S'il reste de la place, retourner TRUE
    IF v_entretiens_count < v_capacite_max THEN
        RETURN TRUE;
    END IF;
    
    RETURN FALSE;
END$$
DELIMITER ;

DELIMITER $$
CREATE FUNCTION trouver_prochaine_heure_disponible(p_date DATE) 
RETURNS TIME
READS SQL DATA
BEGIN
    DECLARE v_nom_jour VARCHAR(20);
    DECLARE v_derniere_heure TIME;
    DECLARE v_heure_debut TIME;
    DECLARE v_heure_fin TIME;
    DECLARE v_duree_entretien INT;
    DECLARE v_nouvelle_heure TIME;
    
    -- Obtenir le nom du jour
    SET v_nom_jour = CASE DAYOFWEEK(p_date)
        WHEN 2 THEN 'Lundi'
        WHEN 3 THEN 'Mardi'
        WHEN 4 THEN 'Mercredi'
        WHEN 5 THEN 'Jeudi'
        WHEN 6 THEN 'Vendredi'
        ELSE NULL
    END;
    
    -- Trouver la dernière heure d'entretien de la journée
    SELECT MAX(heure_entretien) INTO v_derniere_heure
    FROM entretien_1
    WHERE date_entretien = p_date;
    
    -- Si aucun entretien ce jour-là, commencer à la première heure de la première plage
    IF v_derniere_heure IS NULL THEN
        SELECT heure_debut INTO v_heure_debut
        FROM plage_horaire_entretien
        WHERE FIND_IN_SET(v_nom_jour, jours_travail) > 0
        ORDER BY heure_debut
        LIMIT 1;
        
        RETURN v_heure_debut;
    END IF;
    
    -- Trouver la plage horaire active à cette heure
    SELECT pl.heure_debut, pl.heure_fin, pl.duree_entretien_minutes
    INTO v_heure_debut, v_heure_fin, v_duree_entretien
    FROM plage_horaire_entretien pl
    WHERE FIND_IN_SET(v_nom_jour, jours_travail) > 0
    AND v_derniere_heure BETWEEN pl.heure_debut AND pl.heure_fin;
    
    -- Calculer la nouvelle heure (dernière heure + durée entretien)
    SET v_nouvelle_heure = ADDTIME(v_derniere_heure, SEC_TO_TIME(v_duree_entretien * 60));
    
    -- Vérifier si on est toujours dans la même plage horaire
    IF v_nouvelle_heure <= v_heure_fin THEN
        RETURN v_nouvelle_heure;
    ELSE
        -- Passer à la plage horaire suivante
        SELECT heure_debut INTO v_heure_debut
        FROM plage_horaire_entretien
        WHERE FIND_IN_SET(v_nom_jour, jours_travail) > 0
        AND heure_debut > v_heure_fin
        ORDER BY heure_debut
        LIMIT 1;
        
        -- Si une autre plage existe dans la journée, l'utiliser
        IF v_heure_debut IS NOT NULL THEN
            RETURN v_heure_debut;
        ELSE
            -- Sinon, retourner NULL (doit être géré par l'appelant)
            RETURN NULL;
        END IF;
    END IF;
END$$
DELIMITER ;

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


DROP PROCEDURE IF EXISTS planifier_entretien_apres_qcm;

DELIMITER $$
CREATE PROCEDURE planifier_entretien_apres_qcm(IN p_id_candidat INT, IN p_id_qcm INT)
BEGIN
    DECLARE v_date_entretien DATETIME;
    DECLARE v_id_user INT;
    DECLARE v_date_reponse TIMESTAMP;
    
    -- NE PAS refaire la vérification de réussite ici
    -- Supprimer: SET v_est_reussi = verifier_reussite_qcm(p_id_candidat, p_id_qcm);
    
    -- Récupérer directement la date de réponse
    SELECT date_reponse INTO v_date_reponse
    FROM resultat_qcm
    WHERE Id_candidat = p_id_candidat AND Id_qcm = p_id_qcm
    ORDER BY date_reponse DESC LIMIT 1;
    
    -- Trouver le créneau disponible
    SET v_date_entretien = trouver_creneau_disponible(p_id_candidat, DATE(v_date_reponse));
    
    -- Trouver l'utilisateur RH
    SET v_id_user = trouver_utilisateur_rh(DATE(v_date_entretien));
    
    -- Insérer l'entretien
    INSERT INTO entretien_1 (date_entretien, heure_entretien, Id_candidat, Id_user)
    VALUES (DATE(v_date_entretien), TIME(v_date_entretien), p_id_candidat, v_id_user);
    
    -- Mettre à jour l'état du candidat
    UPDATE candidat SET Id_etat_candidat = 3 WHERE Id_candidat = p_id_candidat;
    
    -- Historique
    INSERT INTO historique_etat (date_changement, Id_candidat, Id_etat_candidat)
    VALUES (NOW(), p_id_candidat, 3);
END$$
DELIMITER ;

DROP TRIGGER IF EXISTS after_reponse_insert_auto_eval;
DELIMITER $$
CREATE TRIGGER after_reponse_insert_auto_eval
AFTER INSERT ON reponse
FOR EACH ROW
BEGIN
    DECLARE v_nb_questions_specifiques INT DEFAULT 0;
    DECLARE v_nb_questions_generales INT DEFAULT 0;
    DECLARE v_nb_questions_total INT DEFAULT 0;
    DECLARE v_nb_bonnes_reponses INT DEFAULT 0;
    DECLARE v_pourcentage DOUBLE DEFAULT 0;
    DECLARE v_seuil_reussite DOUBLE DEFAULT 50;
    DECLARE v_qcm_id INT;
    DECLARE v_total_reponses INT DEFAULT 0;
    DECLARE v_continue BOOLEAN DEFAULT TRUE;

    -- Trouver l'ID du QCM - VERSION CORRIGÉE
    BEGIN
        DECLARE EXIT HANDLER FOR NOT FOUND
        BEGIN
            -- Au lieu d'une valeur fixe, prendre le premier QCM existant
            SELECT Id_qcm INTO v_qcm_id FROM qcm ORDER BY Id_qcm LIMIT 1;
            -- Si toujours pas trouvé, utiliser NULL et arrêter
            IF v_qcm_id IS NULL THEN
                SET v_continue = FALSE;
            END IF;
        END;
        
        SELECT COALESCE(q.Id_qcm, 
               (SELECT Id_qcm FROM qcm ORDER BY Id_qcm LIMIT 1)) 
        INTO v_qcm_id
        FROM choix c
        LEFT JOIN question q ON c.Id_question = q.Id_question
        WHERE c.Id_choix = NEW.Id_choix
        LIMIT 1;
    END;

    -- Vérifier si on doit continuer
    IF v_continue = FALSE OR EXISTS (SELECT 1 FROM entretien_1 WHERE Id_candidat = NEW.Id_candidat) THEN
        SET v_continue = FALSE;
    END IF;

    IF v_continue = TRUE AND EXISTS (SELECT 1 FROM resultat_qcm WHERE Id_candidat = NEW.Id_candidat AND Id_qcm = v_qcm_id) THEN
        SET v_continue = FALSE;
    END IF;

    IF v_continue THEN
        -- Compter les questions spécifiques et générales SÉPARÉMENT (CORRIGÉ)
        SELECT COUNT(*) INTO v_nb_questions_specifiques
        FROM question 
        WHERE Id_qcm = v_qcm_id;

        SELECT COUNT(*) INTO v_nb_questions_generales
        FROM question_generale;

        SET v_nb_questions_total = v_nb_questions_specifiques + v_nb_questions_generales;

        -- Compter les réponses actuelles du candidat
        SELECT COUNT(*) INTO v_total_reponses
        FROM reponse r
        JOIN choix c ON r.Id_choix = c.Id_choix
        WHERE r.Id_candidat = NEW.Id_candidat
          AND (
              c.Id_question IN (SELECT Id_question FROM question WHERE Id_qcm = v_qcm_id)
              OR c.Id_question_generale IS NOT NULL
          );

        -- Vérifier si le candidat a répondu à toutes les questions
        IF v_total_reponses >= v_nb_questions_total THEN
            -- Compter les bonnes réponses
            SELECT COUNT(*) INTO v_nb_bonnes_reponses
            FROM reponse r
            JOIN choix c ON r.Id_choix = c.Id_choix
            WHERE r.Id_candidat = NEW.Id_candidat
              AND c.est_correct = 1
              AND (
                  c.Id_question IN (SELECT Id_question FROM question WHERE Id_qcm = v_qcm_id)
                  OR c.Id_question_generale IS NOT NULL
              );

            -- Calculer le pourcentage
            IF v_nb_questions_total > 0 THEN
                SET v_pourcentage = (v_nb_bonnes_reponses / v_nb_questions_total) * 100;
            END IF;

            -- Si réussi, enregistrer le résultat et planifier l'entretien
            IF v_pourcentage >= v_seuil_reussite THEN
                INSERT INTO resultat_qcm (bonnes_reponses, total_questions, pourcentage, Id_candidat, Id_qcm, est_reussi, date_reponse)
                VALUES (v_nb_bonnes_reponses, v_nb_questions_total, v_pourcentage, NEW.Id_candidat, v_qcm_id, 1, NOW());

                IF EXISTS (SELECT 1 FROM information_schema.ROUTINES WHERE ROUTINE_NAME = 'planifier_entretien_apres_qcm') THEN
                    CALL planifier_entretien_apres_qcm(NEW.Id_candidat, v_qcm_id);
                END IF;
            END IF;

            IF v_pourcentage < v_seuil_reussite THEN
                INSERT INTO resultat_qcm (bonnes_reponses, total_questions, pourcentage, Id_candidat, Id_qcm, est_reussi, date_reponse)
                VALUES (v_nb_bonnes_reponses, v_nb_questions_total, v_pourcentage, NEW.Id_candidat, v_qcm_id, 0, NOW());
            END IF;
        END IF;
    END IF;

END$$

DELIMITER ;


-- DELIMITER $$
-- CREATE TRIGGER after_reponse_insert_auto_eval
-- AFTER INSERT ON reponse
-- FOR EACH ROW
-- BEGIN
--     DECLARE v_nb_questions INT DEFAULT 0;
--     DECLARE v_nb_bonnes_reponses INT DEFAULT 0;
--     DECLARE v_pourcentage DOUBLE DEFAULT 0;
--     DECLARE v_seuil_reussite DOUBLE DEFAULT 50;
--     DECLARE v_qcm_id INT;
--     DECLARE v_total_reponses INT DEFAULT 0;
--     DECLARE v_continue BOOLEAN DEFAULT TRUE;

--     -- Trouver l'ID du QCM
--     BEGIN
--         DECLARE EXIT HANDLER FOR NOT FOUND
--         BEGIN
--             SET v_qcm_id = 999; -- QCM par défaut pour les tests
--         END;
        
--         SELECT COALESCE(q.Id_qcm, 999) INTO v_qcm_id
--         FROM choix c
--         LEFT JOIN question q ON c.Id_question = q.Id_question
--         WHERE c.Id_choix = NEW.Id_choix
--         LIMIT 1;
--     END;

--     -- Vérifier si on doit continuer (pas d'entretien existant)
--     IF EXISTS (SELECT 1 FROM entretien_1 WHERE Id_candidat = NEW.Id_candidat) THEN
--         SET v_continue = FALSE;
--     END IF;

--     -- Vérifier si résultat existe déjà
--     IF EXISTS (SELECT 1 FROM resultat_qcm WHERE Id_candidat = NEW.Id_candidat AND Id_qcm = v_qcm_id) THEN
--         SET v_continue = FALSE;
--     END IF;

--     IF v_continue THEN
--         -- Compter le total de questions (spécifiques + générales)
--         SELECT COUNT(*) INTO v_nb_questions
--         FROM (
--             SELECT Id_question FROM question WHERE Id_qcm = v_qcm_id
--             UNION 
--             SELECT Id_question_generale FROM question_generale
--         ) AS total_questions;

--         -- Compter les réponses actuelles du candidat
--         SELECT COUNT(*) INTO v_total_reponses
--         FROM reponse r
--         JOIN choix c ON r.Id_choix = c.Id_choix
--         WHERE r.Id_candidat = NEW.Id_candidat
--           AND (
--               c.Id_question IN (SELECT Id_question FROM question WHERE Id_qcm = v_qcm_id)
--               OR c.Id_question_generale IS NOT NULL
--           );

--         -- Vérifier si le candidat a répondu à toutes les questions
--         IF v_total_reponses >= v_nb_questions THEN
--             -- Compter les bonnes réponses
--             SELECT COUNT(*) INTO v_nb_bonnes_reponses
--             FROM reponse r
--             JOIN choix c ON r.Id_choix = c.Id_choix
--             WHERE r.Id_candidat = NEW.Id_candidat
--               AND c.est_correct = 1
--               AND (
--                   c.Id_question IN (SELECT Id_question FROM question WHERE Id_qcm = v_qcm_id)
--                   OR c.Id_question_generale IS NOT NULL
--               );

--             -- Calculer le pourcentage
--             IF v_nb_questions > 0 THEN
--                 SET v_pourcentage = (v_nb_bonnes_reponses / v_nb_questions) * 100;
--             END IF;

--             -- Si réussi, enregistrer le résultat et planifier l'entretien
--             IF v_pourcentage >= v_seuil_reussite THEN
--                 -- Insérer le résultat
--                 INSERT INTO resultat_qcm (bonnes_reponses, total_questions, pourcentage, Id_candidat, Id_qcm, est_reussi, date_reponse)
--                 VALUES (v_nb_bonnes_reponses, v_nb_questions, v_pourcentage, NEW.Id_candidat, v_qcm_id, 1, NOW());

--                 -- Planifier l'entretien (si la procédure existe)
--                 IF EXISTS (SELECT 1 FROM information_schema.ROUTINES WHERE ROUTINE_NAME = 'planifier_entretien_apres_qcm') THEN
--                     CALL planifier_entretien_apres_qcm(NEW.Id_candidat, v_qcm_id);
--                 END IF;
--             END IF;

--             IF v_pourcentage < v_seuil_reussite THEN
--                 -- Insérer le résultat d'échec
--                 INSERT INTO resultat_qcm (bonnes_reponses, total_questions, pourcentage, Id_candidat, Id_qcm, est_reussi, date_reponse)
--                 VALUES (v_nb_bonnes_reponses, v_nb_questions, v_pourcentage, NEW.Id_candidat, v_qcm_id, 0, NOW());
--             END IF;
--         END IF;
--     END IF;

-- END$$

-- DELIMITER ;

-- par jour je crois
-- DROP FUNCTION IF EXISTS trouver_utilisateur_rh;

-- DELIMITER $$
-- CREATE FUNCTION trouver_utilisateur_rh(p_date_entretien DATE) 
-- RETURNS INT
-- READS SQL DATA
-- BEGIN
--     DECLARE v_id_user INT;
--     DECLARE v_min_id INT;
--     DECLARE v_max_id INT;
--     DECLARE v_total_rh INT;
--     DECLARE v_jour_index INT;
    
--     -- Trouver les IDs min et max des utilisateurs RH
--     SELECT MIN(u.Id_user), MAX(u.Id_user), COUNT(*) 
--     INTO v_min_id, v_max_id, v_total_rh
--     FROM user_ u
--     JOIN departement d ON u.Id_departement = d.Id_departement
--     WHERE d.departement = 'Ressources Humaines';
    
--     -- Si aucun RH trouvé, retourner une valeur par défaut
--     IF v_total_rh = 0 THEN
--         RETURN NULL;
--     END IF;
    
--     -- Calculer un index basé sur la date (pour alterner les jours)
--     -- Utiliser le jour de l'année modulo le nombre de RH
--     SET v_jour_index = DAYOFYEAR(p_date_entretien) % v_total_rh;
    
--     -- Ajuster l'index pour qu'il commence à 0
--     SET v_jour_index = IF(v_jour_index = 0, v_total_rh, v_jour_index);
    
--     -- Calculer l'ID utilisateur : min_id + index
--     SET v_id_user = v_min_id + (v_jour_index - 1);
    
--     -- S'assurer qu'on ne dépasse pas le max
--     IF v_id_user > v_max_id THEN
--         SET v_id_user = v_max_id;
--     END IF;
    
--     RETURN v_id_user;
-- END$$
-- DELIMITER ;