package com.example.gestion.models;

import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "contrat_essai")
public class ContratEssai {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id_contrat_essai;

    private Date date_debut;
    private String date_fin;

    @OneToOne
    @JoinColumn(name = "id_candidat")
    private Candidat candidat;

    public Integer getId_contrat_essai() { return id_contrat_essai; }
    public void setId_contrat_essai(Integer id_contrat_essai) { this.id_contrat_essai = id_contrat_essai; }

    public Date getDate_debut() { return date_debut; }
    public void setDate_debut(Date date_debut) { this.date_debut = date_debut; }

    public String getDate_fin() { return date_fin; }
    public void setDate_fin(String date_fin) { this.date_fin = date_fin; }

    public Candidat getCandidat() { return candidat; }
    public void setCandidat(Candidat candidat) { this.candidat = candidat; }
}
