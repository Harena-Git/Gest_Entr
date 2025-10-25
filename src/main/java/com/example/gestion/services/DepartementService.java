package com.example.gestion.services;

import com.example.gestion.models.*;
import com.example.gestion.repository.DepartementRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class DepartementService {

    private final DepartementRepository departementRepository;

    public DepartementService(DepartementRepository departementRepository) {
        this.departementRepository = departementRepository;
    }

    public List<Departement> findAll() {
        return departementRepository.findAll();
    }

    public Optional<Departement> findById(Integer id) {
        return departementRepository.findById(id);
    }

    public Departement save(Departement entretien) {
        return departementRepository.save(entretien);
    }

    public void deleteById(Integer id) {
        departementRepository.deleteById(id);
    }

}
