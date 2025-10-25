package com.example.gestion.services;

import com.example.gestion.models.*;
import com.example.gestion.repository.Entretien1Repository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class Entretien1Service {

    private final Entretien1Repository entretien1Repository;

    public Entretien1Service(Entretien1Repository entretien1Repository) {
        this.entretien1Repository = entretien1Repository;
    }

    public List<Entretien1> findAll() {
        return entretien1Repository.findAll();
    }

    public Optional<Entretien1> findById(Integer id) {
        return entretien1Repository.findById(id);
    }

    public Entretien1 save(Entretien1 entretien) {
        return entretien1Repository.save(entretien);
    }

    public void deleteById(Integer id) {
        entretien1Repository.deleteById(id);
    }

    public List<Entretien1> getEntretien1(User user)
    {
        return entretien1Repository.findAllWithoutEvaluationByUser(user.getId_user());
    }
}
