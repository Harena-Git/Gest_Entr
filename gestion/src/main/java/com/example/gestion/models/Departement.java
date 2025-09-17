package com.example.gestion.models;

import jakarta.persistence.*;
import java.util.List;

@Entity
@Table(name = "departement")
public class Departement {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id_departement;

    private String departement;

    @OneToMany(mappedBy = "departement")
    private List<User> users;

    @OneToMany(mappedBy = "departement")
    private List<Poste> postes;

    public Integer getId_departement() { return id_departement; }
    public void setId_departement(Integer id_departement) { this.id_departement = id_departement; }

    public String getDepartement() { return departement; }
    public void setDepartement(String departement) { this.departement = departement; }

    public List<User> getUsers() { return users; }
    public void setUsers(List<User> users) { this.users = users; }

    public List<Poste> getPostes() { return postes; }
    public void setPostes(List<Poste> postes) { this.postes = postes; }
}
