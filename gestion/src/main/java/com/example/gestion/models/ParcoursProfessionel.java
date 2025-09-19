package com.example.gestion.models;

import jakarta.persistence.*;
import java.util.Date;

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
    @Column(name = "date_debut")
    private Date dateDebut;

    @Temporal(TemporalType.DATE)
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
}
