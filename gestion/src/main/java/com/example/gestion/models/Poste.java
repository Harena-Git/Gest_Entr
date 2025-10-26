package com.example.gestion.models;

import jakarta.persistence.*;
import java.util.List;

@Entity
@Table(name = "poste")
public class Poste {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id_poste;

    private String libelle;
    private Integer salaire;

    @ManyToOne
    @JoinColumn(name = "id_departement")
    private Departement departement;

    @OneToMany(mappedBy = "poste")
    private List<Personnel> personnels;

    public Integer getId_poste() { return id_poste; }
    public void setId_poste(Integer id_poste) { this.id_poste = id_poste; }

    public String getLibelle() { return libelle; }
    public void setLibelle(String libelle) { this.libelle = libelle; }

    public Integer getSalaire() { return salaire; }
    public void setSalaire(Integer salaire) { this.salaire = salaire; }

    public Departement getDepartement() { return departement; }
    public void setDepartement(Departement departement) { this.departement = departement; }

    public List<Personnel> getPersonnels() { return personnels; }
    public void setPersonnels(List<Personnel> personnels) { this.personnels = personnels; }
}
