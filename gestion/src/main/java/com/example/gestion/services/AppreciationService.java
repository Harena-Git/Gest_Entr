package com.example.gestion.services;

import com.example.gestion.models.*;
import com.example.gestion.repository.AppreciationRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class AppreciationService {

    private final AppreciationRepository appreciationRepository;

    public AppreciationService(AppreciationRepository appreciationRepository) {
        this.appreciationRepository = appreciationRepository;
    }

    public List<Appreciation> findAll() {
        return appreciationRepository.findAll();
    }

    public Optional<Appreciation> findById(Integer id) {
        return appreciationRepository.findById(id);
    }

    public Appreciation save(Appreciation entretien) {
        return appreciationRepository.save(entretien);
    }

    public void deleteById(Integer id) {
        appreciationRepository.deleteById(id);
    }

}
