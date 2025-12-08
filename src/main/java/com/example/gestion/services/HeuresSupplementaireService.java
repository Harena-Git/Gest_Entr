package com.example.gestion.services;

import com.example.gestion.models.*;
import com.example.gestion.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class HeuresSupplementaireService {

    @Autowired
    private HeuresSupplementaireRepository heuresSupplementaireRepository;

    @Autowired
    private HeuresSupTypeRepository heuresSupTypeRepository;

    @Autowired
    private PersonnelHeureSuppRepository personnelHeureSuppRepository;

    @Autowired
    private PersonnelRepository personnelRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PosteRepository posteRepository;

    @Autowired
    private AuditLogService auditLogService;

    // ========== CRÉER HEURES SUPPLÉMENTAIRES ==========
    public HeuresSupplementaire creerHeuresSupplementaires(Integer nbHeures, Integer idHeuresSupType, 
                                                           Double tauxHoraire, Integer userId) {
        HeuresSupType type = heuresSupTypeRepository.findById(idHeuresSupType)
                .orElseThrow(() -> new RuntimeException("Type d'heures sup non trouvé"));

        HeuresSupplementaire heuresSup = new HeuresSupplementaire();
        heuresSup.setNbHeures(nbHeures);
        heuresSup.setHeuresSupType(type);

        // Calculer le montant
        heuresSup.calculerMontant(tauxHoraire);

        HeuresSupplementaire saved = heuresSupplementaireRepository.save(heuresSup);

        // Audit log
        auditLogService.log("heures_supplementaire", saved.getIdHeuresSupplementaire(), 
                "CREATE", userId, AuditLog.UserType.USER,
                "Création heures sup: " + nbHeures + "h - Montant: " + saved.getMontant());

        return saved;
    }

    // ========== ATTRIBUER HEURES SUP À UN PERSONNEL ==========
    public PersonnelHeureSupp attribuerHeuresSuppAPersonnel(Integer idPersonnel, Integer idHeuresSup, Integer userId) {
        Personnel personnel = personnelRepository.findById(idPersonnel)
                .orElseThrow(() -> new RuntimeException("Personnel non trouvé"));

        HeuresSupplementaire heuresSup = heuresSupplementaireRepository.findById(idHeuresSup)
                .orElseThrow(() -> new RuntimeException("Heures supplémentaires non trouvées"));

        PersonnelHeureSupp attribution = new PersonnelHeureSupp();
        attribution.setPersonnel(personnel);
        attribution.setHeuresSupplementaire(heuresSup);

        PersonnelHeureSupp saved = personnelHeureSuppRepository.save(attribution);

        // Audit log
        auditLogService.log("Personnel_HeureSupp", saved.getIdPersonnelHeureSupp(), 
                "CREATE", userId, AuditLog.UserType.USER,
                "Attribution heures sup au personnel ID: " + idPersonnel);

        return saved;
    }

    // ========== ATTRIBUER HEURES SUP À UN USER ==========
    public PersonnelHeureSupp attribuerHeuresSuppAUser(Integer idUser, Integer idHeuresSup, Integer userId) {
        User user = userRepository.findById(idUser)
                .orElseThrow(() -> new RuntimeException("User non trouvé"));

        HeuresSupplementaire heuresSup = heuresSupplementaireRepository.findById(idHeuresSup)
                .orElseThrow(() -> new RuntimeException("Heures supplémentaires non trouvées"));

        PersonnelHeureSupp attribution = new PersonnelHeureSupp();
        attribution.setUser(user);
        attribution.setHeuresSupplementaire(heuresSup);

        PersonnelHeureSupp saved = personnelHeureSuppRepository.save(attribution);

        // Audit log
        auditLogService.log("Personnel_HeureSupp", saved.getIdPersonnelHeureSupp(), 
                "CREATE", userId, AuditLog.UserType.USER,
                "Attribution heures sup au user ID: " + idUser);

        return saved;
    }

    // ========== CRÉER ET ATTRIBUER HEURES SUP À UN PERSONNEL ==========
    public PersonnelHeureSupp creerEtAttribuerHeuresSuppAPersonnel(Integer idPersonnel, Integer nbHeures, 
                                                                     Integer idHeuresSupType, Integer userId) {
        Personnel personnel = personnelRepository.findById(idPersonnel)
                .orElseThrow(() -> new RuntimeException("Personnel non trouvé"));

        // Récupérer le taux horaire du poste
        Double tauxHoraire = personnel.getPoste().getSalaire() / 160.0; // Salaire mensuel / 160h

        // Créer les heures sup
        HeuresSupplementaire heuresSup = creerHeuresSupplementaires(nbHeures, idHeuresSupType, tauxHoraire, userId);

        // Attribuer au personnel
        return attribuerHeuresSuppAPersonnel(idPersonnel, heuresSup.getIdHeuresSupplementaire(), userId);
    }

    // ========== RÉCUPÉRER HEURES SUP PAR ID ==========
    public HeuresSupplementaire getHeuresSupById(Integer id) {
        return heuresSupplementaireRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Heures supplémentaires non trouvées"));
    }

    // ========== RÉCUPÉRER TOUTES LES HEURES SUP ==========
    public List<HeuresSupplementaire> getToutesLesHeuresSup() {
        return heuresSupplementaireRepository.findAll();
    }

    // ========== RÉCUPÉRER HEURES SUP D'UN PERSONNEL ==========
    public List<PersonnelHeureSupp> getHeuresSupByPersonnel(Integer idPersonnel) {
        Personnel personnel = personnelRepository.findById(idPersonnel)
                .orElseThrow(() -> new RuntimeException("Personnel non trouvé"));
        return personnelHeureSuppRepository.findByPersonnel(personnel);
    }

    // ========== RÉCUPÉRER HEURES SUP D'UN USER ==========
    public List<PersonnelHeureSupp> getHeuresSupByUser(Integer idUser) {
        User user = userRepository.findById(idUser)
                .orElseThrow(() -> new RuntimeException("User non trouvé"));
        return personnelHeureSuppRepository.findByUser(user);
    }

    // ========== RÉCUPÉRER HEURES SUP PAR DÉPARTEMENT ==========
    public List<PersonnelHeureSupp> getHeuresSupByDepartement(Integer idDepartement) {
        return personnelHeureSuppRepository.findByDepartement(idDepartement);
    }

    // ========== STATISTIQUES - MONTANT TOTAL HEURES SUP PERSONNEL ==========
    public Double calculerMontantTotalHeuresSup(Integer idPersonnel) {
        Personnel personnel = personnelRepository.findById(idPersonnel)
                .orElseThrow(() -> new RuntimeException("Personnel non trouvé"));
        Double montant = personnelHeureSuppRepository.sumMontantsByPersonnel(personnel);
        return montant != null ? montant : 0.0;
    }

    // ========== STATISTIQUES - NB TOTAL HEURES SUP PERSONNEL ==========
    public Long calculerNbTotalHeuresSup(Integer idPersonnel) {
        Personnel personnel = personnelRepository.findById(idPersonnel)
                .orElseThrow(() -> new RuntimeException("Personnel non trouvé"));
        Long nbHeures = personnelHeureSuppRepository.sumNbHeuresByPersonnel(personnel);
        return nbHeures != null ? nbHeures : 0L;
    }

    // ========== STATISTIQUES - MONTANT TOTAL ENTREPRISE ==========
    public Double calculerMontantTotalEntreprise() {
        Double montant = heuresSupplementaireRepository.sumAllMontants();
        return montant != null ? montant : 0.0;
    }

    // ========== STATISTIQUES - NB TOTAL HEURES ENTREPRISE ==========
    public Long calculerNbTotalHeuresEntreprise() {
        Long nbHeures = heuresSupplementaireRepository.sumAllNbHeures();
        return nbHeures != null ? nbHeures : 0L;
    }

    // ========== SUPPRIMER HEURES SUP ==========
    public void supprimerHeuresSup(Integer id, Integer userId) {
        HeuresSupplementaire heuresSup = getHeuresSupById(id);
        heuresSupplementaireRepository.delete(heuresSup);

        // Audit log
        auditLogService.log("heures_supplementaire", id, "DELETE", userId, 
                AuditLog.UserType.USER,
                "Suppression heures sup");
    }

    // ========== SUPPRIMER ATTRIBUTION ==========
    public void supprimerAttribution(Integer idAttribution, Integer userId) {
        PersonnelHeureSupp attribution = personnelHeureSuppRepository.findById(idAttribution)
                .orElseThrow(() -> new RuntimeException("Attribution non trouvée"));
        
        personnelHeureSuppRepository.delete(attribution);

        // Audit log
        auditLogService.log("Personnel_HeureSupp", idAttribution, "DELETE", userId, 
                AuditLog.UserType.USER,
                "Suppression attribution heures sup");
    }
}