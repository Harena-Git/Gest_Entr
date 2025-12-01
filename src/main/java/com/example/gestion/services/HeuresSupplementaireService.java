package com.example.gestion.services;

import com.example.gestion.models.HeuresSupplementaire;
import com.example.gestion.models.Personnel;
import com.example.gestion.repository.HeuresSupplementaireRepository;
import org.springframework.stereotype.Service;
import java.time.LocalDate;
import java.util.List;

@Service
public class HeuresSupplementaireService {

    private final HeuresSupplementaireRepository heuresSupplementaireRepository;

    public HeuresSupplementaireService(HeuresSupplementaireRepository heuresSupplementaireRepository) {
        this.heuresSupplementaireRepository = heuresSupplementaireRepository;
    }

    public double calculerHeuresSupplementaires(Personnel personnel, int mois, int annee) {
        try {
            // Essayer la méthode avec query
            List<HeuresSupplementaire> heuresSupList = heuresSupplementaireRepository
                    .findByPersonnelAndMoisAndAnnee(personnel, mois, annee);
            
            return heuresSupList.stream()
                    .mapToDouble(HeuresSupplementaire::getMontant)
                    .sum();
                    
        } catch (Exception e) {
            // Fallback: méthode alternative avec période
            return calculerHeuresSupplementairesAlternative(personnel, mois, annee);
        }
    }

    // Méthode alternative avec période
    public double calculerHeuresSupplementairesAlternative(Personnel personnel, int mois, int annee) {
        LocalDate startDate = LocalDate.of(annee, mois, 1);
        LocalDate endDate = startDate.withDayOfMonth(startDate.lengthOfMonth());
        
        List<HeuresSupplementaire> heuresSupList = heuresSupplementaireRepository
                .findByPersonnelAndPeriode(personnel, startDate, endDate);
                
        return heuresSupList.stream()
                .mapToDouble(HeuresSupplementaire::getMontant)
                .sum();
    }

    // Méthode de fallback manuel (100% sûr)
    public double calculerHeuresSupplementairesManuel(Personnel personnel, int mois, int annee) {
        List<HeuresSupplementaire> allHeures = heuresSupplementaireRepository.findByPersonnel(personnel);
        
        if (allHeures == null || allHeures.isEmpty()) {
            return 0.0;
        }
        
        return allHeures.stream()
                .filter(hs -> hs.getDateHeureSup() != null)
                .filter(hs -> hs.getDateHeureSup().getMonthValue() == mois)
                .filter(hs -> hs.getDateHeureSup().getYear() == annee)
                .mapToDouble(hs -> hs.getMontant() * hs.getNbHeures())
                .sum();
    }

    // Méthode pour obtenir la liste des heures supp
    public List<HeuresSupplementaire> getHeuresSuppByPersonnelAndMois(Personnel personnel, int mois, int annee) {
        try {
            return heuresSupplementaireRepository.findByPersonnelAndMoisAndAnnee(personnel, mois, annee);
        } catch (Exception e) {
            // Fallback manuel
            List<HeuresSupplementaire> allHeures = heuresSupplementaireRepository.findByPersonnel(personnel);
            return allHeures.stream()
                    .filter(hs -> hs.getDateHeureSup() != null)
                    .filter(hs -> hs.getDateHeureSup().getMonthValue() == mois)
                    .filter(hs -> hs.getDateHeureSup().getYear() == annee)
                    .toList();
        }
    }
    
    // Autres méthodes utilitaires
    public HeuresSupplementaire save(HeuresSupplementaire heureSupp) {
        return heuresSupplementaireRepository.save(heureSupp);
    }
    
    public List<HeuresSupplementaire> findAll() {
        return heuresSupplementaireRepository.findAll();
    }
}