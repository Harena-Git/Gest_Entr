package com.example.gestion.services;

import java.util.Date;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.gestion.models.DemandeConge;
import com.example.gestion.models.Personnel;
import com.example.gestion.models.StatutDemande;
import com.example.gestion.repository.DemandeCongeRepository;
import com.example.gestion.repository.StatutDemandeRepository;

@Service
public class DemandeCongeService {

    @Autowired
    private DemandeCongeRepository demandeCongeRepository;

    @Autowired
    private StatutDemandeRepository statutDemandeRepository;

    @Autowired
    private SoldeCongeService soldeCongeService;

    /**
     * Créer une demande de congé après vérification du solde
     * @param personnel Le personnel
     * @param dateDebut La date de début du congé
     * @param dateFin La date de fin du congé
     * @param motif Le motif du congé
     * @return La demande créée ou null si solde insuffisant
     */
    @Transactional
    public DemandeConge creerDemande(Personnel personnel, Date dateDebut, Date dateFin, String motif) {
        // Calculer le nombre de jours
        long diffInMillis = dateFin.getTime() - dateDebut.getTime();
        int nombreJours = (int) (diffInMillis / (1000 * 60 * 60 * 24)) + 1;

        // Vérifier le solde
        if (!soldeCongeService.verifierSoldeSuffisant(personnel, nombreJours)) {
            throw new IllegalArgumentException("Solde de congé insuffisant. Jours demandés: " + nombreJours + 
                                             ", Solde disponible: " + soldeCongeService.obtenirSoldeRestant(personnel.getId_personnel()));
        }

        // Obtenir le statut "En attente" ou créer un statut par défaut
        StatutDemande statut = null;
        Optional<StatutDemande> statutOpt = statutDemandeRepository.findByLibelle("En attente");
        
        if (statutOpt.isEmpty()) {
            // Chercher un autre statut existant ou en créer un
            try {
                statut = new StatutDemande();
                statut.setLibelle("En attente");
                statut = statutDemandeRepository.save(statut);
            } catch (Exception e) {
                // En dernier recours, chercher n'importe quel statut
                List<StatutDemande> allStatuts = statutDemandeRepository.findAll();
                if (!allStatuts.isEmpty()) {
                    statut = allStatuts.get(0);
                } else {
                    throw new RuntimeException("Aucun statut de demande n'existe en base de données");
                }
            }
        } else {
            statut = statutOpt.get();
        }

        // Créer la demande
        DemandeConge demande = new DemandeConge(dateDebut, dateFin, nombreJours, motif, personnel, statut);
        return demandeCongeRepository.save(demande);
    }

    /**
     * Vérifier si des conflits de congés existent
     * @param personnel Le personnel
     * @param dateDebut La date de début
     * @param dateFin La date de fin
     * @return true s'il y a un conflit
     */
    public Boolean verifierConflitCongees(Personnel personnel, Date dateDebut, Date dateFin) {
        Long conflits = demandeCongeRepository.countConflictingCongees(personnel.getId_personnel(), dateDebut, dateFin);
        return conflits > 0;
    }

    /**
     * Obtenir toutes les demandes en attente d'un personnel
     * @param personnel Le personnel
     * @return La liste des demandes
     */
    public List<DemandeConge> obtenirDemandesEnAttente(Personnel personnel) {
        Optional<StatutDemande> statutOpt = statutDemandeRepository.findByLibelle("En attente");
        if (statutOpt.isEmpty()) {
            return List.of();
        }
        return demandeCongeRepository.findByPersonnelAndStatutDemande(personnel, statutOpt.get());
    }

    /**
     * Obtenir les demandes en attente pour un département (pour le chef)
     * @param idDept L'ID du département
     * @return La liste des demandes
     */
    public List<DemandeConge> obtenirDemandesEnAtenteParDepartement(Integer idDept) {
        return demandeCongeRepository.findPendingCongeesByDepartment(idDept);
    }

    /**
     * Obtenir les demandes approuvées par le chef (en attente de RH)
     * @return La liste des demandes
     */
    public List<DemandeConge> obtenirDemandesApprouveesParChef() {
        return demandeCongeRepository.findApprovedByChef();
    }

    /**
     * Mettre à jour le statut d'une demande
     * @param demande La demande
     * @param nouveauStatut Le nouveau statut
     * @return La demande mise à jour
     */
    @Transactional
    public DemandeConge mettreAJourStatut(DemandeConge demande, String nouveauStatut) {
        Optional<StatutDemande> statutOpt = statutDemandeRepository.findByLibelle(nouveauStatut);
        if (statutOpt.isEmpty()) {
            throw new RuntimeException("Le statut '" + nouveauStatut + "' n'existe pas");
        }
        demande.setStatutDemande(statutOpt.get());
        return demandeCongeRepository.save(demande);
    }

    /**
     * Obtenir une demande par ID
     * @param id L'ID de la demande
     * @return La demande
     */
    public Optional<DemandeConge> obtenirDemande(Integer id) {
        return demandeCongeRepository.findById(id);
    }

    /**
     * Obtenir tous les congés d'un personnel entre deux dates
     * @param idPersonnel L'ID du personnel
     * @param debut La date de début
     * @param fin La date de fin
     * @return La liste des demandes
     */
    public List<DemandeConge> obtenirCongesBetweenDates(Integer idPersonnel, Date debut, Date fin) {
        return demandeCongeRepository.findCongesBetweenDates(idPersonnel, debut, fin);
    }
}
