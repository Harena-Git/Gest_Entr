package com.example.gestion.models;

import jakarta.persistence.*;

@Entity
@Table(name = "Impot")
public class Impot {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Id_Impot")
    private Integer id;

    @Column(name = "ImpotDu")
    private double impotDu;

    @Column(name = "EnfantChargePU")
    private double enfantChargePU;

    @Column(name = "Igrnet")
    private double igrnet;

    @Column(name = "enfantChargenbr")
    private double enfantChargeNbr;

    @Column(name = "autresImpots")
    private double autresImpots;

    @Column(name = "mois", length = 50)
    private int mois;

    @Column(name = "annee", length = 50)
    private int annee;

    @ManyToOne
    @JoinColumn(name = "Id_personnel", nullable = false)
    private Personnel personnel;

    // Constructeurs
    public Impot() {}

    public Impot(double impotDu, double enfantChargePU, double igrnet, 
                 double enfantChargeNbr, int mois, int annee, Personnel personnel) {
        this.impotDu = impotDu;
        this.enfantChargePU = enfantChargePU;
        this.igrnet = igrnet;
        this.enfantChargeNbr = enfantChargeNbr;
        this.mois = mois;
        this.annee = annee;
        this.personnel = personnel;
    }

    // Getters et setters
    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public double getImpotDu() {
        return impotDu;
    }

    public void setImpotDu(double impotDu) {
        this.impotDu = impotDu;
    }

    public double getEnfantChargePU() {
        return enfantChargePU;
    }

    public void setEnfantChargePU(double enfantChargePU) {
        this.enfantChargePU = enfantChargePU;
    }

    public double getIgrnet() {
        return igrnet;
    }

    public void setIgrnet(double igrnet) {
        this.igrnet = igrnet;
    }

    public double getEnfantChargeNbr() {
        return enfantChargeNbr;
    }

    public void setEnfantChargeNbr(double enfantChargeNbr) {
        this.enfantChargeNbr = enfantChargeNbr;
    }

    public int getMois() {
        return mois;
    }

    public void setMois(int mois) {
        this.mois = mois;
    }

    public int getAnnee() {
        return annee;
    }

    public void setAnnee(int annee) {
        this.annee = annee;
    }

    public Personnel getPersonnel() {
        return personnel;
    }

    public void setPersonnel(Personnel personnel) {
        this.personnel = personnel;
    }

    public double getAutresImpots() {
        return autresImpots;
    }
    public void setAutresImpots(double autresImpots) {
        this.autresImpots = autresImpots;
    }

    // Méthode corrigée - utilisation de double
    public double calculerTotalChargesEnfants() {
        return enfantChargePU * enfantChargeNbr;
    }

    // Méthode pour calculer le total des impôts
    public double calculerTotalImpots() {
        return impotDu + igrnet + autresImpots + calculerTotalChargesEnfants();
    }
}