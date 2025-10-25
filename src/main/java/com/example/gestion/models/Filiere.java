package com.example.gestion.models;

import jakarta.persistence.*;
import java.util.*;

@Entity
@Table(name = "filiere")
public class Filiere {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Id_filiere")
    private Integer idFiliere;

    @Column(name = "libelle")
    private String libelle;

    

    // Getters & Setters
    public Integer getIdFiliere() { return idFiliere; }
    public void setIdFiliere(Integer idFiliere) { this.idFiliere = idFiliere; }

    public String getLibelle() { return libelle; }
    public void setLibelle(String libelle) { this.libelle = libelle; }

    
}

