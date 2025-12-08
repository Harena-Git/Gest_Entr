package com.example.gestion.models;

import jakarta.persistence.*;

@Entity
@Table(name = "Retenu")
public class Retenu {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Id_Retenu")
    private Integer id;

    @Column(name = "mois", nullable = false)
    private int mois;

    @Column(name = "annee", nullable = false)
    private int annee;

    @Column(name = "montant_defaut")
    private int montantDefaut;

    @ManyToOne
    @JoinColumn(name = "Id_Plafond", nullable = false)
    private Plafond plafond;

    @ManyToOne
    @JoinColumn(name = "Id_personnel", nullable = false)
    private Personnel personnel;

    @ManyToOne
    @JoinColumn(name = "Id_TypeRetenu", nullable = false)
    private TypeRetenu typeRetenu;

    // Getters et setters
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public Plafond getPlafond() { return plafond; }
    public void setPlafond(Plafond plafond) { this.plafond = plafond; }

    public Personnel getPersonnel() { return personnel; }
    public void setPersonnel(Personnel personnel) { this.personnel = personnel; }

    public TypeRetenu getTypeRetenu() { return typeRetenu; }
    public void setTypeRetenu(TypeRetenu typeRetenu) { this.typeRetenu = typeRetenu; }

    public int getMois() { return mois; }
    public void setMois(int mois) { this.mois = mois; }

    public int getAnnee() { return annee; }
    public void setAnnee(int annee) { this.annee = annee; }

    public int getMontantDefaut() { return montantDefaut; }
    public void setMontantDefaut(int montantDefaut) { this.montantDefaut = montantDefaut; }

    public double calculRetenu(double salaire) {
        double retenuValue = 0.0;
        if(this.getTypeRetenu().getTypeEnum() == TypeEnum.AUTRE) {
            return this.montantDefaut; 
        }
        if(this.getPlafond().getMontant() > salaire) {
            retenuValue = salaire * this.getTypeRetenu().getTaux() / 100;
        } else {
            retenuValue = this.getPlafond().getMontant() * this.getTypeRetenu().getTaux() / 100;
        }
        return retenuValue;
    }

    public double calculAbsence(double salaire, int joursAbsence) {
        double retenuValue = (salaire / 30) * joursAbsence;
        return retenuValue;
    }
}
