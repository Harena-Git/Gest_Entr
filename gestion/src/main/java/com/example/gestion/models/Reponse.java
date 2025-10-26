package com.example.gestion.models;

import jakarta.persistence.*;

@Entity
@Table(name = "reponse")
public class Reponse {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id_reponse;

    @ManyToOne
    @JoinColumn(name = "Id_profil")
    private Profil profil;

    @ManyToOne
    @JoinColumn(name = "Id_question")
    private Question question;

    @ManyToOne
    @JoinColumn(name = "Id_choix")
    private Choix choix;

    // Getters and Setters
    public Integer getId_reponse() { return id_reponse; }
    public void setId_reponse(Integer id_reponse) { this.id_reponse = id_reponse; }

    public Profil getProfil() { return profil; }
    public void setProfil(Profil profil) { this.profil = profil; }

    public Question getQuestion() { return question; }
    public void setQuestion(Question question) { this.question = question; }

    public Choix getChoix() { return choix; }
    public void setChoix(Choix choix) { this.choix = choix; }
}
