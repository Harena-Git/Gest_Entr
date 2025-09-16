CREATE TABLE role(
   Id_role COUNTER,
   libelle VARCHAR(50) NOT NULL,
   PRIMARY KEY(Id_role),
   UNIQUE(libelle)
);

CREATE TABLE user_(
   Id_user COUNTER,
   nom VARCHAR(50) NOT NULL,
   mot_de_passe VARCHAR(250) NOT NULL,
   Id_role INT NOT NULL,
   PRIMARY KEY(Id_user),
   UNIQUE(nom),
   FOREIGN KEY(Id_role) REFERENCES role(Id_role)
);

CREATE TABLE etat_candidat(
   Id_etat_candidat COUNTER,
   libelle VARCHAR(50) NOT NULL,
   PRIMARY KEY(Id_etat_candidat),
   UNIQUE(libelle)
);

CREATE TABLE candidat(
   Id_candidat COUNTER,
   nom VARCHAR(100) NOT NULL,
   prenom VARCHAR(100) NOT NULL,
   email VARCHAR(150) NOT NULL,
   photo TEXT,
   telephone VARCHAR(20),
   adresse TEXT,
   date_candidature DATE NOT NULL,
   annee_experience INT,
   Id_etat_candidat INT NOT NULL,
   PRIMARY KEY(Id_candidat),
   UNIQUE(email),
   FOREIGN KEY(Id_etat_candidat) REFERENCES etat_candidat(Id_etat_candidat)
);

CREATE TABLE poste(
   Id_poste COUNTER,
   libelle VARCHAR(50),
   PRIMARY KEY(Id_poste)
);

CREATE TABLE personnel(
   Id_personnel COUNTER,
   date_embauche DATE NOT NULL,
   Id_candidat INT NOT NULL,
   Id_poste INT NOT NULL,
   PRIMARY KEY(Id_personnel),
   UNIQUE(Id_candidat),
   FOREIGN KEY(Id_candidat) REFERENCES candidat(Id_candidat),
   FOREIGN KEY(Id_poste) REFERENCES poste(Id_poste)
);

CREATE TABLE historique_etat(
   Id_historique_etat COUNTER,
   date_changement VARCHAR(50),
   Id_candidat INT NOT NULL,
   Id_etat_candidat INT NOT NULL,
   PRIMARY KEY(Id_historique_etat),
   FOREIGN KEY(Id_candidat) REFERENCES candidat(Id_candidat),
   FOREIGN KEY(Id_etat_candidat) REFERENCES etat_candidat(Id_etat_candidat)
);

CREATE TABLE filiere(
   Id_filiere COUNTER,
   libelle VARCHAR(50),
   PRIMARY KEY(Id_filiere)
);

CREATE TABLE qcm(
   Id_qcm COUNTER,
   titre VARCHAR(50),
   description TEXT,
   PRIMARY KEY(Id_qcm)
);

CREATE TABLE question(
   Id_question COUNTER,
   libelle TEXT,
   Id_qcm INT NOT NULL,
   PRIMARY KEY(Id_question),
   FOREIGN KEY(Id_qcm) REFERENCES qcm(Id_qcm)
);

CREATE TABLE choix(
   Id_choix COUNTER,
   libelle VARCHAR(50),
   est_correct LOGICAL,
   Id_question INT NOT NULL,
   PRIMARY KEY(Id_choix),
   UNIQUE(Id_question),
   FOREIGN KEY(Id_question) REFERENCES question(Id_question)
);

CREATE TABLE resultat_qcm(
   Id_resultat_qcm COUNTER,
   bonnes_reponses INT,
   total_questions INT,
   pourcentage DECIMAL(15,2),
   PRIMARY KEY(Id_resultat_qcm)
);

CREATE TABLE diplome(
   Id_diplome COUNTER,
   niveau VARCHAR(50),
   Id_filiere INT NOT NULL,
   PRIMARY KEY(Id_diplome),
   FOREIGN KEY(Id_filiere) REFERENCES filiere(Id_filiere)
);

CREATE TABLE diplome_candidat(
   Id_diplome_candidat COUNTER,
   etablissement VARCHAR(150),
   annee_obtention INT,
   Id_diplome INT NOT NULL,
   Id_candidat INT NOT NULL,
   PRIMARY KEY(Id_diplome_candidat),
   FOREIGN KEY(Id_diplome) REFERENCES diplome(Id_diplome),
   FOREIGN KEY(Id_candidat) REFERENCES candidat(Id_candidat)
);

CREATE TABLE profil(
   Id_profil COUNTER,
   genre VARCHAR(50),
   age INT,
   adresse VARCHAR(50),
   annee_experience VARCHAR(50),
   Id_diplome INT NOT NULL,
   PRIMARY KEY(Id_profil),
   FOREIGN KEY(Id_diplome) REFERENCES diplome(Id_diplome)
);

CREATE TABLE annonce(
   Id_annonce COUNTER,
   date_annonce VARCHAR(50),
   Id_profil INT NOT NULL,
   PRIMARY KEY(Id_annonce),
   FOREIGN KEY(Id_profil) REFERENCES profil(Id_profil)
);

CREATE TABLE profil_qcm(
   Id_profil INT,
   Id_qcm INT,
   Id_profil_qcm COUNTER,
   PRIMARY KEY(Id_profil, Id_qcm, Id_profil_qcm),
   FOREIGN KEY(Id_profil) REFERENCES profil(Id_profil),
   FOREIGN KEY(Id_qcm) REFERENCES qcm(Id_qcm)
);

CREATE TABLE reponse(
   Id_reponse COUNTER,
   Id_profil INT NOT NULL,
   Id_question INT NOT NULL,
   Id_choix INT NOT NULL,
   PRIMARY KEY(Id_reponse),
   UNIQUE(Id_profil),
   UNIQUE(Id_question),
   UNIQUE(Id_choix),
   FOREIGN KEY(Id_profil) REFERENCES profil(Id_profil),
   FOREIGN KEY(Id_question) REFERENCES question(Id_question),
   FOREIGN KEY(Id_choix) REFERENCES choix(Id_choix)
);
