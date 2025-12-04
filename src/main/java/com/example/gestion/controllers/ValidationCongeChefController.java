package com.example.gestion.controllers;

import java.util.List;
import java.util.Optional;

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

import com.example.gestion.models.DemandeConge;
import com.example.gestion.models.Remplacement;
import com.example.gestion.models.User;
import com.example.gestion.repository.DemandeCongeRepository;
import com.example.gestion.repository.UserRepository;
import com.example.gestion.services.DemandeCongeService;
import com.example.gestion.services.RemplacementService;
import com.example.gestion.services.ValidationCongeChefService;

@Controller
@RequestMapping("/chef/conge")
public class ValidationCongeChefController {

    @Autowired
    private DemandeCongeService demandeCongeService;

    @Autowired
    private ValidationCongeChefService validationCongeChefService;

    @Autowired
    private RemplacementService remplacementService;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private DemandeCongeRepository demandeCongeRepository;

    /**
     * Afficher la liste des demandes en attente pour le département du chef
     */
    @GetMapping("/en-attente")
    public String afficherDemandesEnAttente(Model model, @RequestParam Integer idChef) {
        Optional<User> chef = userRepository.findById(idChef);
        if (chef.isEmpty()) {
            return "redirect:/error";
        }

        Integer idDept = chef.get().getDepartement().getId_departement();
        List<DemandeConge> demandes = demandeCongeService.obtenirDemandesEnAtenteParDepartement(idDept);

        model.addAttribute("chef", chef.get());
        model.addAttribute("demandes", demandes);

        return "conge/chef/en-attente";
    }

    /**
     * Afficher le formulaire de validation d'une demande
     */
    @GetMapping("/valider/{idDemande}")
    public String afficherFormulaireValidation(Model model, 
                                               @PathVariable Integer idDemande,
                                               @RequestParam Integer idChef) {
        Optional<DemandeConge> demande = demandeCongeService.obtenirDemande(idDemande);
        Optional<User> chef = userRepository.findById(idChef);

        if (demande.isEmpty() || chef.isEmpty()) {
            return "redirect:/error";
        }

        model.addAttribute("demande", demande.get());
        model.addAttribute("chef", chef.get());

        return "conge/chef/formulaire-validation";
    }

    /**
     * Approuver une demande de congé
     */
    @PostMapping("/approuver")
    public String approuverDemande(@RequestParam Integer idDemande,
                                   @RequestParam Integer idChef,
                                   @RequestParam(required = false) String commentaire,
                                   RedirectAttributes redirectAttributes) {
        try {
            Optional<DemandeConge> demande = demandeCongeService.obtenirDemande(idDemande);
            Optional<User> chef = userRepository.findById(idChef);

            if (demande.isEmpty() || chef.isEmpty()) {
                redirectAttributes.addFlashAttribute("erreur", "Données invalides");
                return "redirect:/chef/conge/en-attente?idChef=" + idChef;
            }

            // Valider l'approbation
            validationCongeChefService.validerApprobation(demande.get(), chef.get(), commentaire);

            // Proposer automatiquement un remplaçant
            try {
                Remplacement remplacement = remplacementService.proposerRemplacant(demande.get());
                redirectAttributes.addFlashAttribute("succes", 
                    "Demande approuvée! Remplaçant proposé: " + remplacement.getPersonnel().getCandidat().getPrenom() + 
                    " " + remplacement.getPersonnel().getCandidat().getNom());
            } catch (RuntimeException e) {
                redirectAttributes.addFlashAttribute("avertissement", 
                    "Demande approuvée, mais aucun remplaçant disponible trouvé.");
            }

            return "redirect:/chef/conge/en-attente?idChef=" + idChef;

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("erreur", "Erreur: " + e.getMessage());
            return "redirect:/chef/conge/en-attente?idChef=" + idChef;
        }
    }

    /**
     * Rejeter une demande de congé
     */
    @PostMapping("/rejeter")
    public String rejeterDemande(@RequestParam Integer idDemande,
                                 @RequestParam Integer idChef,
                                 @RequestParam String commentaire,
                                 RedirectAttributes redirectAttributes) {
        try {
            Optional<DemandeConge> demande = demandeCongeService.obtenirDemande(idDemande);
            Optional<User> chef = userRepository.findById(idChef);

            if (demande.isEmpty() || chef.isEmpty()) {
                redirectAttributes.addFlashAttribute("erreur", "Données invalides");
                return "redirect:/chef/conge/en-attente?idChef=" + idChef;
            }

            // Valider le rejet
            validationCongeChefService.validerRejet(demande.get(), chef.get(), commentaire);

            redirectAttributes.addFlashAttribute("succes", "Demande rejetée avec le motif: " + commentaire);
            return "redirect:/chef/conge/en-attente?idChef=" + idChef;

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("erreur", "Erreur: " + e.getMessage());
            return "redirect:/chef/conge/en-attente?idChef=" + idChef;
        }
    }

    /**
     * API pour obtenir les demandes en JSON
     */
    @GetMapping("/api/demandes/{idDept}")
    @ResponseBody
    public List<DemandeConge> obtenirDemandesAPI(@PathVariable Integer idDept) {
        return demandeCongeRepository.findPendingCongeesByDepartment(idDept);
    }
}
