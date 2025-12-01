package com.example.gestion.models;

import jakarta.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "heures_supplementaire")
public class HeuresSupplementaire {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Id_heures_supplementaire")
    private Long id;

    @Column(name = "nb_heures")
    private Integer nbHeures;

    @Column(name = "montant")
    private Double montant;

    @Column(name = "date_heure_sup")
    private LocalDate dateHeureSup;

    @ManyToOne
    @JoinColumn(name = "Id_heures_sup", nullable = false)
    private HeuresSupType heuresSupType;

    // CORRECTION : Relation directe avec Personnel (OneToMany)
    @ManyToOne
    @JoinColumn(name = "Id_personnel") // Cette colonne doit exister dans votre table
    private Personnel personnel;

    // Constructeurs
    public HeuresSupplementaire() {}

    public HeuresSupplementaire(Integer nbHeures, Double montant, LocalDate dateHeureSup, HeuresSupType heuresSupType, Personnel personnel) {
        this.nbHeures = nbHeures;
        this.montant = montant;
        this.dateHeureSup = dateHeureSup;
        this.heuresSupType = heuresSupType;
        this.personnel = personnel;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Integer getNbHeures() {
        return nbHeures;
    }

    public void setNbHeures(Integer nbHeures) {
        this.nbHeures = nbHeures;
    }

    public Double getMontant() {
        return montant;
    }

    public void setMontant(Double montant) {
        this.montant = montant;
    }

    public LocalDate getDateHeureSup() {
        return dateHeureSup;
    }

    public void setDateHeureSup(LocalDate dateHeureSup) {
        this.dateHeureSup = dateHeureSup;
    }

    public HeuresSupType getHeuresSupType() {
        return heuresSupType;
    }

    public void setHeuresSupType(HeuresSupType heuresSupType) {
        this.heuresSupType = heuresSupType;
    }

    // CORRECTION : Ajouter le getter pour personnel
    public Personnel getPersonnel() {
        return personnel;
    }

    public void setPersonnel(Personnel personnel) {
        this.personnel = personnel;
    }

    // Méthode utilitaire pour calculer le montant automatiquement
    public void calculerMontant(Double salaireHoraire) {
        if (heuresSupType != null && heuresSupType.getTaux() != null && nbHeures != null && salaireHoraire != null) {
            this.montant = nbHeures * salaireHoraire * heuresSupType.getTaux();
        }
    }

    public int getMois() {
        return dateHeureSup != null ? dateHeureSup.getMonthValue() : 0;
    }

    public int getAnnee() {
        return dateHeureSup != null ? dateHeureSup.getYear() : 0;
    }
}