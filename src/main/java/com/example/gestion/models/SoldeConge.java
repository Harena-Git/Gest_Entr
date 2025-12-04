package com.example.gestion.models;

import java.util.Date;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;

@Entity
@Table(name = "solde_conge")
public class SoldeConge {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id_solde_conge;

    private Integer solde_annuel;

    private Integer solde_restant;

    @Temporal(TemporalType.DATE)
    private Date date_initialisation;

    @Temporal(TemporalType.DATE)
    private Date date_renouvellement;

    @OneToOne
    @JoinColumn(name = "id_personnel", unique = true, nullable = false)
    private Personnel personnel;

    // Constructeurs
    public SoldeConge() {
        this.date_initialisation = new Date();
        this.solde_annuel = 25;
        this.solde_restant = 25;
    }

    public SoldeConge(Personnel personnel) {
        this.personnel = personnel;
        this.date_initialisation = new Date();
        this.solde_annuel = 25;
        this.solde_restant = 25;
    }

    public SoldeConge(Personnel personnel, Integer solde_annuel) {
        this.personnel = personnel;
        this.solde_annuel = solde_annuel;
        this.solde_restant = solde_annuel;
        this.date_initialisation = new Date();
    }

    // Getters et Setters
    public Integer getId_solde_conge() {
        return id_solde_conge;
    }

    public void setId_solde_conge(Integer id_solde_conge) {
        this.id_solde_conge = id_solde_conge;
    }

    public Integer getSolde_annuel() {
        return solde_annuel;
    }

    public void setSolde_annuel(Integer solde_annuel) {
        this.solde_annuel = solde_annuel;
    }

    public Integer getSolde_restant() {
        return solde_restant;
    }

    public void setSolde_restant(Integer solde_restant) {
        this.solde_restant = solde_restant;
    }

    public Date getDate_initialisation() {
        return date_initialisation;
    }

    public void setDate_initialisation(Date date_initialisation) {
        this.date_initialisation = date_initialisation;
    }

    public Date getDate_renouvellement() {
        return date_renouvellement;
    }

    public void setDate_renouvellement(Date date_renouvellement) {
        this.date_renouvellement = date_renouvellement;
    }

    public Personnel getPersonnel() {
        return personnel;
    }

    public void setPersonnel(Personnel personnel) {
        this.personnel = personnel;
    }

    @Override
    public String toString() {
        return "SoldeConge{" +
                "id_solde_conge=" + id_solde_conge +
                ", solde_annuel=" + solde_annuel +
                ", solde_restant=" + solde_restant +
                ", date_initialisation=" + date_initialisation +
                '}';
    }
}
