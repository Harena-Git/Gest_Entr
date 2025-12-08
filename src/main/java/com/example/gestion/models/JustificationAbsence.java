package com.example.gestion.models;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.util.List;

@Entity
@Table(name = "justification_absence")
public class JustificationAbsence {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer idJustificationAbsence;

    @Column(name = "date_demande")
    private LocalDate dateDemande;

    @Column(name = "fichier_justification")
    @Lob
    private String fichierJustification;

    @Column(name = "date_absence")
    private LocalDate dateAbsence;

    @Column(name = "est_justifie")
    private Boolean estJustifie = false;

    @ManyToOne
    @JoinColumn(name = "Id_personnel", nullable = false)
    private Personnel personnel;

    @OneToMany(mappedBy = "justificationAbsence")
    private List<ValidationAbsChef> validationsChef;

    // Constructeurs
    public JustificationAbsence() {}

    public JustificationAbsence(LocalDate dateDemande, LocalDate dateAbsence, Personnel personnel) {
        this.dateDemande = dateDemande;
        this.dateAbsence = dateAbsence;
        this.personnel = personnel;
        this.estJustifie = false;
    }

    // Getters et Setters
    public Integer getIdJustificationAbsence() {
        return idJustificationAbsence;
    }

    public void setIdJustificationAbsence(Integer idJustificationAbsence) {
        this.idJustificationAbsence = idJustificationAbsence;
    }

    public LocalDate getDateDemande() {
        return dateDemande;
    }

    public void setDateDemande(LocalDate dateDemande) {
        this.dateDemande = dateDemande;
    }

    public String getFichierJustification() {
        return fichierJustification;
    }

    public void setFichierJustification(String fichierJustification) {
        this.fichierJustification = fichierJustification;
    }

    public LocalDate getDateAbsence() {
        return dateAbsence;
    }

    public void setDateAbsence(LocalDate dateAbsence) {
        this.dateAbsence = dateAbsence;
    }

    public Boolean getEstJustifie() {
        return estJustifie;
    }

    public void setEstJustifie(Boolean estJustifie) {
        this.estJustifie = estJustifie;
    }

    public Personnel getPersonnel() {
        return personnel;
    }

    public void setPersonnel(Personnel personnel) {
        this.personnel = personnel;
    }

    public List<ValidationAbsChef> getValidationsChef() {
        return validationsChef;
    }

    public void setValidationsChef(List<ValidationAbsChef> validationsChef) {
        this.validationsChef = validationsChef;
    }

    // Méthodes utilitaires
    public boolean aFichierJustificatif() {
        return fichierJustification != null && !fichierJustification.isEmpty();
    }

    public boolean isEnAttente() {
        return !estJustifie && validationsChef == null || validationsChef.isEmpty();
    }
}