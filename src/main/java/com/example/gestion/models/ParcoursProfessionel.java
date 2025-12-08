package com.example.gestion.models;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

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
@Table(name = "parcours_professionel")
public class ParcoursProfessionel {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Id_parcours_professionel")
    private Integer idParcoursProfessionel;

    @Column(name = "entreprise", length = 50)
    private String entreprise;

    @Column(name = "poste", length = 50)
    private String poste;

    @Temporal(TemporalType.DATE)
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    @Column(name = "date_debut")
    private Date dateDebut;

    @Temporal(TemporalType.DATE)
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    @Column(name = "date_fin")
    private Date dateFin;

    @ManyToOne
    @JoinColumn(name = "Id_candidat", nullable = false)
    private Candidat candidat;

    // ----- Getters & Setters -----

    public Integer getIdParcoursProfessionel() {
        return idParcoursProfessionel;
    }

    public void setIdParcoursProfessionel(Integer idParcoursProfessionel) {
        this.idParcoursProfessionel = idParcoursProfessionel;
    }

    public String getEntreprise() {
        return entreprise;
    }

    public void setEntreprise(String entreprise) {
        this.entreprise = entreprise;
    }

    public String getPoste() {
        return poste;
    }

    public void setPoste(String poste) {
        this.poste = poste;
    }

    public Date getDateDebut() {
        return dateDebut;
    }

    public void setDateDebut(Date dateDebut) {
        this.dateDebut = dateDebut;
    }

    public Date getDateFin() {
        return dateFin;
    }

    public void setDateFin(Date dateFin) {
        this.dateFin = dateFin;
    }

    public Candidat getCandidat() {
        return candidat;
    }

    public void setCandidat(Candidat candidat) {
        this.candidat = candidat;
    }
    
    // Getters avec anciens noms pour compatibilité JSP
    public Date getDate_debut() {
        return dateDebut;
    }
    
    public Date getDate_fin() {
        return dateFin;
    }
}
