package com.example.gestion.models;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.util.List;

@Entity
@Table(name = "heures_supplementaire")
public class HeuresSupplementaire {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Id_heures_supplementaire")
    private Integer idHeuresSupplementaire;

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

    @OneToMany(mappedBy = "heuresSupplementaire")
    private List<PersonnelHeureSupp> personnelHeureSupps;

    // Constructeurs
    public HeuresSupplementaire() {}

    public HeuresSupplementaire(Integer nbHeures, HeuresSupType heuresSupType) {
        this.nbHeures = nbHeures;
        this.heuresSupType = heuresSupType;
    }

    // Getters et Setters
    public Integer getIdHeuresSupplementaire() {
        return idHeuresSupplementaire;
    }

    public void setIdHeuresSupplementaire(Integer idHeuresSupplementaire) {
        this.idHeuresSupplementaire = idHeuresSupplementaire;
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
    public void calculerMontantBemaso(Double salaireHoraire) {
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
    public List<PersonnelHeureSupp> getPersonnelHeureSupps() {
        return personnelHeureSupps;
    }

    public void setPersonnelHeureSupps(List<PersonnelHeureSupp> personnelHeureSupps) {
        this.personnelHeureSupps = personnelHeureSupps;
    }

    // Méthode utilitaire pour calculer le montant
    public void calculerMontant(Double tauxHoraire) {
        if (nbHeures != null && heuresSupType != null && tauxHoraire != null) {
            Double tauxBD = heuresSupType.getTaux() != null ? heuresSupType.getTaux() : 0.0;
            // calculer en double puis convertir en Double pour la propriété montant
            this.montant = Double.valueOf(tauxHoraire.doubleValue() * nbHeures.doubleValue() * tauxBD.doubleValue());
        }
    }
}