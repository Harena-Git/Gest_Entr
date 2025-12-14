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

import com.example.gestion.models.HistoriquePoste;
import com.example.gestion.models.Personnel;
import com.example.gestion.repository.PersonnelRepository;
import com.example.gestion.repository.PosteRepository;
import com.example.gestion.services.HistoriquePosteService;

@Controller
@RequestMapping("/admin/historique-postes")
public class AdminHistoriquePosteController {
    
    @Autowired
    private HistoriquePosteService historiquePosteService;
    
    @Autowired
    private PersonnelRepository personnelRepository;
    
    @Autowired
    private PosteRepository posteRepository;
    
    @GetMapping
    public String listHistoriques(Model model) {
        List<HistoriquePoste> historiques = historiquePosteService.getAllHistoriques();
        
        model.addAttribute("historiques", historiques);
        model.addAttribute("titre", "Historique des Postes, Promotions et Mobilités");
        
        return "admin/historique-postes/list";
    }
    
    @GetMapping("/nouveau")
    public String nouveauHistoriqueForm(Model model) {
        model.addAttribute("historique", new HistoriquePoste());
        model.addAttribute("personnels", personnelRepository.findAll());
        model.addAttribute("postes", posteRepository.findAll());
        model.addAttribute("titre", "Nouveau Mouvement");
        
        return "admin/historique-postes/form";
    }
    
    @GetMapping("/modifier/{id}")
    public String modifierHistoriqueForm(@PathVariable Integer id, Model model) {
        HistoriquePoste historique = historiquePosteService.getHistoriqueById(id)
                .orElseThrow(() -> new IllegalArgumentException("Historique invalide: " + id));
        
        model.addAttribute("historique", historique);
        model.addAttribute("personnels", personnelRepository.findAll());
        model.addAttribute("postes", posteRepository.findAll());
        model.addAttribute("titre", "Modifier Mouvement");
        
        return "admin/historique-postes/form";
    }
    
    @PostMapping("/enregistrer")
    public String enregistrerHistorique(@ModelAttribute HistoriquePoste historique) {
        historiquePosteService.saveHistorique(historique);
        return "redirect:/admin/historique-postes?success=1";
    }
    
    @GetMapping("/supprimer/{id}")
    public String supprimerHistorique(@PathVariable Integer id) {
        historiquePosteService.deleteHistorique(id);
        return "redirect:/admin/historique-postes?deleted=1";
    }
    
    @GetMapping("/personnel/{id}")
    public String historiqueByPersonnel(@PathVariable Integer id, Model model) {
        Personnel personnel = personnelRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Personnel invalide: " + id));
        
        List<HistoriquePoste> historiques = historiquePosteService.getHistoriquesByPersonnel(personnel);
        
        model.addAttribute("personnel", personnel);
        model.addAttribute("historiques", historiques);
        model.addAttribute("titre", "Carrière de " + personnel.getCandidat().getNom());
        
        return "admin/historique-postes/personnel";
    }
}
