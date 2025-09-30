package com.example.gestion.services;

import com.example.gestion.models.*;
import com.example.gestion.repository.CandidatRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class CandidatService {

    private final CandidatRepository candidatRepository;

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

}
