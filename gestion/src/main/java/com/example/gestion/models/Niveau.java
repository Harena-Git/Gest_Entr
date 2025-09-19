package com.example.gestion.models;

import jakarta.persistence.*;

@Entity
@Table(name = "niveau")
public class Niveau {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Id_niveau")
    private Integer idNiveau;

    @Column(name = "libelle", nullable = false, length = 50)
    private String libelle;

    // --- Constructeurs ---
    public Niveau() {
    }

    public Niveau(String libelle) {
        this.libelle = libelle;
    }

    // --- Getters et Setters ---
    public Integer getIdNiveau() {
        return idNiveau;
    }

    public void setIdNiveau(Integer idNiveau) {
        this.idNiveau = idNiveau;
    }

    public String getLibelle() {
        return libelle;
    }

    public void setLibelle(String libelle) {
        this.libelle = libelle;
    }
}
