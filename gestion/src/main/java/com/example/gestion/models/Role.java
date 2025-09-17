package com.example.gestion.models;
import jakarta.persistence.*;
import java.util.*;

@Entity
@Table(name = "role")
public class Role {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Id_role")
    private Integer idRole;

    @Column(name = "libelle", nullable = false, unique = true)
    private String libelle;

    @OneToMany(mappedBy = "role")
    private List<User> users = new ArrayList<>();

    // Getters & Setters
    public Integer getIdRole() { return idRole; }
    public void setIdRole(Integer idRole) { this.idRole = idRole; }

    public String getLibelle() { return libelle; }
    public void setLibelle(String libelle) { this.libelle = libelle; }

    public List<User> getUsers() { return users; }
    public void setUsers(List<User> users) { this.users = users; }
}

