package com.example.gestion.controllers;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import com.example.gestion.models.Personnel;
import com.example.gestion.repository.PersonnelRepository;

/**
 * Contrôleur pour gérer la redirection de la racine (/) 
 * vers le formulaire de demande de congé public
 */
@Controller
public class RootController {

    @Autowired
    private PersonnelRepository personnelRepository;

    /**
     * Redirection de la racine vers le formulaire de demande de congé
     * Utilise le premier employé actif trouvé ou l'ID 1 par défaut
     */
    @GetMapping("/")
    public String redirectToCongeForm() {
        try {
            // Chercher le premier employé actif
            List<Personnel> personnelList = personnelRepository.findAll();
            if (!personnelList.isEmpty()) {
                for (Personnel p : personnelList) {
                    if (p.getActif() != null && p.getActif()) {
                        return "redirect:/public/conge/nouvelle-demande?id=" + p.getId_personnel();
                    }
                }
                // Si aucun actif, prendre le premier
                return "redirect:/public/conge/nouvelle-demande?id=" + personnelList.get(0).getId_personnel();
            }
        } catch (Exception e) {
            // En cas d'erreur, rediriger avec ID par défaut
        }
        
        // Redirection par défaut avec ID 1
        return "redirect:/public/conge/nouvelle-demande?id=1";
    }
}
