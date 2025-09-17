package com.example.gestion.models;

import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "personnel")
public class Personnel {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id_personnel;

    private Date date_embauche;
    private Boolean actif;

    @OneToOne
    @JoinColumn(name = "id_candidat")
    private Candidat candidat;

    @ManyToOne
    @JoinColumn(name = "id_poste")
    private Poste poste;

    public Integer getId_personnel() { return id_personnel; }
    public void setId_personnel(Integer id_personnel) { this.id_personnel = id_personnel; }

    public Date getDate_embauche() { return date_embauche; }
    public void setDate_embauche(Date date_embauche) { this.date_embauche = date_embauche; }

    public Boolean getActif() { return actif; }
    public void setActif(Boolean actif) { this.actif = actif; }

    public Candidat getCandidat() { return candidat; }
    public void setCandidat(Candidat candidat) { this.candidat = candidat; }

    public Poste getPoste() { return poste; }
    public void setPoste(Poste poste) { this.poste = poste; }
}
