package com.example.gestion.dto;

import com.example.gestion.models.*;
import java.util.Map;
import java.util.List;

public class EtatPaieDTO {

    private int absenceDuMois;
    private List<FichePaie> fichePaie;
    private Double salaireBrut;

    public List<FichePaie> getFichePaie() { return fichePaie; }
    public void setFichePaie(List<FichePaie> fichePaie) { this.fichePaie = fichePaie; }

    public int getAbsenceDuMois() { return absenceDuMois; }
    public void setAbsenceDuMois(int absenceDuMois) { this.absenceDuMois = absenceDuMois; }

    public Double getSalaireBrut() { return salaireBrut; }
    public void setSalaireBrut(Double salaireBrut) { this.salaireBrut = salaireBrut; }
}
