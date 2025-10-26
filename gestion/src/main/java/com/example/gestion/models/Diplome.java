package com.example.gestion.models;

import java.util.List;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;

@Entity
@Table(name = "diplome")
public class Diplome {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id_diplome;

    @ManyToOne
    @JoinColumn(name = "Id_niveau")
    private Niveau niveau;

    @ManyToOne
    @JoinColumn(name = "Id_filiere")
    private Filiere filiere;

    @OneToMany(mappedBy = "diplome")
    private List<DiplomeCandidat> diplomesCandidats;

    @OneToMany(mappedBy = "diplome")
    private List<Profil> profils;

    // Getters and Setters
    public Integer getId_diplome() { return id_diplome; }
    public void setId_diplome(Integer id_diplome) { this.id_diplome = id_diplome; }

    public Niveau getNiveau() { return niveau; }
    public void setNiveau(Niveau niveau) { this.niveau = niveau; }

    public Filiere getFiliere() { return filiere; }
    public void setFiliere(Filiere filiere) { this.filiere = filiere; }

    public List<DiplomeCandidat> getDiplomesCandidats() { return diplomesCandidats; }
    public void setDiplomesCandidats(List<DiplomeCandidat> diplomesCandidats) { this.diplomesCandidats = diplomesCandidats; }

    public List<Profil> getProfils() { return profils; }
    public void setProfils(List<Profil> profils) { this.profils = profils; }
}
