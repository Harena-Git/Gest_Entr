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
    private PresenceAbsenceService presenceAbsenceService;

    // ========== DASHBOARD RH ==========
    @GetMapping("/dashboard")
    public String dashboard(Model model, HttpSession session) {
        // Vérifier authentification RH
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
        model.addAttribute("justifsEnAttenteTotal", justifsAbsenceEnAttente.size() + justifsRetardEnAttente.size());

        return "rh/dashboard";
    }

    // ========== GÉNÉRATION RELEVÉS DE PRÉSENCE ==========
    @GetMapping("/releves")
    public String pageReleves(Model model, HttpSession session) {
        if (!estRh(session)) return "redirect:/admin/login";
        return "rh/releves";
    }

    @PostMapping("/generer-releve-global")
    public String genererReleveGlobal(
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dateDebut,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dateFin,
            @RequestParam String format,
            RedirectAttributes redirectAttributes) {
        
        try {
            String fichierUrl = relevePresenceService.genererReleveGlobal(dateDebut, dateFin, format);
            redirectAttributes.addFlashAttribute("success", "Relevé généré avec succès: " + fichierUrl);
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

    @PostMapping("/exporter-paie-json")
    @ResponseBody
    public Map<String, Object> exporterPaieJSON(
            @RequestParam Integer mois,
            @RequestParam Integer annee) {
        
        return paieIntegrationService.getDonneesPaieGlobaleJSON(mois, annee);
    }

    @PostMapping("/exporter-paie-excel")
    public String exporterPaieExcel(
            @RequestParam Integer mois,
            @RequestParam Integer annee,
            RedirectAttributes redirectAttributes) {
        
        try {
            String fichierUrl = paieIntegrationService.genererFichierPaieExcel(mois, annee);
            redirectAttributes.addFlashAttribute("success", "Fichier paie généré: " + fichierUrl);
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur génération: " + e.getMessage());
        }
        
        return "redirect:/rh/paie";
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

        // Validations contradictoires
        List<ValidationAbsRh> validationsContradictoires = validationAbsRhService.getValidationsContradictoires();
        model.addAttribute("validationsContradictoires", validationsContradictoires);

        return "rh/audit";
    }

    // ========== MÉTHODES UTILITAIRES ==========
    private boolean estRh(HttpSession session) {
        String role = (String) session.getAttribute("userRole");
        return role != null && role.equalsIgnoreCase("RESPONSABLE RH");
    }
}