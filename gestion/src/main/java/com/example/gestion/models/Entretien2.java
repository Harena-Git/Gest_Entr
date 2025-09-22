package com.example.gestion.models;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.time.LocalTime;

@Entity
@Table(name = "entretien_2")
public class Entretien2 {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Id_entretien_2")
    private Integer idEntretien2;

    @Column(name = "date_entretien")
    private LocalDate dateEntretien;

    @Column(name = "heure_entretien")
    private LocalTime heureEntretien;

    @ManyToOne
    @JoinColumn(name = "Id_user", nullable = false)
    private User user;

    @OneToOne
    @JoinColumn(name = "Id_entretien_", nullable = false)
    private Entretien1 entretien1;

    @OneToOne(mappedBy = "entretien2")
    private EvaluationEntretien2 evaluation;

    // Getters and Setters
    public Integer getIdEntretien2() { return idEntretien2; }
    public void setIdEntretien2(Integer idEntretien2) { this.idEntretien2 = idEntretien2; }

    public LocalDate getDateEntretien() { return dateEntretien; }
    public void setDateEntretien(LocalDate dateEntretien) { this.dateEntretien = dateEntretien; }

    public LocalTime getHeureEntretien() { return heureEntretien; }
    public void setHeureEntretien(LocalTime heureEntretien) { this.heureEntretien = heureEntretien; }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }

    public Entretien1 getEntretien1() { return entretien1; }
    public void setEntretien1(Entretien1 entretien1) { this.entretien1 = entretien1; }

    public EvaluationEntretien2 getEvaluation() { return evaluation; }
    public void setEvaluation(EvaluationEntretien2 evaluation) { this.evaluation = evaluation; }
}