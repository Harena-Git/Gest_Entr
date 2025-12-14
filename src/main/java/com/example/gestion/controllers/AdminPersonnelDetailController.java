package com.example.gestion.controllers;

import com.example.gestion.models.*;
import com.example.gestion.repository.*;
import com.example.gestion.services.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/admin/personnel")
public class AdminPersonnelDetailController {
    
    @Autowired
    private PersonnelRepository personnelRepository;
    
    @Autowired
    private ContratTravailService contratTravailService;
    
    @Autowired
    private HistoriquePosteService historiquePosteService;
    
    @Autowired
    private DocumentPersonnelService documentPersonnelService;
    
    @GetMapping("/{id}/fiche")
    public String ficheEmploye(@PathVariable Integer id, Model model) {
        Personnel personnel = personnelRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Personnel invalide: " + id));
        
        // Récupérer toutes les informations de l'employé
        List<ContratTravail> contrats = contratTravailService.getContratsByPersonnel(personnel);
        List<HistoriquePoste> historique = historiquePosteService.getHistoriquesByPersonnel(personnel);
        List<DocumentPersonnel> documents = documentPersonnelService.getDocumentsByPersonnel(personnel);
        
        model.addAttribute("personnel", personnel);
        model.addAttribute("contrats", contrats);
        model.addAttribute("historique", historique);
        model.addAttribute("documents", documents);
        model.addAttribute("titre", "Fiche Employé - " + personnel.getCandidat().getNom() + " " + personnel.getCandidat().getPrenom());
        
        return "admin/personnel/fiche";
    }
}
