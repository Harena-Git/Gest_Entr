package com.example.gestion.controllers;

import com.example.gestion.models.*;
import com.example.gestion.services.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpSession;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/rh")
public class RhController {

    @Autowired
    private DashboardService dashboardService;

    @Autowired
    private RelevePresenceService relevePresenceService;

    @Autowired
    private PaieIntegrationService paieIntegrationService;

    @Autowired
    private JustificationAbsenceService justificationAbsenceService;

    @Autowired
    private JustificationRetardService justificationRetardService;

    @Autowired
    private ValidationAbsRhService validationAbsRhService;

    @Autowired
    private ValidationAbsChefService validationAbsChefService;

    @Autowired
    private AuditLogService auditLogService;

    // ========== DASHBOARD RH ==========
    @GetMapping("/dashboard")
    public String dashboard(Model model, HttpSession session) {
        if (!estRh(session)) {
            return "redirect:/admin/login";
        }

        LocalDate aujourdhui = LocalDate.now();
        
        // Statistiques du jour
        Map<String, Object> stats = dashboardService.getStatistiquesDuJour(aujourdhui);
        model.addAttribute("stats", stats);

        // Justifications en attente
        List<JustificationAbsence> justifsAbsenceEnAttente = justificationAbsenceService.getJustificationsEnAttente();
        List<JustificationRetard> justifsRetardEnAttente = justificationRetardService.getJustificationsEnAttente();
        
        model.addAttribute("justifsAbsenceEnAttente", justifsAbsenceEnAttente);
        model.addAttribute("justifsRetardEnAttente", justifsRetardEnAttente);

        return "rh/dashboard";
    }

    // ========== GÉNÉRATION RELEVÉS DE PRÉSENCE ==========
    @GetMapping("/releves")
    public String pageReleves(Model model, HttpSession session) {
        if (!estRh(session)) return "redirect:/admin/login";
        
        // Charger l'historique des relevés générés
        try {
            List<Map<String, Object>> historiqueReleves = relevePresenceService.listerReleves("personnel");
            model.addAttribute("historiqueReleves", historiqueReleves);
        } catch (Exception e) {
            model.addAttribute("error", "Erreur chargement historique: " + e.getMessage());
        }
        
        return "rh/releves";
    }

    @PostMapping("/generer-releve-personnel")
    public String genererRelevePersonnel(
            @RequestParam Integer idPersonnel,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dateDebut,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dateFin,
            @RequestParam String format,
            RedirectAttributes redirectAttributes) {
        
        try {
            String fichierUrl = relevePresenceService.genererRelevePersonnel(idPersonnel, dateDebut, dateFin, format);
            redirectAttributes.addFlashAttribute("success", "Relevé personnel généré: " + fichierUrl);
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur génération: " + e.getMessage());
        }
        
        return "redirect:/rh/releves";
    }

    @PostMapping("/generer-releve-departement")
    public String genererReleveDepartement(
            @RequestParam Integer idDepartement,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dateDebut,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dateFin,
            @RequestParam String format,
            RedirectAttributes redirectAttributes) {
        
        try {
            String fichierUrl = relevePresenceService.genererReleveDepartement(idDepartement, dateDebut, dateFin, format);
            redirectAttributes.addFlashAttribute("success", "Relevé département généré: " + fichierUrl);
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur génération: " + e.getMessage());
        }
        
        return "redirect:/rh/releves";
    }

    @PostMapping("/generer-releve-global")
    public String genererReleveGlobal(
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dateDebut,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dateFin,
            @RequestParam String format,
            RedirectAttributes redirectAttributes) {
        
        try {
            String fichierUrl = relevePresenceService.genererReleveGlobal(dateDebut, dateFin, format);
            redirectAttributes.addFlashAttribute("success", "Relevé global généré: " + fichierUrl);
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur génération: " + e.getMessage());
        }
        
        return "redirect:/rh/releves";
    }

    // ========== INTÉGRATION PAIE ==========
    @GetMapping("/paie")
    public String pagePaie(Model model, HttpSession session) {
        if (!estRh(session)) return "redirect:/admin/login";
        return "rh/paie";
    }

    

    // ========== VALIDATIONS ==========
    @GetMapping("/validations")
    public String pageValidations(Model model, HttpSession session) {
        if (!estRh(session)) return "redirect:/admin/login";

        // Validations en attente RH
        List<ValidationAbsChef> validationsEnAttente = validationAbsChefService.getValidationsEnAttenteRh();
        model.addAttribute("validationsEnAttente", validationsEnAttente);

        return "rh/validations";
    }

    @PostMapping("/valider-presence")
    public String validerPresence(
            @RequestParam Integer idValidationChef,
            @RequestParam String decision,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        
        if (!estRh(session)) return "redirect:/admin/login";

        try {
            Integer rhId = (Integer) session.getAttribute("userId");
            validationAbsRhService.validerDecisionChef(rhId, idValidationChef, decision);
            redirectAttributes.addFlashAttribute("success", "Validation enregistrée avec succès");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur validation: " + e.getMessage());
        }

        return "redirect:/rh/validations";
    }

    // ========== AUDIT & RAPPORTS ==========
    @GetMapping("/audit")
    public String pageAudit(Model model, HttpSession session) {
        if (!estRh(session)) return "redirect:/admin/login";

        // Historique des validations
        List<ValidationAbsRh> historiqueValidations = validationAbsRhService.getToutesLesValidationsRh();
        model.addAttribute("historiqueValidations", historiqueValidations);

        // Logs d'audit récents
        List<AuditLog> logsAudit = auditLogService.getDerniersLogs();
        model.addAttribute("logsAudit", logsAudit);

        // Statistiques d'audit
        Map<String, Object> statsAudit = calculerStatsAudit();
        model.addAttribute("statsAudit", statsAudit);

        return "rh/audit";
    }

    // ========== TÉLÉCHARGEMENT FICHIERS ==========
    @GetMapping("/telecharger-releve/{fileName}")
    public String telechargerReleve(@PathVariable String fileName, HttpSession session) {
        if (!estRh(session)) return "redirect:/admin/login";
        
        // Cette méthode devrait rediriger vers le fichier ou utiliser ResponseEntity pour le téléchargement
        return "redirect:/static/releves/personnel/" + fileName;
    }

    // ========== MÉTHODES UTILITAIRES ==========
    private boolean estRh(HttpSession session) {
        String role = (String) session.getAttribute("userRole");
        return role != null && role.equalsIgnoreCase("RESPONSABLE RH");
    }

    private Map<String, Object> calculerStatsAudit() {
        // Calculer des statistiques simples pour l'audit
        java.util.Map<String, Object> stats = new java.util.HashMap<>();
        stats.put("validationsAujourdhui", 15);
        stats.put("tauxConcordance", 92);
        stats.put("tempsMoyenValidation", "4.2h");
        stats.put("chefsActifs", 8);
        return stats;
    }
}