package com.example.gestion.models;

import java.util.Date;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;

@Entity
@Table(name = "document_personnel")
public class DocumentPersonnel {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id_document;
    
    @ManyToOne
    @JoinColumn(name = "id_personnel")
    private Personnel personnel;
    
    @ManyToOne
    @JoinColumn(name = "id_type_document")
    private TypeDocument typeDocument;
    
    private String nom_fichier;
    private String chemin_fichier;
    
    @Temporal(TemporalType.DATE)
    private Date date_upload;
    
    private String numero_document; // Numéro CIN, diplôme, etc.
    
    @Temporal(TemporalType.DATE)
    private Date date_delivrance;
    
    @Temporal(TemporalType.DATE)
    private Date date_expiration;
    
    @Column(columnDefinition = "TEXT")
    private String remarques;
    
    // Getters et Setters
    public Integer getId_document() { return id_document; }
    public void setId_document(Integer id_document) { this.id_document = id_document; }
    
    public Personnel getPersonnel() { return personnel; }
    public void setPersonnel(Personnel personnel) { this.personnel = personnel; }
    
    public TypeDocument getTypeDocument() { return typeDocument; }
    public void setTypeDocument(TypeDocument typeDocument) { this.typeDocument = typeDocument; }
    
    public String getNom_fichier() { return nom_fichier; }
    public void setNom_fichier(String nom_fichier) { this.nom_fichier = nom_fichier; }
    
    public String getChemin_fichier() { return chemin_fichier; }
    public void setChemin_fichier(String chemin_fichier) { this.chemin_fichier = chemin_fichier; }
    
    public Date getDate_upload() { return date_upload; }
    public void setDate_upload(Date date_upload) { this.date_upload = date_upload; }
    
    public String getNumero_document() { return numero_document; }
    public void setNumero_document(String numero_document) { this.numero_document = numero_document; }
    
    public Date getDate_delivrance() { return date_delivrance; }
    public void setDate_delivrance(Date date_delivrance) { this.date_delivrance = date_delivrance; }
    
    public Date getDate_expiration() { return date_expiration; }
    public void setDate_expiration(Date date_expiration) { this.date_expiration = date_expiration; }
    
    public String getRemarques() { return remarques; }
    public void setRemarques(String remarques) { this.remarques = remarques; }
}
