package com.example.gestion.models;

import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "type_contrat")
public class TypeContrat {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id_type_contrat;
    
    private String libelle; // CDD, CDI, Stage, Freelance
    
    // Getters et Setters
    public Integer getId_type_contrat() { return id_type_contrat; }
    public void setId_type_contrat(Integer id_type_contrat) { this.id_type_contrat = id_type_contrat; }
    
    public String getLibelle() { return libelle; }
    public void setLibelle(String libelle) { this.libelle = libelle; }
}
