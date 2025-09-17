package com.example.gestion.models;

import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "entretien_1")
public class Entretien1 {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id_entretien;

    private Date date_entretien;

    @ManyToOne
    @JoinColumn(name = "id_user")
    private User user;

    // Lien avec l'évaluation de cet entretien
    @OneToOne(mappedBy = "entretien1")
    private EvaluationEntretien1 evaluation;

    // Lien avec l'entretien_2 associé
    @OneToOne(mappedBy = "entretien1")
    private Entretien2 entretien2;

    public Integer getId_entretien() { return id_entretien; }
    public void setId_entretien(Integer id_entretien) { this.id_entretien = id_entretien; }

    public Date getDate_entretien() { return date_entretien; }
    public void setDate_entretien(Date date_entretien) { this.date_entretien = date_entretien; }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }

    public EvaluationEntretien1 getEvaluation() { return evaluation; }
    public void setEvaluation(EvaluationEntretien1 evaluation) { this.evaluation = evaluation; }

    public Entretien2 getEntretien2() { return entretien2; }
    public void setEntretien2(Entretien2 entretien2) { this.entretien2 = entretien2; }
}
