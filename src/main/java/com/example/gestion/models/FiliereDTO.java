package com.example.gestion.models;

public class FiliereDTO {

    private Integer id;
    private String libelle;

    // Constructeur vide (nécessaire pour Jackson)
    public FiliereDTO() {
    }

    // Constructeur avec paramètres
    public FiliereDTO(Integer id, String libelle) {
        this.id = id;
        this.libelle = libelle;
    }

    // Getters et setters
    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getLibelle() {
        return libelle;
    }

    public void setLibelle(String libelle) {
        this.libelle = libelle;
    }

}
