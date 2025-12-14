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
@Table(name = "contrat_travail")
public class ContratTravail {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id_contrat_travail;
    
    @ManyToOne
    @JoinColumn(name = "id_personnel")
    private Personnel personnel;
    
    @ManyToOne
    @JoinColumn(name = "id_type_contrat")
    private TypeContrat typeContrat;
    
    @Temporal(TemporalType.DATE)
    private Date date_debut;
    
    @Temporal(TemporalType.DATE)
    private Date date_fin;
    
    private Integer duree_mois;
    
    @Temporal(TemporalType.DATE)
    private Date date_fin_periode_essai;
    
    private Boolean renouvele;
    
    @Temporal(TemporalType.DATE)
    private Date date_alerte;
    
    private String statut; // Actif, Terminé, Renouvelé
    
    @Column(columnDefinition = "TEXT")
    private String remarques;
    
    // Getters et Setters
    public Integer getId_contrat_travail() { return id_contrat_travail; }
    public void setId_contrat_travail(Integer id_contrat_travail) { this.id_contrat_travail = id_contrat_travail; }
    
    public Personnel getPersonnel() { return personnel; }
    public void setPersonnel(Personnel personnel) { this.personnel = personnel; }
    
    public TypeContrat getTypeContrat() { return typeContrat; }
    public void setTypeContrat(TypeContrat typeContrat) { this.typeContrat = typeContrat; }
    
    public Date getDate_debut() { return date_debut; }
    public void setDate_debut(Date date_debut) { this.date_debut = date_debut; }
    
    public Date getDate_fin() { return date_fin; }
    public void setDate_fin(Date date_fin) { this.date_fin = date_fin; }
    
    public Integer getDuree_mois() { return duree_mois; }
    public void setDuree_mois(Integer duree_mois) { this.duree_mois = duree_mois; }
    
    public Date getDate_fin_periode_essai() { return date_fin_periode_essai; }
    public void setDate_fin_periode_essai(Date date_fin_periode_essai) { this.date_fin_periode_essai = date_fin_periode_essai; }
    
    public Boolean getRenouvele() { return renouvele; }
    public void setRenouvele(Boolean renouvele) { this.renouvele = renouvele; }
    
    public Date getDate_alerte() { return date_alerte; }
    public void setDate_alerte(Date date_alerte) { this.date_alerte = date_alerte; }
    
    public String getStatut() { return statut; }
    public void setStatut(String statut) { this.statut = statut; }
    
    public String getRemarques() { return remarques; }
    public void setRemarques(String remarques) { this.remarques = remarques; }
}
