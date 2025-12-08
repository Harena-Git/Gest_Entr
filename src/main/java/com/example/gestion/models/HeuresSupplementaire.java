package com.example.gestion.models;

import jakarta.persistence.*;
import java.util.List;

@Entity
@Table(name = "heures_supplementaire")
public class HeuresSupplementaire {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer idHeuresSupplementaire;

    @Column(name = "nb_heures")
    private Integer nbHeures;

    @Column
    private Double montant;

    @ManyToOne
    @JoinColumn(name = "Id_heures_sup", nullable = false)
    private HeuresSupType heuresSupType;

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

    public HeuresSupType getHeuresSupType() {
        return heuresSupType;
    }

    public void setHeuresSupType(HeuresSupType heuresSupType) {
        this.heuresSupType = heuresSupType;
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