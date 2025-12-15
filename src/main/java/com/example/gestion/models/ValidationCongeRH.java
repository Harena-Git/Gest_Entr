package com.example.gestion.models;

import java.util.Date;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;

@Entity
@Table(name = "validation_conge_rh")
public class ValidationCongeRH {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id_validation_conge_rh;

    @Temporal(TemporalType.DATE)
    private Date date_validation;

    private String commentaire;

    @OneToOne
    @JoinColumn(name = "id_validation_conge_chef", unique = true, nullable = false)
    private ValidationCongeChef validationCongeChef;

    @ManyToOne
    @JoinColumn(name = "id_user", nullable = false)
    private User user;

    @ManyToOne
    @JoinColumn(name = "id_decision_validation", nullable = false)
    private DecisionValidation decisionValidation;

    // Constructeurs
    public ValidationCongeRH() {
        this.date_validation = new Date();
    }

    public ValidationCongeRH(ValidationCongeChef validationCongeChef, 
                             User user, DecisionValidation decisionValidation) {
        this.date_validation = new Date();
        this.validationCongeChef = validationCongeChef;
        this.user = user;
        this.decisionValidation = decisionValidation;
    }

    public ValidationCongeRH(ValidationCongeChef validationCongeChef, 
                             User user, DecisionValidation decisionValidation, String commentaire) {
        this.date_validation = new Date();
        this.validationCongeChef = validationCongeChef;
        this.user = user;
        this.decisionValidation = decisionValidation;
        this.commentaire = commentaire;
    }

    // Getters et Setters
    public Integer getId_validation_conge_rh() {
        return id_validation_conge_rh;
    }

    public void setId_validation_conge_rh(Integer id_validation_conge_rh) {
        this.id_validation_conge_rh = id_validation_conge_rh;
    }

    public Date getDate_validation() {
        return date_validation;
    }

    public void setDate_validation(Date date_validation) {
        this.date_validation = date_validation;
    }

    public String getCommentaire() {
        return commentaire;
    }

    public void setCommentaire(String commentaire) {
        this.commentaire = commentaire;
    }

    public ValidationCongeChef getValidationCongeChef() {
        return validationCongeChef;
    }

    public void setValidationCongeChef(ValidationCongeChef validationCongeChef) {
        this.validationCongeChef = validationCongeChef;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public DecisionValidation getDecisionValidation() {
        return decisionValidation;
    }

    public void setDecisionValidation(DecisionValidation decisionValidation) {
        this.decisionValidation = decisionValidation;
    }

    @Override
    public String toString() {
        return "ValidationCongeRH{" +
                "id_validation_conge_rh=" + id_validation_conge_rh +
                ", date_validation=" + date_validation +
                ", commentaire='" + commentaire + '\'' +
                '}';
    }
}
