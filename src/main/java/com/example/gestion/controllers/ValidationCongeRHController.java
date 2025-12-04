package com.example.gestion.controllers;

import com.example.gestion.models.*;
import com.example.gestion.services.*;
import com.example.gestion.repository.UserRepository;
import com.example.gestion.repository.ValidationCongeChefRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/rh/conge")
public class ValidationCongeRHController {

    @Autowired
    private DemandeCongeService demandeCongeService;

    @Autowired
    private ValidationCongeChefService validationCongeChefService;

    @Autowired
    private ValidationCongeRHService validationCongeRHService;

    @Autowired
    private RemplacementService remplacementService;

    @Autowired
    private SoldeCongeService soldeCongeService;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private ValidationCongeChefRepository validationCongeChefRepository;

    /**
     * Afficher la liste des demandes approuvées par le chef
     */
    @GetMapping("/en-attente")
    public String afficherDemandesEnAttente(Model model, @RequestParam Integer idRH) {
        Optional<User> rh = userRepository.findById(idRH);
        if (rh.isEmpty()) {
            return "redirect:/error";
        }

        List<DemandeConge> demandes = demandeCongeService.obtenirDemandesApprouveesParChef();

        model.addAttribute("rh", rh.get());
        model.addAttribute("demandes", demandes);

        return "conge/rh/en-attente";
    }

    /**
     * Afficher le détail d'une demande avec le statut du remplaçant
     */
    @GetMapping("/details/{idDemande}")
    public String afficherDetails(Model model, 
                                  @PathVariable Integer idDemande,
                                  @RequestParam Integer idRH) {
        Optional<DemandeConge> demande = demandeCongeService.obtenirDemande(idDemande);
        Optional<User> rh = userRepository.findById(idRH);

        if (demande.isEmpty() || rh.isEmpty()) {
            return "redirect:/error";
        }

        Optional<Remplacement> remplacement = remplacementService.obtenirRemplacement(demande.get());
        Optional<ValidationCongeChef> validationChef = validationCongeChefService.obtenirValidation(demande.get());

        model.addAttribute("demande", demande.get());
        model.addAttribute("rh", rh.get());
        model.addAttribute("remplacement", remplacement);
        model.addAttribute("validationChef", validationChef);

        return "conge/rh/details-demande";
    }

    /**
     * Approuver une demande
     */
    @PostMapping("/approuver")
    public String approuverDemande(@RequestParam Integer idDemande,
                                   @RequestParam Integer idRH,
                                   @RequestParam(required = false) String commentaire,
                                   RedirectAttributes redirectAttributes) {
        try {
            Optional<DemandeConge> demande = demandeCongeService.obtenirDemande(idDemande);
            Optional<User> rh = userRepository.findById(idRH);

            if (demande.isEmpty() || rh.isEmpty()) {
                redirectAttributes.addFlashAttribute("erreur", "Données invalides");
                return "redirect:/rh/conge/en-attente?idRH=" + idRH;
            }

            // Obtenir la validation chef
            Optional<ValidationCongeChef> validationChefOpt = 
                validationCongeChefRepository.findByDemandeConge(demande.get());

            if (validationChefOpt.isEmpty()) {
                redirectAttributes.addFlashAttribute("erreur", "Validation chef non trouvée");
                return "redirect:/rh/conge/en-attente?idRH=" + idRH;
            }

            // Valider l'approbation par RH
            validationCongeRHService.validerApprobation(validationChefOpt.get(), rh.get(), commentaire);

            redirectAttributes.addFlashAttribute("succes", 
                "Congé approuvé! Le solde du personnel a été mis à jour.");

            return "redirect:/rh/conge/en-attente?idRH=" + idRH;

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("erreur", "Erreur: " + e.getMessage());
            return "redirect:/rh/conge/en-attente?idRH=" + idRH;
        }
    }

    /**
     * Rejeter une demande
     */
    @PostMapping("/rejeter")
    public String rejeterDemande(@RequestParam Integer idDemande,
                                 @RequestParam Integer idRH,
                                 @RequestParam String commentaire,
                                 RedirectAttributes redirectAttributes) {
        try {
            Optional<DemandeConge> demande = demandeCongeService.obtenirDemande(idDemande);
            Optional<User> rh = userRepository.findById(idRH);

            if (demande.isEmpty() || rh.isEmpty()) {
                redirectAttributes.addFlashAttribute("erreur", "Données invalides");
                return "redirect:/rh/conge/en-attente?idRH=" + idRH;
            }

            // Obtenir la validation chef
            Optional<ValidationCongeChef> validationChefOpt = 
                validationCongeChefRepository.findByDemandeConge(demande.get());

            if (validationChefOpt.isEmpty()) {
                redirectAttributes.addFlashAttribute("erreur", "Validation chef non trouvée");
                return "redirect:/rh/conge/en-attente?idRH=" + idRH;
            }

            // Valider le rejet par RH
            validationCongeRHService.validerRejet(validationChefOpt.get(), rh.get(), commentaire);

            redirectAttributes.addFlashAttribute("succes", "Demande rejetée avec le motif: " + commentaire);

            return "redirect:/rh/conge/en-attente?idRH=" + idRH;

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("erreur", "Erreur: " + e.getMessage());
            return "redirect:/rh/conge/en-attente?idRH=" + idRH;
        }
    }

    /**
     * Proposer un autre remplaçant
     */
    @PostMapping("/proposer-remplacant")
    public String proposerRemplacant(@RequestParam Integer idDemande,
                                     @RequestParam Integer idRH,
                                     RedirectAttributes redirectAttributes) {
        try {
            Optional<DemandeConge> demande = demandeCongeService.obtenirDemande(idDemande);
            if (demande.isEmpty()) {
                redirectAttributes.addFlashAttribute("erreur", "Demande non trouvée");
                return "redirect:/rh/conge/en-attente?idRH=" + idRH;
            }

            Remplacement remplacement = remplacementService.proposerRemplacant(demande.get());
            redirectAttributes.addFlashAttribute("succes", 
                "Nouveau remplaçant proposé: " + remplacement.getPersonnel().getCandidat().getPrenom());

            return "redirect:/rh/conge/details/" + idDemande + "?idRH=" + idRH;

        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("erreur", "Aucun remplaçant disponible: " + e.getMessage());
            return "redirect:/rh/conge/details/" + idDemande + "?idRH=" + idRH;
        }
    }

    /**
     * API pour obtenir les demandes
     */
    @GetMapping("/api/demandes")
    @ResponseBody
    public List<DemandeConge> obtenirDemandesAPI() {
        return demandeCongeService.obtenirDemandesApprouveesParChef();
    }
}
