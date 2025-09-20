package com.example.gestion.models;

import jakarta.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name = "resultat_qcm")
public class ResultatQcm {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id_resultat_qcm;

    private Integer bonnes_reponses;
    private Integer total_questions;

    @Column(precision = 15, scale = 2)
    private BigDecimal pourcentage;

    @ManyToOne
    @JoinColumn(name = "Id_qcm")
    private Qcm qcm;

    @ManyToOne
    @JoinColumn(name = "Id_profil")
    private Profil profil;

    // Getters and Setters
    public Integer getId_resultat_qcm() { return id_resultat_qcm; }
    public void setId_resultat_qcm(Integer id_resultat_qcm) { this.id_resultat_qcm = id_resultat_qcm; }

    public Integer getBonnes_reponses() { return bonnes_reponses; }
    public void setBonnes_reponses(Integer bonnes_reponses) { this.bonnes_reponses = bonnes_reponses; }

    public Integer getTotal_questions() { return total_questions; }
    public void setTotal_questions(Integer total_questions) { this.total_questions = total_questions; }

    public BigDecimal getPourcentage() { return pourcentage; }
    public void setPourcentage(BigDecimal pourcentage) { this.pourcentage = pourcentage; }

    public Qcm getQcm() { return qcm; }
    public void setQcm(Qcm qcm) { this.qcm = qcm; }

    public Profil getProfil() { return profil; }
    public void setProfil(Profil profil) { this.profil = profil; }
}
