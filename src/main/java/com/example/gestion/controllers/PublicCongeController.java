package com.example.gestion.controllers;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.gestion.models.Personnel;
import com.example.gestion.repository.PersonnelRepository;
import com.example.gestion.services.DemandeCongeService;
import com.example.gestion.services.SoldeCongeService;

import jakarta.servlet.http.HttpSession;

/**
 * Contrôleur public pour les demandes de congé sans authentification Spring
 * Accès direct avec paramètre ?id=X
 */
@Controller
@RequestMapping("/public/conge")
public class PublicCongeController {

    @Autowired
    private PersonnelRepository personnelRepository;

    @Autowired
    private DemandeCongeService demandeCongeService;

    @Autowired
    private SoldeCongeService soldeCongeService;

    /**
     * Affiche le formulaire de demande de congé publique
     * Accès direct: /public/conge/nouvelle-demande?id=1
     */
    @GetMapping("/nouvelle-demande")
    public String afficherFormulaire(
            @RequestParam Integer id,
            HttpSession session, 
            Model model, 
            RedirectAttributes redirectAttributes) {
        
        try {
            // Récupérer les informations de l'employé
            Optional<Personnel> optPersonnel = personnelRepository.findById(id);
            if (optPersonnel.isEmpty()) {
                redirectAttributes.addFlashAttribute("erreur", "Employé non trouvé");
                return "redirect:/public/conge/nouvelle-demande?id=" + id;
            }

            Personnel personnel = optPersonnel.get();
            
            if (personnel.getActif() == null || !personnel.getActif()) {
                redirectAttributes.addFlashAttribute("erreur", "Cet employé n'est pas actif");
                return "redirect:/public/conge/nouvelle-demande?id=" + id;
            }

            // Initialiser le solde s'il n'existe pas
            Integer soldeRestant = soldeCongeService.obtenirSoldeRestant(personnel.getId_personnel());
            if (soldeRestant == 0) {
                // Vérifier si le solde n'existe vraiment pas (et pas juste 0)
                java.util.Optional<com.example.gestion.models.SoldeConge> soldeListe = soldeCongeService.obtenirSolde(personnel);
                if (soldeListe.isEmpty()) {
                    // Initialiser avec 25 jours par défaut
                    soldeCongeService.initialiserSolde(personnel, 25);
                    soldeRestant = 25;
                }
            }

            // Ajouter les données au modèle
            model.addAttribute("employeId", id);
            model.addAttribute("personnel", personnel);
            model.addAttribute("soldeRestant", soldeRestant);

            // Stocker en session pour les appels suivants
            session.setAttribute("employeId", id);

            return "public/conge-nouvelle-demande";
            
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("erreur", "Paramètre d'ID invalide");
            return "redirect:/error";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("erreur", "Erreur: " + e.getMessage());
            return "redirect:/error";
        }
    }

    /**
     * Créer une nouvelle demande de congé
     */
    @PostMapping("/creer")
    public String creerDemande(
            @RequestParam Integer id,
            @RequestParam String dateDebut,
            @RequestParam String dateFin,
            @RequestParam String motif,
            RedirectAttributes redirectAttributes) {
        try {
            // Récupérer l'employé
            Optional<Personnel> optPersonnel = personnelRepository.findById(id);
            if (optPersonnel.isEmpty()) {
                redirectAttributes.addFlashAttribute("erreur", "Employé non trouvé");
                return "redirect:/public/conge/nouvelle-demande?id=" + id;
            }

            Personnel personnel = optPersonnel.get();

            // Parser les dates
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date debut = sdf.parse(dateDebut);
            Date fin = sdf.parse(dateFin);

            // Créer la demande
            demandeCongeService.creerDemande(personnel, debut, fin, motif);

            redirectAttributes.addFlashAttribute("succes", "Demande de congé créée avec succès!");
            return "redirect:/public/conge/mes-demandes?id=" + id;

        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("erreur", e.getMessage());
            return "redirect:/public/conge/nouvelle-demande?id=" + id;
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("erreur", "Erreur lors de la création: " + e.getMessage());
            return "redirect:/public/conge/nouvelle-demande?id=" + id;
        }
    }

    /**
     * Afficher les demandes de congé de l'employé
     */
    @GetMapping("/mes-demandes")
    public String afficherMesDemandesPublic(
            @RequestParam Integer id,
            Model model, 
            RedirectAttributes redirectAttributes) {
        try {
            Optional<Personnel> optPersonnel = personnelRepository.findById(id);
            if (optPersonnel.isEmpty()) {
                redirectAttributes.addFlashAttribute("erreur", "Employé non trouvé");
                return "redirect:/public/conge/nouvelle-demande?id=" + id;
            }

            Personnel personnel = optPersonnel.get();
            model.addAttribute("demandes", demandeCongeService.obtenirDemandesEnAttente(personnel));
            model.addAttribute("employeId", id);

            return "public/conge-mes-demandes";
            
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("erreur", "Erreur: " + e.getMessage());
            return "redirect:/public/conge/nouvelle-demande?id=" + id;
        }
    }
}
