package com.example.gestion.services;

import com.example.gestion.models.*;
import com.example.gestion.repository.PersonnelRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class PersonnelService {

    private final PersonnelRepository personnelRepository;

    public PersonnelService(PersonnelRepository personnelRepository) {
        this.personnelRepository = personnelRepository;
    }

    public List<Personnel> findAll() {
        return personnelRepository.findAll();
    }

    public Optional<Personnel> findById(Integer id) {
        return personnelRepository.findById(id);
    }

    public Personnel save(Personnel entretien) {
        return personnelRepository.save(entretien);
    }

    public void deleteById(Integer id) {
        personnelRepository.deleteById(id);
    }
}
