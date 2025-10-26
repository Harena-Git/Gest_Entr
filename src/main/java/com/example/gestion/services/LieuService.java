package com.example.gestion.services;

import com.example.gestion.models.*;
import com.example.gestion.repository.LieuRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class LieuService {

    private final LieuRepository lieuRepository;

    public LieuService(LieuRepository lieuRepository) {
        this.lieuRepository = lieuRepository;
    }

    public List<Lieu> findAll() {
        return lieuRepository.findAll();
    }

    public Optional<Lieu> findById(Integer id) {
        return lieuRepository.findById(id);
    }

    public Lieu save(Lieu entretien) {
        return lieuRepository.save(entretien);
    }

    public void deleteById(Integer id) {
        lieuRepository.deleteById(id);
    }

    
}
