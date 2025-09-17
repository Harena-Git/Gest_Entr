package com.example.gestion.models;

import jakarta.persistence.*;

@Entity
@Table(name = "historique_etat")
public class HistoriqueEtat {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id_historique_etat;

    private String date_changement;

    @ManyToOne
    @JoinColumn(name = "Id_candidat")
    private Candidat candidat;

    @ManyToOne
    @JoinColumn(name = "Id_etat_candidat")
    private EtatCandidat etatCandidat;

    // Getters and Setters
    public Integer getId_historique_etat() { return id_historique_etat; }
    public void setId_historique_etat(Integer id_historique_etat) { this.id_historique_etat = id_historique_etat; }

    public String getDate_changement() { return date_changement; }
    public void setDate_changement(String date_changement) { this.date_changement = date_changement; }

    public Candidat getCandidat() { return candidat; }
    public void setCandidat(Candidat candidat) { this.candidat = candidat; }

    public EtatCandidat getEtatCandidat() { return etatCandidat; }
    public void setEtatCandidat(EtatCandidat etatCandidat) { this.etatCandidat = etatCandidat; }
}
