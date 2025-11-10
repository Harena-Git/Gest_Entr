package com.example.gestion.services;


import java.time.LocalDate;
import java.time.Period;
import java.time.ZoneId;
import java.util.List;
import java.time.Instant;

import java.util.Date;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.example.gestion.models.*;
import com.example.gestion.repository.CandidatRepository;
import com.example.gestion.repository.DiplomeCandidatRepository;

import java.util.Optional;

@Service
public class CandidatService {

    @Autowired
    private CandidatRepository candidatRepository;

    @Autowired
    private DiplomeCandidatRepository diplomeCandidatRepository;

 

    public String verifierEtEnregistrer(Candidat candidat, Profil profilAnnonce) {
        // Vérification genre
        if (!"les deux".equalsIgnoreCase(profilAnnonce.getGenre()) 
                        && !profilAnnonce.getGenre().equalsIgnoreCase(candidat.getGenre())) {
                    System.out.println("Genre du profil annonce: " + profilAnnonce.getGenre());
                    System.out.println("Genre du candidat: " + candidat.getGenre());
                    return "Le genre du candidat ne correspond pas au profil recherché.";
            }

        // Convertir Date en LocalDate
        // Vérification date de naissance et calcul de l'âge
       if (candidat.getDate_naissance() == null) {
            return "La date de naissance du candidat est manquante.";
        }

        // Conversion java.util.Date → LocalDate
        Date dateNaissance = candidat.getDate_naissance();
        LocalDate naissance = Instant.ofEpochMilli(dateNaissance.getTime())
                                    .atZone(ZoneId.systemDefault())
                                    .toLocalDate();

        LocalDate aujourdHui = LocalDate.now();
        int ageCandidat = java.time.Period.between(naissance, aujourdHui).getYears();

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
        

        // Vérification diplômes  if (profilAnnonce.getDiplome() != null) {
        Diplome diplomeProfil = profilAnnonce.getDiplome();
      

        // 🔹 Récupérer les diplômes du candidat dans la base
        List<DiplomeCandidat> diplomes = diplomeCandidatRepository.findDiplomesByCandidatId(candidat.getId_candidat());

        boolean match = false;
        

        for (DiplomeCandidat dc : diplomes) {
            Diplome diplomeCandidat = dc.getDiplome();
            if (diplomeCandidat == null) continue;

            
            boolean memeFiliere = diplomeProfil.getFiliere() != null
                    && diplomeCandidat.getFiliere() != null
                    && diplomeProfil.getFiliere().getIdFiliere().equals(diplomeCandidat.getFiliere().getIdFiliere());

            boolean niveauOk = diplomeProfil.getNiveau() != null
                    && diplomeCandidat.getNiveau() != null
                    && diplomeCandidat.getNiveau().getId_niveau() >= diplomeProfil.getNiveau().getId_niveau();

            if (memeFiliere && niveauOk) {
                match = true;
                break;
            }
        }

        if (!match) {
            return "Diplôme invalide ";
        }
    

        return "OK"; // Tout est conforme
    }
    
    public CandidatService(CandidatRepository candidatRepository) {
        this.candidatRepository = candidatRepository;
    }

    public List<Candidat> findAll() {
        return candidatRepository.findAll();
    }

    public Optional<Candidat> findById(Integer id) {
        return candidatRepository.findById(id);
    }

    public Candidat save(Candidat entretien) {
        return candidatRepository.save(entretien);
    }

    public void deleteById(Integer id) {
        candidatRepository.deleteById(id);
    }
    public Optional<Candidat> getCandidatById(Integer id) {
        return candidatRepository.findById(id);
    }
}


