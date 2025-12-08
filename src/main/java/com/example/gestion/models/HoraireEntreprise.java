package com.example.gestion.models;

import jakarta.persistence.*;
import java.time.LocalTime;

@Entity
@Table(name = "horaire_entreprise")
public class HoraireEntreprise {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer idHoraire;

    @Column(name = "heure_debut", nullable = false)
    private LocalTime heureDebut;

    @Column(name = "heure_fin", nullable = false)
    private LocalTime heureFin;

    @Column(name = "pause_debut")
    private LocalTime pauseDebut;

    @Column(name = "pause_fin")
    private LocalTime pauseFin;

    // Constructeurs
    public HoraireEntreprise() {}

    public HoraireEntreprise(LocalTime heureDebut, LocalTime heureFin, LocalTime pauseDebut, LocalTime pauseFin) {
        this.heureDebut = heureDebut;
        this.heureFin = heureFin;
        this.pauseDebut = pauseDebut;
        this.pauseFin = pauseFin;
    }

    // Getters et Setters
    public Integer getIdHoraire() {
        return idHoraire;
    }

    public void setIdHoraire(Integer idHoraire) {
        this.idHoraire = idHoraire;
    }

    public LocalTime getHeureDebut() {
        return heureDebut;
    }

    public void setHeureDebut(LocalTime heureDebut) {
        this.heureDebut = heureDebut;
    }

    public LocalTime getHeureFin() {
        return heureFin;
    }

    public void setHeureFin(LocalTime heureFin) {
        this.heureFin = heureFin;
    }

    public LocalTime getPauseDebut() {
        return pauseDebut;
    }

    public void setPauseDebut(LocalTime pauseDebut) {
        this.pauseDebut = pauseDebut;
    }

    public LocalTime getPauseFin() {
        return pauseFin;
    }

    public void setPauseFin(LocalTime pauseFin) {
        this.pauseFin = pauseFin;
    }

    // Méthodes utilitaires
    public int getDureeJourneeMinutes() {
        int totalMinutes = (int) java.time.Duration.between(heureDebut, heureFin).toMinutes();
        if (pauseDebut != null && pauseFin != null) {
            int pauseMinutes = (int) java.time.Duration.between(pauseDebut, pauseFin).toMinutes();
            totalMinutes -= pauseMinutes;
        }
        return totalMinutes;
    }

    public int getDureePauseMinutes() {
        if (pauseDebut != null && pauseFin != null) {
            return (int) java.time.Duration.between(pauseDebut, pauseFin).toMinutes();
        }
        return 0;
    }

    public boolean estEnRetard(LocalTime heureArrivee) {
        return heureArrivee.isAfter(heureDebut);
    }

    public int calculerMinutesRetard(LocalTime heureArrivee) {
        if (estEnRetard(heureArrivee)) {
            return (int) java.time.Duration.between(heureDebut, heureArrivee).toMinutes();
        }
        return 0;
    }
}