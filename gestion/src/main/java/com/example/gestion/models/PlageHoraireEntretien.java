package com.example.gestion.models;

import jakarta.persistence.*;
import java.time.LocalTime;
import java.util.Set;

@Entity
@Table(name = "plage_horaire_entretien")
public class PlageHoraireEntretien {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Id_plage")
    private Integer idPlage;

    @Column(name = "heure_debut", nullable = false)
    private LocalTime heureDebut;

    @Column(name = "heure_fin", nullable = false)
    private LocalTime heureFin;

    @Column(name = "duree_entretien_minutes")
    private Integer dureeEntretienMinutes;

    @Column(name = "jours_travail")
    private String joursTravail;

    // Méthode utilitaire pour obtenir les jours de travail comme Set
    public Set<String> getJoursTravailSet() {
        if (joursTravail != null && !joursTravail.isEmpty()) {
            return Set.of(joursTravail.split(","));
        }
        return Set.of();
    }

    // Méthode utilitaire pour définir les jours de travail à partir d'un Set
    public void setJoursTravailSet(Set<String> joursSet) {
        if (joursSet != null && !joursSet.isEmpty()) {
            this.joursTravail = String.join(",", joursSet);
        } else {
            this.joursTravail = null;
        }
    }

    // Getters and Setters
    public Integer getIdPlage() { return idPlage; }
    public void setIdPlage(Integer idPlage) { this.idPlage = idPlage; }

    public LocalTime getHeureDebut() { return heureDebut; }
    public void setHeureDebut(LocalTime heureDebut) { this.heureDebut = heureDebut; }

    public LocalTime getHeureFin() { return heureFin; }
    public void setHeureFin(LocalTime heureFin) { this.heureFin = heureFin; }

    public Integer getDureeEntretienMinutes() { return dureeEntretienMinutes; }
    public void setDureeEntretienMinutes(Integer dureeEntretienMinutes) { this.dureeEntretienMinutes = dureeEntretienMinutes; }

    public String getJoursTravail() { return joursTravail; }
    public void setJoursTravail(String joursTravail) { this.joursTravail = joursTravail; }
}