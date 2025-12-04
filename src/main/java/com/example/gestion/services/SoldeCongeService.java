package com.example.gestion.services;

import java.util.Date;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.gestion.models.Personnel;
import com.example.gestion.models.SoldeConge;
import com.example.gestion.repository.SoldeCongeRepository;

@Service
public class SoldeCongeService {

    @Autowired
    private SoldeCongeRepository soldeCongeRepository;

    /**
     * Initialiser le solde de congé pour un nouveau personnel
     * @param personnel Le personnel
     * @return Le solde créé
     */
    @Transactional
    public SoldeConge initialiserSolde(Personnel personnel) {
        SoldeConge solde = new SoldeConge(personnel, 25);
        return soldeCongeRepository.save(solde);
    }

    /**
     * Initialiser le solde de congé avec un nombre de jours spécifique
     * @param personnel Le personnel
     * @param nombreJours Le nombre de jours annuels
     * @return Le solde créé
     */
    @Transactional
    public SoldeConge initialiserSolde(Personnel personnel, Integer nombreJours) {
        SoldeConge solde = new SoldeConge(personnel, nombreJours);
        return soldeCongeRepository.save(solde);
    }

    /**
     * Obtenir le solde de congé d'un personnel
     * @param personnel Le personnel
     * @return Le solde s'il existe
     */
    public Optional<SoldeConge> obtenirSolde(Personnel personnel) {
        return soldeCongeRepository.findByPersonnel(personnel);
    }

    /**
     * Obtenir le solde restant d'un personnel
     * @param idPersonnel L'ID du personnel
     * @return Le nombre de jours restants
     */
    public Integer obtenirSoldeRestant(Integer idPersonnel) {
        Optional<Integer> solde = soldeCongeRepository.getSoldeRestantByPersonnel(idPersonnel);
        return solde.orElse(0);
    }

    /**
     * Vérifier si le solde est suffisant pour une demande
     * @param personnel Le personnel
     * @param nombreJours Le nombre de jours demandés
     * @return true si le solde est suffisant
     */
    public Boolean verifierSoldeSuffisant(Personnel personnel, Integer nombreJours) {
        Optional<SoldeConge> solde = soldeCongeRepository.findByPersonnel(personnel);
        if (solde.isEmpty()) {
            return false;
        }
        return solde.get().getSolde_restant() >= nombreJours;
    }

    /**
     * Diminuer le solde après approbation d'un congé par la RH
     * @param personnel Le personnel
     * @param nombreJours Le nombre de jours à déduire
     */
    @Transactional
    public void diminuerSolde(Personnel personnel, Integer nombreJours) {
        Optional<SoldeConge> soldeOpt = soldeCongeRepository.findByPersonnel(personnel);
        if (soldeOpt.isPresent()) {
            SoldeConge solde = soldeOpt.get();
            solde.setSolde_restant(solde.getSolde_restant() - nombreJours);
            soldeCongeRepository.save(solde);
        }
    }

    /**
     * Augmenter le solde (en cas d'annulation de congé)
     * @param personnel Le personnel
     * @param nombreJours Le nombre de jours à ajouter
     */
    @Transactional
    public void augmenterSolde(Personnel personnel, Integer nombreJours) {
        Optional<SoldeConge> soldeOpt = soldeCongeRepository.findByPersonnel(personnel);
        if (soldeOpt.isPresent()) {
            SoldeConge solde = soldeOpt.get();
            solde.setSolde_restant(Math.min(solde.getSolde_restant() + nombreJours, solde.getSolde_annuel()));
            soldeCongeRepository.save(solde);
        }
    }

    /**
     * Renouveler le solde annuel
     * @param personnel Le personnel
     */
    @Transactional
    public void renouvelerSolde(Personnel personnel) {
        Optional<SoldeConge> soldeOpt = soldeCongeRepository.findByPersonnel(personnel);
        if (soldeOpt.isPresent()) {
            SoldeConge solde = soldeOpt.get();
            solde.setSolde_restant(solde.getSolde_annuel());
            solde.setDate_renouvellement(new Date());
            soldeCongeRepository.save(solde);
        }
    }

    /**
     * Vérifier si un personnel a un solde existant
     * @param idPersonnel L'ID du personnel
     * @return true si le solde existe
     */
    public Boolean soldeExiste(Integer idPersonnel) {
        return soldeCongeRepository.existsByPersonnelId(idPersonnel);
    }
}
