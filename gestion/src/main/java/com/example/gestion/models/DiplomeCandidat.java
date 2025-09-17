package com.example.gestion.models;

import jakarta.persistence.*;

@Entity
@Table(name = "diplome_candidat")
public class DiplomeCandidat {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id_diplome_candidat;

    private String etablissement;
    private Integer annee_obtention;

    @ManyToOne
    @JoinColumn(name = "id_diplome")
    private Diplome diplome;

    @ManyToOne
    @JoinColumn(name = "id_candidat")
    private Candidat candidat;

    public Integer getId_diplome_candidat() { return id_diplome_candidat; }
    public void setId_diplome_candidat(Integer id_diplome_candidat) { this.id_diplome_candidat = id_diplome_candidat; }

    public String getEtablissement() { return etablissement; }
    public void setEtablissement(String etablissement) { this.etablissement = etablissement; }

    public Integer getAnnee_obtention() { return annee_obtention; }
    public void setAnnee_obtention(Integer annee_obtention) { this.annee_obtention = annee_obtention; }

    public Diplome getDiplome() { return diplome; }
    public void setDiplome(Diplome diplome) { this.diplome = diplome; }

    public Candidat getCandidat() { return candidat; }
    public void setCandidat(Candidat candidat) { this.candidat = candidat; }
}
