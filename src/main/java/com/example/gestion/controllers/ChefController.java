package com.example.gestion.controllers;

import java.nio.file.Path;
import java.nio.file.Paths;

import com.example.gestion.models.*;
import com.example.gestion.services.*;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.UrlResource;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpSession;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;

@Controller
@RequestMapping("/chef")
public class ChefController {

    @Autowired
    private DashboardService dashboardService;

    @Autowired
    private RelevePresenceService relevePresenceService;

    @Autowired
    private JustificationAbsenceService justificationAbsenceService;

    @Autowired
    private JustificationRetardService justificationRetardService;

    @Autowired
    private ValidationAbsChefService validationAbsChefService;

    @Autowired
    private PresenceAbsenceService presenceAbsenceService;

        // ========== DASHBOARD CHEF ==========
    @GetMapping("/dashboard")
    public String dashboard(Model model, HttpSession session) {
        if (!estChef(session)) return "redirect:/admin/login";

        Integer departementId = (Integer) session.getAttribute("userDepartement");
        LocalDate aujourdhui = LocalDate.now();

        // Statistiques département
        Map<String, Object> stats = dashboardService.getStatistiquesDepartement(departementId, aujourdhui);
        model.addAttribute("stats", stats);

        // Justifications en attente du département
        List<JustificationAbsence> justifsAbsenceEnAttente = justificationAbsenceService
            .getJustificationsEnAttenteByDepartement(departementId);
        List<JustificationRetard> justifsRetardEnAttente = justificationRetardService
            .getJustificationsEnAttenteByDepartement(departementId);
        
        // Formatage des dates pour le JSP
        DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        DateTimeFormatter dayFormatter = DateTimeFormatter.ofPattern("EEEE", java.util.Locale.FRENCH);
        
        // Pour les absences
        for (JustificationAbsence justif : justifsAbsenceEnAttente) {
            if (justif.getDateAbsence() != null) {
                model.addAttribute("dateAbs_" + justif.getIdJustificationAbsence() + "_formatted",
                    justif.getDateAbsence().format(dateFormatter));
                model.addAttribute("dateAbs_" + justif.getIdJustificationAbsence() + "_day",
                    justif.getDateAbsence().format(dayFormatter));
            }
            if (justif.getDateDemande() != null) {
                model.addAttribute("dateDem_" + justif.getIdJustificationAbsence() + "_formatted",
                    justif.getDateDemande().format(dateFormatter));
            }
        }
        
        // Pour les retards
        for (JustificationRetard justif : justifsRetardEnAttente) {
            if (justif.getDateRetard() != null) {
                model.addAttribute("dateRet_" + justif.getIdJustificationRetard() + "_formatted",
                    justif.getDateRetard().format(dateFormatter));
                model.addAttribute("dateRet_" + justif.getIdJustificationRetard() + "_day",
                    justif.getDateRetard().format(dayFormatter));
            }
        }
        
        model.addAttribute("justifsAbsenceEnAttente", justifsAbsenceEnAttente);
        model.addAttribute("justifsRetardEnAttente", justifsRetardEnAttente);

        // Présences du jour du département
        List<PresenceAbsence> presencesDuJour = presenceAbsenceService
            .getPresencesByDepartementEtDate(departementId, aujourdhui);
        model.addAttribute("presencesDuJour", presencesDuJour);
        
        // Date d'aujourd'hui formatée
        model.addAttribute("aujourdhuiFormatted", aujourdhui.format(dateFormatter));
        model.addAttribute("aujourdhuiDay", aujourdhui.format(dayFormatter));
        
        // Ajouter les formatters au modèle pour une utilisation directe
        model.addAttribute("dateFormatter", dateFormatter);
        model.addAttribute("dayFormatter", dayFormatter);

        return "chef/dashboard";
    }

    // ========== GÉNÉRATION RELEVÉS DÉPARTEMENT ==========
    @GetMapping("/releves")
    public String pageReleves(Model model, HttpSession session) {
        if (!estChef(session)) return "redirect:/admin/login";
        return "chef/releves";
    }

    @PostMapping("/generer-releve-departement")
    public String genererReleveDepartement(
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dateDebut,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dateFin,
            @RequestParam String format,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        
        if (!estChef(session)) return "redirect:/admin/login";

        try {
            Integer departementId = (Integer) session.getAttribute("userDepartement");
            String fichierUrl = relevePresenceService.genererReleveDepartement(departementId, dateDebut, dateFin, format);
            redirectAttributes.addFlashAttribute("success", "Relevé département généré: " + fichierUrl);
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur génération: " + e.getMessage());
        }
        
        return "redirect:/chef/releves";
    }

    // ========== VALIDATIONS AVEC FILTRES ==========
    @GetMapping("/validations")
    public String pageValidations(
            @RequestParam(required = false) String type, // "absence" ou "retard"
            @RequestParam(required = false) Integer personnel,
            Model model, 
            HttpSession session) {
        
        if (!estChef(session)) return "redirect:/admin/login";

        Integer departementId = (Integer) session.getAttribute("userDepartement");

        // Justifications en attente du département
        List<JustificationAbsence> justifsAbsence = justificationAbsenceService
            .getJustificationsEnAttenteByDepartement(departementId);
        
        List<JustificationRetard> justifsRetard = justificationRetardService
            .getJustificationsEnAttenteByDepartement(departementId);
        
        // Appliquer les filtres
        if (personnel != null) {
            justifsAbsence = justifsAbsence.stream()
                .filter(j -> j.getPersonnel().getId_personnel().equals(personnel))
                .collect(Collectors.toList());
            
            justifsRetard = justifsRetard.stream()
                .filter(j -> j.getPersonnel().getId_personnel().equals(personnel))
                .collect(Collectors.toList());
        }
        
        if ("absence".equalsIgnoreCase(type)) {
            justifsRetard = Collections.emptyList();
        } else if ("retard".equalsIgnoreCase(type)) {
            justifsAbsence = Collections.emptyList();
        }
        
        // Formatage des dates pour le JSP
        DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        DateTimeFormatter dayFormatter = DateTimeFormatter.ofPattern("EEEE", java.util.Locale.FRENCH);
        
        // Pour les absences
        Map<Integer, String> dateAbsFormatted = new HashMap<>();
        Map<Integer, String> dateAbsDay = new HashMap<>();
        Map<Integer, String> dateDemFormatted = new HashMap<>();
        
        for (JustificationAbsence justif : justifsAbsence) {
            if (justif.getDateAbsence() != null) {
                dateAbsFormatted.put(justif.getIdJustificationAbsence(),
                    justif.getDateAbsence().format(dateFormatter));
                dateAbsDay.put(justif.getIdJustificationAbsence(),
                    justif.getDateAbsence().format(dayFormatter));
            }
            if (justif.getDateDemande() != null) {
                dateDemFormatted.put(justif.getIdJustificationAbsence(),
                    justif.getDateDemande().format(dateFormatter));
            }
        }
        
        // Pour les retards
        Map<Integer, String> dateRetFormatted = new HashMap<>();
        Map<Integer, String> dateRetDay = new HashMap<>();
        
        for (JustificationRetard justif : justifsRetard) {
            if (justif.getDateRetard() != null) {
                dateRetFormatted.put(justif.getIdJustificationRetard(),
                    justif.getDateRetard().format(dateFormatter));
                dateRetDay.put(justif.getIdJustificationRetard(),
                    justif.getDateRetard().format(dayFormatter));
            }
        }
        
        // Ajouter au modèle
        model.addAttribute("justifsAbsence", justifsAbsence);
        model.addAttribute("justifsRetard", justifsRetard);
        model.addAttribute("dateAbsFormatted", dateAbsFormatted);
        model.addAttribute("dateAbsDay", dateAbsDay);
        model.addAttribute("dateDemFormatted", dateDemFormatted);
        model.addAttribute("dateRetFormatted", dateRetFormatted);
        model.addAttribute("dateRetDay", dateRetDay);
        
        // Date d'aujourd'hui pour calculer le nombre de jours
        LocalDate aujourdhui = LocalDate.now();
        model.addAttribute("aujourdhui", aujourdhui);
        
        return "chef/validations";
    }

    // ========== PRÉVISUALISATION RELEVÉ ==========
    @PostMapping("/preview-releve")
    @ResponseBody
    public Map<String, Object> previewReleve(
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dateDebut,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dateFin,
            @RequestParam String format,
            @RequestParam(required = false) boolean includeAbsences,
            @RequestParam(required = false) boolean includeRetards,
            @RequestParam(required = false) boolean includeHeuresSup,
            @RequestParam(required = false, defaultValue = "nom") String sortBy,
            HttpSession session) {
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            if (!estChef(session)) {
                throw new RuntimeException("Accès non autorisé");
            }
            
            Integer departementId = (Integer) session.getAttribute("userDepartement");
            
            // Calculer les statistiques pour la prévisualisation
            long nbPersonnel = 0; // À remplacer par la vraie logique
            long nbPresences = presenceAbsenceService
                .getPresencesByDepartementEtDate(departementId, LocalDate.now()).size();
            
            response.put("success", true);
            response.put("periode", dateDebut.toString() + " au " + dateFin.toString());
            response.put("format", format);
            response.put("nbPersonnel", nbPersonnel);
            response.put("nbPresences", nbPresences);
            response.put("estimatedSize", "2.4 MB");
            response.put("generationTime", "~30 secondes");
            
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", e.getMessage());
        }
        
        return response;
    }

    // ========== TÉLÉCHARGER RELEVÉ EXISTANT ==========
    @GetMapping("/telecharger-releve/{filename}")
    public ResponseEntity<Resource> telechargerReleve(
            @PathVariable String filename,
            HttpSession session) {
        
        if (!estChef(session)) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
        
        try {
            // Chemin vers le fichier
            Path filePath = Paths.get("E:/HP/Documents/S5/Mr Tovo/Gest_Entr/src/main/resources/static/releves/" + filename);
            Resource resource = new UrlResource(filePath.toUri());
            
            if (resource.exists() && resource.isReadable()) {
                return ResponseEntity.ok()
                        .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + filename + "\"")
                        .contentType(MediaType.APPLICATION_OCTET_STREAM)
                        .body(resource);
            } else {
                return ResponseEntity.notFound().build();
            }
            
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    // ========== VALIDER PLUSIEURS JUSTIFICATIONS ==========
    @PostMapping("/valider-multiple")
    @ResponseBody
    public Map<String, Object> validerMultiple(
            @RequestParam List<Integer> ids,
            @RequestParam String type, // "absence" ou "retard"
            @RequestParam String decision, // "accepté" ou "refusé"
            HttpSession session) {
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            if (!estChef(session)) {
                throw new RuntimeException("Accès non autorisé");
            }
            
            Integer chefId = (Integer) session.getAttribute("userId");
            int count = 0;
            
            if ("absence".equals(type)) {
                for (Integer id : ids) {
                    try {
                        validationAbsChefService.validerJustificationAbsence(chefId, id, null, decision);
                        count++;
                    } catch (Exception e) {
                        // Continuer avec les autres
                    }
                }
            } else if ("retard".equals(type)) {
                for (Integer id : ids) {
                    try {
                        validationAbsChefService.validerJustificationRetard(chefId, id, null, decision);
                        count++;
                    } catch (Exception e) {
                        // Continuer avec les autres
                    }
                }
            }
            
            response.put("success", true);
            response.put("message", count + " justification(s) validée(s) avec succès");
            response.put("count", count);
            
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Erreur: " + e.getMessage());
        }
        
        return response;
    }

    @PostMapping("/valider-absence")
    public String validerAbsence(
            @RequestParam Integer idJustification,
            @RequestParam Integer idPresence,
            @RequestParam String decision,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        
        if (!estChef(session)) return "redirect:/admin/login";

        try {
            Integer chefId = (Integer) session.getAttribute("userId");
            validationAbsChefService.validerJustificationAbsence(chefId, idJustification, idPresence, decision);
            redirectAttributes.addFlashAttribute("success", "Absence validée avec succès");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur validation: " + e.getMessage());
        }

        return "redirect:/chef/validations";
    }

    @PostMapping("/valider-retard")
    public String validerRetard(
            @RequestParam Integer idJustification,
            @RequestParam Integer idPresence,
            @RequestParam String decision,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        
        if (!estChef(session)) return "redirect:/admin/login";

        try {
            Integer chefId = (Integer) session.getAttribute("userId");
            validationAbsChefService.validerJustificationRetard(chefId, idJustification, idPresence, decision);
            redirectAttributes.addFlashAttribute("success", "Retard validé avec succès");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur validation: " + e.getMessage());
        }

        return "redirect:/chef/validations";
    }

    
    // ========== GESTION ÉQUIPE ==========
    @GetMapping("/equipe")
    public String pageEquipe(Model model, HttpSession session) {
        if (!estChef(session)) return "redirect:/admin/login";

        Integer departementId = (Integer) session.getAttribute("userDepartement");
        LocalDate aujourdhui = LocalDate.now();

        // Présences de l'équipe aujourd'hui
        List<PresenceAbsence> presencesEquipe = presenceAbsenceService.getPresencesByDepartementEtDate(departementId, aujourdhui);
        model.addAttribute("presencesEquipe", presencesEquipe);

        return "chef/equipe";
    }

    // ========== MÉTHODES UTILITAIRES ==========
    private boolean estChef(HttpSession session) {
        String role = (String) session.getAttribute("userRole");
        return role != null && role.equalsIgnoreCase("CHEF DE DÉPARTEMENT");
    }
}