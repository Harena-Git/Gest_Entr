package com.example.gestion.models;

import jakarta.persistence.*;

import java.util.List;

@Entity
@Table(name = "heures_sup_type")
public class HeuresSupType {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer idHeuresSup;

    @Column(nullable = false, length = 50)
    private String libelle;

    @Column(nullable = false)
    private Double taux;

    @OneToMany(mappedBy = "heuresSupType")
    private List<HeuresSupplementaire> heuresSupplementaires;

    // Constructeurs
    public HeuresSupType() {}

    public HeuresSupType(String libelle, Double taux) {
        this.libelle = libelle;
        this.taux = taux;
    }

    // Getters et Setters
    public Integer getIdHeuresSup() {
        return idHeuresSup;
    }

    public void setIdHeuresSup(Integer idHeuresSup) {
        this.idHeuresSup = idHeuresSup;
    }

    public String getLibelle() {
        return libelle;
    }

    public void setLibelle(String libelle) {
        this.libelle = libelle;
    }

    public Double getTaux() {
        return taux;
    }

    public void setTaux(Double taux) {
        this.taux = taux;
    }

    public List<HeuresSupplementaire> getHeuresSupplementaires() {
        return heuresSupplementaires;
    }

    public void setHeuresSupplementaires(List<HeuresSupplementaire> heuresSupplementaires) {
        this.heuresSupplementaires = heuresSupplementaires;
    }
}