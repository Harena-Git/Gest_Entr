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

    public boolean verifierEtEnregistrer(Candidat candidat, Profil profilAnnonce) {
        // Vérification genre
        if (profilAnnonce.getGenre() != null && !profilAnnonce.getGenre().equalsIgnoreCase(candidat.getGenre())) {
            return false;
        }
          // Convertir Date en LocalDate
        LocalDate naissance = candidat.getDate_naissance().toInstant()
                                    .atZone(ZoneId.systemDefault())
                                    .toLocalDate();

        LocalDate aujourdHui = LocalDate.now();
        int ageCandidat = Period.between(naissance, aujourdHui).getYears();
        // Vérification âge
        if (profilAnnonce.getAge() != null && profilAnnonce.getAge() <= ageCandidat) {
            return false;
        }

        // Vérification années d'expérience
        if (profilAnnonce.getAnnee_experience() != null && 
            profilAnnonce.getAnnee_experience() <= candidat.getAnnee_experience()) {
            return false;
        }

        // Vérification lieu
        if (profilAnnonce.getLieu() != null) {
            if (candidat.getLieu() == null || 
                !profilAnnonce.getLieu().getId_lieu().equals(candidat.getLieu().getId_lieu())) {
                return false;
            }
        }
        // Vérification diplôme
        // Vérification diplôme (filière + niveau)
        if (profilAnnonce.getDiplome() != null) {
            boolean match = false;

            for (DiplomeCandidat dc : candidat.getDiplomesCandidats()) {
                Diplome diplomeCandidat = dc.getDiplome();
                Diplome diplomeProfil = profilAnnonce.getDiplome();

                if (diplomeCandidat != null) {
                    // Vérifier que la filière est identique
                    boolean memeFiliere = diplomeProfil.getFiliere() != null 
                            && diplomeCandidat.getFiliere() != null
                            && diplomeProfil.getFiliere().getIdFiliere().equals(
                            diplomeCandidat.getFiliere().getIdFiliere());

                    // Vérifier que le niveau du candidat >= niveau du profil
                    boolean niveauOk = diplomeProfil.getNiveau() != null
                            && diplomeCandidat.getNiveau() != null
                            && diplomeCandidat.getNiveau().getIdNiveau() 
                            >= diplomeProfil.getNiveau().getIdNiveau();

                    if (memeFiliere && niveauOk) {
                        match = true;
                        break; // un diplôme valide trouvé
                    }
                }
            }

            if (!match) {
                return false;
            }
        }



        // Si tout est conforme, on enregistre
        //candidatRepository.save(candidat);
        return true;
    }
}

