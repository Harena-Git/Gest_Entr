package com.example.gestion.service;


import java.time.LocalDate;
import java.time.Period;
import java.time.ZoneId;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.example.gestion.models.*;
import com.example.gestion.repository.CandidatRepository;

@Service
public class CandidatService {

    @Autowired
    private CandidatRepository candidatRepository;

    public String verifierEtEnregistrer(Candidat candidat, Profil profilAnnonce) {
        // Vérification genre
        if (profilAnnonce.getGenre() != null && !profilAnnonce.getGenre().equalsIgnoreCase(candidat.getGenre())) {
            return "Le genre du candidat ne correspond pas au profil recherché.";
        }

        // Convertir Date en LocalDate
        if (candidat.getDate_naissance() == null) {
            return "La date de naissance du candidat est manquante.";
        }
        LocalDate naissance = candidat.getDate_naissance().toInstant()
                                    .atZone(ZoneId.systemDefault())
                                    .toLocalDate();
        LocalDate aujourdHui = LocalDate.now();
        int ageCandidat = Period.between(naissance, aujourdHui).getYears();

        // Vérification âge
        if (profilAnnonce.getAge() != null && ageCandidat < profilAnnonce.getAge()) {
            return "L'âge du candidat est inférieur à l'âge minimum requis.";
        }

        // Vérification années d'expérience
        Integer anneeCandidat = candidat.getAnnee_experience() != null ? candidat.getAnnee_experience() : 0;
        if (profilAnnonce.getAnnee_experience() != null && anneeCandidat < profilAnnonce.getAnnee_experience()) {
            return "Le candidat n'a pas assez d'années d'expérience.";
        }

        // Vérification lieu
       if (profilAnnonce.getLieu() != null) {
            if (candidat.getLieu() == null || 
                !profilAnnonce.getLieu().getId_lieu().equals(candidat.getLieu().getId_lieu())) {

                String lieuRequis = profilAnnonce.getLieu().getLieu(); // nom du lieu dans l'annonce
                String lieuChoisi = (candidat.getLieu() != null) 
                                        ? candidat.getLieu().getLieu() 
                                        : "aucun lieu sélectionné";

                return "Lieu requis : " + lieuRequis + " | Lieu choisi : " + lieuChoisi;
            }
        }


      // Vérification diplôme (filière + niveau)
        if (profilAnnonce.getDiplome() != null) {
            boolean match = false;
            Diplome diplomeProfil = profilAnnonce.getDiplome();
            String filiereAttendue = diplomeProfil.getFiliere() != null ? diplomeProfil.getFiliere().getLibelle() : "Non précisée";
            String niveauAttendu = diplomeProfil.getNiveau() != null ? diplomeProfil.getNiveau().getLibelle() : "Non précisé";

            for (DiplomeCandidat dc : candidat.getDiplomesCandidats()) {
                Diplome diplomeCandidat = dc.getDiplome();

                if (diplomeCandidat != null) {
                    String filiereCandidat = diplomeCandidat.getFiliere() != null ? diplomeCandidat.getFiliere().getLibelle() : "Non précisée";
                    String niveauCandidat = diplomeCandidat.getNiveau() != null ? diplomeCandidat.getNiveau().getLibelle() : "Non précisé";

                    boolean memeFiliere = diplomeProfil.getFiliere() != null
                            && diplomeCandidat.getFiliere() != null
                            && diplomeProfil.getFiliere().getIdFiliere().equals(diplomeCandidat.getFiliere().getIdFiliere());

                    boolean niveauOk = diplomeProfil.getNiveau() != null
                            && diplomeCandidat.getNiveau() != null
                            && diplomeCandidat.getNiveau().getIdNiveau() >= diplomeProfil.getNiveau().getIdNiveau();

                    if (memeFiliere && niveauOk) {
                        match = true;
                        break;
                    } else {
                        return "Diplôme invalide : attendu [Filière = " + filiereAttendue +
                                ", Niveau = " + niveauAttendu + "] mais reçu [Filière = " + filiereCandidat +
                                ", Niveau = " + niveauCandidat + "]";
                    }
                }
            }

          /*   if (!match) {
             return "Diplôme invalide : attendu [Filière = " + filiereAttendue +
                                ", Niveau = " + niveauAttendu + "] mais reçu [Filière = " + filiereCandidat +
                                ", Niveau = " + niveauCandidat + "]";
            }*/
        }

        return "OK"; // Tout est conforme
    }
}


