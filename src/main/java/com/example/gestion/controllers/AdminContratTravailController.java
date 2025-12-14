package com.example.gestion.controllers;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.example.gestion.models.ContratTravail;
import com.example.gestion.models.Personnel;
import com.example.gestion.repository.PersonnelRepository;
import com.example.gestion.repository.TypeContratRepository;
import com.example.gestion.services.ContratTravailService;

@Controller
@RequestMapping("/admin/contrats")
public class AdminContratTravailController {
    
    @Autowired
    private ContratTravailService contratTravailService;
    
    @Autowired
    private PersonnelRepository personnelRepository;
    
    @Autowired
    private TypeContratRepository typeContratRepository;
    
    @GetMapping
    public String listContrats(Model model) {
        List<ContratTravail> contrats = contratTravailService.getAllContrats();
        List<ContratTravail> alertes = contratTravailService.getContratsExpirantBientot();
        
        model.addAttribute("contrats", contrats);
        model.addAttribute("alertes", alertes);
        model.addAttribute("titre", "Gestion des Contrats de Travail");
        
        return "admin/contrats/list";
    }
    
    @GetMapping("/nouveau")
    public String nouveauContratForm(Model model) {
        model.addAttribute("contrat", new ContratTravail());
        model.addAttribute("personnels", personnelRepository.findAll());
        model.addAttribute("typesContrat", typeContratRepository.findAll());
        model.addAttribute("titre", "Nouveau Contrat de Travail");
        
        return "admin/contrats/form";
    }
    
    @GetMapping("/modifier/{id}")
    public String modifierContratForm(@PathVariable Integer id, Model model) {
        ContratTravail contrat = contratTravailService.getContratById(id)
                .orElseThrow(() -> new IllegalArgumentException("Contrat invalide: " + id));
        
        model.addAttribute("contrat", contrat);
        model.addAttribute("personnels", personnelRepository.findAll());
        model.addAttribute("typesContrat", typeContratRepository.findAll());
        model.addAttribute("titre", "Modifier Contrat de Travail");
        
        return "admin/contrats/form";
    }
    
    @PostMapping("/enregistrer")
    public String enregistrerContrat(@ModelAttribute ContratTravail contrat) {
        contratTravailService.saveContrat(contrat);
        return "redirect:/admin/contrats?success=1";
    }
    
    @GetMapping("/supprimer/{id}")
    public String supprimerContrat(@PathVariable Integer id) {
        contratTravailService.deleteContrat(id);
        return "redirect:/admin/contrats?deleted=1";
    }
    
    @GetMapping("/personnel/{id}")
    public String contratsByPersonnel(@PathVariable Integer id, Model model) {
        Personnel personnel = personnelRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Personnel invalide: " + id));
        
        List<ContratTravail> contrats = contratTravailService.getContratsByPersonnel(personnel);
        
        model.addAttribute("personnel", personnel);
        model.addAttribute("contrats", contrats);
        model.addAttribute("titre", "Contrats de " + personnel.getCandidat().getNom());
        
        return "admin/contrats/personnel";
    }
}
