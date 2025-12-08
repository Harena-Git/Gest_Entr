package com.example.gestion.services;

import com.example.gestion.models.*;
import com.example.gestion.repository.*;
import com.example.gestion.dto.*;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.time.LocalDate;


@Service
public class FichePaieService {
    private final FichePaieRepository fichePaieRepository;
    private final ComplementsSalaireRepository complementsSalaireRepository;
    private final RetenuRepository retenuRepository;
    private final ImpotRepository impotRepository;
    private final PersonnelRepository personnelRepository;
    private final ImpotService impotService;
    private final HeuresSupplementaireService heuresSupplementaireService;

    public FichePaieService(FichePaieRepository fichePaieRepository, 
                            ComplementsSalaireRepository complementsSalaireRepository,
                            RetenuRepository retenuRepository,
                            ImpotRepository impotRepository,
                            PersonnelRepository personnelRepository,
                            ImpotService impotService,
                            HeuresSupplementaireService heuresSupplementaireService) {
        this.fichePaieRepository = fichePaieRepository;
        this.complementsSalaireRepository = complementsSalaireRepository;
        this.retenuRepository = retenuRepository;
        this.impotRepository = impotRepository;
        this.personnelRepository = personnelRepository;
        this.impotService = impotService;
        this.heuresSupplementaireService = heuresSupplementaireService;
    }

    public EtatPaieDTO genererEtatPaie(Personnel personnel) {
        EtatPaieDTO etatPaieDTO = new EtatPaieDTO();
        List<FichePaie> fichePaies = fichePaieRepository.findByPersonnel(personnel);

        for (FichePaie fiche : fichePaies) {
            List<ComplementsSalaire> primes = complementsSalaireRepository
                .findByPersonnelAndMoisAndAnnee(personnel, fiche.getMois(), fiche.getAnnee());
            fiche.setPrimes(primes); 

            List<Retenu> retenus = retenuRepository
                .findByPersonnelAndMoisAndAnnee(personnel, fiche.getMois(), fiche.getAnnee());
            fiche.setRetenus(retenus);
            
            Impot impot = impotRepository
                .findByPersonnelAndMoisAndAnnee(personnel, fiche.getMois(), fiche.getAnnee());
            fiche.setImpot(impot);
        }
        
        etatPaieDTO.setFichePaie(fichePaies);
        return etatPaieDTO;
    }

    private double calculTotalRetenu(FichePaie fiche, double salaireBase) {
        double deductions = 0.0;
        for (Retenu retenu : fiche.getRetenus()) {
            if (retenu.getTypeRetenu().getTypeEnum() == TypeEnum.EMPLOYE || retenu.getTypeRetenu().getTypeEnum() == TypeEnum.AUTRE) {
                // CNAPS employé et OSTIE employé et Autres sont déductibles 
                deductions += retenu.calculRetenu(salaireBase);
            }
            if (retenu.getTypeRetenu().getTypeEnum() == TypeEnum.ABSENCE) {
                // Absence
                deductions += retenu.calculAbsence(salaireBase, fiche.getTotalAbsence());
            }
        }
        return Math.max(deductions, 0);
    }

    public void genererFichePaie() {
        List<Personnel> personnels = personnelRepository.findAll();
        int mois = LocalDate.now().getMonthValue();
        int annee = LocalDate.now().getYear();
        
        for (Personnel personnel : personnels) {
            // VÉRIFIER SI LA FICHE EXISTE DÉJÀ
            FichePaie ficheExistante = fichePaieRepository.findByPersonnelAndMoisAndAnnee(personnel, mois, annee);
            if (ficheExistante != null) {
                System.out.println("Fiche déjà existante pour " + personnel.getMatricule() + " - " + mois + "/" + annee);
                continue; 
            }
            FichePaie fichePaie = new FichePaie();
            fichePaie.setPersonnel(personnel);
            fichePaie.setMois(mois);
            fichePaie.setAnnee(annee);

            List<ComplementsSalaire> primes = complementsSalaireRepository
                .findByPersonnelAndMoisAndAnnee(personnel, mois, annee);
            fichePaie.setPrimes(primes); 
            fichePaie.setSalaireBase(personnel.getPoste().getSalaire());

            double heures_supplementaire = heuresSupplementaireService.calculerHeuresSupplementairesManuel(personnel, mois, annee);
            fichePaie.setTotalHeureSup(heures_supplementaire);            
            double primeTotalMois = primes.stream()
                .mapToDouble(p -> p.getAutres() + p.getIndemnite() + p.getRappels())
                .sum();
            double salaireBrutMois = personnel.getPoste().getSalaire() + primeTotalMois + heures_supplementaire;
            fichePaie.setTotalPrime(primeTotalMois);
            fichePaie.setSalaireBrut(salaireBrutMois);

            List<Retenu> retenus = retenuRepository
                .findByPersonnelAndMoisAndAnnee(personnel, mois, annee);
            fichePaie.setRetenus(retenus);
            
            fichePaie.setTotalAbsence(2); //RECUPERENA AVY ANY AM COUSIN
            double totalRetenus = calculTotalRetenu(fichePaie, personnel.getPoste().getSalaire());
            double salaireImposable = salaireBrutMois - totalRetenus;
            fichePaie.setTotalRetenus(totalRetenus);
            fichePaie.setSalaireImposable(salaireImposable);

            double impotdu = impotService.calculerIRSA(salaireImposable, LocalDate.of(annee, mois, 1));
            Impot impot = impotRepository
                .findByPersonnelAndMoisAndAnnee(personnel, mois, annee);
            impotRepository.updateImpotDuById(impot.getId(), impotdu);
            impot = impotRepository.findById(impot.getId()).orElse(impot);
            fichePaie.setImpot(impot);
            double impotTotalMois = impot.getAutresImpots() + (impot.getEnfantChargePU() * impot.getEnfantChargeNbr()) + impot.getIgrnet() + impot.getImpotDu();
            double salaireNet = salaireImposable - impotTotalMois;
            fichePaie.setTotalImpots(impotTotalMois);
            fichePaie.setSalaireNet(salaireNet);

            double avance = primes.stream()
                .mapToDouble(p -> p.getAvance())
                .sum();
            double netAPayer = salaireNet - avance;
            fichePaie.setNetAPayer(netAPayer);
            
            fichePaieRepository.save(fichePaie);
            System.out.println("Fiche générée pour " + personnel.getMatricule() + " - " + mois + "/" + annee);
        }
    }
     public FichePaie findByPersonnelAndMoisAndAnnee(Personnel personnel, int mois, int annee) {
        FichePaie fiche = fichePaieRepository.findByPersonnelAndMoisAndAnnee(personnel, mois, annee);
        
        if (fiche != null) {
            // Chargez manuellement les collections
            List<ComplementsSalaire> primes = complementsSalaireRepository
                .findByPersonnelAndMoisAndAnnee(personnel, mois, annee);
            fiche.setPrimes(primes);
            
            List<Retenu> retenus = retenuRepository
                .findByPersonnelAndMoisAndAnnee(personnel, mois, annee);
            fiche.setRetenus(retenus);
            
            Impot impot = impotRepository
                .findByPersonnelAndMoisAndAnnee(personnel, mois, annee);
            fiche.setImpot(impot);
        }
        
        return fiche;
    }
}