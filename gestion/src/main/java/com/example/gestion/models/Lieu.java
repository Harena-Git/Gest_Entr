package com.example.gestion.models;

import jakarta.persistence.*;

@Entity
@Table(name = "lieu")
public class Lieu {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id_lieu;

    private String lieu;

    public Integer getId_lieu() { return id_lieu; }
    public void setId_lieu(Integer id_lieu) { this.id_lieu = id_lieu; }

    public String getLieu() { return lieu; }
    public void setLieu(String lieu) { this.lieu = lieu; }
}
