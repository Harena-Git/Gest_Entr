package com.example.gestion.dto;


public class AbsenceRateDTO {
    private String departement;
    private int absences;
    private int total;
    private double tauxAbsent;

    // getters et setters
    public String getDepartement() { return departement; }
    public void setDepartement(String departement) { this.departement = departement; }

    public int getAbsences() { return absences; }
    public void setAbsences(int absences) { this.absences = absences; }

    public int getTotal() { return total; }
    public void setTotal(int total) { this.total = total; }

    public double getTauxAbsent() { return tauxAbsent; }
    public void setTauxAbsent(double tauxAbsent) { this.tauxAbsent = tauxAbsent; }
}

