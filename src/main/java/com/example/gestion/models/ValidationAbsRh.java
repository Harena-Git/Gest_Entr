package com.example.gestion.models;

import jakarta.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "validationAbs_Rh")
public class ValidationAbsRh {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer idValidationAbsRh;

    @Column(name = "date_validation")
    private LocalDate dateValidation;

    @ManyToOne
    @JoinColumn(name = "Id_user", nullable = false)
    private User user;

    @OneToOne
    @JoinColumn(name = "Id_validationAbs_chef", nullable = false)
    private ValidationAbsChef validationAbsChef;

    @ManyToOne
    @JoinColumn(name = "Id_decision_validation", nullable = false)
    private DecisionValidation decisionValidation;

    // Constructeurs
    public ValidationAbsRh() {}

    public ValidationAbsRh(User user, ValidationAbsChef validationAbsChef, DecisionValidation decisionValidation) {
        this.user = user;
        this.validationAbsChef = validationAbsChef;
        this.decisionValidation = decisionValidation;
        this.dateValidation = LocalDate.now();
    }

    // Getters et Setters
    public Integer getIdValidationAbsRh() {
        return idValidationAbsRh;
    }

    public void setIdValidationAbsRh(Integer idValidationAbsRh) {
        this.idValidationAbsRh = idValidationAbsRh;
    }

    public LocalDate getDateValidation() {
        return dateValidation;
    }

    public void setDateValidation(LocalDate dateValidation) {
        this.dateValidation = dateValidation;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public ValidationAbsChef getValidationAbsChef() {
        return validationAbsChef;
    }

    public void setValidationAbsChef(ValidationAbsChef validationAbsChef) {
        this.validationAbsChef = validationAbsChef;
    }

    public DecisionValidation getDecisionValidation() {
        return decisionValidation;
    }

    public void setDecisionValidation(DecisionValidation decisionValidation) {
        this.decisionValidation = decisionValidation;
    }

    // Méthodes utilitaires
    public boolean isAccepte() {
        return decisionValidation != null && decisionValidation.isAccepte();
    }

    public boolean isRefuse() {
        return decisionValidation != null && decisionValidation.isRefuse();
    }

    public boolean confirmeDecisionChef() {
        return validationAbsChef.getDecisionValidation().getLibelle()
                .equals(decisionValidation.getLibelle());
    }
}