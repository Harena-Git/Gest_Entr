package com.example.gestion.models;

import jakarta.persistence.*;

@Entity
@Table(name = "niveau")
public class Niveau {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Id_niveau")
    private Integer id_niveau;

    @Column(name = "libelle", nullable = false, length = 50)
    private String libelle;

    // --- Constructeurs ---
    public Niveau() {
    }

    public Niveau(String libelle) {
        this.libelle = libelle;
    }

    // --- Getters et Setters ---
    public Integer getId_niveau() { return id_niveau; }
	public void setId_niveau(Integer id_niveau) { this.id_niveau = id_niveau; }

    public String getLibelle() {
        return libelle;
    }

    public void setLibelle(String libelle) {
        this.libelle = libelle;
    }
}
