package com.example.gestion.controllers;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.gestion.models.Remplacement;
import com.example.gestion.repository.PersonnelRepository;
import com.example.gestion.services.RemplacementService;

@Controller
@RequestMapping("/personnel/remplacement")
public class RemplacementController {

    @Autowired
    private RemplacementService remplacementService;

    @Autowired
    private PersonnelRepository personnelRepository;

    /**
     * Afficher les remplaçants assignés au personnel
     */
    @GetMapping("/mes-remplacements")
    public String afficherMesRemplacements(Model model, @RequestParam Integer idPersonnel) {
        var personnel = personnelRepository.findById(idPersonnel);
        if (personnel.isEmpty()) {
            return "redirect:/error";
        }

        List<Remplacement> remplacements = remplacementService.obtenirRemplacementsAssignes(personnel.get());

        model.addAttribute("personnel", personnel.get());
        model.addAttribute("remplacements", remplacements);

        return "conge/mes-remplacements";
    }

    /**
     * Afficher les détails d'un remplacement
     */
    @GetMapping("/details/{idRemplacement}")
    public String afficherDetails(Model model, @PathVariable Integer idRemplacement) {
        var remplacement = remplacementService.obtenirRemplacement(null);
        // Note: À améliorer avec un repository pour obtenir par ID
        
        return "conge/details-remplacement";
    }

    /**
     * Accepter un remplacement
     */
    @PostMapping("/accepter")
    public String accepterRemplacement(@RequestParam Integer idRemplacement,
                                       @RequestParam(required = false) String commentaire,
                                       @RequestParam Integer idPersonnel,
                                       RedirectAttributes redirectAttributes) {
        try {
            // À compléter avec la logique d'acceptation
            redirectAttributes.addFlashAttribute("succes", "Remplacement accepté!");
            return "redirect:/personnel/remplacement/mes-remplacements?idPersonnel=" + idPersonnel;

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("erreur", "Erreur: " + e.getMessage());
            return "redirect:/personnel/remplacement/mes-remplacements?idPersonnel=" + idPersonnel;
        }
    }

    /**
     * Refuser un remplacement
     */
    @PostMapping("/refuser")
    public String refuserRemplacement(@RequestParam Integer idRemplacement,
                                      @RequestParam String commentaire,
                                      @RequestParam Integer idPersonnel,
                                      RedirectAttributes redirectAttributes) {
        try {
            // À compléter avec la logique de refus
            redirectAttributes.addFlashAttribute("succes", "Remplacement refusé!");
            return "redirect:/personnel/remplacement/mes-remplacements?idPersonnel=" + idPersonnel;

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("erreur", "Erreur: " + e.getMessage());
            return "redirect:/personnel/remplacement/mes-remplacements?idPersonnel=" + idPersonnel;
        }
    }

    /**
     * API pour obtenir les remplaçants non notifiés (pour envoyer des notifications)
     */
    @GetMapping("/api/non-notifies")
    @ResponseBody
    public List<Remplacement> obtenirRemplacementsNonNotifies() {
        return remplacementService.obtenirRemplacementsNonNotifies();
    }
}
