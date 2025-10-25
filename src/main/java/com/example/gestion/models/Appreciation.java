package com.example.gestion.models;

import jakarta.persistence.*;

@Entity
@Table(name = "appreciation")
public class Appreciation {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id_appreciation;

    private String libelle;
    private Integer note;

    @OneToOne(mappedBy = "appreciation")
    private EvaluationEntretien1 evaluationEntretien1;

    @OneToOne(mappedBy = "appreciation")
    private EvaluationEntretien2 evaluationEntretien2;

    public Integer getId_appreciation() { return id_appreciation; }
    public void setId_appreciation(Integer id_appreciation) { this.id_appreciation = id_appreciation; }

    public String getLibelle() { return libelle; }
    public void setLibelle(String libelle) { this.libelle = libelle; }

    public Integer getNote() { return note; }
    public void setNote(Integer note) { this.note = note; }

    public EvaluationEntretien1 getEvaluationEntretien1() { return evaluationEntretien1; }
    public void setEvaluationEntretien1(EvaluationEntretien1 evaluationEntretien1) { this.evaluationEntretien1 = evaluationEntretien1; }

    public EvaluationEntretien2 getEvaluationEntretien2() { return evaluationEntretien2; }
    public void setEvaluationEntretien2(EvaluationEntretien2 evaluationEntretien2) { this.evaluationEntretien2 = evaluationEntretien2; }
}
