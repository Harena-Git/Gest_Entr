package com.example.gestion.controllers;

import com.example.gestion.models.*;
import com.example.gestion.services.*;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/personnel")
public class PersonnelController {

    @Autowired
    private PresenceAbsenceService presenceAbsenceService;

    @Autowired
    private JustificationAbsenceService justificationAbsenceService;

    @Autowired
    private JustificationRetardService justificationRetardService;

    @Autowired
    private DashboardService dashboardService;

    @Autowired
    private HoraireEntrepriseService horaireEntrepriseService;

    // ========== DASHBOARD PERSONNEL ==========
    @GetMapping("/dashboard")
    public String dashboard(Model model, HttpSession session) {
        Integer personnelId = (Integer) session.getAttribute("personnelId");
        if (personnelId == null) {
            // Session manquante : utiliser la valeur par défaut 1 pour l'id du personnel
            personnelId = 2;
        }

        LocalDate aujourdhui = LocalDate.now();
        // Convert LocalDate to java.sql.Date (subclass of java.util.Date) for JSP fmt:formatDate
        java.util.Date aujourdhuiDate = java.sql.Date.valueOf(aujourdhui);
        LocalDate debutMois = aujourdhui.withDayOfMonth(1);
        LocalDate finMois = aujourdhui.withDayOfMonth(aujourdhui.lengthOfMonth());

        // Présence du jour
        PresenceAbsence presenceAujourdhui = presenceAbsenceService.getPresencesByPersonnel(personnelId)
                .stream()
                .filter(p -> p.getDate().equals(aujourdhui))
                .findFirst()
                .orElse(null);

        // Statistiques personnelles
        Map<String, Object> stats = dashboardService.getStatistiquesPersonnel(personnelId, debutMois, finMois);

        model.addAttribute("presenceAujourdhui", presenceAujourdhui);
        model.addAttribute("stats", stats);
        model.addAttribute("aujourdhui", aujourdhuiDate);

        return "personnel/dashboard";
    }

    // ========== POINTAGE ==========
    @PostMapping("/pointer-entree")
    public String pointerEntree(HttpSession session, RedirectAttributes redirectAttributes) {
        Integer personnelId = (Integer) session.getAttribute("personnelId");
        if (personnelId == null) {
            // Session manquante : utiliser la valeur par défaut 1 pour l'id du personnel
            personnelId = 2;
        }

        try {
            LocalDate aujourdhui = LocalDate.now();
            LocalTime maintenant = LocalTime.now();

            presenceAbsenceService.enregistrerEntree(personnelId, "personnel", aujourdhui, maintenant);
            redirectAttributes.addFlashAttribute("success", "Pointage d'entrée enregistré à " + maintenant);

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur pointage: " + e.getMessage());
        }

        return "redirect:/personnel/dashboard";
    }

    @PostMapping("/pointer-sortie")
    public String pointerSortie(HttpSession session, RedirectAttributes redirectAttributes) {
        Integer personnelId = (Integer) session.getAttribute("personnelId");
        if (personnelId == null) {
            // Session manquante : utiliser la valeur par défaut 1 pour l'id du personnel
            personnelId = 2;
        }

        try {
            LocalDate aujourdhui = LocalDate.now();
            LocalTime maintenant = LocalTime.now();

            presenceAbsenceService.enregistrerSortie(personnelId, "personnel", aujourdhui, maintenant);
            redirectAttributes.addFlashAttribute("success", "Pointage de sortie enregistré à " + maintenant);

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur pointage: " + e.getMessage());
        }

        return "redirect:/personnel/dashboard";
    }

    // ========== JUSTIFICATIONS ==========
    @GetMapping("/justifications")
    public String pageJustifications(Model model, HttpSession session) {
        Integer personnelId = (Integer) session.getAttribute("personnelId");
        if (personnelId == null) {
            // Session manquante : utiliser la valeur par défaut 1 pour l'id du personnel
            personnelId = 2;
        }

        // Historique des justifications
        List<JustificationAbsence> justifsAbsence = justificationAbsenceService.getJustificationsByPersonnel(personnelId);
        List<JustificationRetard> justifsRetard = justificationRetardService.getJustificationsByPersonnel(personnelId);

        model.addAttribute("justifsAbsence", justifsAbsence);
        model.addAttribute("justifsRetard", justifsRetard);

        return "personnel/justifications";
    }

    @PostMapping("/justifier-absence")
    public String justifierAbsence(
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dateAbsence,
            @RequestParam(required = false) MultipartFile fichier,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        
        Integer personnelId = (Integer) session.getAttribute("personnelId");
        if (personnelId == null) {
            // Session manquante : utiliser la valeur par défaut 1 pour l'id du personnel
            personnelId = 2;
        }

        try {
            justificationAbsenceService.creerJustificationAbsence(personnelId, dateAbsence, fichier, "Demande personnel");
            redirectAttributes.addFlashAttribute("success", "Absence justifiée avec succès");

        } catch (IOException e) {
            redirectAttributes.addFlashAttribute("error", "Erreur upload fichier: " + e.getMessage());
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur justification: " + e.getMessage());
        }

        return "redirect:/personnel/justifications";
    }

    // @PostMapping("/justifier-retard")
    //     public String justifierRetard(Model model, HttpSession session) {

    //     Integer personnelId = (Integer) session.getAttribute("personnelId");
    //     if (personnelId == null) {
    //         personnelId = 2;
    //     }

    //     LocalDate today = LocalDate.now();

    //     // Récupérer la présence du jour
    //     PresenceAbsence presence = presenceAbsenceService
    //             .getPresenceByPersonnelAndDate(personnelId, today);

    //     int retardMinutes = 15; // valeur par défaut

    //     if (presence != null && presence.getHeureArrivee() != null) {
    //         HoraireEntreprise horaire = horaireEntrepriseService.getHoraire(); // heureDebut = 08:00 par ex.
    //         int calcul = horaire.calculerMinutesRetard(presence.getHeureArrivee());

    //         if (calcul > 15) {
    //             retardMinutes = calcul;
    //         }
    //     }

    //     model.addAttribute("retardParDefaut", retardMinutes);

    //     return "personnel/justifications";
    // }

    // ========== AJOUTER UN FICHIER À UNE JUSTIFICATION EXISTANTE ==========
    @PostMapping("/upload-justificatif")
    @ResponseBody
    public Map<String, Object> uploadJustificatif(
            @RequestParam("file") MultipartFile fichier,
            @RequestParam("id") Integer idJustification,
            @RequestParam("type") String type,
            HttpSession session) {
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            Integer personnelId = (Integer) session.getAttribute("personnelId");
            if (personnelId == null) {
                personnelId = 2; // Valeur par défaut
            }
            
            if ("absence".equalsIgnoreCase(type)) {
                justificationAbsenceService.ajouterFichier(idJustification, fichier);
            } else if ("retard".equalsIgnoreCase(type)) {
                justificationRetardService.ajouterFichier(idJustification, fichier);
            } else {
                throw new RuntimeException("Type de justification invalide");
            }
            
            response.put("success", true);
            response.put("message", "Fichier ajouté avec succès");
            
        } catch (IOException e) {
            response.put("success", false);
            response.put("message", "Erreur upload fichier: " + e.getMessage());
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Erreur: " + e.getMessage());
        }
        
        return response;
    }

    // ========== NOUVELLE MÉTHODE POUR JUSTIFIER RETARD (POST) ==========
    @PostMapping("/justifier-retard")
    public String justifierRetardPost(
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dateRetard,
            @RequestParam Integer minutesRetard,
            @RequestParam(required = false) MultipartFile fichier,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        
        Integer personnelId = (Integer) session.getAttribute("personnelId");
        if (personnelId == null) {
            personnelId = 2;
        }
        
        try {
            justificationRetardService.creerJustificationRetard(personnelId, dateRetard, minutesRetard, fichier);
            redirectAttributes.addFlashAttribute("success", "Retard justifié avec succès");
            
        } catch (IOException e) {
            redirectAttributes.addFlashAttribute("error", "Erreur upload fichier: " + e.getMessage());
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur justification: " + e.getMessage());
        }
        
        return "redirect:/personnel/justifications";
    }

    // ========== API POUR CALCULER RETARD AUTOMATIQUE ==========
    @GetMapping("/justifier-retard/api")
    @ResponseBody
    public Map<String, Object> getRetardAutomatique(HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        
        Integer personnelId = (Integer) session.getAttribute("personnelId");
        if (personnelId == null) {
            personnelId = 2;
        }
        
        LocalDate today = LocalDate.now();
        
        try {
            // Récupérer la présence du jour
            PresenceAbsence presence = presenceAbsenceService
                    .getPresenceByPersonnelAndDate(personnelId, today);
            
            if (presence != null && presence.getHeureArrivee() != null) {
                // Calculer le retard par rapport à l'horaire d'entreprise
                HoraireEntreprise horaire = horaireEntrepriseService.getHoraire();
                int retardMinutes = horaire.calculerMinutesRetard(presence.getHeureArrivee());
                
                if (retardMinutes > 15) {
                    response.put("retardMinutes", retardMinutes);
                    response.put("heureArrivee", presence.getHeureArrivee().toString());
                    response.put("heureTheorique", horaire.getHeureDebut().toString());
                }
            }
            
            response.put("success", true);
            
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", e.getMessage());
        }
        
        return response;
    }

    // ========== HISTORIQUE ==========
    @GetMapping("/historique")
    public String pageHistorique(
        @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dateDebut,
        @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dateFin,
        @RequestParam(required = false) Integer id,
        Model model,
        HttpSession session) {

        // 1. Récupération du personnelId (avec fallback)
        Integer personnelId = (Integer) session.getAttribute("personnelId");
        if (personnelId == null) {
            personnelId = 2; // Valeur par défaut
        }

        // 2. Période par défaut = dernier mois
        if (dateDebut == null) dateDebut = LocalDate.now().minusDays(30);
        if (dateFin == null) dateFin = LocalDate.now();

        // 3. Charger l’historique filtré
        List<PresenceAbsence> historique =
                presenceAbsenceService.getPresencesByPersonnelEtPeriode(personnelId, dateDebut, dateFin);
        model.addAttribute("historique", historique);

        // 4. Si "id" est fourni → charger la présence détaillée AVEC validations (JOIN FETCH)
        if (id != null) {
            PresenceAbsence pa = presenceAbsenceService.getPresenceWithValidation(id);
            model.addAttribute("presenceAbs", pa);
        }

        // 5. Gérer les dates au format LocalDate et java.util.Date pour JSTL
        model.addAttribute("dateDebut", java.sql.Date.valueOf(dateDebut));
        model.addAttribute("dateFin", java.sql.Date.valueOf(dateFin));
        model.addAttribute("dateDebutLocal", dateDebut);
        model.addAttribute("dateFinLocal", dateFin);

        LocalDate aujourdhui = LocalDate.now();
        LocalDate ilYa7Jours = aujourdhui.minusDays(7);
        LocalDate debutMois = aujourdhui.withDayOfMonth(1);
        
        model.addAttribute("aujourdhuiDate", java.sql.Date.valueOf(aujourdhui));
        model.addAttribute("ilYa7JoursDate", java.sql.Date.valueOf(ilYa7Jours));
        model.addAttribute("debutMoisDate", java.sql.Date.valueOf(debutMois));

        return "personnel/historique";
    }

}