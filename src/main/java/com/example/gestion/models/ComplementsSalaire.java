package com.example.gestion.models;

import jakarta.persistence.*;
import java.io.Serializable;

@Entity
@Table(name = "ComplementSalaire")
public class ComplementsSalaire implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Id_ComplementSalaire")
    private Integer id;

    @Column(name = "mois", nullable = false)
    private int mois;

    @Column(name = "annee", nullable = false)
    private int annee;

    @Column(name = "indemnite")
    private double indemnite;

    @Column(name = "rappels")
    private double rappels;

    @Column(name = "autres")
    private double autres;

    @Column(name = "avance")
    private double avance;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "Id_personnel", nullable = false)
    private Personnel personnel;

    // ----- Getters et Setters -----
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public int getMois() { return mois; }
    public void setMois(int mois) { this.mois = mois; }

    public int getAnnee() { return annee; }
    public void setAnnee(int annee) { this.annee = annee; }

    public double getIndemnite() { return indemnite; }
    public void setIndemnite(double indemnite) { this.indemnite = indemnite; }

    public double getRappels() { return rappels; }
    public void setRappels(double rappels) { this.rappels = rappels; }

    public double getAutres() { return autres; }
    public void setAutres(double autres) { this.autres = autres; }

     public double getAvance() { return avance; }
    public void setAvance(double avance) { this.avance = avance; }

    public Personnel getPersonnel() { return personnel; }
    public void setPersonnel(Personnel personnel) { this.personnel = personnel; }
}
