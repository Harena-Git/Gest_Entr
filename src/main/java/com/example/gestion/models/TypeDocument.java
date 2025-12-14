package com.example.gestion.models;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "type_document")
public class TypeDocument {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id_type_document;
    
    private String libelle; // CIN, Diplôme, Certificat, Attestation, etc.
    
    // Getters et Setters
    public Integer getId_type_document() { return id_type_document; }
    public void setId_type_document(Integer id_type_document) { this.id_type_document = id_type_document; }
    
    public String getLibelle() { return libelle; }
    public void setLibelle(String libelle) { this.libelle = libelle; }
}
