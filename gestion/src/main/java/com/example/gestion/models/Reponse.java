package com.example.gestion.models;

import jakarta.persistence.*;

@Entity
@Table(name = "reponse")
public class Reponse {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id_reponse;

    @ManyToOne
    @JoinColumn(name = "Id_candidat")
    private Candidat candidat;


    @ManyToOne
    @JoinColumn(name = "Id_choix")
    private Choix choix;

    // Getters and Setters
    public Integer getId_reponse() { return id_reponse; }
    public void setId_reponse(Integer id_reponse) { this.id_reponse = id_reponse; }

    public Candidat getCandidat() { return candidat; }
    public void setCandidat(Candidat candidat) { this.candidat = candidat; }


    public Choix getChoix() { return choix; }
    public void setChoix(Choix choix) { this.choix = choix; }
}
