package com.example.gestion.models;

import java.util.Date;

import jakarta.persistence.Column;
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
@Table(name = "historique_poste")
public class HistoriquePoste {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id_historique_poste;
    
    @ManyToOne
    @JoinColumn(name = "id_personnel")
    private Personnel personnel;
    
    @ManyToOne
    @JoinColumn(name = "id_poste")
    private Poste poste;
    
    @Temporal(TemporalType.DATE)
    private Date date_debut;
    
    @Temporal(TemporalType.DATE)
    private Date date_fin;
    
    private String type_mouvement; // Promotion, Mutation, Affectation initiale
    
    @Column(columnDefinition = "TEXT")
    private String motif;
    
    private Double salaire;
    
    // Getters et Setters
    public Integer getId_historique_poste() { return id_historique_poste; }
    public void setId_historique_poste(Integer id_historique_poste) { this.id_historique_poste = id_historique_poste; }
    
    public Personnel getPersonnel() { return personnel; }
    public void setPersonnel(Personnel personnel) { this.personnel = personnel; }
    
    public Poste getPoste() { return poste; }
    public void setPoste(Poste poste) { this.poste = poste; }
    
    public Date getDate_debut() { return date_debut; }
    public void setDate_debut(Date date_debut) { this.date_debut = date_debut; }
    
    public Date getDate_fin() { return date_fin; }
    public void setDate_fin(Date date_fin) { this.date_fin = date_fin; }
    
    public String getType_mouvement() { return type_mouvement; }
    public void setType_mouvement(String type_mouvement) { this.type_mouvement = type_mouvement; }
    
    public String getMotif() { return motif; }
    public void setMotif(String motif) { this.motif = motif; }
    
    public Double getSalaire() { return salaire; }
    public void setSalaire(Double salaire) { this.salaire = salaire; }
}
