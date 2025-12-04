package com.example.gestion.models;

import jakarta.persistence.*;

@Entity
@Table(name = "statut_demande")
public class StatutDemande {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id_statut_demande;

    private String libelle;

    // Constructeurs
    public StatutDemande() {}

    public StatutDemande(String libelle) {
        this.libelle = libelle;
    }

    // Getters et Setters
    public Integer getId_statut_demande() {
        return id_statut_demande;
    }

    public void setId_statut_demande(Integer id_statut_demande) {
        this.id_statut_demande = id_statut_demande;
    }

    public String getLibelle() {
        return libelle;
    }

    public void setLibelle(String libelle) {
        this.libelle = libelle;
    }

    @Override
    public String toString() {
        return "StatutDemande{" +
                "id_statut_demande=" + id_statut_demande +
                ", libelle='" + libelle + '\'' +
                '}';
    }
}
