-- MySQL-compatible schema for leave (congé) management
-- Focus: tables required for congé workflow (departement, poste, user_, candidat, personnel,
-- statut_demande, decision_validation, solde_conge, demande_conge, validation_conge_chef,
-- validation_conge_rh, remplacement)

SET FOREIGN_KEY_CHECKS = 0;

CREATE DATABASE IF NOT EXISTS `gestion` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `gestion`;

-- departement
CREATE TABLE IF NOT EXISTS departement (
  Id_departement INT AUTO_INCREMENT,
  departement VARCHAR(50),
  PRIMARY KEY (Id_departement)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- role
CREATE TABLE IF NOT EXISTS `role` (
  Id_role INT AUTO_INCREMENT,
  libelle VARCHAR(50) NOT NULL,
  PRIMARY KEY (Id_role),
  UNIQUE KEY uk_role_libelle (libelle)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- user_ (utilisateurs pour login/chef/rh)
CREATE TABLE IF NOT EXISTS `user_` (
  Id_user INT AUTO_INCREMENT,
  nom VARCHAR(50) NOT NULL,
  mot_de_passe VARCHAR(250) NOT NULL,
  Id_departement INT NOT NULL,
  Id_role INT NOT NULL,
  PRIMARY KEY (Id_user),
  UNIQUE KEY uk_user_nom (nom),
  CONSTRAINT fk_user_dept FOREIGN KEY (Id_departement) REFERENCES departement(Id_departement) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_user_role FOREIGN KEY (Id_role) REFERENCES `role`(Id_role) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- candidat (minimal)
CREATE TABLE IF NOT EXISTS candidat (
  Id_candidat INT AUTO_INCREMENT,
  nom VARCHAR(100) NOT NULL,
  prenom VARCHAR(100) NOT NULL,
  email VARCHAR(150) NOT NULL,
  date_candidature DATE,
  Id_lieu INT,
  Id_etat_candidat INT,
  PRIMARY KEY (Id_candidat),
  UNIQUE KEY uk_candidat_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- poste
CREATE TABLE IF NOT EXISTS poste (
  Id_poste INT AUTO_INCREMENT,
  libelle VARCHAR(50),
  salaire INT,
  Id_departement INT NOT NULL,
  PRIMARY KEY (Id_poste),
  CONSTRAINT fk_poste_dept FOREIGN KEY (Id_departement) REFERENCES departement(Id_departement) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- personnel
CREATE TABLE IF NOT EXISTS personnel (
  Id_personnel INT AUTO_INCREMENT,
  date_embauche DATE NOT NULL,
  actif BOOLEAN DEFAULT TRUE,
  Id_candidat INT NOT NULL,
  Id_poste INT NOT NULL,
  PRIMARY KEY (Id_personnel),
  UNIQUE KEY uk_personnel_candidat (Id_candidat),
  CONSTRAINT fk_personnel_candidat FOREIGN KEY (Id_candidat) REFERENCES candidat(Id_candidat) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_personnel_poste FOREIGN KEY (Id_poste) REFERENCES poste(Id_poste) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- statut_demande
CREATE TABLE IF NOT EXISTS statut_demande (
  Id_statut_demande INT AUTO_INCREMENT,
  libelle VARCHAR(50),
  PRIMARY KEY (Id_statut_demande),
  UNIQUE KEY uk_statut_libelle (libelle)
) ;

-- decision_validation
CREATE TABLE IF NOT EXISTS decision_validation (
  Id_decision_validation INT AUTO_INCREMENT,
  libelle VARCHAR(50),
  PRIMARY KEY (Id_decision_validation),
  UNIQUE KEY uk_decision_libelle (libelle)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- solde_conge
CREATE TABLE IF NOT EXISTS solde_conge (
  Id_solde_conge INT AUTO_INCREMENT,
  solde_annuel INT NOT NULL DEFAULT 25,
  solde_restant INT NOT NULL DEFAULT 25,
  date_initialisation DATETIME DEFAULT CURRENT_TIMESTAMP,
  date_renouvellement DATE NULL,
  Id_personnel INT NOT NULL,
  PRIMARY KEY (Id_solde_conge),
  UNIQUE KEY uk_solde_personnel (Id_personnel),
  CONSTRAINT fk_solde_personnel FOREIGN KEY (Id_personnel) REFERENCES personnel(Id_personnel) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- demande_conge
CREATE TABLE IF NOT EXISTS demande_conge (
  Id_demande_conge INT AUTO_INCREMENT,
  date_demande DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  date_debut DATE NOT NULL,
  date_fin DATE NOT NULL,
  nombre_jours INT NOT NULL,
  motif VARCHAR(255),
  Id_personnel INT NOT NULL,
  Id_statut_demande INT NOT NULL,
  PRIMARY KEY (Id_demande_conge),
  CONSTRAINT fk_demande_personnel FOREIGN KEY (Id_personnel) REFERENCES personnel(Id_personnel) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_demande_statut FOREIGN KEY (Id_statut_demande) REFERENCES statut_demande(Id_statut_demande) ON DELETE RESTRICT ON UPDATE CASCADE,
  CHECK (date_fin >= date_debut),
  CHECK (nombre_jours > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- validation_conge_chef
CREATE TABLE IF NOT EXISTS validation_conge_chef (
  Id_validation_conge_chef INT AUTO_INCREMENT,
  date_validation DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  commentaire VARCHAR(255),
  Id_user INT NOT NULL,
  Id_demande_conge INT NOT NULL,
  Id_decision_validation INT NOT NULL,
  PRIMARY KEY (Id_validation_conge_chef),
  UNIQUE KEY uk_valchef_demande (Id_demande_conge),
  CONSTRAINT fk_valchef_user FOREIGN KEY (Id_user) REFERENCES user_(Id_user) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_valchef_demande FOREIGN KEY (Id_demande_conge) REFERENCES demande_conge(Id_demande_conge) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_valchef_decision FOREIGN KEY (Id_decision_validation) REFERENCES decision_validation(Id_decision_validation) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- validation_conge_rh
CREATE TABLE IF NOT EXISTS validation_conge_rh (
  Id_validation_conge_RH INT AUTO_INCREMENT,
  date_validation DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  commentaire VARCHAR(255),
  Id_validation_conge_chef INT NOT NULL,
  Id_user INT NOT NULL,
  Id_decision_validation INT NOT NULL,
  PRIMARY KEY (Id_validation_conge_RH),
  UNIQUE KEY uk_valrh_valchef (Id_validation_conge_chef),
  CONSTRAINT fk_valrh_valchef FOREIGN KEY (Id_validation_conge_chef) REFERENCES validation_conge_chef(Id_validation_conge_chef) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_valrh_user FOREIGN KEY (Id_user) REFERENCES user_(Id_user) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_valrh_decision FOREIGN KEY (Id_decision_validation) REFERENCES decision_validation(Id_decision_validation) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- remplacement
CREATE TABLE IF NOT EXISTS remplacement (
  Id_remplacement INT AUTO_INCREMENT,
  date_creation DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  remplacant_accepte BOOLEAN DEFAULT FALSE,
  notifiee BOOLEAN DEFAULT FALSE,
  commentaire_remplacant VARCHAR(255),
  Id_personnel INT NOT NULL,
  Id_demande_conge INT NOT NULL,
  PRIMARY KEY (Id_remplacement),
  UNIQUE KEY uk_remplacement_demande (Id_demande_conge),
  CONSTRAINT fk_rempl_personnel FOREIGN KEY (Id_personnel) REFERENCES personnel(Id_personnel) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_rempl_demande FOREIGN KEY (Id_demande_conge) REFERENCES demande_conge(Id_demande_conge) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

SET FOREIGN_KEY_CHECKS = 1;

-- End of conge_mysql.sql
