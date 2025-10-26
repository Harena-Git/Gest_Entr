package com.example.gestion.models;

import jakarta.persistence.*;

@Entity
@Table(name = "evaluation_entretien_1")
public class EvaluationEntretien1 {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id_evaluation_entretien_1;

    private Boolean presence;

    @OneToOne
    @JoinColumn(name = "id_appreciation")
    private Appreciation appreciation;

    @OneToOne
    @JoinColumn(name = "id_entretien_")
    private Entretien1 entretien1;

    public Integer getId_evaluation_entretien_1() { return id_evaluation_entretien_1; }
    public void setId_evaluation_entretien_1(Integer id_evaluation_entretien_1) { this.id_evaluation_entretien_1 = id_evaluation_entretien_1; }

    public Boolean getPresence() { return presence; }
    public void setPresence(Boolean presence) { this.presence = presence; }

    public Appreciation getAppreciation() { return appreciation; }
    public void setAppreciation(Appreciation appreciation) { this.appreciation = appreciation; }

    public Entretien1 getEntretien1() { return entretien1; }
    public void setEntretien1(Entretien1 entretien1) { this.entretien1 = entretien1; }
}
