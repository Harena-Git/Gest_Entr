package com.example.gestion.models;

import jakarta.persistence.*;
import java.util.ArrayList;

import java.util.List;

@Entity
@Table(name = "heures_sup_type")
public class HeuresSupType {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Id_heures_sup")
    private Integer idHeuresSup;

    @Column(name = "libelle", length = 50)
    private String libelle;

    @Column(name = "taux")
    private Double taux;

    @OneToMany(mappedBy = "heuresSupType", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<HeuresSupplementaire> heuresSupplementaires = new ArrayList<>();

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