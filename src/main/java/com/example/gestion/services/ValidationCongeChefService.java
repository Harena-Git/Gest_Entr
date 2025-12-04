package com.example.gestion.services;

import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.gestion.models.DecisionValidation;
import com.example.gestion.models.DemandeConge;
import com.example.gestion.models.User;
import com.example.gestion.models.ValidationCongeChef;
import com.example.gestion.repository.DecisionValidationRepository;
import com.example.gestion.repository.StatutDemandeRepository;
import com.example.gestion.repository.ValidationCongeChefRepository;

@Service
public class ValidationCongeChefService {

    @Autowired
    private ValidationCongeChefRepository validationCongeChefRepository;

    @Autowired
    private DecisionValidationRepository decisionValidationRepository;

    @Autowired
    private StatutDemandeRepository statutDemandeRepository;

    @Autowired
    private DemandeCongeService demandeCongeService;

    /**
     * Valider une demande de congé par le chef (approbation)
     * @param demande La demande
     * @param user Le chef
     * @param commentaire Le commentaire du chef
     * @return La validation créée
     */
    @Transactional
    public ValidationCongeChef validerApprobation(DemandeConge demande, User user, String commentaire) {
        // Vérifier si déjà validée
        if (validationCongeChefRepository.existsByDemandeId(demande.getId_demande_conge())) {
            throw new IllegalArgumentException("Cette demande a déjà été validée par le chef");
        }

        // Obtenir la décision "Approuvée"
        Optional<DecisionValidation> decisionOpt = decisionValidationRepository.findByLibelle("Approuvée");
        if (decisionOpt.isEmpty()) {
            throw new RuntimeException("La décision 'Approuvée' n'existe pas");
        }

        // Créer la validation
        ValidationCongeChef validation = new ValidationCongeChef(user, demande, decisionOpt.get(), commentaire);
        ValidationCongeChef saved = validationCongeChefRepository.save(validation);

        // Mettre à jour le statut de la demande
        demandeCongeService.mettreAJourStatut(demande, "Approuvée par chef");

        return saved;
    }

    /**
     * Rejeter une demande de congé par le chef
     * @param demande La demande
     * @param user Le chef
     * @param commentaire Le motif du rejet
     * @return La validation créée
     */
    @Transactional
    public ValidationCongeChef validerRejet(DemandeConge demande, User user, String commentaire) {
        // Vérifier si déjà validée
        if (validationCongeChefRepository.existsByDemandeId(demande.getId_demande_conge())) {
            throw new IllegalArgumentException("Cette demande a déjà été validée par le chef");
        }

        // Obtenir la décision "Rejetée"
        Optional<DecisionValidation> decisionOpt = decisionValidationRepository.findByLibelle("Rejetée");
        if (decisionOpt.isEmpty()) {
            throw new RuntimeException("La décision 'Rejetée' n'existe pas");
        }

        // Créer la validation
        ValidationCongeChef validation = new ValidationCongeChef(user, demande, decisionOpt.get(), commentaire);
        ValidationCongeChef saved = validationCongeChefRepository.save(validation);

        // Mettre à jour le statut de la demande
        demandeCongeService.mettreAJourStatut(demande, "Rejetée par chef");

        return saved;
    }

    /**
     * Obtenir la validation chef d'une demande
     * @param demande La demande
     * @return La validation si elle existe
     */
    public Optional<ValidationCongeChef> obtenirValidation(DemandeConge demande) {
        return validationCongeChefRepository.findByDemandeConge(demande);
    }

    /**
     * Vérifier si une demande a été validée par le chef
     * @param idDemande L'ID de la demande
     * @return true si validée
     */
    public Boolean estValideeParChef(Integer idDemande) {
        return validationCongeChefRepository.existsByDemandeId(idDemande);
    }
}
