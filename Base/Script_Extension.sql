-- Script pour ajouter les nouvelles tables nécessaires pour les fonctionnalités de gestion du personnel
-- À exécuter après Script.sql

USE gestion_entreprise;

-- Table type_contrat
CREATE TABLE IF NOT EXISTS type_contrat(
   id_type_contrat INT AUTO_INCREMENT,
   libelle VARCHAR(50) NOT NULL,
   PRIMARY KEY(id_type_contrat)
);

-- Table contrat_travail
CREATE TABLE IF NOT EXISTS contrat_travail(
   id_contrat_travail INT AUTO_INCREMENT,
   id_personnel INT NOT NULL,
   id_type_contrat INT NOT NULL,
   date_debut DATE NOT NULL,
   date_fin DATE,
   duree_mois INT,
   date_fin_periode_essai DATE,
   renouvele BOOLEAN DEFAULT FALSE,
   date_alerte DATE,
   statut VARCHAR(20) DEFAULT 'Actif',
   remarques TEXT,
   PRIMARY KEY(id_contrat_travail),
   FOREIGN KEY(id_personnel) REFERENCES personnel(id_personnel) ON DELETE CASCADE,
   FOREIGN KEY(id_type_contrat) REFERENCES type_contrat(id_type_contrat)
);

-- Table historique_poste
CREATE TABLE IF NOT EXISTS historique_poste(
   id_historique_poste INT AUTO_INCREMENT,
   id_personnel INT NOT NULL,
   id_poste INT NOT NULL,
   date_debut DATE NOT NULL,
   date_fin DATE,
   type_mouvement VARCHAR(50) NOT NULL,
   motif TEXT,
   salaire DOUBLE,
   PRIMARY KEY(id_historique_poste),
   FOREIGN KEY(id_personnel) REFERENCES personnel(id_personnel) ON DELETE CASCADE,
   FOREIGN KEY(id_poste) REFERENCES poste(id_poste)
);

-- Table type_document
CREATE TABLE IF NOT EXISTS type_document(
   id_type_document INT AUTO_INCREMENT,
   libelle VARCHAR(100) NOT NULL,
   PRIMARY KEY(id_type_document)
);

-- Table document_personnel
CREATE TABLE IF NOT EXISTS document_personnel(
   id_document INT AUTO_INCREMENT,
   id_personnel INT NOT NULL,
   id_type_document INT NOT NULL,
   nom_fichier VARCHAR(255) NOT NULL,
   chemin_fichier VARCHAR(500) NOT NULL,
   date_upload DATE NOT NULL,
   numero_document VARCHAR(100),
   date_delivrance DATE,
   date_expiration DATE,
   remarques TEXT,
   PRIMARY KEY(id_document),
   FOREIGN KEY(id_personnel) REFERENCES personnel(id_personnel) ON DELETE CASCADE,
   FOREIGN KEY(id_type_document) REFERENCES type_document(id_type_document)
);
