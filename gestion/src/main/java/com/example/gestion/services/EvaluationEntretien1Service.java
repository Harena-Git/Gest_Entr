package com.example.gestion.services;

import com.example.gestion.models.*;
import com.example.gestion.repository.EvaluationEntretien1Repository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class EvaluationEntretien1Service {

    private final EvaluationEntretien1Repository evaluationentretien1Repository;

    public EvaluationEntretien1Service(EvaluationEntretien1Repository evaluationentretien1Repository) {
        this.evaluationentretien1Repository = evaluationentretien1Repository;
    }

    public List<EvaluationEntretien1> findAll() {
        return evaluationentretien1Repository.findAll();
    }

    public Optional<EvaluationEntretien1> findById(Integer id) {
        return evaluationentretien1Repository.findById(id);
    }

    public EvaluationEntretien1 save(EvaluationEntretien1 entretien) {
        return evaluationentretien1Repository.save(entretien);
    }

    public void deleteById(Integer id) {
        evaluationentretien1Repository.deleteById(id);
    }

    public Optional<EvaluationEntretien1> findByEntretien(Entretien1 entretien) {
        return evaluationentretien1Repository.findByEntretien1(entretien);
    }

}
