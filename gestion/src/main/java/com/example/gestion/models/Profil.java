package com.example.gestion.models;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

@Entity
@Table(name = "profil")
public class Profil {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id_profil;

    private String genre;
    private Integer age;
    private String annee_experience;

    @ManyToOne
    @JoinColumn(name = "id_lieu")
    private Lieu lieu;

    @ManyToOne
    @JoinColumn(name = "id_diplome")
    private Diplome diplome;

    public Integer getId_profil() { return id_profil; }
    public void setId_profil(Integer id_profil) { this.id_profil = id_profil; }

    public String getGenre() { return genre; }
    public void setGenre(String genre) { this.genre = genre; }

    public Integer getAge() { return age; }
    public void setAge(Integer age) { this.age = age; }

    public String getAnnee_experience() { return annee_experience; }
    public void setAnnee_experience(String annee_experience) { this.annee_experience = annee_experience; }

    public Lieu getLieu() { return lieu; }
    public void setLieu(Lieu lieu) { this.lieu = lieu; }

    public Diplome getDiplome() { return diplome; }
    public void setDiplome(Diplome diplome) { this.diplome = diplome; }
}
