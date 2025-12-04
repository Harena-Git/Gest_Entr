package com.example.gestion.models;

import java.util.Date;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;

@Entity
@Table(name = "demande_conge")
public class DemandeConge {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id_demande_conge;

    @Temporal(TemporalType.DATE)
    private Date date_demande;

    @Temporal(TemporalType.DATE)
    private Date date_debut;

    @Temporal(TemporalType.DATE)
    private Date date_fin;

    private Integer nombre_jours;

    private String motif;

    @ManyToOne
    @JoinColumn(name = "id_personnel", nullable = false)
    private Personnel personnel;

    @ManyToOne
    @JoinColumn(name = "id_statut_demande", nullable = false)
    private StatutDemande statutDemande;

    // Constructeurs
    public DemandeConge() {
        this.date_demande = new Date();
    }

    public DemandeConge(Date date_debut, Date date_fin, Integer nombre_jours, 
                        String motif, Personnel personnel, StatutDemande statutDemande) {
        this.date_demande = new Date();
        this.date_debut = date_debut;
        this.date_fin = date_fin;
        this.nombre_jours = nombre_jours;
        this.motif = motif;
        this.personnel = personnel;
        this.statutDemande = statutDemande;
    }

    // Getters et Setters
    public Integer getId_demande_conge() {
        return id_demande_conge;
    }

    public void setId_demande_conge(Integer id_demande_conge) {
        this.id_demande_conge = id_demande_conge;
    }

    public Date getDate_demande() {
        return date_demande;
    }

    public void setDate_demande(Date date_demande) {
        this.date_demande = date_demande;
    }

    public Date getDate_debut() {
        return date_debut;
    }

    public void setDate_debut(Date date_debut) {
        this.date_debut = date_debut;
    }

    public Date getDate_fin() {
        return date_fin;
    }

    public void setDate_fin(Date date_fin) {
        this.date_fin = date_fin;
    }

    public Integer getNombre_jours() {
        return nombre_jours;
    }

    public void setNombre_jours(Integer nombre_jours) {
        this.nombre_jours = nombre_jours;
    }

    public String getMotif() {
        return motif;
    }

    public void setMotif(String motif) {
        this.motif = motif;
    }

    public Personnel getPersonnel() {
        return personnel;
    }

    public void setPersonnel(Personnel personnel) {
        this.personnel = personnel;
    }

    public StatutDemande getStatutDemande() {
        return statutDemande;
    }

    public void setStatutDemande(StatutDemande statutDemande) {
        this.statutDemande = statutDemande;
    }

    @Override
    public String toString() {
        return "DemandeConge{" +
                "id_demande_conge=" + id_demande_conge +
                ", date_demande=" + date_demande +
                ", date_debut=" + date_debut +
                ", date_fin=" + date_fin +
                ", nombre_jours=" + nombre_jours +
                ", motif='" + motif + '\'' +
                '}';
    }
}
