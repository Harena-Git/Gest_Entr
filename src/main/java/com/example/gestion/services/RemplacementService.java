package com.example.gestion.services;

import com.example.gestion.models.*;
import com.example.gestion.repository.RemplacementRepository;
import com.example.gestion.repository.DemandeCongeRepository;
import com.example.gestion.repository.PersonnelRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
public class RemplacementService {

    @Autowired
    private RemplacementRepository remplacementRepository;

    @Autowired
    private DemandeCongeRepository demandeCongeRepository;

    @Autowired
    private PersonnelRepository personnelRepository;

    /**
     * Proposer automatiquement un remplaçant pour un congé
     * Recherche un personnel actif du même département sans congé lors de la période
     * @param demande La demande de congé approuvée par le chef
     * @return Le remplaçant proposé
     */
    @Transactional
    public Remplacement proposerRemplacant(DemandeConge demande) {
        Personnel demandeur = demande.getPersonnel();
        Integer idDept = demandeur.getPoste().getDepartement().getId_departement();

        // Récupérer tous les personnels du même département
        List<Personnel> candidats = personnelRepository.findByPoste_departement_id_departement(idDept);

        // Filtrer les remplaçants potentiels
        for (Personnel candidat : candidats) {
            // Exclure le demandeur lui-même
            if (candidat.getId_personnel().equals(demandeur.getId_personnel())) {
                continue;
            }

            // Vérifier que le candidat est actif
            if (!candidat.getActif()) {
                continue;
            }

            // Vérifier qu'il n'a pas de congé lors de la période
            Long conflits = demandeCongeRepository.countConflictingCongees(
                candidat.getId_personnel(),
                demande.getDate_debut(),
                demande.getDate_fin()
            );

            if (conflits == 0) {
                // Créer le remplacement
                Remplacement remplacement = new Remplacement(candidat, demande);
                return remplacementRepository.save(remplacement);
            }
        }

        // Si aucun remplaçant trouvé, lever une exception
        throw new RuntimeException("Aucun remplaçant disponible pour cette période");
    }

    /**
     * Mettre à jour le statut d'acceptation du remplaçant
     * @param remplacement Le remplacement
     * @param accepte true si accepté, false sinon
     * @param commentaire Le commentaire du remplaçant
     */
    @Transactional
    public void traiterReponseRemplacant(Remplacement remplacement, Boolean accepte, String commentaire) {
        remplacement.setRemplacant_accepte(accepte);
        remplacement.setCommentaire_remplacant(commentaire);
        remplacementRepository.save(remplacement);
    }

    /**
     * Obtenir le remplacement d'une demande de congé
     * @param demande La demande
     * @return Le remplacement
     */
    public Optional<Remplacement> obtenirRemplacement(DemandeConge demande) {
        return remplacementRepository.findByDemandeConge(demande);
    }

    /**
     * Obtenir les remplaçants d'un personnel
     * @param personnel Le personnel
     * @return La liste des remplaçants assignés
     */
    public List<Remplacement> obtenirRemplacementsAssignes(Personnel personnel) {
        return remplacementRepository.findByPersonnel(personnel);
    }

    /**
     * Obtenir les remplaçants qui n'ont pas accepté
     * @return La liste des remplaçants
     */
    public List<Remplacement> obtenirRemplacementsNonAcceptes() {
        return remplacementRepository.findUnacceptedRemplacements();
    }

    /**
     * Obtenir les remplaçants qui n'ont pas été notifiés
     * @return La liste des remplaçants
     */
    public List<Remplacement> obtenirRemplacementsNonNotifies() {
        return remplacementRepository.findNotNotifiedRemplacements();
    }

    /**
     * Marquer un remplacement comme notifié
     * @param remplacement Le remplacement
     */
    @Transactional
    public void marquerCommeNotifie(Remplacement remplacement) {
        remplacement.setNotifiee(true);
        remplacementRepository.save(remplacement);
    }

    /**
     * Vérifier si un personnel a un conflit de remplacement
     * @param idPersonnel L'ID du personnel
     * @param debut La date de début
     * @param fin La date de fin
     * @return true s'il y a un conflit
     */
    public Boolean verifierConflitRemplacement(Integer idPersonnel, java.util.Date debut, java.util.Date fin) {
        return remplacementRepository.hasConflictingReplacement(idPersonnel, debut, fin);
    }
}
