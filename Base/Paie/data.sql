CREATE TABLE poste(
   Id_poste COUNTER,
   libelle VARCHAR(50),
   salaire DECIMAL(15,2),
   PRIMARY KEY(Id_poste)
);

CREATE TABLE heures_sup_type(
   Id_heures_sup COUNTER,
   libelle VARCHAR(50),
   taux DECIMAL(15,2),
   PRIMARY KEY(Id_heures_sup)
);

CREATE TABLE Plafond(
   Id_Plafond COUNTER,
   date_ DATE,
   montant DECIMAL(15,2),
   PRIMARY KEY(Id_Plafond)
);

CREATE TABLE TypeRetenu(
   Id_TypeRetenu COUNTER,
   libelle VARCHAR(50),
   taux DECIMAL(15,2),
   PRIMARY KEY(Id_TypeRetenu)
);

CREATE TABLE personnel(
   Id_personnel COUNTER,
   date_embauche DATE NOT NULL,
   actif LOGICAL,
   matricule VARCHAR(50),
   num_cnaps VARCHAR(50),
   Id_poste INT NOT NULL,
   PRIMARY KEY(Id_personnel),
   FOREIGN KEY(Id_poste) REFERENCES poste(Id_poste)
);

CREATE TABLE fiche_paie(
   Id_fiche_paie COUNTER,
   mois INT,
   salaire_base DECIMAL(15,2),
   salaire_net DECIMAL(15,2),
   salaire_brut DECIMAL(15,2),
   total_heure_sup DECIMAL(15,2),
   annee INT,
   total_prime DECIMAL(15,2),
   total_retenus DECIMAL(15,2),
   salaire_imposable DECIMAL(15,2),
   Id_personnel INT NOT NULL,
   PRIMARY KEY(Id_fiche_paie),
   FOREIGN KEY(Id_personnel) REFERENCES personnel(Id_personnel)
);

CREATE TABLE heures_supplementaire(
   Id_heures_supplementaire COUNTER,
   nb_heures INT,
   montant DECIMAL(15,2),
   Id_heures_sup INT NOT NULL,
   PRIMARY KEY(Id_heures_supplementaire),
   FOREIGN KEY(Id_heures_sup) REFERENCES heures_sup_type(Id_heures_sup)
);

CREATE TABLE Impot(
   Id_Impot COUNTER,
   ImpotDu DECIMAL(15,2),
   EnfantChargePU DECIMAL(15,2),
   Igrnet DECIMAL(15,2),
   enfantChargenbr DECIMAL(15,2),
   mois VARCHAR(50),
   annee VARCHAR(50),
   Id_personnel INT NOT NULL,
   PRIMARY KEY(Id_Impot),
   FOREIGN KEY(Id_personnel) REFERENCES personnel(Id_personnel)
);

CREATE TABLE ComplementSalaire(
   Id_ComplementSalaire COUNTER,
   mois INT,
   annee INT,
   indemnite DECIMAL(15,2),
   rappels DECIMAL(15,2),
   autres DECIMAL(15,2),
   Id_personnel INT NOT NULL,
   PRIMARY KEY(Id_ComplementSalaire),
   FOREIGN KEY(Id_personnel) REFERENCES personnel(Id_personnel)
);

CREATE TABLE Retenu(
   Id_Retenu COUNTER,
   mois INT,
   annee INT,
   Id_Plafond INT NOT NULL,
   Id_personnel INT NOT NULL,
   Id_TypeRetenu INT NOT NULL,
   PRIMARY KEY(Id_Retenu),
   FOREIGN KEY(Id_Plafond) REFERENCES Plafond(Id_Plafond),
   FOREIGN KEY(Id_personnel) REFERENCES personnel(Id_personnel),
   FOREIGN KEY(Id_TypeRetenu) REFERENCES TypeRetenu(Id_TypeRetenu)
);

CREATE TABLE personnel_heure_supp(
   Id_personnel INT,
   Id_heures_supplementaire INT,
   PRIMARY KEY(Id_personnel, Id_heures_supplementaire),
   FOREIGN KEY(Id_personnel) REFERENCES personnel(Id_personnel),
   FOREIGN KEY(Id_heures_supplementaire) REFERENCES heures_supplementaire(Id_heures_supplementaire)
);

CREATE TABLE IRSA(
   Id_IRSA BIGINT AUTO_INCREMENT PRIMARY KEY,
   tranche_min DECIMAL(15,2),
   tranche_max DECIMAL(15,2),
   taux DECIMAL(5,4),
   date_debut DATE,
   date_fin DATE,
   est_actif BOOLEAN DEFAULT TRUE
);


