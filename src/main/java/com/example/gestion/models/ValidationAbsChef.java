package com.example.gestion.models;

import jakarta.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "validationAbs_chef")
public class ValidationAbsChef {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer idValidationAbsChef;

    @Column(name = "date_validation")
    private LocalDate dateValidation;

    @ManyToOne
    @JoinColumn(name = "Id_user", nullable = false)
    private User user;

    @ManyToOne
    @JoinColumn(name = "Id_presence_absence", nullable = false)
    private PresenceAbsence presenceAbsence;

    @ManyToOne
    @JoinColumn(name = "Id_justification_absence")
    private JustificationAbsence justificationAbsence;

    @ManyToOne
    @JoinColumn(name = "Id_justification_retard")
    private JustificationRetard justificationRetard;

    @ManyToOne
    @JoinColumn(name = "Id_decision_validation", nullable = false)
    private DecisionValidation decisionValidation;

    @OneToOne(mappedBy = "validationAbsChef")
    private ValidationAbsRh validationRh;

    // Constructeurs
    public ValidationAbsChef() {}

    public ValidationAbsChef(User user, PresenceAbsence presenceAbsence, DecisionValidation decisionValidation) {
        this.user = user;
        this.presenceAbsence = presenceAbsence;
        this.decisionValidation = decisionValidation;
        this.dateValidation = LocalDate.now();
    }

    // Getters et Setters
    public Integer getIdValidationAbsChef() {
        return idValidationAbsChef;
    }

    public void setIdValidationAbsChef(Integer idValidationAbsChef) {
        this.idValidationAbsChef = idValidationAbsChef;
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

    public PresenceAbsence getPresenceAbsence() {
        return presenceAbsence;
    }

    public void setPresenceAbsence(PresenceAbsence presenceAbsence) {
        this.presenceAbsence = presenceAbsence;
    }

    public JustificationAbsence getJustificationAbsence() {
        return justificationAbsence;
    }

    public void setJustificationAbsence(JustificationAbsence justificationAbsence) {
        this.justificationAbsence = justificationAbsence;
    }

    public JustificationRetard getJustificationRetard() {
        return justificationRetard;
    }

    public void setJustificationRetard(JustificationRetard justificationRetard) {
        this.justificationRetard = justificationRetard;
    }

    public DecisionValidation getDecisionValidation() {
        return decisionValidation;
    }

    public void setDecisionValidation(DecisionValidation decisionValidation) {
        this.decisionValidation = decisionValidation;
    }

    public ValidationAbsRh getValidationRh() {
        return validationRh;
    }

    public void setValidationRh(ValidationAbsRh validationRh) {
        this.validationRh = validationRh;
    }

    // Méthodes utilitaires
    public boolean isAccepte() {
        return decisionValidation != null && decisionValidation.isAccepte();
    }

    public boolean isRefuse() {
        return decisionValidation != null && decisionValidation.isRefuse();
    }

    public boolean isValideParRh() {
        return validationRh != null;
    }

    public String getTypeJustification() {
        if (justificationAbsence != null) return "absence";
        if (justificationRetard != null) return "retard";
        return "presence";
    }
}