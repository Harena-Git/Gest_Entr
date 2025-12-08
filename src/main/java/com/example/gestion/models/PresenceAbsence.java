package com.example.gestion.models;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import java.util.Objects;

@Entity
@Table(name = "presence_absence")
public class PresenceAbsence {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer idPresenceAbsence;

    @Column(name = "date_")
    private LocalDate date;

    @Column(name = "heure_arrivee")
    private LocalTime heureArrivee;

    @Column(name = "heure_depart")
    private LocalTime heureDepart;

    private Boolean present;

    @ManyToOne
    @JoinColumn(name = "Id_personnel")
    private Personnel personnel;

    @ManyToOne
    @JoinColumn(name = "Id_user")
    private User user;

    @OneToMany(mappedBy = "presenceAbsence", fetch = FetchType.LAZY)
    private List<ValidationAbsChef> validationsChef;

    // Constructeurs
    public PresenceAbsence() {}

    public PresenceAbsence(LocalDate date, LocalTime heureArrivee, Boolean present) {
        this.date = date;
        this.heureArrivee = heureArrivee;
        this.present = present;
    }

    // Getters et Setters
    public Integer getIdPresenceAbsence() {
        return idPresenceAbsence;
    }

    public void setIdPresenceAbsence(Integer idPresenceAbsence) {
        this.idPresenceAbsence = idPresenceAbsence;
    }

    public LocalDate getDate() {
        return date;
    }

    public void setDate(LocalDate date) {
        this.date = date;
    }

    public LocalTime getHeureArrivee() {
        return heureArrivee;
    }

    public void setHeureArrivee(LocalTime heureArrivee) {
        this.heureArrivee = heureArrivee;
    }

    public LocalTime getHeureDepart() {
        return heureDepart;
    }

    public void setHeureDepart(LocalTime heureDepart) {
        this.heureDepart = heureDepart;
    }

    public Boolean getPresent() {
        return present;
    }

    public void setPresent(Boolean present) {
        this.present = present;
    }

    public Personnel getPersonnel() {
        return personnel;
    }

    public void setPersonnel(Personnel personnel) {
        this.personnel = personnel;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public List<ValidationAbsChef> getValidationsChef() {
        return validationsChef;
    }

    public void setValidationsChef(List<ValidationAbsChef> validationsChef) {
        this.validationsChef = validationsChef;
    }

    // Indique si l'enregistrement a été validé par les RH (s'il existe une ValidationAbsRh
    // associée à au moins une ValidationAbsChef)
    public boolean isValideParRh() {
        if (validationsChef == null || validationsChef.isEmpty()) return false;
        for (ValidationAbsChef vc : validationsChef) {
            if (vc != null && vc.getValidationRh() != null) {
                return true;
            }
        }
        return false;
    }

    // Méthodes utilitaires
    public boolean isValidePourSortie() {
        return this.heureArrivee != null;
    }

    public boolean isResponsable() {
        return this.user != null && this.personnel == null;
    }

    public Integer getActorId() {
        return personnel != null ? personnel.getId_personnel() : (user != null ? user.getId_user() : null);
    }

    public String getActorType() {
        return personnel != null ? "personnel" : "user";
    }

    public Double getHeuresTravaillees() {
        if (heureArrivee != null && heureDepart != null) {
            long minutes = java.time.Duration.between(heureArrivee, heureDepart).toMinutes();
            return minutes / 60.0;
        }
        return 0.0;
    }
    
}