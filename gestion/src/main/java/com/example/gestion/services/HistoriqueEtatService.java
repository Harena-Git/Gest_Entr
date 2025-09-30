package com.example.gestion.services;

import com.example.gestion.models.*;
import com.example.gestion.repository.HistoriqueEtatRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class HistoriqueEtatService {

    private final HistoriqueEtatRepository historiqueEtatRepository;

    public HistoriqueEtatService(HistoriqueEtatRepository historiqueEtatRepository) {
        this.historiqueEtatRepository = historiqueEtatRepository;
    }

    public List<HistoriqueEtat> findAll() {
        return historiqueEtatRepository.findAll();
    }

    public Optional<HistoriqueEtat> findById(Integer id) {
        return historiqueEtatRepository.findById(id);
    }

    public HistoriqueEtat save(HistoriqueEtat entretien) {
        return historiqueEtatRepository.save(entretien);
    }

    public void deleteById(Integer id) {
        historiqueEtatRepository.deleteById(id);
    }
}
