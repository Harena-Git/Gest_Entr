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
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.gestion.models.DemandeConge;
import com.example.gestion.models.User;
import com.example.gestion.repository.DemandeCongeRepository;
import com.example.gestion.repository.UserRepository;
import com.example.gestion.services.DemandeCongeService;
import com.example.gestion.services.ValidationCongeChefService;

@Controller
@RequestMapping("/public/chef/conge")
public class PublicValidationCongeChefController {

    @Autowired
    private DemandeCongeService demandeCongeService;

    @Autowired
    private ValidationCongeChefService validationCongeChefService;

    @Autowired
    private DemandeCongeRepository demandeCongeRepository;

    @Autowired
    private UserRepository userRepository; // Changé de PersonnelRepository

    /**
     * Liste des demandes en attente pour un département (pour le chef)
     */
    @GetMapping("/en-attente")
    public String afficherDemandesEnAttente(
            @RequestParam Integer idChef,
            Model model,
            RedirectAttributes redirectAttributes) {
        try {
            Optional<User> chefOpt = userRepository.findById(idChef); // Changé
            if (chefOpt.isEmpty()) {
                redirectAttributes.addFlashAttribute("erreur", "Chef non trouvé");
                return "redirect:/public/chef/conge/en-attente?idChef=" + idChef;
            }

            User chef = chefOpt.get();
            
            // Vérifier que l'utilisateur est bien un chef
            if (!"Chef de département".equals(chef.getRole().getLibelle())) {
                redirectAttributes.addFlashAttribute("erreur", "Utilisateur n'est pas un chef");
                return "redirect:/public/chef/conge/en-attente?idChef=" + idChef;
            }
            
            // Récupérer les demandes du département du chef
            List<DemandeConge> demandes = demandeCongeService.obtenirDemandesEnAtenteParDepartement(
                chef.getDepartement() != null ? chef.getDepartement().getId_departement() : null
            );

            model.addAttribute("chef", chef);
            model.addAttribute("demandes", demandes);
            model.addAttribute("idChef", idChef);

            return "public/chef/conge-en-attente";

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("erreur", "Erreur: " + e.getMessage());
            return "redirect:/";
        }
    }

    /**
     * Formulaire de validation d'une demande
     */
    @GetMapping("/valider/{idDemande}")
    public String afficherFormulaireValidation(
            @PathVariable Integer idDemande,
            @RequestParam Integer idChef,
            Model model,
            RedirectAttributes redirectAttributes) {
        try {
            Optional<DemandeConge> demandeOpt = demandeCongeRepository.findById(idDemande);
            Optional<User> chefOpt = userRepository.findById(idChef); // Changé

            if (demandeOpt.isEmpty() || chefOpt.isEmpty()) {
                redirectAttributes.addFlashAttribute("erreur", "Données invalides");
                return "redirect:/public/chef/conge/en-attente?idChef=" + idChef;
            }

            DemandeConge demande = demandeOpt.get();
            User chef = chefOpt.get(); // Changé

            model.addAttribute("demande", demande);
            model.addAttribute("chef", chef);
            model.addAttribute("idChef", idChef);
            model.addAttribute("personnel", demande.getPersonnel());

            return "public/chef/conge-formulaire-validation";

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("erreur", "Erreur: " + e.getMessage());
            return "redirect:/";
        }
    }

    /**
     * Approuver une demande de congé
     */
    @PostMapping("/approuver")
    public String approuverDemande(
            @RequestParam Integer idDemande,
            @RequestParam Integer idChef,
            @RequestParam(required = false) String commentaire,
            RedirectAttributes redirectAttributes) {
        try {
            Optional<DemandeConge> demandeOpt = demandeCongeRepository.findById(idDemande);
            Optional<User> chefOpt = userRepository.findById(idChef); // Changé

            if (demandeOpt.isEmpty() || chefOpt.isEmpty()) {
                redirectAttributes.addFlashAttribute("erreur", "Données invalides");
                return "redirect:/public/chef/conge/en-attente?idChef=" + idChef;
            }

            DemandeConge demande = demandeOpt.get();
            User chef = chefOpt.get(); // Changé
            
            validationCongeChefService.validerApprobation(demande, chef, commentaire);

            redirectAttributes.addFlashAttribute("succes", "Demande approuvée avec succès!");
            return "redirect:/public/chef/conge/en-attente?idChef=" + idChef;

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("erreur", "Erreur lors de l'approbation: " + e.getMessage());
            return "redirect:/public/chef/conge/en-attente?idChef=" + idChef;
        }
    }

    /**
     * Rejeter une demande de congé
     */
    @PostMapping("/rejeter")
    public String rejeterDemande(
            @RequestParam Integer idDemande,
            @RequestParam Integer idChef,
            @RequestParam(required = false) String commentaire,
            RedirectAttributes redirectAttributes) {
        try {
            Optional<DemandeConge> demandeOpt = demandeCongeRepository.findById(idDemande);
            Optional<User> chefOpt = userRepository.findById(idChef); // Changé

            if (demandeOpt.isEmpty() || chefOpt.isEmpty()) {
                redirectAttributes.addFlashAttribute("erreur", "Données invalides");
                return "redirect:/public/chef/conge/en-attente?idChef=" + idChef;
            }

            DemandeConge demande = demandeOpt.get();
            User chef = chefOpt.get(); // Changé
            
            validationCongeChefService.validerRejet(demande, chef, commentaire);

            redirectAttributes.addFlashAttribute("succes", "Demande rejetée!");
            return "redirect:/public/chef/conge/en-attente?idChef=" + idChef;

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("erreur", "Erreur lors du rejet: " + e.getMessage());
            return "redirect:/public/chef/conge/en-attente?idChef=" + idChef;
        }
    }
}