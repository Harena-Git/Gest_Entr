package com.example.gestion.services;

import com.example.gestion.models.DecisionValidation;
import com.example.gestion.repository.DecisionValidationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class DecisionValidationService {

    @Autowired
    private DecisionValidationRepository decisionValidationRepository;

    // ========== RÉCUPÉRER DÉCISION PAR ID ==========
    public DecisionValidation getDecisionById(Integer id) {
        return decisionValidationRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Décision non trouvée"));
    }

    // ========== RÉCUPÉRER DÉCISION PAR LIBELLÉ ==========
    public DecisionValidation getDecisionByLibelle(String libelle) {
        return decisionValidationRepository.findByLibelle(libelle)
                .orElseThrow(() -> new RuntimeException("Décision non trouvée"));
    }

    // ========== RÉCUPÉRER TOUTES LES DÉCISIONS ==========
    public List<DecisionValidation> getToutesLesDecisions() {
        return decisionValidationRepository.findAll();
    }

    // ========== RÉCUPÉRER DÉCISION "ACCEPTÉ" ==========
    public DecisionValidation getDecisionAccepte() {
        return getDecisionByLibelle("accepté");
    }

    // ========== RÉCUPÉRER DÉCISION "REFUSÉ" ==========
    public DecisionValidation getDecisionRefuse() {
        return getDecisionByLibelle("refusé");
    }

    // ========== INITIALISER LES DÉCISIONS PAR DÉFAUT ==========
    public void initialiserDecisions() {
        if (!decisionValidationRepository.existsByLibelle("accepté")) {
            DecisionValidation accepte = new DecisionValidation("accepté");
            decisionValidationRepository.save(accepte);
        }

        if (!decisionValidationRepository.existsByLibelle("refusé")) {
            DecisionValidation refuse = new DecisionValidation("refusé");
            decisionValidationRepository.save(refuse);
        }
    }
}