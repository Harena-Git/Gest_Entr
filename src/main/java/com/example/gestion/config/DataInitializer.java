package com.example.gestion.config;

import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import com.example.gestion.models.DecisionValidation;
import com.example.gestion.models.StatutDemande;
import com.example.gestion.repository.DecisionValidationRepository;
import com.example.gestion.repository.StatutDemandeRepository;

@Component
public class DataInitializer implements CommandLineRunner {

    private final DecisionValidationRepository decisionValidationRepository;
    private final StatutDemandeRepository statutDemandeRepository;

    public DataInitializer(DecisionValidationRepository decisionValidationRepository,
                          StatutDemandeRepository statutDemandeRepository) {
        this.decisionValidationRepository = decisionValidationRepository;
        this.statutDemandeRepository = statutDemandeRepository;
    }

    @Override
    public void run(String... args) throws Exception {
        initializeDecisions();
        initializeStatuts();
    }

    private void initializeDecisions() {
        String[] decisions = {
            "Approuvée",
            "Rejetée",
            "Approuvée avec modifications",
            "En attente",
            "À reviser",
            "Conditionnel",
            "Reportée",
            "Annulée",
            "Automatiquement approuvée",
            "Nécessite approbation supérieure"
        };

        for (String decision : decisions) {
            if (decisionValidationRepository.findByLibelle(decision).isEmpty()) {
                DecisionValidation dv = new DecisionValidation();
                dv.setLibelle(decision);
                decisionValidationRepository.save(dv);
                System.out.println("✓ Créé: décision '" + decision + "'");
            }
        }
    }

    private void initializeStatuts() {
        String[] statuts = {
            "En attente",
            "Approuvée par chef",
            "Approuvée par RH",
            "Rejetée par chef",
            "Rejetée par RH",
            "Annulée"
        };

        for (String statut : statuts) {
            if (statutDemandeRepository.findByLibelle(statut).isEmpty()) {
                StatutDemande sd = new StatutDemande();
                sd.setLibelle(statut);
                statutDemandeRepository.save(sd);
                System.out.println("✓ Créé: statut '" + statut + "'");
            }
        }
    }
}
