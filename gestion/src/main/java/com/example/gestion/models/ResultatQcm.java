package com.example.gestion.models;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "resultat_qcm")
public class ResultatQcm {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer idResultatQcm;

    @Column(name = "bonnes_reponses")
    private Integer bonnesReponses;

    @Column(name = "total_questions")
    private Integer totalQuestions;

    @Column(name = "pourcentage")
    private Double pourcentage;

    @Column(name = "est_reussi")
    private Boolean estReussi;

    @Column(name = "date_reponse")
    private LocalDateTime dateReponse;

    @ManyToOne
    @JoinColumn(name = "Id_candidat", nullable = false)
    private Candidat candidat;

    @ManyToOne
    @JoinColumn(name = "Id_qcm", nullable = false)
    private Qcm qcm;

    // Getters and Setters
    public Integer getIdResultatQcm() { return idResultatQcm; }
    public void setIdResultatQcm(Integer idResultatQcm) { this.idResultatQcm = idResultatQcm; }

    public Integer getBonnesReponses() { return bonnesReponses; }
    public void setBonnesReponses(Integer bonnesReponses) { this.bonnesReponses = bonnesReponses; }

    public Integer getTotalQuestions() { return totalQuestions; }
    public void setTotalQuestions(Integer totalQuestions) { this.totalQuestions = totalQuestions; }

    public Double getPourcentage() { return pourcentage; }
    public void setPourcentage(Double pourcentage) { this.pourcentage = pourcentage; }

    public Boolean getEstReussi() { return estReussi; }
    public void setEstReussi(Boolean estReussi) { this.estReussi = estReussi; }

    public LocalDateTime getDateReponse() { return dateReponse; }
    public void setDateReponse(LocalDateTime dateReponse) { this.dateReponse = dateReponse; }

    public Candidat getCandidat() { return candidat; }
    public void setCandidat(Candidat candidat) { this.candidat = candidat; }

    public Qcm getQcm() { return qcm; }
    public void setQcm(Qcm qcm) { this.qcm = qcm; }
}