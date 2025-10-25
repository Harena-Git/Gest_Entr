package com.example.gestion.models;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.time.LocalTime;

@Entity
@Table(name = "entretien_1")
public class Entretien1 {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Id_entretien_")
    private Integer idEntretien;

    @Column(name = "date_entretien")
    private LocalDate dateEntretien;

    @Column(name = "heure_entretien")
    private LocalTime heureEntretien;

    @ManyToOne
    @JoinColumn(name = "Id_candidat", nullable = false)
    private Candidat candidat;

    @ManyToOne
    @JoinColumn(name = "Id_user", nullable = false)
    private User user;

    @OneToOne(mappedBy = "entretien1")
    private EvaluationEntretien1 evaluation;

    @OneToOne(mappedBy = "entretien1")
    private Entretien2 entretien2;

    // Getters and Setters
    public Integer getIdEntretien() { return idEntretien; }
    public void setIdEntretien(Integer idEntretien) { this.idEntretien = idEntretien; }

    public LocalDate getDateEntretien() { return dateEntretien; }
    public void setDateEntretien(LocalDate dateEntretien) { this.dateEntretien = dateEntretien; }

    public LocalTime getHeureEntretien() { return heureEntretien; }
    public void setHeureEntretien(LocalTime heureEntretien) { this.heureEntretien = heureEntretien; }

    public Candidat getCandidat() { return candidat; }
    public void setCandidat(Candidat candidat) { this.candidat = candidat; }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }

    public EvaluationEntretien1 getEvaluation() { return evaluation; }
    public void setEvaluation(EvaluationEntretien1 evaluation) { this.evaluation = evaluation; }

    public Entretien2 getEntretien2() { return entretien2; }
    public void setEntretien2(Entretien2 entretien2) { this.entretien2 = entretien2; }
}