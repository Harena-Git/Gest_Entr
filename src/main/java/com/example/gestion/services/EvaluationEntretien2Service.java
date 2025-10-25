package com.example.gestion.services;

import com.example.gestion.models.*;
import com.example.gestion.repository.EvaluationEntretien2Repository;
import com.example.gestion.services.*;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.ArrayList;
import java.util.Optional;

@Service
public class EvaluationEntretien2Service {

    private final EvaluationEntretien2Repository evaluationentretien2Repository;
    private final AppreciationService appreciationService;
    private final Entretien1Service entretien1Service;

    public EvaluationEntretien2Service(EvaluationEntretien2Repository evaluationentretien2Repository,
                                        AppreciationService appreciationService,
                                        Entretien1Service entretien1Service) {
        this.evaluationentretien2Repository = evaluationentretien2Repository;
        this.appreciationService = appreciationService;
        this.entretien1Service = entretien1Service;
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

    public List<EvaluationEntretien2> findEntretienReussi()
    {
        return evaluationentretien2Repository.findEvaluationsWithNoteGreaterThan(2);
    }
    public List<EvaluationEntretien1> findEvaluationsEntretien1FromEntretien2() {
        List<Object[]> rows = evaluationentretien2Repository.findEvaluationsEntretien1FromEntretien2(2);
        List<EvaluationEntretien1> result = new ArrayList<>();

        for (Object[] row : rows) {
            EvaluationEntretien1 e = new EvaluationEntretien1();

            if (row[0] != null) e.setId_evaluation_entretien_1(((Number) row[0]).intValue());
            if (row[1] != null) e.setPresence((Boolean) row[1]);
            if (row[2] != null) {
                int appId = ((Number) row[2]).intValue();
                Appreciation app = appreciationService.findById(appId)
                                                    .orElse(null);
                e.setAppreciation(app);
            }
            if (row[3] != null) {
                int entId = ((Number) row[3]).intValue();
                Entretien1 ent = entretien1Service.findById(entId)
                                                .orElse(null);
                e.setEntretien1(ent);
            }
            result.add(e);
        }
        return result;
    }          

}
