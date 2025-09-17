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

    @OneToMany(mappedBy = "filiere")
    private List<Diplome> diplomes = new ArrayList<>();

    // Getters & Setters
    public Integer getIdFiliere() { return idFiliere; }
    public void setIdFiliere(Integer idFiliere) { this.idFiliere = idFiliere; }

    public String getLibelle() { return libelle; }
    public void setLibelle(String libelle) { this.libelle = libelle; }

    public List<Diplome> getDiplomes() { return diplomes; }
    public void setDiplomes(List<Diplome> diplomes) { this.diplomes = diplomes; }
}

