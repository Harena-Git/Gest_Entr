-- Désactiver temporairement les contraintes de clés étrangères
SET FOREIGN_KEY_CHECKS = 0;

-- Supprimer les tables dans l'ordre inverse de leur création
DROP TABLE IF EXISTS resultat_qcm;
DROP TABLE IF EXISTS reponse;
DROP TABLE IF EXISTS profil_qcm;
DROP TABLE IF EXISTS annonce;
DROP TABLE IF EXISTS profil;
DROP TABLE IF EXISTS diplome_candidat;
DROP TABLE IF EXISTS contrat_essai;
DROP TABLE IF EXISTS evaluation_entretien_2;
DROP TABLE IF EXISTS entretien_2;
DROP TABLE IF EXISTS evaluation_entretien_1;
DROP TABLE IF EXISTS entretien_1;
DROP TABLE IF EXISTS historique_etat;
DROP TABLE IF EXISTS personnel;
DROP TABLE IF EXISTS poste;
DROP TABLE IF EXISTS diplome;
DROP TABLE IF EXISTS candidat;
DROP TABLE IF EXISTS user_;
DROP TABLE IF EXISTS choix;
DROP TABLE IF EXISTS question;
DROP TABLE IF EXISTS qcm;
DROP TABLE IF EXISTS appreciation;
DROP TABLE IF EXISTS lieu;
DROP TABLE IF EXISTS departement;
DROP TABLE IF EXISTS filiere;
DROP TABLE IF EXISTS etat_candidat;
DROP TABLE IF EXISTS role;

-- Réactiver les contraintes de clés étrangères
SET FOREIGN_KEY_CHECKS = 1;