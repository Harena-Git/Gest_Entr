package com.example.gestion.services;

import com.example.gestion.models.*;
import com.example.gestion.repository.EtatCandidatRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class EtatCandidatService {

    private final EtatCandidatRepository etatCandidatRepository;

    public EtatCandidatService(EtatCandidatRepository etatCandidatRepository) {
        this.etatCandidatRepository = etatCandidatRepository;
    }

    public List<EtatCandidat> findAll() {
        return etatCandidatRepository.findAll();
    }

    public Optional<EtatCandidat> findById(Integer id) {
        return etatCandidatRepository.findById(id);
    }

    public EtatCandidat save(EtatCandidat entretien) {
        return etatCandidatRepository.save(entretien);
    }

    public void deleteById(Integer id) {
        etatCandidatRepository.deleteById(id);
    }
}
