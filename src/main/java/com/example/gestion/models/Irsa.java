package com.example.gestion.models;

import jakarta.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "IRSA")
public class Irsa {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Id_IRSA")
    private Long id;  // Changé de Integer à Long

    @Column(name = "tranche_min")
    private Double trancheMin;

    @Column(name = "tranche_max")
    private Double trancheMax;

    @Column(name = "taux")
    private Double taux;  // Changé de String à Double (ex: 0.05 pour 5%)

    @Column(name = "date_debut")
    private LocalDate dateDebut;

    @Column(name = "date_fin")
    private LocalDate dateFin;

    @Column(name = "est_actif")
    private Boolean estActif;

    // Constructeurs
    public Irsa() {}

    public Irsa(Double trancheMin, Double trancheMax, Double taux, LocalDate dateDebut, LocalDate dateFin, Boolean estActif) {
        this.trancheMin = trancheMin;
        this.trancheMax = trancheMax;
        this.taux = taux;
        this.dateDebut = dateDebut;
        this.dateFin = dateFin;
        this.estActif = estActif;
    }

    // Getters et Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Double getTrancheMin() {
        return trancheMin;
    }

    public void setTrancheMin(Double trancheMin) {
        this.trancheMin = trancheMin;
    }

    public Double getTrancheMax() {
        return trancheMax;
    }

    public void setTrancheMax(Double trancheMax) {
        this.trancheMax = trancheMax;
    }

    public Double getTaux() {
        return taux;
    }

    public void setTaux(Double taux) {
        this.taux = taux;
    }

    public LocalDate getDateDebut() {
        return dateDebut;
    }

    public void setDateDebut(LocalDate dateDebut) {
        this.dateDebut = dateDebut;
    }

    public LocalDate getDateFin() {
        return dateFin;
    }

    public void setDateFin(LocalDate dateFin) {
        this.dateFin = dateFin;
    }

    public Boolean getEstActif() {
        return estActif;
    }

    public void setEstActif(Boolean estActif) {
        this.estActif = estActif;
    }
}