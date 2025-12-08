package com.example.gestion.models;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.util.List;

@Entity
@Table(name = "justification_retard")
public class JustificationRetard {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer idJustificationRetard;

    @Column(name = "date_retard", nullable = false)
    private LocalDate dateRetard;

    @Column(name = "minutes_retard", nullable = false)
    private Integer minutesRetard;

    @Column(name = "fichier_justification")
    @Lob
    private String fichierJustification;

    @Column(name = "est_justifie")
    private Boolean estJustifie = false;

    @ManyToOne
    @JoinColumn(name = "Id_personnel", nullable = false)
    private Personnel personnel;

    @OneToMany(mappedBy = "justificationRetard")
    private List<ValidationAbsChef> validationsChef;

    // Constructeurs
    public JustificationRetard() {}

    public JustificationRetard(LocalDate dateRetard, Integer minutesRetard, Personnel personnel) {
        this.dateRetard = dateRetard;
        this.minutesRetard = minutesRetard;
        this.personnel = personnel;
        this.estJustifie = false;
    }

    // Getters et Setters
    public Integer getIdJustificationRetard() {
        return idJustificationRetard;
    }

    public void setIdJustificationRetard(Integer idJustificationRetard) {
        this.idJustificationRetard = idJustificationRetard;
    }

    public LocalDate getDateRetard() {
        return dateRetard;
    }

    public void setDateRetard(LocalDate dateRetard) {
        this.dateRetard = dateRetard;
    }

    public Integer getMinutesRetard() {
        return minutesRetard;
    }

    public void setMinutesRetard(Integer minutesRetard) {
        this.minutesRetard = minutesRetard;
    }

    public String getFichierJustification() {
        return fichierJustification;
    }

    public void setFichierJustification(String fichierJustification) {
        this.fichierJustification = fichierJustification;
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
    public boolean isRetardSignificatif() {
        return minutesRetard >= 15;
    }

    public String getHeuresRetardFormatees() {
        int heures = minutesRetard / 60;
        int minutes = minutesRetard % 60;
        return "%dh%02d".formatted(heures, minutes);
    }

    public boolean aFichierJustificatif() {
        return fichierJustification != null && !fichierJustification.isEmpty();
    }
}