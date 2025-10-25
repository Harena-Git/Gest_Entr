package com.example.gestion.models;

import jakarta.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "question_generale")
public class QuestionGenerale {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer idQuestionGenerale;

    @Column(name = "libelle")
    private String libelle;

    @Column(name = "ordre")
    private Integer ordre;

    @OneToMany(mappedBy = "questionGenerale")
    private List<Choix> choix = new ArrayList<>();

    // Getters and Setters
    public Integer getIdQuestionGenerale() { return idQuestionGenerale; }
    public void setIdQuestionGenerale(Integer idQuestionGenerale) { this.idQuestionGenerale = idQuestionGenerale; }

    public String getLibelle() { return libelle; }
    public void setLibelle(String libelle) { this.libelle = libelle; }

    public Integer getOrdre() { return ordre; }
    public void setOrdre(Integer ordre) { this.ordre = ordre; }

    public List<Choix> getChoix() { return choix; }
    public void setChoix(List<Choix> choix) { this.choix = choix; }
}