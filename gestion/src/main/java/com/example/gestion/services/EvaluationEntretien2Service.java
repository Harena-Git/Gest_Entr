package com.example.gestion.services;

import com.example.gestion.models.*;
import com.example.gestion.repository.EvaluationEntretien2Repository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class EvaluationEntretien2Service {

    private final EvaluationEntretien2Repository evaluationentretien2Repository;

    public EvaluationEntretien2Service(EvaluationEntretien2Repository evaluationentretien2Repository) {
        this.evaluationentretien2Repository = evaluationentretien2Repository;
    }

    public List<EvaluationEntretien2> findAll() {
        return evaluationentretien2Repository.findAll();
    }

    public Optional<EvaluationEntretien2> findById(Integer id) {
        return evaluationentretien2Repository.findById(id);
    }

    public EvaluationEntretien2 save(EvaluationEntretien2 entretien) {
        return evaluationentretien2Repository.save(entretien);
    }

    public void deleteById(Integer id) {
        evaluationentretien2Repository.deleteById(id);
    }

    public Optional<EvaluationEntretien2> findByEntretien(Entretien2 entretien) {
        return evaluationentretien2Repository.findByEntretien2(entretien);
    }

}
