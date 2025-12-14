package com.example.gestion.controllers;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import com.example.gestion.models.ContratTravail;
import com.example.gestion.models.DocumentPersonnel;
import com.example.gestion.models.HistoriquePoste;
import com.example.gestion.models.Personnel;
import com.example.gestion.repository.PersonnelRepository;
import com.example.gestion.services.ContratTravailService;
import com.example.gestion.services.DocumentPersonnelService;
import com.example.gestion.services.HistoriquePosteService;

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
