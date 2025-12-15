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
import com.example.gestion.models.ValidationCongeChef;
import com.example.gestion.repository.DemandeCongeRepository;
import com.example.gestion.repository.UserRepository;
import com.example.gestion.repository.ValidationCongeChefRepository;
import com.example.gestion.services.DemandeCongeService;
import com.example.gestion.services.SoldeCongeService;
import com.example.gestion.services.ValidationCongeRHService;

@Controller
@RequestMapping("/public/rh/conge")
public class PublicValidationCongeRHController {

    @Autowired
    private DemandeCongeService demandeCongeService;

    @Autowired
    private SoldeCongeService soldeCongeService;

    @Autowired
    private ValidationCongeRHService validationCongeRHService;

    @Autowired
    private DemandeCongeRepository demandeCongeRepository;

    @Autowired
    private UserRepository userRepository; // Changé

    @Autowired
    private ValidationCongeChefRepository validationCongeChefRepository;

    /**
     * Liste des demandes approuvées par le chef (en attente RH)
     */
    @GetMapping("/en-attente")
    public String afficherDemandesEnAttente(
            @RequestParam Integer idRH,
            Model model,
            RedirectAttributes redirectAttributes) {
        try {
            Optional<User> rhOpt = userRepository.findById(idRH); // Changé
            if (rhOpt.isEmpty()) {
                redirectAttributes.addFlashAttribute("erreur", "RH non trouvé");
                return "redirect:/public/rh/conge/en-attente?idRH=" + idRH;
            }

            User rh = rhOpt.get(); // Changé
            
            // Vérifier que l'utilisateur est bien un RH
            if (!"Responsable RH".equals(rh.getRole().getLibelle())) {
                redirectAttributes.addFlashAttribute("erreur", "Utilisateur n'est pas un RH");
                return "redirect:/public/rh/conge/en-attente?idRH=" + idRH;
            }

            // Récupérer les demandes approuvées par le chef (via ValidationCongeChef)
            List<ValidationCongeChef> validationsChef = validationCongeChefRepository.findAll();
            List<DemandeConge> demandes = new java.util.ArrayList<>();
            
            for (ValidationCongeChef validation : validationsChef) {
                DemandeConge demande = validation.getDemandeConge();
                if (demande.getStatutDemande().getLibelle().equals("Approuvée par chef")) {
                    demandes.add(demande);
                }
            }

            model.addAttribute("rh", rh);
            model.addAttribute("demandes", demandes);
            model.addAttribute("idRH", idRH);

            return "public/rh/conge-en-attente";

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
            @RequestParam Integer idRH,
            Model model,
            RedirectAttributes redirectAttributes) {
        try {
            Optional<DemandeConge> demandeOpt = demandeCongeRepository.findById(idDemande);
            Optional<User> rhOpt = userRepository.findById(idRH); // Changé

            if (demandeOpt.isEmpty() || rhOpt.isEmpty()) {
                redirectAttributes.addFlashAttribute("erreur", "Données invalides");
                return "redirect:/public/rh/conge/en-attente?idRH=" + idRH;
            }

            DemandeConge demande = demandeOpt.get();
            User rh = rhOpt.get(); // Changé
            Integer soldeRestant = soldeCongeService.obtenirSoldeRestant(demande.getPersonnel().getId_personnel());

            model.addAttribute("demande", demande);
            model.addAttribute("rh", rh);
            model.addAttribute("idRH", idRH);
            model.addAttribute("personnel", demande.getPersonnel());
            model.addAttribute("soldeRestant", soldeRestant);

            return "public/rh/conge-formulaire-validation";

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
            @RequestParam Integer idRH,
            @RequestParam(required = false) String commentaire,
            RedirectAttributes redirectAttributes) {
        try {
            Optional<DemandeConge> demandeOpt = demandeCongeRepository.findById(idDemande);
            Optional<User> rhOpt = userRepository.findById(idRH); // Changé

            if (demandeOpt.isEmpty() || rhOpt.isEmpty()) {
                redirectAttributes.addFlashAttribute("erreur", "Données invalides");
                return "redirect:/public/rh/conge/en-attente?idRH=" + idRH;
            }

            DemandeConge demande = demandeOpt.get();
            User rh = rhOpt.get(); // Changé
            
            // Récupérer la validation du chef pour cette demande
            Optional<ValidationCongeChef> validationChefOpt = validationCongeChefRepository.findByDemandeConge(demande);
            if (validationChefOpt.isEmpty()) {
                redirectAttributes.addFlashAttribute("erreur", "Validation du chef non trouvée");
                return "redirect:/public/rh/conge/en-attente?idRH=" + idRH;
            }
            
            validationCongeRHService.validerApprobation(validationChefOpt.get(), rh, commentaire);

            redirectAttributes.addFlashAttribute("succes", "Demande approuvée et solde mis à jour!");
            return "redirect:/public/rh/conge/en-attente?idRH=" + idRH;

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("erreur", "Erreur lors de l'approbation: " + e.getMessage());
            return "redirect:/public/rh/conge/en-attente?idRH=" + idRH;
        }
    }

    /**
     * Rejeter une demande de congé
     */
    @PostMapping("/rejeter")
    public String rejeterDemande(
            @RequestParam Integer idDemande,
            @RequestParam Integer idRH,
            @RequestParam(required = false) String commentaire,
            RedirectAttributes redirectAttributes) {
        try {
            Optional<DemandeConge> demandeOpt = demandeCongeRepository.findById(idDemande);
            Optional<User> rhOpt = userRepository.findById(idRH); // Changé

            if (demandeOpt.isEmpty() || rhOpt.isEmpty()) {
                redirectAttributes.addFlashAttribute("erreur", "Données invalides");
                return "redirect:/public/rh/conge/en-attente?idRH=" + idRH;
            }

            DemandeConge demande = demandeOpt.get();
            User rh = rhOpt.get(); // Changé
            
            // Récupérer la validation du chef pour cette demande
            Optional<ValidationCongeChef> validationChefOpt = validationCongeChefRepository.findByDemandeConge(demande);
            if (validationChefOpt.isEmpty()) {
                redirectAttributes.addFlashAttribute("erreur", "Validation du chef non trouvée");
                return "redirect:/public/rh/conge/en-attente?idRH=" + idRH;
            }
            
            validationCongeRHService.validerRejet(validationChefOpt.get(), rh, commentaire);

            redirectAttributes.addFlashAttribute("succes", "Demande rejetée!");
            return "redirect:/public/rh/conge/en-attente?idRH=" + idRH;

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("erreur", "Erreur lors du rejet: " + e.getMessage());
            return "redirect:/public/rh/conge/en-attente?idRH=" + idRH;
        }
    }
}