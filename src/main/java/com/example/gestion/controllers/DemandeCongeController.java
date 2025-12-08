package com.example.gestion.controllers;

import java.security.Principal;
import java.text.SimpleDateFormat;
import java.util.Date;
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
import com.example.gestion.models.Personnel;
import com.example.gestion.repository.PersonnelRepository;
import com.example.gestion.services.DemandeCongeService;
import com.example.gestion.services.SoldeCongeService;

@Controller
@RequestMapping("/personnel/conge")
public class DemandeCongeController {

    @Autowired
    private DemandeCongeService demandeCongeService;

    @Autowired
    private SoldeCongeService soldeCongeService;

    @Autowired
    private PersonnelRepository personnelRepository;

    /**
     * Récupère le Personnel associé à l'utilisateur connecté
     */
    private Personnel getPersonnelConnecte(Principal principal) {
        if (principal == null) {
            return null;
        }
        Optional<Personnel> personnel = personnelRepository.findByUsername(principal.getName());
        return personnel.orElse(null);
    }

    /**
     * Afficher le formulaire de demande de congé
     */
    @GetMapping("/nouvelle-demande")
    public String afficherFormulaire(Model model, Principal principal) {
        Personnel personnel = getPersonnelConnecte(principal);
        if (personnel == null) {
            return "redirect:/nouvelle-demande";
        }

        Integer soldeRestant = soldeCongeService.obtenirSoldeRestant(personnel.getId_personnel());
        model.addAttribute("personnel", personnel);
        model.addAttribute("soldeRestant", soldeRestant);
        model.addAttribute("demandeConge", new DemandeConge());

        return "conge/nouvelle-demande";
    }

    /**
     * Créer une nouvelle demande de congé
     */
    @PostMapping("/creer")
    public String creerDemande(@RequestParam String dateDebut,
                               @RequestParam String dateFin,
                               @RequestParam String motif,
                               Principal principal,
                               RedirectAttributes redirectAttributes) {
        try {
            Personnel personnel = getPersonnelConnecte(principal);
            if (personnel == null) {
                redirectAttributes.addFlashAttribute("erreur", "Utilisateur non connecté ou personnel non trouvé");
                return "redirect:/nouvelle-demande";
            }

            // Parser les dates
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date debut = sdf.parse(dateDebut);
            Date fin = sdf.parse(dateFin);

            // Créer la demande
            demandeCongeService.creerDemande(personnel, debut, fin, motif);

            redirectAttributes.addFlashAttribute("succes", "Demande de congé créée avec succès!");
            return "redirect:/personnel/conge/mes-demandes";

        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("erreur", e.getMessage());
            return "redirect:/personnel/conge/nouvelle-demande";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("erreur", "Erreur lors de la création: " + e.getMessage());
            return "redirect:/personnel/conge/nouvelle-demande";
        }
    }

    /**
     * Afficher les demandes du personnel connecté
     */
    @GetMapping("/mes-demandes")
    public String afficherMesDemandes(Model model, Principal principal) {
        Personnel personnel = getPersonnelConnecte(principal);
        if (personnel == null) {
            return "redirect:/mes-demandes";
        }

        Integer soldeRestant = soldeCongeService.obtenirSoldeRestant(personnel.getId_personnel());
        List<DemandeConge> demandes = demandeCongeService.obtenirDemandesEnAttente(personnel);

        model.addAttribute("personnel", personnel);
        model.addAttribute("soldeRestant", soldeRestant);
        model.addAttribute("demandes", demandes);

        return "conge/mes-demandes";
    }

    /**
     * Afficher le détail d'une demande
     */
    @GetMapping("/details/{idDemande}")
    public String afficherDetails(Model model, @PathVariable Integer idDemande, Principal principal) {
        Personnel personnel = getPersonnelConnecte(principal);
        if (personnel == null) {
            return "redirect:/details-demande";
        }

        Optional<DemandeConge> demande = demandeCongeService.obtenirDemande(idDemande);
        if (demande.isEmpty()) {
            return "redirect:/error";
        }

        model.addAttribute("demande", demande.get());
        model.addAttribute("personnel", personnel);

        return "conge/details-demande";
    }

    /**
     * API pour vérifier le solde disponible (utilisateur connecté)
     */
    @GetMapping("/api/solde")
    @ResponseBody
    public Integer verifierSolde(Principal principal) {
        Personnel personnel = getPersonnelConnecte(principal);
        if (personnel == null) {
            return 0;
        }
        return soldeCongeService.obtenirSoldeRestant(personnel.getId_personnel());
    }

    /**
     * API pour calculer le nombre de jours
     */
    @GetMapping("/api/calcul-jours")
    @ResponseBody
    public Integer calculerJours(@RequestParam String dateDebut, @RequestParam String dateFin) {
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date debut = sdf.parse(dateDebut);
            Date fin = sdf.parse(dateFin);

            long diffInMillis = fin.getTime() - debut.getTime();
            return (int) (diffInMillis / (1000 * 60 * 60 * 24)) + 1;
        } catch (Exception e) {
            return 0;
        }
    }
}
