package com.example.gestion.models;

import jakarta.persistence.*;
import java.util.List;

@Entity
@Table(name = "choix")
public class Choix {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id_choix;

    private String libelle;
    private Boolean est_correct;

    @ManyToOne
    @JoinColumn(name = "Id_question")
    private Question question;

    @ManyToOne
    @JoinColumn(name = "Id_question_generale")
    private QuestionGenerale questionGenerale;

    @OneToMany(mappedBy = "choix")
    private List<Reponse> reponses;

    // Getters and Setters
    public Integer getId_choix() { return id_choix; }
    public void setId_choix(Integer id_choix) { this.id_choix = id_choix; }

    public String getLibelle() { return libelle; }
    public void setLibelle(String libelle) { this.libelle = libelle; }

    public Boolean getEst_correct() { return est_correct; }
    public void setEst_correct(Boolean est_correct) { this.est_correct = est_correct; }

    public Question getQuestion() { return question; }
    public void setQuestion(Question question) { this.question = question; }

    public QuestionGenerale getQuestionGenerale() { return questionGenerale; }
    public void setQuestionGenerale(QuestionGenerale questionGenerale) { this.questionGenerale = questionGenerale; }
    public List<Reponse> getReponses() { return reponses; }
    public void setReponses(List<Reponse> reponses) { this.reponses = reponses; }
}
