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
@Table(name = "remplacement")
public class Remplacement {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id_remplacement;

    @Temporal(TemporalType.DATE)
    private Date date_creation;

    private Boolean remplacant_accepte;

    private Boolean notifiee;

    private String commentaire_remplacant;

    @ManyToOne
    @JoinColumn(name = "id_personnel", nullable = false)
    private Personnel personnel;

    @OneToOne
    @JoinColumn(name = "id_demande_conge", unique = true, nullable = false)
    private DemandeConge demandeConge;

    // Constructeurs
    public Remplacement() {
        this.date_creation = new Date();
        this.remplacant_accepte = false;
        this.notifiee = false;
    }

    public Remplacement(Personnel personnel, DemandeConge demandeConge) {
        this.date_creation = new Date();
        this.personnel = personnel;
        this.demandeConge = demandeConge;
        this.remplacant_accepte = false;
        this.notifiee = false;
    }

    // Getters et Setters
    public Integer getId_remplacement() {
        return id_remplacement;
    }

    public void setId_remplacement(Integer id_remplacement) {
        this.id_remplacement = id_remplacement;
    }

    public Date getDate_creation() {
        return date_creation;
    }

    public void setDate_creation(Date date_creation) {
        this.date_creation = date_creation;
    }

    public Boolean getRemplacant_accepte() {
        return remplacant_accepte;
    }

    public void setRemplacant_accepte(Boolean remplacant_accepte) {
        this.remplacant_accepte = remplacant_accepte;
    }

    public Boolean getNotifiee() {
        return notifiee;
    }

    public void setNotifiee(Boolean notifiee) {
        this.notifiee = notifiee;
    }

    public String getCommentaire_remplacant() {
        return commentaire_remplacant;
    }

    public void setCommentaire_remplacant(String commentaire_remplacant) {
        this.commentaire_remplacant = commentaire_remplacant;
    }

    public Personnel getPersonnel() {
        return personnel;
    }

    public void setPersonnel(Personnel personnel) {
        this.personnel = personnel;
    }

    public DemandeConge getDemandeConge() {
        return demandeConge;
    }

    public void setDemandeConge(DemandeConge demandeConge) {
        this.demandeConge = demandeConge;
    }

    @Override
    public String toString() {
        return "Remplacement{" +
                "id_remplacement=" + id_remplacement +
                ", date_creation=" + date_creation +
                ", remplacant_accepte=" + remplacant_accepte +
                ", notifiee=" + notifiee +
                '}';
    }
}
