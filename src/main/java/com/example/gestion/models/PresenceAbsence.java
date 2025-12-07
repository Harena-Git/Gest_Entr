package com.example.gestion.models;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.time.LocalTime;

@Entity
@Table(name = "presence_absence")
public class PresenceAbsence {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Id_presence_absence")
    private Integer idPresenceAbsence;

    @Column(name = "date_")
    private LocalDate date;

    @Column(name = "heure_depart")
    private LocalTime heureDepart;

    @Column(name = "heure_arrivee")
    private LocalTime heureArrivee;

    @Column(name = "present")
    private Boolean present;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "Id_personnel", nullable = false)
    private Personnel personnel;

    public Integer getIdPresenceAbsence() { return idPresenceAbsence; }
    public void setIdPresenceAbsence(Integer idPresenceAbsence) { this.idPresenceAbsence = idPresenceAbsence; }

    public LocalDate getDate() { return date; }
    public void setDate(LocalDate date) { this.date = date; }

    public LocalTime getHeureDepart() { return heureDepart; }
    public void setHeureDepart(LocalTime heureDepart) { this.heureDepart = heureDepart; }

    public LocalTime getHeureArrivee() { return heureArrivee; }
    public void setHeureArrivee(LocalTime heureArrivee) { this.heureArrivee = heureArrivee; }

    public Boolean getPresent() { return present; }
    public void setPresent(Boolean present) { this.present = present; }

    public Personnel getPersonnel() { return personnel; }
    public void setPersonnel(Personnel personnel) { this.personnel = personnel; }
}
