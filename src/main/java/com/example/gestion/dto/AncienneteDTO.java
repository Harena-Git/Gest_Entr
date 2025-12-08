package com.example.gestion.dto;

public class AncienneteDTO {
    private String departement;
    private String range;
    private Long total;

    public AncienneteDTO(String departement, String rangeAnciennete, Long total) {
        this.departement = departement;
        this.range = rangeAnciennete;
        this.total = total;
    }

    // getters et setters
    public String getRange() { return range; }
    public void setRange(String range) { this.range = range; }

    public Long getTotal() { return total; }
    public void setTotal(Long total) { this.total = total; }



    public String getDepartement() { return departement; }
    public void setDepartement(String departement) { this.departement = departement; }
}
