package com.example.gestion.models;

import jakarta.persistence.*;

@Entity
@Table(name = "Personnel_HeureSupp")
public class PersonnelHeureSupp {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer idPersonnelHeureSupp;

    @ManyToOne
    @JoinColumn(name = "Id_personnel")
    private Personnel personnel;

    @ManyToOne
    @JoinColumn(name = "Id_user")
    private User user;

    @ManyToOne
    @JoinColumn(name = "Id_heures_supplementaire")
    private HeuresSupplementaire heuresSupplementaire;

    // Constructeurs
    public PersonnelHeureSupp() {}

    // Getters et Setters
    public Integer getIdPersonnelHeureSupp() {
        return idPersonnelHeureSupp;
    }

    public void setIdPersonnelHeureSupp(Integer idPersonnelHeureSupp) {
        this.idPersonnelHeureSupp = idPersonnelHeureSupp;
    }

    public Personnel getPersonnel() {
        return personnel;
    }

    public void setPersonnel(Personnel personnel) {
        this.personnel = personnel;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public HeuresSupplementaire getHeuresSupplementaire() {
        return heuresSupplementaire;
    }

    public void setHeuresSupplementaire(HeuresSupplementaire heuresSupplementaire) {
        this.heuresSupplementaire = heuresSupplementaire;
    }
}