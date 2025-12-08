package com.example.gestion.models;

import jakarta.persistence.*;
import java.util.List;

@Entity
@Table(name = "decision_validation")
public class DecisionValidation {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer idDecisionValidation;

    @Column(nullable = false, length = 50)
    private String libelle;

    @OneToMany(mappedBy = "decisionValidation")
    private List<ValidationAbsChef> validationsChef;

    @OneToMany(mappedBy = "decisionValidation")
    private List<ValidationAbsRh> validationsRh;

    // Constructeurs
    public DecisionValidation() {}

    public DecisionValidation(String libelle) {
        this.libelle = libelle;
    }

    // Getters et Setters
    public Integer getIdDecisionValidation() {
        return idDecisionValidation;
    }

    public void setIdDecisionValidation(Integer idDecisionValidation) {
        this.idDecisionValidation = idDecisionValidation;
    }

    public String getLibelle() {
        return libelle;
    }

    public void setLibelle(String libelle) {
        this.libelle = libelle;
    }

    public List<ValidationAbsChef> getValidationsChef() {
        return validationsChef;
    }

    public void setValidationsChef(List<ValidationAbsChef> validationsChef) {
        this.validationsChef = validationsChef;
    }

    public List<ValidationAbsRh> getValidationsRh() {
        return validationsRh;
    }

    public void setValidationsRh(List<ValidationAbsRh> validationsRh) {
        this.validationsRh = validationsRh;
    }

    // Méthodes utilitaires
    public boolean isAccepte() {
        return "accepté".equalsIgnoreCase(libelle);
    }

    public boolean isRefuse() {
        return "refusé".equalsIgnoreCase(libelle);
    }
}