package com.example.gestion.models;

import jakarta.persistence.*;
import java.util.List;

@Entity
@Table(name = "user_")
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id_user;

    private String nom;
    private String mot_de_passe;

    @ManyToOne
    @JoinColumn(name = "id_departement")
    private Departement departement;

    @ManyToOne
    @JoinColumn(name = "id_role")
    private Role role;

    @OneToMany(mappedBy = "user")
    private List<Entretien2> entretiens2;

    public Integer getId_user() { return id_user; }
    public void setId_user(Integer id_user) { this.id_user = id_user; }

    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }

    public String getMot_de_passe() { return mot_de_passe; }
    public void setMot_de_passe(String mot_de_passe) { this.mot_de_passe = mot_de_passe; }

    public Departement getDepartement() { return departement; }
    public void setDepartement(Departement departement) { this.departement = departement; }

    public Role getRole() { return role; }
    public void setRole(Role role) { this.role = role; }

    public List<Entretien2> getEntretiens2() { return entretiens2; }
    public void setEntretiens2(List<Entretien2> entretiens2) { this.entretiens2 = entretiens2; }
}
