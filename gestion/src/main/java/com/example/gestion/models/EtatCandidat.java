package com.example.gestion.models;

import jakarta.persistence.*;
import java.util.*;

@Entity
@Table(name = "etat_candidat")
public class EtatCandidat {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Id_etat_candidat")
    private Integer idEtatCandidat;

    @Column(name = "libelle", nullable = false, unique = true)
    private String libelle;

    @OneToMany(mappedBy = "etatCandidat")
    private List<HistoriqueEtat> historiques = new ArrayList<>();

    // Getters and Setters
    public Integer getIdEtatCandidat() { return idEtatCandidat; }
    public void setIdEtatCandidat(Integer idEtatCandidat) { this.idEtatCandidat = idEtatCandidat; }

    public String getLibelle() { return libelle; }
    public void setLibelle(String libelle) { this.libelle = libelle; }

   
}
