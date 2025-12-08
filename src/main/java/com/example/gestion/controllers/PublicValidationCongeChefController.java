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
import com.example.gestion.models.Personnel;
import com.example.gestion.models.User;
import com.example.gestion.repository.DemandeCongeRepository;
import com.example.gestion.repository.PersonnelRepository;
import com.example.gestion.services.DemandeCongeService;
import com.example.gestion.services.ValidationCongeChefService;

/**
 * Contrôleur public pour la validation des demandes de congé par le chef
 */
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
    private PersonnelRepository personnelRepository;

    /**
     * Liste des demandes en attente pour un département (pour le chef)
     */
    @GetMapping("/en-attente")
    public String afficherDemandesEnAttente(
            @RequestParam Integer idChef,
            Model model,
            RedirectAttributes redirectAttributes) {
        try {
            Optional<Personnel> chefOpt = personnelRepository.findById(idChef);
            if (chefOpt.isEmpty()) {
                redirectAttributes.addFlashAttribute("erreur", "Chef non trouvé");
                return "redirect:/public/chef/conge/en-attente?idChef=" + idChef;
            }

            Personnel chef = chefOpt.get();
            // Récupérer les demandes du département du chef
            List<DemandeConge> demandes = demandeCongeService.obtenirDemandesEnAtenteParDepartement(
                chef.getPoste() != null ? chef.getPoste().getDepartement().getId_departement() : null
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
            Optional<Personnel> chefOpt = personnelRepository.findById(idChef);

            if (demandeOpt.isEmpty() || chefOpt.isEmpty()) {
                redirectAttributes.addFlashAttribute("erreur", "Données invalides");
                return "redirect:/public/chef/conge/en-attente?idChef=" + idChef;
            }

            DemandeConge demande = demandeOpt.get();
            Personnel chef = chefOpt.get();

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
            Optional<Personnel> chefOpt = personnelRepository.findById(idChef);

            if (demandeOpt.isEmpty() || chefOpt.isEmpty()) {
                redirectAttributes.addFlashAttribute("erreur", "Données invalides");
                return "redirect:/public/chef/conge/en-attente?idChef=" + idChef;
            }

            DemandeConge demande = demandeOpt.get();
            Personnel chefPersonnel = chefOpt.get();
            
            // Créer un User avec le Personnel lié
            // (idChef est l'ID du Personnel, pas de User)
            User chef = new User();
            chef.setPersonnel(chefPersonnel);
            
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
            Optional<Personnel> chefOpt = personnelRepository.findById(idChef);

            if (demandeOpt.isEmpty() || chefOpt.isEmpty()) {
                redirectAttributes.addFlashAttribute("erreur", "Données invalides");
                return "redirect:/public/chef/conge/en-attente?idChef=" + idChef;
            }

            DemandeConge demande = demandeOpt.get();
            Personnel chefPersonnel = chefOpt.get();
            
            User chef = new User();
            chef.setPersonnel(chefPersonnel);
            
            validationCongeChefService.validerRejet(demande, chef, commentaire);

            redirectAttributes.addFlashAttribute("succes", "Demande rejetée!");
            return "redirect:/public/chef/conge/en-attente?idChef=" + idChef;

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("erreur", "Erreur lors du rejet: " + e.getMessage());
            return "redirect:/public/chef/conge/en-attente?idChef=" + idChef;
        }
    }
}
