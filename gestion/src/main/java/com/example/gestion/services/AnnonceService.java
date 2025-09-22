package com.example.gestion.services;

import com.example.gestion.models.*;
import com.example.gestion.repository.AnnonceRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class AnnonceService {

    private final AnnonceRepository annonceRepository;

    public AnnonceService(AnnonceRepository annonceRepository) {
        this.annonceRepository = annonceRepository;
    }

    public List<Annonce> findAll() {
        return annonceRepository.findAll();
    }

    public Optional<Annonce> findById(Integer id) {
        return annonceRepository.findById(id);
    }

    public Annonce save(Annonce entretien) {
        return annonceRepository.save(entretien);
    }

    public void deleteById(Integer id) {
        annonceRepository.deleteById(id);
    }

    public List<Annonce> findByProfil(Profil profil)
    {
        return annonceRepository.findByProfil(profil);
    }

}
