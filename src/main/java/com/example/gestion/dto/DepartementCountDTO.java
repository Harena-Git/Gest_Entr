package com.example.gestion.dto;

public class DepartementCountDTO {
    private String departement;
    private long nombrePersonnel;

    // getters et setters
    public String getDepartement() { return departement; }
    public void setDepartement(String departement) { this.departement = departement; }

    public long getNombrePersonnel() { return nombrePersonnel; }
    public void setNombrePersonnel(long nombrePersonnel) { this.nombrePersonnel = nombrePersonnel; }
}

