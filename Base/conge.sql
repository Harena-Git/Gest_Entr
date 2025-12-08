CREATE TABLE role(
   Id_role SERIAL,
   libelle VARCHAR(50)  NOT NULL,
   PRIMARY KEY(Id_role),
   UNIQUE(libelle)
);

CREATE TABLE etat_candidat(
   Id_etat_candidat SERIAL,
   libelle VARCHAR(50)  NOT NULL,
   PRIMARY KEY(Id_etat_candidat),
   UNIQUE(libelle)
);

CREATE TABLE filiere(
   Id_filiere SERIAL,
   libelle VARCHAR(50) ,
   PRIMARY KEY(Id_filiere)
);

CREATE TABLE qcm(
   Id_qcm SERIAL,
   titre VARCHAR(50) ,
   description TEXT,
   PRIMARY KEY(Id_qcm)
);

CREATE TABLE question(
   Id_question SERIAL,
   libelle TEXT,
   Id_qcm INTEGER NOT NULL,
   PRIMARY KEY(Id_question),
   FOREIGN KEY(Id_qcm) REFERENCES qcm(Id_qcm)
);

CREATE TABLE choix(
   Id_choix SERIAL,
   libelle VARCHAR(50) ,
   est_correct BOOLEAN,
   Id_question INTEGER NOT NULL,
   PRIMARY KEY(Id_choix),
   UNIQUE(Id_question),
   FOREIGN KEY(Id_question) REFERENCES question(Id_question)
);

CREATE TABLE departement(
   Id_departement SERIAL,
   departement VARCHAR(50) ,
   PRIMARY KEY(Id_departement)
);

CREATE TABLE appreciation(
   Id_appreciation SERIAL,
   libelle VARCHAR(50) ,
   note INTEGER,
   PRIMARY KEY(Id_appreciation)
);

CREATE TABLE lieu(
   Id_lieu SERIAL,
   lieu VARCHAR(50) ,
   PRIMARY KEY(Id_lieu)
);

CREATE TABLE type_contrat(
   Id_type_contrat SERIAL,
   libelle VARCHAR(50) ,
   PRIMARY KEY(Id_type_contrat)
);

CREATE TABLE retenus(
   Id_retenus SERIAL,
   libelle VARCHAR(50) ,
   taux NUMERIC(15,2)  ,
   plafond NUMERIC(15,2)  ,
   PRIMARY KEY(Id_retenus)
);

CREATE TABLE heures_sup_type(
   Id_heures_sup SERIAL,
   libelle VARCHAR(50) ,
   taux NUMERIC(15,2)  ,
   PRIMARY KEY(Id_heures_sup)
);

CREATE TABLE heures_supplementaire(
   Id_heures_supplementaire SERIAL,
   nb_heures INTEGER,
   montant NUMERIC(15,2)  ,
   Id_heures_sup INTEGER NOT NULL,
   PRIMARY KEY(Id_heures_supplementaire),
   FOREIGN KEY(Id_heures_sup) REFERENCES heures_sup_type(Id_heures_sup)
);

CREATE TABLE IRSA(
   Id_IRSA SERIAL,
   debut NUMERIC(15,2)  ,
   fin NUMERIC(15,2)  ,
   taux NUMERIC(15,2)  ,
   PRIMARY KEY(Id_IRSA)
);

CREATE TABLE statut_demande(
   Id_statut_demande SERIAL,
   libelle VARCHAR(50) ,
   PRIMARY KEY(Id_statut_demande)
);

CREATE TABLE decision_validation(
   Id_decision_validation SERIAL,
   libelle VARCHAR(50) ,
   PRIMARY KEY(Id_decision_validation)
);

CREATE TABLE user_(
   Id_user SERIAL,
   nom VARCHAR(50)  NOT NULL,
   mot_de_passe VARCHAR(250)  NOT NULL,
   Id_departement INTEGER NOT NULL,
   Id_role INTEGER NOT NULL,
   PRIMARY KEY(Id_user),
   UNIQUE(nom),
   FOREIGN KEY(Id_departement) REFERENCES departement(Id_departement),
   FOREIGN KEY(Id_role) REFERENCES role(Id_role)
);

CREATE TABLE candidat(
   Id_candidat SERIAL,
   nom VARCHAR(100)  NOT NULL,
   prenom VARCHAR(100)  NOT NULL,
   email VARCHAR(150)  NOT NULL,
   photo TEXT,
   telephone VARCHAR(20) ,
   adresse TEXT,
   date_candidature DATE NOT NULL,
   annee_experience INTEGER,
   Id_lieu INTEGER NOT NULL,
   Id_etat_candidat INTEGER NOT NULL,
   PRIMARY KEY(Id_candidat),
   UNIQUE(email),
   FOREIGN KEY(Id_lieu) REFERENCES lieu(Id_lieu),
   FOREIGN KEY(Id_etat_candidat) REFERENCES etat_candidat(Id_etat_candidat)
);

CREATE TABLE poste(
   Id_poste SERIAL,
   libelle VARCHAR(50) ,
   salaire INTEGER,
   Id_departement INTEGER NOT NULL,
   PRIMARY KEY(Id_poste),
   FOREIGN KEY(Id_departement) REFERENCES departement(Id_departement)
);

CREATE TABLE personnel(
   Id_personnel SERIAL,
   date_embauche DATE NOT NULL,
   actif BOOLEAN,
   Id_candidat INTEGER NOT NULL,
   Id_poste INTEGER NOT NULL,
   PRIMARY KEY(Id_personnel),
   UNIQUE(Id_candidat),
   FOREIGN KEY(Id_candidat) REFERENCES candidat(Id_candidat),
   FOREIGN KEY(Id_poste) REFERENCES poste(Id_poste)
);

CREATE TABLE historique_etat(
   Id_historique_etat SERIAL,
   date_changement VARCHAR(50) ,
   Id_candidat INTEGER NOT NULL,
   Id_etat_candidat INTEGER NOT NULL,
   PRIMARY KEY(Id_historique_etat),
   FOREIGN KEY(Id_candidat) REFERENCES candidat(Id_candidat),
   FOREIGN KEY(Id_etat_candidat) REFERENCES etat_candidat(Id_etat_candidat)
);

CREATE TABLE diplome(
   Id_diplome SERIAL,
   niveau VARCHAR(50) ,
   Id_filiere INTEGER NOT NULL,
   PRIMARY KEY(Id_diplome),
   FOREIGN KEY(Id_filiere) REFERENCES filiere(Id_filiere)
);

CREATE TABLE entretien_1(
   Id_entretien_ SERIAL,
   date_entretien DATE,
   Id_user INTEGER NOT NULL,
   PRIMARY KEY(Id_entretien_),
   FOREIGN KEY(Id_user) REFERENCES user_(Id_user)
);

CREATE TABLE evaluation_entretien_1(
   Id_evaluation_entretien_1 SERIAL,
   presence BOOLEAN,
   Id_appreciation INTEGER NOT NULL,
   Id_entretien_ INTEGER NOT NULL,
   PRIMARY KEY(Id_evaluation_entretien_1),
   UNIQUE(Id_entretien_),
   FOREIGN KEY(Id_appreciation) REFERENCES appreciation(Id_appreciation),
   FOREIGN KEY(Id_entretien_) REFERENCES entretien_1(Id_entretien_)
);

CREATE TABLE entretien_2(
   Id_entretien_2 SERIAL,
   date_entretien DATE,
   Id_user INTEGER NOT NULL,
   Id_entretien_ INTEGER NOT NULL,
   PRIMARY KEY(Id_entretien_2),
   UNIQUE(Id_entretien_),
   FOREIGN KEY(Id_user) REFERENCES user_(Id_user),
   FOREIGN KEY(Id_entretien_) REFERENCES entretien_1(Id_entretien_)
);

CREATE TABLE evaluation_entretien_2(
   Id_evaluation_appreciation_2 SERIAL,
   presence BOOLEAN,
   Id_appreciation INTEGER NOT NULL,
   Id_entretien_2 INTEGER NOT NULL,
   PRIMARY KEY(Id_evaluation_appreciation_2),
   UNIQUE(Id_entretien_2),
   FOREIGN KEY(Id_appreciation) REFERENCES appreciation(Id_appreciation),
   FOREIGN KEY(Id_entretien_2) REFERENCES entretien_2(Id_entretien_2)
);

CREATE TABLE contrat_essai(
   Id_contrat_essai SERIAL,
   date_debut DATE,
   date_fin VARCHAR(50) ,
   Id_candidat INTEGER NOT NULL,
   PRIMARY KEY(Id_contrat_essai),
   UNIQUE(Id_candidat),
   FOREIGN KEY(Id_candidat) REFERENCES candidat(Id_candidat)
);

CREATE TABLE contrat(
   Id_contrat SERIAL,
   dateDebut DATE,
   statut VARCHAR(50) ,
   date_renouvelement DATE,
   dateFin DATE,
   Id_personnel INTEGER NOT NULL,
   Id_type_contrat INTEGER NOT NULL,
   PRIMARY KEY(Id_contrat),
   FOREIGN KEY(Id_personnel) REFERENCES personnel(Id_personnel),
   FOREIGN KEY(Id_type_contrat) REFERENCES type_contrat(Id_type_contrat)
);

CREATE TABLE demande_conge(
   Id_demande_conge SERIAL,
   date_demande DATE NOT NULL,
   date_debut DATE NOT NULL,
   date_fin DATE NOT NULL,
   nombre_jours INTEGER NOT NULL,
   motif VARCHAR(255),
   Id_personnel INTEGER NOT NULL,
   Id_statut_demande INTEGER NOT NULL,
   PRIMARY KEY(Id_demande_conge),
   FOREIGN KEY(Id_personnel) REFERENCES personnel(Id_personnel) ON DELETE RESTRICT ON UPDATE CASCADE,
   FOREIGN KEY(Id_statut_demande) REFERENCES statut_demande(Id_statut_demande) ON DELETE RESTRICT ON UPDATE CASCADE,
   CHECK (date_fin >= date_debut),
   CHECK (nombre_jours > 0)
);

CREATE TABLE fiche_paie(
   Id_fiche_paie SERIAL,
   mois INTEGER,
   annee INTEGER,
   salaire_base NUMERIC(15,2)  ,
   salaire_net NUMERIC(15,2)  ,
   salaire_brut NUMERIC(15,2)  ,
   total_heure_sup NUMERIC(15,2)  ,
   total_prime NUMERIC(15,2)  ,
   total_retenus NUMERIC(15,2)  ,
   salaire_imposable NUMERIC(15,2)  ,
   Id_personnel INTEGER NOT NULL,
   PRIMARY KEY(Id_fiche_paie),
   FOREIGN KEY(Id_personnel) REFERENCES personnel(Id_personnel)
);

CREATE TABLE solde_conge(
   Id_solde_conge SERIAL,
   solde_annuel INTEGER NOT NULL DEFAULT 25,
   solde_restant INTEGER NOT NULL DEFAULT 25,
   date_initialisation DATE NOT NULL DEFAULT CURRENT_DATE,
   date_renouvellement DATE,
   Id_personnel INTEGER NOT NULL,
   PRIMARY KEY(Id_solde_conge),
   UNIQUE(Id_personnel),
   FOREIGN KEY(Id_personnel) REFERENCES personnel(Id_personnel) ON DELETE RESTRICT ON UPDATE CASCADE,
   CHECK (solde_restant >= 0),
   CHECK (solde_annuel >= 0)
);

CREATE TABLE validation_conge_chef(
   Id_validation_conge_chef SERIAL,
   date_validation DATE NOT NULL DEFAULT CURRENT_DATE,
   commentaire VARCHAR(255),
   Id_user INTEGER NOT NULL,
   Id_demande_conge INTEGER NOT NULL,
   Id_decision_validation INTEGER NOT NULL,
   PRIMARY KEY(Id_validation_conge_chef),
   UNIQUE(Id_demande_conge),
   FOREIGN KEY(Id_user) REFERENCES user_(Id_user) ON DELETE RESTRICT ON UPDATE CASCADE,
   FOREIGN KEY(Id_demande_conge) REFERENCES demande_conge(Id_demande_conge) ON DELETE RESTRICT ON UPDATE CASCADE,
   FOREIGN KEY(Id_decision_validation) REFERENCES decision_validation(Id_decision_validation) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE remplacement(
   Id_remplacement SERIAL,
   date_creation DATE NOT NULL DEFAULT CURRENT_DATE,
   remplacant_accepte BOOLEAN DEFAULT FALSE,
   notifiee BOOLEAN DEFAULT FALSE,
   commentaire_remplacant VARCHAR(255),
   Id_personnel INTEGER NOT NULL,
   Id_demande_conge INTEGER NOT NULL,
   PRIMARY KEY(Id_remplacement),
   UNIQUE(Id_demande_conge),
   FOREIGN KEY(Id_personnel) REFERENCES personnel(Id_personnel) ON DELETE RESTRICT ON UPDATE CASCADE,
   FOREIGN KEY(Id_demande_conge) REFERENCES demande_conge(Id_demande_conge) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE presence_absence(
   Id_presence_absence SERIAL,
   date_ DATE,
   heure_depart TIME,
   heure_arrivee TIME,
   present BOOLEAN,
   Id_personnel INTEGER NOT NULL,
   PRIMARY KEY(Id_presence_absence),
   FOREIGN KEY(Id_personnel) REFERENCES personnel(Id_personnel)
);

CREATE TABLE justification_absence(
   Id_justification_absence SERIAL,
   date_demande DATE,
   fichier_justification TEXT,
   date_absence DATE,
   type_absenca VARCHAR(50) ,
   est_justifie BOOLEAN,
   Id_personnel INTEGER NOT NULL,
   PRIMARY KEY(Id_justification_absence),
   FOREIGN KEY(Id_personnel) REFERENCES personnel(Id_personnel)
);

CREATE TABLE validationAbs_chef(
   Id_validationAbs_chef SERIAL,
   date_validation DATE,
   Id_user INTEGER NOT NULL,
   Id_decision_validation INTEGER NOT NULL,
   PRIMARY KEY(Id_validationAbs_chef),
   FOREIGN KEY(Id_user) REFERENCES user_(Id_user),
   FOREIGN KEY(Id_decision_validation) REFERENCES decision_validation(Id_decision_validation)
);

CREATE TABLE validationAbs_Rh(
   Id_validationAbs_Rh SERIAL,
   date_validation VARCHAR(50) ,
   Id_user INTEGER NOT NULL,
   Id_justification_absence INTEGER NOT NULL,
   Id_decision_validation INTEGER NOT NULL,
   PRIMARY KEY(Id_validationAbs_Rh),
   FOREIGN KEY(Id_user) REFERENCES user_(Id_user),
   FOREIGN KEY(Id_justification_absence) REFERENCES justification_absence(Id_justification_absence),
   FOREIGN KEY(Id_decision_validation) REFERENCES decision_validation(Id_decision_validation)
);

CREATE TABLE diplome_candidat(
   Id_diplome_candidat SERIAL,
   etablissement VARCHAR(150) ,
   annee_obtention INTEGER,
   Id_diplome INTEGER NOT NULL,
   Id_candidat INTEGER NOT NULL,
   PRIMARY KEY(Id_diplome_candidat),
   FOREIGN KEY(Id_diplome) REFERENCES diplome(Id_diplome),
   FOREIGN KEY(Id_candidat) REFERENCES candidat(Id_candidat)
);

CREATE TABLE profil(
   Id_profil SERIAL,
   genre VARCHAR(50) ,
   age INTEGER,
   annee_experience VARCHAR(50) ,
   Id_lieu INTEGER NOT NULL,
   Id_diplome INTEGER NOT NULL,
   PRIMARY KEY(Id_profil),
   FOREIGN KEY(Id_lieu) REFERENCES lieu(Id_lieu),
   FOREIGN KEY(Id_diplome) REFERENCES diplome(Id_diplome)
);

CREATE TABLE annonce(
   Id_annonce SERIAL,
   date_annonce VARCHAR(50) ,
   responsabilite TEXT,
   date_fin DATE,
   Id_profil INTEGER NOT NULL,
   PRIMARY KEY(Id_annonce),
   FOREIGN KEY(Id_profil) REFERENCES profil(Id_profil)
);

CREATE TABLE profil_qcm(
   Id_profil INTEGER,
   Id_qcm INTEGER,
   Id_profil_qcm SERIAL,
   PRIMARY KEY(Id_profil, Id_qcm, Id_profil_qcm),
   FOREIGN KEY(Id_profil) REFERENCES profil(Id_profil),
   FOREIGN KEY(Id_qcm) REFERENCES qcm(Id_qcm)
);

CREATE TABLE reponse(
   Id_reponse SERIAL,
   Id_profil INTEGER NOT NULL,
   Id_question INTEGER NOT NULL,
   Id_choix INTEGER NOT NULL,
   PRIMARY KEY(Id_reponse),
   UNIQUE(Id_profil),
   UNIQUE(Id_question),
   UNIQUE(Id_choix),
   FOREIGN KEY(Id_profil) REFERENCES profil(Id_profil),
   FOREIGN KEY(Id_question) REFERENCES question(Id_question),
   FOREIGN KEY(Id_choix) REFERENCES choix(Id_choix)
);

CREATE TABLE resultat_qcm(
   Id_resultat_qcm SERIAL,
   bonnes_reponses INTEGER,
   total_questions INTEGER,
   pourcentage NUMERIC(15,2)  ,
   Id_qcm INTEGER NOT NULL,
   Id_profil INTEGER NOT NULL,
   PRIMARY KEY(Id_resultat_qcm),
   UNIQUE(Id_qcm),
   UNIQUE(Id_profil),
   FOREIGN KEY(Id_qcm) REFERENCES qcm(Id_qcm),
   FOREIGN KEY(Id_profil) REFERENCES profil(Id_profil)
);

CREATE TABLE validation_conge_RH(
   Id_validation_conge_RH SERIAL,
   date_validation DATE NOT NULL DEFAULT CURRENT_DATE,
   commentaire VARCHAR(255),
   Id_validation_conge_chef INTEGER NOT NULL,
   Id_user INTEGER NOT NULL,
   Id_decision_validation INTEGER NOT NULL,
   PRIMARY KEY(Id_validation_conge_RH),
   UNIQUE(Id_validation_conge_chef),
   FOREIGN KEY(Id_validation_conge_chef) REFERENCES validation_conge_chef(Id_validation_conge_chef) ON DELETE RESTRICT ON UPDATE CASCADE,
   FOREIGN KEY(Id_user) REFERENCES user_(Id_user) ON DELETE RESTRICT ON UPDATE CASCADE,
   FOREIGN KEY(Id_decision_validation) REFERENCES decision_validation(Id_decision_validation) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE Asso_37(
   Id_personnel INTEGER,
   Id_heures_supplementaire INTEGER,
   PRIMARY KEY(Id_personnel, Id_heures_supplementaire),
   FOREIGN KEY(Id_personnel) REFERENCES personnel(Id_personnel),
   FOREIGN KEY(Id_heures_supplementaire) REFERENCES heures_supplementaire(Id_heures_supplementaire)
);



INSERT INTO decision_validation (libelle) VALUES
('Approuvée'),                         
('Rejetée'),                           
('Approuvée avec modifications'),      
('En attente'),                       
('À reviser'),                        
('Conditionnel'),                     
('Reportée'),                         
('Annulée'),                          
('Automatiquement approuvée'),        
('Nécessite approbation supérieure'); 