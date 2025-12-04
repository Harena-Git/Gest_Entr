package com.example.gestion.models;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "decision_validation")
public class DecisionValidation {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id_decision_validation;

    private String libelle;

    // Constructeurs
    public DecisionValidation() {}

    public DecisionValidation(String libelle) {
        this.libelle = libelle;
    }

    // Getters et Setters
    public Integer getId_decision_validation() {
        return id_decision_validation;
    }

    public void setId_decision_validation(Integer id_decision_validation) {
        this.id_decision_validation = id_decision_validation;
    }

    public String getLibelle() {
        return libelle;
    }

    public void setLibelle(String libelle) {
        this.libelle = libelle;
    }

    @Override
    public String toString() {
        return "DecisionValidation{" +
                "id_decision_validation=" + id_decision_validation +
                ", libelle='" + libelle + '\'' +
                '}';
    }
}
