package com.example.gestion.services;

import com.example.gestion.models.*;
import com.example.gestion.repository.Entretien2Repository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class Entretien2Service {

    private final Entretien2Repository entretien2Repository;

    public Entretien2Service(Entretien2Repository entretien2Repository) {
        this.entretien2Repository = entretien2Repository;
    }

    public List<Entretien2> findAll() {
        return entretien2Repository.findAll();
    }

    public Optional<Entretien2> findById(Integer id) {
        return entretien2Repository.findById(id);
    }

    public Entretien2 save(Entretien2 entretien) {
        return entretien2Repository.save(entretien);
    }

    public void deleteById(Integer id) {
        entretien2Repository.deleteById(id);
    }

    public List<Entretien2> getEntretien2(User user)
    {
        return entretien2Repository.findAllWithoutEvaluationByUser(user.getId_user());
    }
}
