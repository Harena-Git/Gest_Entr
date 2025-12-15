package com.example.gestion.controllers;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import com.example.gestion.models.Personnel;
import com.example.gestion.repository.PersonnelRepository;
import com.example.gestion.services.SoldeCongeService;

@Controller
@RequestMapping("/test")
public class TestPersonnelController {

    @Autowired
    private PersonnelRepository personnelRepository;

    @Autowired
    private SoldeCongeService soldeCongeService;

    /**
     * Affiche directement le personnel par son ID (SANS AUTHENTIFICATION)
     * Utilisé pour tester : /test/personnel/1
     */
    @GetMapping("/personnel/{id}")
    public String afficherPersonnel(@PathVariable Integer id, Model model) {
        System.out.println("➡️ TEST: Affichage personnel ID=" + id);
        
        try {
            Optional<Personnel> personnelOpt = personnelRepository.findById(id);
            
            if (personnelOpt.isPresent()) {
                Personnel personnel = personnelOpt.get();
                // System.out.println("✅ Personnel trouvé: " + personnel.getCandidat());
                
                model.addAttribute("personnel", personnel);
                
                // Calculer le solde restant
                try {
                    Integer soldeRestant = soldeCongeService.obtenirSoldeRestant(id);
                    model.addAttribute("soldeRestant", soldeRestant);
                    System.out.println("✅ Solde: " + soldeRestant + " jours");
                } catch (Exception e) {
                    System.out.println("⚠️ Erreur solde: " + e.getMessage());
                    model.addAttribute("soldeRestant", null);
                }
                
                // Récupérer tous les personnels pour afficher
                List<Personnel> tousLesPersonnels = personnelRepository.findAll();
                model.addAttribute("tousLesPersonnels", tousLesPersonnels);
                System.out.println("✅ Total personnels: " + tousLesPersonnels.size());
                
                return "test-personnel";
            } else {
                System.out.println("❌ Personnel non trouvé avec l'ID: " + id);
                model.addAttribute("personnel", null);
                
                List<Personnel> tousLesPersonnels = personnelRepository.findAll();
                model.addAttribute("tousLesPersonnels", tousLesPersonnels);
                
                return "test-personnel";
            }
        } catch (Exception e) {
            System.out.println("❌ Erreur: " + e.getMessage());
            e.printStackTrace();
            model.addAttribute("personnel", null);
            model.addAttribute("tousLesPersonnels", personnelRepository.findAll());
            return "test-personnel";
        }
    }

    /**
     * Affiche le personnel par USERNAME (SANS AUTHENTIFICATION)
     * Utilisé pour tester : /test/personnel-by-username/dupont.j
     */
    // @GetMapping("/personnel-by-username/{username}")
    // public String afficherPersonnelParUsername(@PathVariable String username, Model model) {
    //     System.out.println("➡️ TEST: Affichage personnel username=" + username);
        
    //     try {
    //         Optional<Personnel> personnelOpt = personnelRepository.findByUsername(username);
            
    //         if (personnelOpt.isPresent()) {
    //             Personnel personnel = personnelOpt.get();
    //             System.out.println("✅ Personnel trouvé: " + personnel.getId_personnel());
                
    //             model.addAttribute("personnel", personnel);
                
    //             // Calculer le solde restant
    //             try {
    //                 Integer soldeRestant = soldeCongeService.obtenirSoldeRestant(personnel.getId_personnel());
    //                 model.addAttribute("soldeRestant", soldeRestant);
    //                 System.out.println("✅ Solde: " + soldeRestant + " jours");
    //             } catch (Exception e) {
    //                 System.out.println("⚠️ Erreur solde: " + e.getMessage());
    //                 model.addAttribute("soldeRestant", null);
    //             }
                
    //             // Récupérer tous les personnels pour afficher
    //             List<Personnel> tousLesPersonnels = personnelRepository.findAll();
    //             model.addAttribute("tousLesPersonnels", tousLesPersonnels);
    //             System.out.println("✅ Total personnels: " + tousLesPersonnels.size());
                
    //             return "test-personnel";
    //         } else {
    //             System.out.println("❌ Personnel non trouvé avec l'username: " + username);
    //             model.addAttribute("personnel", null);
                
    //             List<Personnel> tousLesPersonnels = personnelRepository.findAll();
    //             model.addAttribute("tousLesPersonnels", tousLesPersonnels);
                
    //             return "test-personnel";
    //         }
    //     } catch (Exception e) {
    //         System.out.println("❌ Erreur: " + e.getMessage());
    //         e.printStackTrace();
    //         model.addAttribute("personnel", null);
    //         model.addAttribute("tousLesPersonnels", personnelRepository.findAll());
    //         return "test-personnel";
    //     }
    // }

    /**
     * Liste TOUS les personnels avec leurs IDs
     * Utilisé pour tester : /test/all-personnels
     */
    @GetMapping("/all-personnels")
    public String afficherTousLesPersonnels(Model model) {
        System.out.println("➡️ TEST: Affichage tous les personnels");
        
        try {
            List<Personnel> tousLesPersonnels = personnelRepository.findAll();
            System.out.println("✅ Total personnels trouvés: " + tousLesPersonnels.size());
            
            model.addAttribute("tousLesPersonnels", tousLesPersonnels);
            model.addAttribute("personnel", null); // Pas de personnel spécifique
            model.addAttribute("soldeRestant", null);
            
            return "test-personnel";
        } catch (Exception e) {
            System.out.println("❌ Erreur: " + e.getMessage());
            e.printStackTrace();
            model.addAttribute("tousLesPersonnels", personnelRepository.findAll());
            model.addAttribute("personnel", null);
            return "test-personnel";
        }
    }
}
