package com.example.gestion.models;

import jakarta.persistence.*;
import java.util.Date;
import java.util.List;
import java.util.Map;
import org.springframework.format.annotation.DateTimeFormat;

import jakarta.persistence.*;

@Entity
@Table(name = "fiche_paie")
public class FichePaie {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Id_fiche_paie")
    private Long idFichePaie;

    private int mois;
    private int annee;
    private int totalAbsence;

    @Column(name = "salaire_base")
    private double salaireBase;

    @Column(name = "salaire_brut")
    private double salaireBrut;

    @Column(name = "salaire_net")
    private Double salaireNet;

    @Column(name = "net_a_payer")
    private Double netAPayer;

    @Column(name = "total_heure_sup")
    private Double totalHeureSup;

    @Column(name = "total_prime")
    private Double totalPrime;

    @Column(name = "total_retenus")
    private Double totalRetenus;

    @Column(name = "salaire_imposable")
    private Double salaireImposable;

    @Column(name = "total_impots")
    private Double totalImpots;

    @ManyToOne
    @JoinColumn(name = "Id_personnel", nullable = false)
    private Personnel personnel;

    @OneToMany
    @JoinColumn(name = "id_personnel", referencedColumnName = "id_personnel") 
    private List<ComplementsSalaire> primes;

    @OneToMany
    @JoinColumn(name = "id_personnel", referencedColumnName = "id_personnel") 
    private List<Retenu> retenus;

    @OneToOne(cascade = CascadeType.MERGE)
    @JoinColumn(name = "id_impot")  // Colonne dans la table fiche_paie qui référence l'ID de l'impot
    private Impot impot;

    @Column(name = "retenu_values")
    @Transient // pour ne pas persister dans la base si tu veux
    private Map<String, Double> retenuValues;

    public Long getIdFichePaie() {
        return idFichePaie;
    }

    public void setIdFichePaie(Long idFichePaie) {
        this.idFichePaie = idFichePaie;
    }

    public int getMois() {
        return mois;
    }

    public void setMois(int mois) {
        this.mois = mois;
    }

    public int getTotalAbsence() {
        return totalAbsence;
    }

    public void setTotalAbsence(int totalAbsence) {
        this.totalAbsence = totalAbsence;
    }

    public int getAnnee() {
        return annee;
    }

    public void setAnnee(int annee) {
        this.annee = annee;
    }

    public Double getSalaireBase() {
        return salaireBase;
    }

    public void setSalaireBase(double salaireBase) {
        this.salaireBase = salaireBase;
    }

    public Double getSalaireNet() {
        return salaireNet;
    }

    public void setSalaireNet(Double salaireNet) {
        this.salaireNet = salaireNet;
    }

    public Double getNetAPayer() {
        return netAPayer;
    }

    public void setNetAPayer(Double netAPayer) {
        this.netAPayer = netAPayer;
    }

    public Double getSalaireBrut() {
        return salaireBrut;
    }

    public void setSalaireBrut(Double salaireBrut) {
        this.salaireBrut = salaireBrut;
    }

    public Double getTotalHeureSup() {
        return totalHeureSup;
    }

    public void setTotalHeureSup(Double totalHeureSup) {
        this.totalHeureSup = totalHeureSup;
    }

    public Double getTotalPrime() {
        return totalPrime;
    }

    public void setTotalPrime(Double totalPrime) {
        this.totalPrime = totalPrime;
    }

    public Double getTotalImpots() {
        return totalImpots;
    }

    public void setTotalImpots(Double totalImpots) {
        this.totalImpots = totalImpots;
    }

    public Double getTotalRetenus() {
        return totalRetenus;
    }

    public void setTotalRetenus(Double totalRetenus) {
        this.totalRetenus = totalRetenus;
    }

    public Double getSalaireImposable() {
        return salaireImposable;
    }

    public void setSalaireImposable(Double salaireImposable) {
        this.salaireImposable = salaireImposable;
    }

    public Personnel getPersonnel() {
        return personnel;
    }

    public void setPersonnel(Personnel personnel) {
        this.personnel = personnel;
    }

    public List<ComplementsSalaire> getPrimes() { return primes; }
    public void setPrimes(List<ComplementsSalaire> primes) { this.primes = primes; }

    public List<Retenu> getRetenus() { return retenus; }
    public void setRetenus(List<Retenu> retenus) { this.retenus = retenus; }

    public Impot getImpot() { return impot; }
    public void setImpot(Impot impot) { this.impot = impot; }

    public Map<String, Double> getRetenuValues() {
        return retenuValues;
    }

    public void setRetenuValues(Map<String, Double> retenuValues) {
        this.retenuValues = retenuValues;
    }

    public String getMoisString(int mois)
    {
        String[] moisNoms = {
            "Janvier", "Fevrier", "Mars", "Avril", "Mai", "Juin",
            "Juillet", "Aout", "Septembre", "Octobre", "Novembre", "Decembre"
        };
        if (mois >= 1 && mois <= 12) {
            return moisNoms[mois - 1];
        } else {
            return "Mois invalide";
        }
    }
}
