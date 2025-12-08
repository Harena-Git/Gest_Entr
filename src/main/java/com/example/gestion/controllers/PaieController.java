package com.example.gestion.controllers;

import com.example.gestion.models.*;
import com.example.gestion.dto.*;
import com.example.gestion.services.*;
import java.util.stream.Collectors;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;
import java.util.ArrayList;
import java.util.List;
import java.time.LocalDate;

@Controller
@RequestMapping
public class PaieController {

    @Autowired
    private FichePaieService fichePaieService;

    @Autowired 
    private PersonnelService personnelService;

    @Autowired 
    private ImpotService impotService;
    
    @GetMapping("/paie/etats")
    public String viewEtatsPaie(Model model) {
        fichePaieService.genererFichePaie();
        List<Personnel> personnels = personnelService.findAll();
        List<EtatPaieDTO> etatsPaieList = new ArrayList<>();
        for( Personnel personnel : personnels) 
        {
            EtatPaieDTO etatPaie = fichePaieService.genererEtatPaie(personnel);
            etatsPaieList.add(etatPaie);
        }
        model.addAttribute("etatsPaie", etatsPaieList);
        return "paie/etats";
    }
    @GetMapping("personnels/{id}/fichePaie")
    public String viewFichePaie(@PathVariable("id") Integer id, 
                            @RequestParam(name = "mois", required = false) Integer mois,
                            @RequestParam(name = "annee", required = false) Integer annee,
                            Model model) {
        
        fichePaieService.genererFichePaie();
        Personnel personnel = personnelService.findById(id)
            .orElseThrow(() -> new RuntimeException("Personnel non trouvé avec ID: " + id));
        
        // Valeurs par défaut si non spécifiées
        if (mois == null) mois = LocalDate.now().getMonthValue();
        if (annee == null) annee = LocalDate.now().getYear();
        
        FichePaie fiche = fichePaieService.findByPersonnelAndMoisAndAnnee(personnel, mois, annee);
        
        if (fiche == null) {
            model.addAttribute("error", "Aucune fiche de paie trouvée pour " + getMoisString(mois) + " " + annee);
            model.addAttribute("personnel", personnel);
            model.addAttribute("mois", mois);
            model.addAttribute("annee", annee);
            return "paie/fichePaie"; // Affiche quand même la page avec le filtre
        }

        List<TrancheIrsaDetail> detailIrsa = impotService.calculerDetailIrsa(
                fiche.getSalaireImposable(), 
                LocalDate.of(fiche.getAnnee(), fiche.getMois(), 1)
            );
        System.out.println("Détail IRSA: " + detailIrsa);
        model.addAttribute("detailIrsa", detailIrsa);
        model.addAttribute("fiche", fiche);
        model.addAttribute("mois", mois);
        model.addAttribute("annee", annee);
        model.addAttribute("personnel", personnel);
        
        return "paie/fichePaie";
    }

    private String getMoisString(int mois) {
        String[] moisNoms = {"Janvier", "Février", "Mars", "Avril", "Mai", "Juin",
                            "Juillet", "Août", "Septembre", "Octobre", "Novembre", "Décembre"};
        return (mois >= 1 && mois <= 12) ? moisNoms[mois - 1] : "Mois invalide";
    }
    @GetMapping("/personnels")
    public String listPersonnels(Model model) {
        List<Personnel> personnels = personnelService.findAll();
        model.addAttribute("personnels", personnels);
        return "paie/personnels";
    }
}