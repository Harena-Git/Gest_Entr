package com.example.gestion.controllers;

import com.example.gestion.models.*;
import com.example.gestion.services.QcmService;
import com.example.gestion.services.Entretien1Service; 
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import jakarta.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Collection;
import java.util.Map;
import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/qcm")
public class QcmController {
    
    @Autowired
    private QcmService qcmService;
    
    @Autowired
    private Entretien1Service entretien1Service;

    // Page d'accueil des QCMs pour test
    @GetMapping("/")
    public String listQcms(Model model) {
        model.addAttribute("qcms", qcmService.getAllQcms());
        return "qcm-list";
    }
    
    @GetMapping("/{qcmId}")
    public String showQcm(@PathVariable Integer qcmId, 
                         @RequestParam(required = false) Integer candidatId,
                         Model model, HttpSession session) {
        
        // Si pas de candidatId, en créer un fictif pour le test
        if (candidatId == null) {
            candidatId = 999; // ID fictif pour test
        }
        
        Map<String, Object> qcmData = qcmService.getQcmData(qcmId);
        
        if (qcmData.containsKey("qcm")) {
            Qcm qcm = (Qcm) qcmData.get("qcm");
            model.addAttribute("qcm", qcm);
            Object questions = qcmData.get("questions");

            if (questions == null) {
                System.err.println("⚠️ Aucune question spécifique trouvée pour ce QCM !" + qcmId);
            } else if (questions instanceof Collection<?> collection && collection.isEmpty()) {
                System.err.println("⚠️ La liste des questions spécifiques est vide !" + qcmId);
            }
            model.addAttribute("questions", qcmData.get("questions"));
            model.addAttribute("choixParQuestion", qcmData.get("choixParQuestion"));
            model.addAttribute("questionsGenerales", qcmData.get("questionsGenerales"));
            model.addAttribute("choixParQuestionGenerale", qcmData.get("choixParQuestionGenerale"));
            model.addAttribute("candidatId", candidatId);
            
            // Stocker l'heure de début en session
            session.setAttribute("startTime", System.currentTimeMillis());
            session.setAttribute("qcmDuration", qcm.getDureeMinutes() * 60 * 1000);
            session.setAttribute("candidatId", candidatId);
            
            return "passage";
        }
        
        return "redirect:/error";
    }
    
    @PostMapping("/{qcmId}/submit")
    public String submitQcm(@PathVariable Integer qcmId,
                        @RequestParam Map<String, String> allParams,
                        HttpSession session, Model model) {
        
        try {
            Integer candidatId = (Integer) session.getAttribute("candidatId");
            if (candidatId == null) {
                candidatId = 999; // ID fictif pour test
            }
            
            // CORRECTION : Stocker choixId → choixId (mais c'est redondant)
            // Ou mieux : créer directement les objets Reponse
            Map<Integer, Integer> choixSelectionnes = new HashMap<>();
            
            for (Map.Entry<String, String> entry : allParams.entrySet()) {
                if (entry.getKey().startsWith("reponse_")) {
                    try {
                        Integer choixId = Integer.parseInt(entry.getValue());
                        // On ignore l'ID de question, on a juste besoin du choixId
                        // Mais on doit garder une structure Map pour la méthode existante
                        String[] parts = entry.getKey().split("_");
                        Integer questionId = Integer.parseInt(parts[1]);
                        choixSelectionnes.put(questionId, choixId);
                    } catch (NumberFormatException e) {
                        // Ignorer les paramètres mal formattés
                    }
                }
            }
            
            // Évaluer le QCM
            ResultatQcm resultat = qcmService.evaluerQcm(candidatId, qcmId, choixSelectionnes);
            
            Integer entretienIds = entretien1Service.getEntretienByCandidatId(candidatId, qcmId);
            Entretien1 entretien = null;
            
            if (entretienIds != null) {
                entretien = entretien1Service.findById(entretienIds).orElse(null);
            }
            
            // Formater les dates pour l'affichage
            if (entretien != null) {
                if (entretien.getDateEntretien() != null) {
                    // Formater la date en français
                    String dateFormatted = entretien.getDateEntretien().format(
                        java.time.format.DateTimeFormatter.ofPattern("EEEE dd MMMM yyyy", java.util.Locale.FRENCH)
                    );
                    model.addAttribute("dateEntretienFormatted", dateFormatted);
                }
                
                if (entretien.getHeureEntretien() != null) {
                    // Formater l'heure
                    String heureFormatted = entretien.getHeureEntretien().format(
                        java.time.format.DateTimeFormatter.ofPattern("HH:mm")
                    );
                    model.addAttribute("heureEntretienFormatted", heureFormatted);
                }
            }
            
            model.addAttribute("entretien", entretien);
            model.addAttribute("resultat", resultat);
            model.addAttribute("candidatId", candidatId);
            model.addAttribute("qcmId", qcmId);

            return "resultat";
            
        } catch (Exception e) {
            model.addAttribute("error", "Erreur: " + e.getMessage());
            return "error";
        }
    }
    
    // Route de test direct sans candidat
    @GetMapping("/test/{qcmId}")
    public String testQcm(@PathVariable Integer qcmId, Model model, HttpSession session) {
        return showQcm(qcmId, 999, model, session); // ID fictif 999 pour test
    }
}