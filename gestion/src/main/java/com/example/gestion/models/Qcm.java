package com.example.gestion.models;

import jakarta.persistence.*;
import java.util.*;

@Entity
@Table(name = "qcm")
public class Qcm {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Id_qcm")
    private Integer idQcm;

    @Column(name = "titre")
    private String titre;

    @Column(name = "description")
    private String description;

    @OneToMany(mappedBy = "qcm")
    private List<Question> questions = new ArrayList<>();

    @OneToMany(mappedBy = "qcm")
    private List<ResultatQcm> resultats = new ArrayList<>();

    // Getters and Setters
    public Integer getIdQcm() { return idQcm; }
    public void setIdQcm(Integer idQcm) { this.idQcm = idQcm; }

    public String getTitre() { return titre; }
    public void setTitre(String titre) { this.titre = titre; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public List<Question> getQuestions() { return questions; }
    public void setQuestions(List<Question> questions) { this.questions = questions; }

    public List<ResultatQcm> getResultats() { return resultats; }
    public void setResultats(List<ResultatQcm> resultats) { this.resultats = resultats; }
}

