package com.example.gestion.models;

import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "Plafond")
public class Plafond {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Id_Plafond")
    private int idPlafond;

    @Column(name = "date_")
    @Temporal(TemporalType.DATE)
    private Date date;

    @Column(name = "montant")
    private double montant;

    // Constructeurs
    public Plafond() {}

    public Plafond(Date date, double montant) {
        this.date = date;
        this.montant = montant;
    }

    // Getters et Setters
    public int getIdPlafond() {
        return idPlafond;
    }

    public void setIdPlafond(int idPlafond) {
        this.idPlafond = idPlafond;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public double getMontant() {
        return montant;
    }

    public void setMontant(double montant) {
        this.montant = montant;
    }
}
