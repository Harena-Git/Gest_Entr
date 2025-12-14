package com.example.gestion.models;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;

@Entity
@Table(name = "evaluation_entretien_2")
public class EvaluationEntretien2 {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Id_evaluation_appreciation_2")
    private Integer id_evaluation_entretien_2;

    private Boolean presence;

    @OneToOne
    @JoinColumn(name = "id_appreciation")
    private Appreciation appreciation;

    @OneToOne
    @JoinColumn(name = "id_entretien_2")
    private Entretien2 entretien2;

    public Integer getId_evaluation_entretien_2() { return id_evaluation_entretien_2; }
    public void setId_evaluation_entretien_2(Integer id_evaluation_entretien_2) { this.id_evaluation_entretien_2 = id_evaluation_entretien_2; }

    public Boolean getPresence() { return presence; }
    public void setPresence(Boolean presence) { this.presence = presence; }

    public Appreciation getAppreciation() { return appreciation; }
    public void setAppreciation(Appreciation appreciation) { this.appreciation = appreciation; }

    public Entretien2 getEntretien2() { return entretien2; }
    public void setEntretien2(Entretien2 entretien2) { this.entretien2 = entretien2; }
}
