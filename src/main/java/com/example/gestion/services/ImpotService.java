package com.example.gestion.services;

import com.example.gestion.models.*;
import com.example.gestion.dto.*;
import com.example.gestion.repository.*;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.ArrayList;
import java.util.Optional;
import java.time.LocalDate;

@Service
public class ImpotService {

    private final ImpotRepository impotRepository;
    private final IrsaRepository irsaRepository;

    public ImpotService(ImpotRepository impotRepository, IrsaRepository irsaRepository) {
        this.impotRepository = impotRepository;
        this.irsaRepository = irsaRepository;
    }

    public List<Impot> findAll() {
        return impotRepository.findAll();
    }

    public Optional<Impot> findById(Integer id) {
        return impotRepository.findById(id);
    }

    public Impot save(Impot entretien) {
        return impotRepository.save(entretien);
    }

    public void deleteById(Integer id) {
        impotRepository.deleteById(id);
    }

    /**
     * Calcule l'IRSA en fonction du salaire imposable et de la date
     */
    public Double calculerIRSA(Double salaireImposable, LocalDate date) {
        if (salaireImposable == null || salaireImposable <= 0) {
            return 0.0;
        }

        // Récupérer les tranches actives à la date donnée
        List<Irsa> tranches = irsaRepository.findTranchesActivesByDate(date);
        
        if (tranches.isEmpty()) {
            throw new RuntimeException("Aucune tranche IRSA trouvée pour la date: " + date);
        }

        double irsa = 0.0;
        double resteImposable = salaireImposable;

        for (Irsa tranche : tranches) {
            if (resteImposable <= 0) break;

            Double trancheMin = tranche.getTrancheMin();
            Double trancheMax = tranche.getTrancheMax();
            Double taux = tranche.getTaux();

            // Calculer le montant de la tranche
            double montantTranche;
            if (trancheMax == null || trancheMax == 999999999) { // Dernière tranche
                montantTranche = Math.max(0, resteImposable - trancheMin);
            } else {
                montantTranche = Math.min(resteImposable, trancheMax) - trancheMin;
                if (montantTranche < 0) montantTranche = 0;
            }

            // Ajouter l'impôt de la tranche
            irsa += montantTranche * taux;
            
            // Réduire le reste imposable
            resteImposable -= montantTranche;
        }

        return Math.round(irsa * 100.0) / 100.0; // Arrondi à 2 décimales
    }

    /**
     * Calcule l'IRSA avec la date courante
     */
    public Double calculerIRSA(Double salaireImposable) {
        return calculerIRSA(salaireImposable, LocalDate.now());
    }

    public List<TrancheIrsaDetail> calculerDetailIrsa(Double salaireImposable, LocalDate date) {
        List<TrancheIrsaDetail> details = new ArrayList<>();
        
        if (salaireImposable == null || salaireImposable <= 0) {
            return details;
        }

        List<Irsa> tranches = irsaRepository.findTranchesActivesByDate(date);
        
        if (tranches.isEmpty()) {
            return details;
        }

        double resteImposable = salaireImposable;

        for (Irsa tranche : tranches) {
            if (resteImposable <= 0) break;

            Double trancheMin = tranche.getTrancheMin();
            Double trancheMax = tranche.getTrancheMax();
            Double taux = tranche.getTaux();

            // Calculer le montant de la tranche
            double montantTranche;
            String libelle;
            
            if (trancheMax == null || trancheMax == 999999999) {
                montantTranche = Math.max(0, resteImposable - trancheMin);
                libelle = String.format("Tranche > %.0f Ar", trancheMin);
            } else {
                montantTranche = Math.min(resteImposable, trancheMax) - trancheMin;
                if (montantTranche < 0) montantTranche = 0;
                libelle = String.format("Tranche %.0f - %.0f Ar", trancheMin, trancheMax);
            }

            if (montantTranche > 0) {
                double impotTranche = montantTranche * taux;
                details.add(new TrancheIrsaDetail(
                    libelle,
                    montantTranche,
                    taux * 100, // Convertir en pourcentage pour l'affichage
                    impotTranche
                ));
            }
            
            resteImposable -= montantTranche;
        }

        return details;
    }
}
