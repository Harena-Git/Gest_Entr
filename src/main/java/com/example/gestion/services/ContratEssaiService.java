package com.example.gestion.services;

import com.example.gestion.models.*;
import com.example.gestion.repository.*;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ContratEssaiService {

    private final ContratEssaiRepository contratEssaiRepository;

    public ContratEssaiService(ContratEssaiRepository contratEssaiRepository) {
        this.contratEssaiRepository = contratEssaiRepository;
    }

    public List<ContratEssai> findAll() {
        return contratEssaiRepository.findAll();
    }

    public Optional<ContratEssai> findById(Integer id) {
        return contratEssaiRepository.findById(id);
    }

    public ContratEssai save(ContratEssai entretien) {
        return contratEssaiRepository.save(entretien);
    }

    public void deleteById(Integer id) {
        contratEssaiRepository.deleteById(id);
    }
    public Optional<ContratEssai> findByCandidat(Candidat candidat) {
        return contratEssaiRepository.findByCandidat(candidat);
    }
}
