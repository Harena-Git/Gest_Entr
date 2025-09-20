package com.example.gestion.models;
import jakarta.persistence.*;
import java.util.*;

@Entity
@Table(name = "question")
public class Question {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Id_question")
    private Integer idQuestion;

    @Column(name = "libelle")
    private String libelle;

    @ManyToOne
    @JoinColumn(name = "Id_qcm", nullable = false)
    private Qcm qcm;

    @OneToMany(mappedBy = "question")
    private List<Choix> choix = new ArrayList<>();
    // Getters and Setters
    public Integer getIdQuestion() { return idQuestion; }
    public void setIdQuestion(Integer idQuestion) { this.idQuestion = idQuestion; }

    public String getLibelle() { return libelle; }
    public void setLibelle(String libelle) { this.libelle = libelle; }

    public Qcm getQcm() { return qcm; }
    public void setQcm(Qcm qcm) { this.qcm = qcm; }

    public List<Choix> getChoix() { return choix; }
    public void setChoix(List<Choix> choix) { this.choix = choix; }
}

