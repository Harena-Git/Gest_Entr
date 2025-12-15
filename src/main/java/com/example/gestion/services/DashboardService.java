package com.example.gestion.services;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.gestion.models.User;
import com.example.gestion.repository.DemandeCongeRepository;
import com.example.gestion.repository.JustificationAbsenceRepository;
import com.example.gestion.repository.JustificationRetardRepository;
import com.example.gestion.repository.PersonnelHeureSuppRepository;
import com.example.gestion.repository.PersonnelRepository;
import com.example.gestion.repository.PresenceAbsenceRepository;
import com.example.gestion.repository.UserRepository;
import com.example.gestion.repository.ValidationAbsChefRepository;
import com.example.gestion.repository.ValidationAbsRhRepository;

@Service
@Transactional(readOnly = true)
public class DashboardService {

    @Autowired
    private PresenceAbsenceRepository presenceAbsenceRepository;

    @Autowired
    private JustificationAbsenceRepository justificationAbsenceRepository;

    @Autowired
    private JustificationRetardRepository justificationRetardRepository;

    @Autowired
    private ValidationAbsChefRepository validationAbsChefRepository;

    @Autowired
    private ValidationAbsRhRepository validationAbsRhRepository;

    @Autowired
    private PersonnelRepository personnelRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PersonnelHeureSuppRepository personnelHeureSuppRepository;

    // AJOUTEZ CES REPOSITORIES
    @Autowired
    private DemandeCongeRepository demandeCongeRepository;

    // ========== STATISTIQUES GLOBALES DU JOUR ==========
    public Map<String, Object> getStatistiquesDuJour(LocalDate date) {
        Map<String, Object> stats = new HashMap<>();

        // Présences du jour
        stats.put("nombrePresences", presenceAbsenceRepository.findByDate(date).size());

         // CONGÉS EN ATTENTE DE VALIDATION (NOUVEAU)
        stats.put("congesEnAttenteChef", demandeCongeRepository.countDemandesEnAttenteParStatut("En attente de chef"));
        stats.put("congesEnAttenteRH", demandeCongeRepository.countDemandesEnAttenteParStatut("Approuvée par chef"));

        // Présences en attente de validation
        stats.put("presencesEnAttenteChef", presenceAbsenceRepository.findPresencesEnAttenteValidationChef().size());
        stats.put("presencesEnAttenteRh", presenceAbsenceRepository.findPresencesEnAttenteValidationRh().size());

        // Justifications en attente
        stats.put("justificationsAbsenceEnAttente", justificationAbsenceRepository.findJustificationsEnAttente().size());
        stats.put("justificationsRetardEnAttente", justificationRetardRepository.findJustificationsEnAttente().size());

        return stats;
    }

    // ========== STATISTIQUES PERSONNEL ==========
    public Map<String, Object> getStatistiquesPersonnel(Integer idPersonnel, LocalDate dateDebut, LocalDate dateFin) {
        Map<String, Object> stats = new HashMap<>();

        // If personnel not found, return zeroed stats instead of throwing an exception
        return personnelRepository.findById(idPersonnel).map(personnel -> {
            // Présences et absences
            stats.put("nombrePresences", presenceAbsenceRepository.countPresencesByPersonnelAndPeriode(personnel, dateDebut, dateFin));
            stats.put("nombreAbsences", presenceAbsenceRepository.countAbsencesByPersonnelAndPeriode(personnel, dateDebut, dateFin));

            // Justifications
            stats.put("absencesJustifiees", justificationAbsenceRepository.countByPersonnelAndEstJustifieTrue(personnel));
            stats.put("absencesNonJustifiees", justificationAbsenceRepository.countByPersonnelAndEstJustifieFalse(personnel));
            stats.put("retardsJustifies", justificationRetardRepository.countByPersonnelAndEstJustifieTrue(personnel));
            stats.put("retardsNonJustifies", justificationRetardRepository.countByPersonnelAndEstJustifieFalse(personnel));

            // Retards
            Long totalMinutesRetard = justificationRetardRepository.sumMinutesRetardByPersonnelAndPeriode(personnel, dateDebut, dateFin);
            stats.put("totalMinutesRetard", totalMinutesRetard != null ? totalMinutesRetard : 0);

            // Heures supplémentaires
            Double nbHeuresSup = presenceAbsenceRepository.sumHeuresSupplementairesParPersonnel(personnel.getId_personnel(), dateDebut, dateFin);
            Double montantHeuresSup = personnelHeureSuppRepository.sumMontantsByPersonnel(personnel);
            stats.put("nombreHeuresSup", nbHeuresSup != null ? nbHeuresSup : 0.0);
            stats.put("montantHeuresSup", montantHeuresSup != null ? montantHeuresSup : 0.0);

            return stats;
        }).orElseGet(() -> {
            // Return zeros when personnel is missing
            stats.put("nombrePresences", 0);
            stats.put("nombreAbsences", 0);
            stats.put("absencesJustifiees", 0);
            stats.put("absencesNonJustifiees", 0);
            stats.put("retardsJustifies", 0);
            stats.put("retardsNonJustifies", 0);
            stats.put("totalMinutesRetard", 0);
            stats.put("nombreHeuresSup", 0.0);
            stats.put("montantHeuresSup", 0.0);
            return stats;
        });
    }

    // ========== STATISTIQUES CHEF ==========
    public Map<String, Object> getStatistiquesChef(Integer idChef) {
        Map<String, Object> stats = new HashMap<>();

        // Validations effectuées
        User chef = userRepository.findById(idChef).orElseThrow(() -> new RuntimeException("Chef non trouvé"));
        stats.put("nombreValidations", validationAbsChefRepository.countByUser(chef));

        stats.put("congesEnAttente", demandeCongeRepository.countDemandesEnAttenteParStatut("Approuvée par chef"));

        User chefRef = new User();
        chefRef.setId_user(idChef);
        stats.put("validationsAcceptees", validationAbsChefRepository.countValidationsAccepteesByChef(chefRef));
        stats.put("validationsRefusees", validationAbsChefRepository.countValidationsRefuseesByChef(chefRef));

        // Validations en attente
        stats.put("validationsEnAttenteRh", validationAbsChefRepository.findValidationsEnAttenteRh().size());

        return stats;
    }

    // ========== STATISTIQUES RH ==========
    public Map<String, Object> getStatistiquesRh(Integer idRh) {
        Map<String, Object> stats = new HashMap<>();

        // Validations effectuées
        User chef = userRepository.findById(idRh).orElseThrow(() -> new RuntimeException("Chef non trouvé"));
        stats.put("nombreValidations", validationAbsRhRepository.countByUser(chef));

        User chefRef = new User();
        chefRef.setId_user(idRh);
        stats.put("validationsAcceptees", validationAbsRhRepository.countValidationsAccepteesByRh(chefRef));
        stats.put("validationsRefusees", validationAbsRhRepository.countValidationsRefuseesByRh(chefRef));

        // Validations en attente
        stats.put("validationsContradictoires", validationAbsRhRepository.findValidationsContradictoires().size());

        return stats;
    }

    // ========== STATISTIQUES PAR DÉPARTEMENT ==========
    public Map<String, Object> getStatistiquesDepartement(Integer idDepartement, LocalDate date) {
        Map<String, Object> stats = new HashMap<>();

        // Présences du département
        stats.put("nombrePresences", presenceAbsenceRepository.findByDepartementAndDate(idDepartement, date).size());

        // Justifications en attente
        stats.put("justificationsAbsenceEnAttente", 
                justificationAbsenceRepository.findJustificationsEnAttenteByDepartement(idDepartement).size());
        stats.put("justificationsRetardEnAttente", 
                justificationRetardRepository.findJustificationsEnAttenteByDepartement(idDepartement).size());
        // Heures supplémentaires du département
        stats.put("heuresSupDepartement", personnelHeureSuppRepository.findByDepartement(idDepartement).size());

        return stats;
    }
}