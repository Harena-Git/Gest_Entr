package com.example.gestion.controllers;

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
     * Afficher le formulaire de demande de congé
     */
    @GetMapping("/nouvelle-demande")
    public String afficherFormulaire(Model model, @RequestParam Integer idPersonnel) {
        Optional<Personnel> personnel = personnelRepository.findById(idPersonnel);
        if (personnel.isEmpty()) {
            return "redirect:/error";
        }

        Integer soldeRestant = soldeCongeService.obtenirSoldeRestant(idPersonnel);
        model.addAttribute("personnel", personnel.get());
        model.addAttribute("soldeRestant", soldeRestant);
        model.addAttribute("demandeConge", new DemandeConge());

        return "conge/nouvelle-demande";
    }

    /**
     * Créer une nouvelle demande de congé
     */
    @PostMapping("/creer")
    public String creerDemande(@RequestParam Integer idPersonnel,
                               @RequestParam String dateDebut,
                               @RequestParam String dateFin,
                               @RequestParam String motif,
                               RedirectAttributes redirectAttributes) {
        try {
            Optional<Personnel> personnel = personnelRepository.findById(idPersonnel);
            if (personnel.isEmpty()) {
                redirectAttributes.addFlashAttribute("erreur", "Personnel non trouvé");
                return "redirect:/personnel/conge/nouvelle-demande?idPersonnel=" + idPersonnel;
            }

            // Parser les dates
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date debut = sdf.parse(dateDebut);
            Date fin = sdf.parse(dateFin);

            // Créer la demande
            DemandeConge demande = demandeCongeService.creerDemande(personnel.get(), debut, fin, motif);

            redirectAttributes.addFlashAttribute("succes", "Demande de congé créée avec succès!");
            return "redirect:/personnel/conge/mes-demandes?idPersonnel=" + idPersonnel;

        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("erreur", e.getMessage());
            return "redirect:/personnel/conge/nouvelle-demande?idPersonnel=" + idPersonnel;
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("erreur", "Erreur lors de la création: " + e.getMessage());
            return "redirect:/personnel/conge/nouvelle-demande?idPersonnel=" + idPersonnel;
        }
    }

    /**
     * Afficher les demandes du personnel
     */
    @GetMapping("/mes-demandes")
    public String afficherMesDemandes(Model model, @RequestParam Integer idPersonnel) {
        Optional<Personnel> personnel = personnelRepository.findById(idPersonnel);
        if (personnel.isEmpty()) {
            return "redirect:/error";
        }

        Integer soldeRestant = soldeCongeService.obtenirSoldeRestant(idPersonnel);
        List<DemandeConge> demandes = personnelRepository.findById(idPersonnel)
            .map(p -> demandeCongeService.obtenirDemandesEnAttente(p))
            .orElse(List.of());

        model.addAttribute("personnel", personnel.get());
        model.addAttribute("soldeRestant", soldeRestant);
        model.addAttribute("demandes", demandes);

        return "conge/mes-demandes";
    }

    /**
     * Afficher le détail d'une demande
     */
    @GetMapping("/details/{idDemande}")
    public String afficherDetails(Model model, @PathVariable Integer idDemande) {
        Optional<DemandeConge> demande = demandeCongeService.obtenirDemande(idDemande);
        if (demande.isEmpty()) {
            return "redirect:/error";
        }

        model.addAttribute("demande", demande.get());

        return "conge/details-demande";
    }

    /**
     * API pour vérifier le solde disponible
     */
    @GetMapping("/api/solde/{idPersonnel}")
    @ResponseBody
    public Integer verifierSolde(@PathVariable Integer idPersonnel) {
        return soldeCongeService.obtenirSoldeRestant(idPersonnel);
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
