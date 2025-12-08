package com.example.gestion.dto;

 public class TrancheIrsaDetail {
        private String libelle;
        private Double montantTranche;
        private Double taux;
        private Double impotTranche;
        
        public TrancheIrsaDetail() {}
        
        public TrancheIrsaDetail(String libelle, Double montantTranche, Double taux, Double impotTranche) {
            this.libelle = libelle;
            this.montantTranche = montantTranche;
            this.taux = taux;
            this.impotTranche = impotTranche;
        }
        
        // Getters et setters
        public String getLibelle() { return libelle; }
        public void setLibelle(String libelle) { this.libelle = libelle; }
        public Double getMontantTranche() { return montantTranche; }
        public void setMontantTranche(Double montantTranche) { this.montantTranche = montantTranche; }
        public Double getTaux() { return taux; }
        public void setTaux(Double taux) { this.taux = taux; }
        public Double getImpotTranche() { return impotTranche; }
        public void setImpotTranche(Double impotTranche) { this.impotTranche = impotTranche; }
    }