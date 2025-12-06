package com.example.gestion.models;

import java.util.Date;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;

@Entity
@Table(name = "personnel")
public class Personnel {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id_personnel;

    private Date date_embauche;
    private Boolean actif;
    private String username;  // Nouveau: identifiant unique pour login
    private String password;  // Nouveau: mot de passe haché (BCrypt)

    @OneToOne
    @JoinColumn(name = "id_candidat")
    private Candidat candidat;

    @ManyToOne
    @JoinColumn(name = "id_poste")
    private Poste poste;

    public Integer getId_personnel() { return id_personnel; }
    public void setId_personnel(Integer id_personnel) { this.id_personnel = id_personnel; }

    public Date getDate_embauche() { return date_embauche; }
    public void setDate_embauche(Date date_embauche) { this.date_embauche = date_embauche; }

    public Boolean getActif() { return actif; }
    public void setActif(Boolean actif) { this.actif = actif; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public Candidat getCandidat() { return candidat; }
    public void setCandidat(Candidat candidat) { this.candidat = candidat; }

    public Poste getPoste() { return poste; }
    public void setPoste(Poste poste) { this.poste = poste; }
}
