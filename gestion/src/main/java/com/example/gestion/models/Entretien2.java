package com.example.gestion.models;

import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "entretien_2")
public class Entretien2 {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id_entretien_2;

    private Date date_entretien;

    @ManyToOne
    @JoinColumn(name = "id_user")
    private User user;

    @OneToOne
    @JoinColumn(name = "id_entretien_")
    private Entretien1 entretien1;

    @OneToOne(mappedBy = "entretien2")
    private EvaluationEntretien2 evaluation;

    public Integer getId_entretien_2() { return id_entretien_2; }
    public void setId_entretien_2(Integer id_entretien_2) { this.id_entretien_2 = id_entretien_2; }

    public Date getDate_entretien() { return date_entretien; }
    public void setDate_entretien(Date date_entretien) { this.date_entretien = date_entretien; }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }

    public Entretien1 getEntretien1() { return entretien1; }
    public void setEntretien1(Entretien1 entretien1) { this.entretien1 = entretien1; }

    public EvaluationEntretien2 getEvaluation() { return evaluation; }
    public void setEvaluation(EvaluationEntretien2 evaluation) { this.evaluation = evaluation; }
}
