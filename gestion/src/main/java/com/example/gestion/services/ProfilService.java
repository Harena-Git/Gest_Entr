package com.example.gestion.services;

import com.example.gestion.models.*;
import com.example.gestion.repository.*;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ProfilService {

    private final ProfilRepository profilRepository;
    private final AnnonceService annonceService;

    public ProfilService(ProfilRepository profilRepository, AnnonceService annonceService) {
        this.profilRepository = profilRepository;
        this.annonceService = annonceService;
    }

    public List<Profil> findAll() {
        return profilRepository.findAll();
    }

    public Optional<Profil> findById(Integer id) {
        return profilRepository.findById(id);
    }

    public Profil save(Profil entretien) {
        return profilRepository.save(entretien);
    }

    public void deleteById(Integer id) {
        profilRepository.deleteById(id);
    }

    public Profil findByLieu(Lieu lieu)
    {
        return profilRepository.findByLieu(lieu);
    }

    public Departement getDepartementDuCandidat(Candidat candidat) {
        // Récupère le profil du candidat via le lieu
        Profil profil = findByLieu(candidat.getLieu());
        // Récupère la première annonce pour ce profil
        Annonce annonce = annonceService.findByProfil(profil).get(0);
        // Retourne le département du poste
        return annonce.getPoste().getDepartement();
    }

}
