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
@Table(name = "validation_conge_chef")
public class ValidationCongeChef {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id_validation_conge_chef;

    @Temporal(TemporalType.DATE)
    private Date date_validation;

    private String commentaire;

    @ManyToOne
    @JoinColumn(name = "id_user", nullable = false)
    private User user;

    @OneToOne
    @JoinColumn(name = "id_demande_conge", unique = true, nullable = false)
    private DemandeConge demandeConge;

    @ManyToOne
    @JoinColumn(name = "id_decision_validation", nullable = false)
    private DecisionValidation decisionValidation;

    // Constructeurs
    public ValidationCongeChef() {
        this.date_validation = new Date();
    }

    public ValidationCongeChef(User user, DemandeConge demandeConge, 
                               DecisionValidation decisionValidation) {
        this.date_validation = new Date();
        this.user = user;
        this.demandeConge = demandeConge;
        this.decisionValidation = decisionValidation;
    }

    public ValidationCongeChef(User user, DemandeConge demandeConge, 
                               DecisionValidation decisionValidation, String commentaire) {
        this.date_validation = new Date();
        this.user = user;
        this.demandeConge = demandeConge;
        this.decisionValidation = decisionValidation;
        this.commentaire = commentaire;
    }

    // Getters et Setters
    public Integer getId_validation_conge_chef() {
        return id_validation_conge_chef;
    }

    public void setId_validation_conge_chef(Integer id_validation_conge_chef) {
        this.id_validation_conge_chef = id_validation_conge_chef;
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

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public DemandeConge getDemandeConge() {
        return demandeConge;
    }

    public void setDemandeConge(DemandeConge demandeConge) {
        this.demandeConge = demandeConge;
    }

    public DecisionValidation getDecisionValidation() {
        return decisionValidation;
    }

    public void setDecisionValidation(DecisionValidation decisionValidation) {
        this.decisionValidation = decisionValidation;
    }

    @Override
    public String toString() {
        return "ValidationCongeChef{" +
                "id_validation_conge_chef=" + id_validation_conge_chef +
                ", date_validation=" + date_validation +
                ", commentaire='" + commentaire + '\'' +
                '}';
    }
}
