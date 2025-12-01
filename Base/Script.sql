CREATE DATABASE Gestion_entreprise ;
use Gestion_entreprise ;
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
   competences_personnelles TEXT,
   genre VARCHAR(10),
   date_naissance DATE,
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
   actif BOOLEAN,
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

CREATE TABLE parcours_professionel(
   Id_parcours_professionel INT AUTO_INCREMENT,
   entreprise VARCHAR(50),
   poste VARCHAR(50),
   date_debut DATE,
   date_fin DATE,
   Id_candidat INT NOT NULL,
   PRIMARY KEY(Id_parcours_professionel),
   FOREIGN KEY(Id_candidat) REFERENCES candidat(Id_candidat)
);

CREATE TABLE qcm(
   Id_qcm INT AUTO_INCREMENT,
   titre VARCHAR(50),
   description TEXT,
   Id_poste INT NOT NULL,
   PRIMARY KEY(Id_qcm),
   UNIQUE(Id_poste),
   FOREIGN KEY(Id_poste) REFERENCES poste(Id_poste)
);

CREATE TABLE question(
   Id_question INT AUTO_INCREMENT,
   libelle TEXT,
   Id_qcm INT NOT NULL,
   PRIMARY KEY(Id_question),
   FOREIGN KEY(Id_qcm) REFERENCES qcm(Id_qcm)
);

CREATE TABLE choix(
   Id_choix INT AUTO_INCREMENT,
   libelle VARCHAR(50),
   est_correct BOOLEAN,
   Id_question_generale INT NOT NULL,
   Id_question INT NOT NULL,
   PRIMARY KEY(Id_choix),
   UNIQUE(Id_question_generale),
   UNIQUE(Id_question),
   FOREIGN KEY(Id_question_generale) REFERENCES question_generale(Id_question_generale),
   FOREIGN KEY(Id_question) REFERENCES question(Id_question)
);

CREATE TABLE reponse(
   Id_reponse INT AUTO_INCREMENT,
   Id_candidat INT NOT NULL,
   Id_choix INT NOT NULL,
   PRIMARY KEY(Id_reponse),
   UNIQUE(Id_choix),
   FOREIGN KEY(Id_candidat) REFERENCES candidat(Id_candidat),
   FOREIGN KEY(Id_choix) REFERENCES choix(Id_choix)
);

   INSERT INTO reponse (id_candidat, id_choix)
   VALUES (11, 5);

CREATE TABLE resultat_qcm(
   Id_resultat_qcm INT AUTO_INCREMENT,
   bonnes_reponses INT,
   total_questions INT,
   pourcentage DECIMAL(15,2),
   Id_candidat INT NOT NULL,
   Id_qcm INT NOT NULL,
   PRIMARY KEY(Id_resultat_qcm),
   UNIQUE(Id_qcm),
   FOREIGN KEY(Id_candidat) REFERENCES candidat(Id_candidat),
   FOREIGN KEY(Id_qcm) REFERENCES qcm(Id_qcm)
);

CREATE TABLE entretien_1(
   Id_entretien_ INT AUTO_INCREMENT,
   date_entretien DATE,
   Id_user INT NOT NULL,
   PRIMARY KEY(Id_entretien_),
   FOREIGN KEY(Id_user) REFERENCES user_(Id_user)
);

CREATE TABLE evaluation_entretien_1(
   Id_evaluation_entretien_1 INT AUTO_INCREMENT,
   presence BOOLEAN,
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
   PRIMARY KEY(Id_entretien_2),
   UNIQUE(Id_entretien_),
   FOREIGN KEY(Id_user) REFERENCES user_(Id_user),
   FOREIGN KEY(Id_entretien_) REFERENCES entretien_1(Id_entretien_)
);

CREATE TABLE evaluation_entretien_2(
   Id_evaluation_appreciation_2 INT AUTO_INCREMENT,
   presence BOOLEAN,
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
   date_fin DATE,
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
   annee_experience INT,
   Id_lieu INT NOT NULL,
   Id_diplome INT NOT NULL,
   PRIMARY KEY(Id_profil),
   FOREIGN KEY(Id_lieu) REFERENCES lieu(Id_lieu),
   FOREIGN KEY(Id_diplome) REFERENCES diplome(Id_diplome)
);

CREATE TABLE annonce(
   Id_annonce INT AUTO_INCREMENT,
   date_annonce DATE,
   responsabilite TEXT,
   date_fin DATE,
   Id_poste INT NOT NULL,
   Id_profil INT NOT NULL,
   PRIMARY KEY(Id_annonce),
   FOREIGN KEY(Id_poste) REFERENCES poste(Id_poste),
   FOREIGN KEY(Id_profil) REFERENCES profil(Id_profil)
);

SELECT COALESCE(q.Id_qcm, (SELECT Id_qcm FROM qcm ORDER BY Id_qcm LIMIT 1)) AS v_qcm_id
FROM choix c
LEFT JOIN question q ON c.Id_question = q.Id_question
WHERE c.Id_choix = 8
LIMIT 1;

SELECT COUNT(*) AS nb_questions_specifiques
FROM question 
WHERE Id_qcm = 1;  -- remplace par le v_qcm_id trouvé à l'étape 1

CREATE TABLE demande_conge (
   Id_demande INT AUTO_INCREMENT PRIMARY KEY,
   Id_personnel INT NOT NULL,
   Id_type_conge INT NOT NULL,
   Id_statut_conge INT NOT NULL DEFAULT 1, -- 1 = EN_ATTENTE
   
   date_demande DATETIME DEFAULT CURRENT_TIMESTAMP,
   date_debut DATE NOT NULL,
   date_fin DATE NOT NULL,
   nb_jours INT AS (DATEDIFF(date_fin, date_debut) + 1) STORED,
   
   motif TEXT NOT NULL,
   date_decision DATETIME NULL,
   decide_par INT NULL,
   
   -- Contraintes de clé étrangère
   FOREIGN KEY (Id_personnel) REFERENCES personnel(Id_personnel),
   FOREIGN KEY (Id_type_conge) REFERENCES type_conge(Id_type_conge),
   FOREIGN KEY (Id_statut_conge) REFERENCES statut_conge(Id_statut_conge),
   FOREIGN KEY (decide_par) REFERENCES user_(Id_user),
   
   -- Contrainte pour vérifier les dates
   CONSTRAINT chk_dates CHECK (date_fin >= date_debut)
);

-- Table type_conge
CREATE TABLE IF NOT EXISTS type_conge (
   Id_type_conge INT AUTO_INCREMENT,
   libelle VARCHAR(100) NOT NULL,
   description TEXT,
   PRIMARY KEY(Id_type_conge)
);

CREATE TABLE IF NOT EXISTS statut_conge (
   Id_statut_conge INT AUTO_INCREMENT,
   libelle VARCHAR(50) NOT NULL,
   couleur VARCHAR(20) DEFAULT '#6c757d',
   PRIMARY KEY(Id_statut_conge),
   UNIQUE(libelle)
);

-- Ajout de la table pour le solde de congés
CREATE TABLE solde_conge (
   Id_solde INT AUTO_INCREMENT,
   Id_personnel INT NOT NULL,
   annee INT NOT NULL,
   jours_acquis DECIMAL(5,2) DEFAULT 30.00,
   jours_restants DECIMAL(5,2) DEFAULT 30.00,
   jours_pris DECIMAL(5,2) DEFAULT 0.00,
   PRIMARY KEY(Id_solde),
   UNIQUE KEY unique_solde_annee (Id_personnel, annee),
   FOREIGN KEY (Id_personnel) REFERENCES personnel(Id_personnel)
);

-- Table pour les remplacements
CREATE TABLE remplacement_conge (
   Id_remplacement INT AUTO_INCREMENT,
   Id_demande INT NOT NULL,
   Id_remplacant INT NOT NULL, -- Id du personnel remplaçant
   statut_remplacement VARCHAR(20) DEFAULT 'PROPOSE',
   date_proposition DATETIME DEFAULT CURRENT_TIMESTAMP,
   date_acceptation DATETIME NULL,
   PRIMARY KEY(Id_remplacement),
   FOREIGN KEY (Id_demande) REFERENCES demande_conge(Id_demande),
   FOREIGN KEY (Id_remplacant) REFERENCES personnel(Id_personnel)
);

-- Ajout d'un champ pour le solde restant dans demande_conge
ALTER TABLE demande_conge 
ADD COLUMN nb_jours_demande DECIMAL(5,2) NULL;

-- Correction: le champ nb_jours existe déjà comme colonne générée, donc on l'utilise

-- Création de la table pour les historiques de validation
CREATE TABLE historique_validation (
   Id_historique INT AUTO_INCREMENT,
   Id_demande INT NOT NULL,
   Id_validateur INT NOT NULL,
   action VARCHAR(50) NOT NULL,
   commentaire TEXT,
   date_action DATETIME DEFAULT CURRENT_TIMESTAMP,
   PRIMARY KEY(Id_historique),
   FOREIGN KEY (Id_demande) REFERENCES demande_conge(Id_demande),
   FOREIGN KEY (Id_validateur) REFERENCES user_(Id_user)
);