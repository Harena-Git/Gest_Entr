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

CREATE TABLE qcm(
   Id_qcm INT AUTO_INCREMENT,
   titre VARCHAR(50),
   description TEXT,
   PRIMARY KEY(Id_qcm)
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
   Id_question INT NOT NULL,
   PRIMARY KEY(Id_choix),
   FOREIGN KEY(Id_question) REFERENCES question(Id_question)
);

CREATE TABLE departement(
   Id_departement INT AUTO_INCREMENT,
   departement VARCHAR(50),
   PRIMARY KEY(Id_departement)
);

CREATE TABLE entretien_1(
   Id_entretien_ INT AUTO_INCREMENT,
   date_entretien DATE,
   Id_user INT NOT NULL,
   PRIMARY KEY(Id_entretien_),
   FOREIGN KEY(Id_user) REFERENCES user_(Id_user)
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
   niveau VARCHAR(50),
   Id_filiere INT NOT NULL,
   PRIMARY KEY(Id_diplome),
   FOREIGN KEY(Id_filiere) REFERENCES filiere(Id_filiere)
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

CREATE TABLE profil_qcm(
   Id_profil INT,
   Id_qcm INT,
   Id_profil_qcm INT AUTO_INCREMENT,
   PRIMARY KEY(Id_profil, Id_qcm, Id_profil_qcm),
   FOREIGN KEY(Id_profil) REFERENCES profil(Id_profil),
   FOREIGN KEY(Id_qcm) REFERENCES qcm(Id_qcm)
);

CREATE TABLE reponse(
   Id_reponse INT AUTO_INCREMENT,
   Id_profil INT NOT NULL,
   Id_question INT NOT NULL,
   Id_choix INT NOT NULL,
   PRIMARY KEY(Id_reponse),
   FOREIGN KEY(Id_profil) REFERENCES profil(Id_profil),
   FOREIGN KEY(Id_question) REFERENCES question(Id_question),
   FOREIGN KEY(Id_choix) REFERENCES choix(Id_choix)
);

CREATE TABLE resultat_qcm(
   Id_resultat_qcm INT AUTO_INCREMENT,
   bonnes_reponses INT,
   total_questions INT,
   pourcentage DECIMAL(15,2),
   Id_qcm INT NOT NULL,
   Id_profil INT NOT NULL,
   PRIMARY KEY(Id_resultat_qcm),
   FOREIGN KEY(Id_qcm) REFERENCES qcm(Id_qcm),
   FOREIGN KEY(Id_profil) REFERENCES profil(Id_profil)
);
