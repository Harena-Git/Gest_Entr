package com.example.gestion.controllers;

import com.example.gestion.repository.*;
import com.example.gestion.models.*;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.ui.Model;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/personnel")
public class PersonnelAuthController {
    
    @Autowired
    private PersonnelRepository personnelRepository;
    
    @GetMapping("/login")
    public String showLoginForm() {
        return "personnel/login";
    }
    
    @PostMapping("/login")
    public String login(@RequestParam String matricule, // ou email/ID
                        HttpSession session,
                        Model model) {
        
        // Option A: Par ID personnel (simple)
        try {
            Integer id = Integer.parseInt(matricule);
            Personnel personnel = personnelRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Personnel non trouvé"));
                
            // Vérifier si actif
            if (personnel.getActif() != null && !personnel.getActif()) {
                model.addAttribute("error", "Compte désactivé");
                return "personnel/login";
            }
            
            // Stocker session
            session.setAttribute("personnelId", personnel.getId_personnel());
            session.setAttribute("personnelNom", personnel.getCandidat().getNom());
            session.setAttribute("personnelPrenom", personnel.getCandidat().getPrenom());
            session.setAttribute("userRole", "PERSONNEL");
            
            return "redirect:/personnel/dashboard";
            
        } catch (NumberFormatException e) {
            model.addAttribute("error", "Matricule invalide");
            return "personnel/login";
        }
    }
}