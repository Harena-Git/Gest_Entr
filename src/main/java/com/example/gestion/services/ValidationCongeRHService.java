package com.example.gestion.services;

import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.gestion.models.DecisionValidation;
import com.example.gestion.models.DemandeConge;
import com.example.gestion.models.Personnel;
import com.example.gestion.models.User;
import com.example.gestion.models.ValidationCongeChef;
import com.example.gestion.models.ValidationCongeRH;
import com.example.gestion.repository.DecisionValidationRepository;
import com.example.gestion.repository.UserRepository;
import com.example.gestion.repository.ValidationCongeChefRepository;
import com.example.gestion.repository.ValidationCongeRHRepository;

@Service
public class ValidationCongeRHService {

    @Autowired
    private ValidationCongeRHRepository validationCongeRHRepository;

    @Autowired
    private ValidationCongeChefRepository validationCongeChefRepository;

    @Autowired
    private DecisionValidationRepository decisionValidationRepository;

    @Autowired
    private DemandeCongeService demandeCongeService;

    @Autowired
    private SoldeCongeService soldeCongeService;

    @Autowired
    private UserRepository userRepository;

    /**
     * Valider et approuver un congé par la RH
     * Mettre à jour le solde du personnel
     * @param validationChef La validation du chef
     * @param user L'utilisateur RH
     * @param commentaire Le commentaire de la RH
     * @return La validation RH créée
     */
    @Transactional
    public ValidationCongeRH validerApprobation(ValidationCongeChef validationChef, User user, String commentaire) {
        // Vérifier si déjà validée
        if (validationCongeRHRepository.existsByValidationChefId(validationChef.getId_validation_conge_chef())) {
            throw new IllegalArgumentException("Cette demande a déjà été validée par la RH");
        }

        // Récupérer l'utilisateur depuis la base de données
        // L'ID du User peut être fourni directement
        Optional<User> userOpt = Optional.empty();
        
        // Essayer d'abord avec l'ID User s'il est disponible
        if (user.getId_user() != null) {
            userOpt = userRepository.findById(user.getId_user());
        }
        
        // // Si pas trouvé par ID direct, essayer par ID de Personnel
        // if (userOpt.isEmpty() && user.getPersonnel() != null && user.getPersonnel().getId_personnel() != null) {
        //     userOpt = userRepository.findByPersonnelId(user.getPersonnel().getId_personnel());
        // }
        
        // // Si toujours pas trouvé, créer un User pour ce Personnel
        // if (userOpt.isEmpty() && user.getPersonnel() != null) {
        //     User newUser = new User();
        //     newUser.setPersonnel(user.getPersonnel());
        //     newUser.setNom(user.getPersonnel().getUsername()); // Utiliser le username du Personnel
        //     newUser.setUsername(user.getPersonnel().getUsername());
        //     newUser.setMot_de_passe(user.getPersonnel().getPassword());
        //     userOpt = Optional.of(userRepository.save(newUser));
        // }
        
        if (userOpt.isEmpty()) {
            throw new RuntimeException("Impossible de créer ou trouver un utilisateur pour la RH");
        }
        User existingUser = userOpt.get();

        // Obtenir la décision "Approuvée"
        Optional<DecisionValidation> decisionOpt = decisionValidationRepository.findByLibelle("Approuvée");
        if (decisionOpt.isEmpty()) {
            throw new RuntimeException("La décision 'Approuvée' n'existe pas");
        }

        // Créer la validation avec l'utilisateur existant
        ValidationCongeRH validation = new ValidationCongeRH(validationChef, existingUser, decisionOpt.get(), commentaire);
        ValidationCongeRH saved = validationCongeRHRepository.save(validation);

        // Mettre à jour le statut de la demande
        DemandeConge demande = validationChef.getDemandeConge();
        demandeCongeService.mettreAJourStatut(demande, "Approuvée par RH");

        // Mettre à jour le solde du personnel
        Personnel personnel = demande.getPersonnel();
        soldeCongeService.diminuerSolde(personnel, demande.getNombre_jours());

        return saved;
    }

    /**
     * Rejeter un congé par la RH
     * @param validationChef La validation du chef
     * @param user L'utilisateur RH
     * @param commentaire Le motif du rejet
     * @return La validation RH créée
     */
    @Transactional
    public ValidationCongeRH validerRejet(ValidationCongeChef validationChef, User user, String commentaire) {
        // Vérifier si déjà validée
        if (validationCongeRHRepository.existsByValidationChefId(validationChef.getId_validation_conge_chef())) {
            throw new IllegalArgumentException("Cette demande a déjà été validée par la RH");
        }

        // Récupérer l'utilisateur depuis la base de données
        // L'ID du User peut être fourni directement
        Optional<User> userOpt = Optional.empty();
        
        // Essayer d'abord avec l'ID User s'il est disponible
        if (user.getId_user() != null) {
            userOpt = userRepository.findById(user.getId_user());
        }
        
        // // Si pas trouvé par ID direct, essayer par ID de Personnel
        // if (userOpt.isEmpty() && user.getPersonnel() != null && user.getPersonnel().getId_personnel() != null) {
        //     userOpt = userRepository.findByPersonnelId(user.getPersonnel().getId_personnel());
        // }
        
        // // Si toujours pas trouvé, créer un User pour ce Personnel
        // if (userOpt.isEmpty() && user.getPersonnel() != null) {
        //     User newUser = new User();
        //     newUser.setPersonnel(user.getPersonnel());
        //     newUser.setNom(user.getPersonnel().getUsername()); // Utiliser le username du Personnel
        //     newUser.setUsername(user.getPersonnel().getUsername());
        //     newUser.setMot_de_passe(user.getPersonnel().getPassword());
        //     userOpt = Optional.of(userRepository.save(newUser));
        // }
        
        if (userOpt.isEmpty()) {
            throw new RuntimeException("Impossible de créer ou trouver un utilisateur pour la RH");
        }
        User existingUser = userOpt.get();

        // Obtenir la décision "Rejetée"
        Optional<DecisionValidation> decisionOpt = decisionValidationRepository.findByLibelle("Rejetée");
        if (decisionOpt.isEmpty()) {
            throw new RuntimeException("La décision 'Rejetée' n'existe pas");
        }

        // Créer la validation
        ValidationCongeRH validation = new ValidationCongeRH(validationChef, existingUser, decisionOpt.get(), commentaire);
        ValidationCongeRH saved = validationCongeRHRepository.save(validation);

        // Mettre à jour le statut de la demande
        DemandeConge demande = validationChef.getDemandeConge();
        demandeCongeService.mettreAJourStatut(demande, "Rejetée par RH");

        return saved;
    }

    /**
     * Obtenir la validation RH d'une validation chef
     * @param validationChef La validation du chef
     * @return La validation RH si elle existe
     */
    public Optional<ValidationCongeRH> obtenirValidation(ValidationCongeChef validationChef) {
        return validationCongeRHRepository.findByValidationCongeChef(validationChef);
    }

    /**
     * Vérifier si une validation chef a une validation RH
     * @param idValChef L'ID de la validation chef
     * @return true si validée par RH
     */
    public Boolean estValideeParRH(Integer idValChef) {
        return validationCongeRHRepository.existsByValidationChefId(idValChef);
    }
}
