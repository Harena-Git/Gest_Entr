package com.example.gestion.models;

import jakarta.persistence.*;

@Entity
@Table(name = "question_generale")
public class QuestionGenerale {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Id_question_generale")
    private Integer idQuestionGenerale;

    @Column(name = "libelle", length = 50, nullable = false)
    private String libelle;

    // --- Constructeurs ---
    public QuestionGenerale() {
    }

    public QuestionGenerale(String libelle) {
        this.libelle = libelle;
    }

    // --- Getters et Setters ---
    public Integer getIdQuestionGenerale() {
        return idQuestionGenerale;
    }

    public void setIdQuestionGenerale(Integer idQuestionGenerale) {
        this.idQuestionGenerale = idQuestionGenerale;
    }

    public String getLibelle() {
        return libelle;
    }

    public void setLibelle(String libelle) {
        this.libelle = libelle;
    }
}
