package com.example.gestion.services;

import java.time.LocalDate;
import java.time.YearMonth;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.gestion.models.Personnel;
import com.example.gestion.models.PresenceAbsence;
import com.example.gestion.repository.JustificationAbsenceRepository;
import com.example.gestion.repository.JustificationRetardRepository;
import com.example.gestion.repository.PersonnelHeureSuppRepository;
import com.example.gestion.repository.PersonnelRepository;
import com.example.gestion.repository.PresenceAbsenceRepository;

@Service
@Transactional(readOnly = true)
public class PaieIntegrationService {

    @Autowired
    private PersonnelRepository personnelRepository;

    @Autowired
    private PresenceAbsenceRepository presenceAbsenceRepository;

    @Autowired
    private JustificationAbsenceRepository justificationAbsenceRepository;

    @Autowired
    private JustificationRetardRepository justificationRetardRepository;

    @Autowired
    private PersonnelHeureSuppRepository personnelHeureSuppRepository;

    @Autowired
    private PresenceAbsenceService presenceAbsenceService;

    @Autowired
    private DashboardService dashboardService;

    @Autowired
    private HeuresSupplementaireService heuresSupplementaireService;

    // ========== DONNÉES PAIE FORMAT JSON ==========

    /**
     * Données pour intégration paie - Format JSON pour un personnel spécifique
     */
    public Map<String, Object> getDonneesPaieJSON(Integer idPersonnel, Integer mois, Integer annee) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            Personnel personnel = personnelRepository.findById(idPersonnel)
                    .orElseThrow(() -> new RuntimeException("Personnel non trouvé"));

            // Période du mois
            YearMonth yearMonth = YearMonth.of(annee, mois);
            LocalDate debutMois = yearMonth.atDay(1);
            LocalDate finMois = yearMonth.atEndOfMonth();

            // Calcul des données
            Map<String, Object> donnees = calculerDonneesPaie(personnel, debutMois, finMois);

            response.put("status", "success");
            response.put("data", donnees);
            response.put("message", "Données paie générées avec succès");

        } catch (Exception e) {
            response.put("status", "error");
            response.put("data", null);
            response.put("message", "Erreur: " + e.getMessage());
        }

        return response;
    }

    /**
     * Données pour tous les personnels - Format JSON (pour RH)
     */
    public Map<String, Object> getDonneesPaieGlobaleJSON(Integer mois, Integer annee) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            List<Personnel> tousPersonnels = personnelRepository.findAll();
            List<Map<String, Object>> donneesGlobales = new ArrayList<>();
            
            YearMonth yearMonth = YearMonth.of(annee, mois);
            LocalDate debutMois = yearMonth.atDay(1);
            LocalDate finMois = yearMonth.atEndOfMonth();

            for (Personnel personnel : tousPersonnels) {
                Map<String, Object> donneesPersonnel = calculerDonneesPaie(personnel, debutMois, finMois);
                donneesGlobales.add(donneesPersonnel);
            }

            // Statistiques globales
            Map<String, Object> statistiques = new HashMap<>();
            statistiques.put("nombre_personnels", tousPersonnels.size());
            statistiques.put("periode", debutMois.toString() + " - " + finMois.toString());
            statistiques.put("date_generation", LocalDate.now().toString());

            response.put("status", "success");
            response.put("data", donneesGlobales);
            response.put("statistiques", statistiques);
            response.put("message", "Données paie globale générées avec succès");

        } catch (Exception e) {
            response.put("status", "error");
            response.put("data", null);
            response.put("message", "Erreur: " + e.getMessage());
        }

        return response;
    }

    /**
     * Données paie pour un département spécifique
     */
    public Map<String, Object> getDonneesPaieDepartementJSON(Integer idDepartement, Integer mois, Integer annee) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            List<Personnel> personnels = personnelRepository.findByPosteDepartementId(idDepartement);
            List<Map<String, Object>> donneesDepartement = new ArrayList<>();
            
            YearMonth yearMonth = YearMonth.of(annee, mois);
            LocalDate debutMois = yearMonth.atDay(1);
            LocalDate finMois = yearMonth.atEndOfMonth();

            for (Personnel personnel : personnels) {
                Map<String, Object> donneesPersonnel = calculerDonneesPaie(personnel, debutMois, finMois);
                donneesDepartement.add(donneesPersonnel);
            }

            response.put("status", "success");
            response.put("departement_id", idDepartement);
            response.put("data", donneesDepartement);
            response.put("nombre_personnels", personnels.size());
            response.put("message", "Données paie département générées avec succès");

        } catch (Exception e) {
            response.put("status", "error");
            response.put("data", null);
            response.put("message", "Erreur: " + e.getMessage());
        }

        return response;
    }

    // ========== CALCUL DES DONNÉES PAIE ==========

    private Map<String, Object> calculerDonneesPaie(Personnel personnel, LocalDate dateDebut, LocalDate dateFin) {
        Map<String, Object> donnees = new HashMap<>();

        // 1. INFORMATIONS BASE
        donnees.put("id_personnel", personnel.getId_personnel());
        // donnees.put("nom", personnel.getCandidat().getNom());
        // donnees.put("prenom", personnel.getCandidat().getPrenom());
        // donnees.put("departement", personnel.getPoste().getDepartement().getDepartement());
        // donnees.put("poste", personnel.getPoste().getLibelle());

        // 2. SALAIRE BASE
        // Double salaireBase = personnel.getPoste().getSalaire().doubleValue();
        // donnees.put("salaire_base", salaireBase);

        // 3. STATISTIQUES DE PRÉSENCE (utilisation des méthodes existantes)
        Map<String, Object> statsPersonnel = dashboardService.getStatistiquesPersonnel(
            personnel.getId_personnel(), dateDebut, dateFin
        );
        
        donnees.put("nombre_presences", statsPersonnel.get("nombrePresences"));
        donnees.put("nombre_absences", statsPersonnel.get("nombreAbsences"));
        donnees.put("absences_justifiees", statsPersonnel.get("absencesJustifiees"));
        donnees.put("absences_non_justifiees", statsPersonnel.get("absencesNonJustifiees"));
        
        // 4. HEURES TRAVAILLÉES ET SUPPLÉMENTAIRES
        List<PresenceAbsence> presences = presenceAbsenceRepository
                .findByPersonnelAndDateBetween(personnel, dateDebut, dateFin);
        
        int heuresTravaillees = calculerHeuresTravailleesTotal(presences);
        int heuresSupplementaires = calculerHeuresSupplementairesTotal(presences);
        
        donnees.put("heures_travaillees", heuresTravaillees);
        donnees.put("heures_supplementaires", heuresSupplementaires);

        // 5. MONTANT HEURES SUP (utilisation du service existant)
        // Double montantHeuresSup = heuresSupplementaireService.calculerMontantTotalHeuresSup(personnel.getId_personnel());
        // donnees.put("montant_heures_sup", montantHeuresSup);

        // 6. RETARDS
        donnees.put("retards_justifies", statsPersonnel.get("retardsJustifies"));
        donnees.put("retards_non_justifies", statsPersonnel.get("retardsNonJustifies"));
        donnees.put("total_minutes_retard", statsPersonnel.get("totalMinutesRetard"));

        // // 7. ÉLÉMENTS PAIE
        // Double tauxHoraire = salaireBase / 176.0; // 176 heures/mois standard
        // Double montantHeuresNormales = heuresTravaillees * tauxHoraire;
        // Double montantHeuresSupMajore = montantHeuresSup; // Déjà calculé avec majoration
        
        // // 8. DÉDUCTIONS (calcul simplifié)
        // Double deductionAbsences = calculerDeductionAbsences(
        //     (Integer) donnees.get("absences_non_justifiees"), 
        //     tauxHoraire
        // );
        // Double deductionRetards = calculerDeductionRetards(
        //     (Long) donnees.get("total_minutes_retard"),
        //     tauxHoraire
        // );
        
        // donnees.put("deduction_absences", deductionAbsences);
        // donnees.put("deduction_retards", deductionRetards);


        // 10. MÉTADONNÉES
        donnees.put("date_generation", LocalDate.now().toString());

        return donnees;
    }

    // ========== MÉTHODES DE CALCUL UTILISANT LES SERVICES EXISTANTS ==========

    private int calculerHeuresTravailleesTotal(List<PresenceAbsence> presences) {
        int totalMinutes = 0;
        for (PresenceAbsence presence : presences) {
            if (presence.getHeureArrivee() != null && presence.getHeureDepart() != null) {
                totalMinutes += presenceAbsenceService.calculerHeuresTravaillees(presence);
            }
        }
        return totalMinutes / 60; // Conversion minutes → heures
    }

    private int calculerHeuresSupplementairesTotal(List<PresenceAbsence> presences) {
        int totalMinutes = 0;
        for (PresenceAbsence presence : presences) {
            if (presence.getHeureArrivee() != null && presence.getHeureDepart() != null) {
                totalMinutes += presenceAbsenceService.calculerHeuresSupplementaires(presence);
            }
        }
        return totalMinutes / 60; // Conversion minutes → heures
    }

    private Double calculerDeductionAbsences(int absencesNonJustifiees, Double tauxHoraire) {
        // 8 heures par jour d'absence
        return absencesNonJustifiees * 8 * tauxHoraire;
    }

    private Double calculerDeductionRetards(Long totalMinutesRetard, Double tauxHoraire) {
        if (totalMinutesRetard == null || totalMinutesRetard <= 0) {
            return 0.0;
        }
        // Conversion minutes en heures avec arrondi
        Double heuresRetard = totalMinutesRetard / 60.0;
        // Retenue proportionnelle au temps perdu
        return heuresRetard * tauxHoraire;
    }


}