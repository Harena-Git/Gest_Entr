package com.example.gestion.models;

import jakarta.persistence.*;

@Entity
@Table(name = "qcm_generale")
public class QcmGenerale {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Id_qcm_generale")
    private Integer idQcmGenerale;

    @ManyToOne
    @JoinColumn(name = "Id_question_generale", nullable = false)
    private QuestionGenerale questionGenerale;

    @ManyToOne
    @JoinColumn(name = "Id_qcm", nullable = false)
    private Qcm qcm;

    // --- Constructeurs ---
    public QcmGenerale() {
    }

    public QcmGenerale(QuestionGenerale questionGenerale, Qcm qcm) {
        this.questionGenerale = questionGenerale;
        this.qcm = qcm;
    }

    // --- Getters et Setters ---
    public Integer getIdQcmGenerale() {
        return idQcmGenerale;
    }

    public void setIdQcmGenerale(Integer idQcmGenerale) {
        this.idQcmGenerale = idQcmGenerale;
    }

    public QuestionGenerale getQuestionGenerale() {
        return questionGenerale;
    }

    public void setQuestionGenerale(QuestionGenerale questionGenerale) {
        this.questionGenerale = questionGenerale;
    }

    public Qcm getQcm() {
        return qcm;
    }

    public void setQcm(Qcm qcm) {
        this.qcm = qcm;
    }
}
