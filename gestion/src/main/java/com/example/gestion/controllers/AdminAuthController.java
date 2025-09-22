package com.example.gestion.controllers;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.gestion.models.User;
import com.example.gestion.repository.UserRepository;

@Controller
public class AdminAuthController {

    private static final Logger logger = LoggerFactory.getLogger(AdminAuthController.class);

    @Autowired
    private UserRepository userRepository;

    @GetMapping("/admin/login")
    public String showLoginForm() {
        logger.info("Affichage du formulaire de connexion admin");
        return "admin/login";
    }

    @PostMapping("/admin/login")
    public String login(@RequestParam("username") String username,
                        @RequestParam("password") String password,
                        Model model) {
        logger.info("Tentative de connexion avec username: {}", username);
        
        User user = userRepository.findByNom(username);
        if (user == null) {
            logger.error("Utilisateur non trouvé pour username: {}", username);
            model.addAttribute("error", "Utilisateur non trouvé.");
            return "admin/login";
        }
        
        logger.info("Utilisateur trouvé: {}, mot de passe fourni: {}", user.getNom(), password);
        if (!user.getMot_de_passe().equals(password)) {
            logger.error("Mot de passe incorrect pour username: {}", username);
            model.addAttribute("error", "Mot de passe incorrect.");
            return "admin/login";
        }
        
        if (user.getRole() == null || !user.getRole().getLibelle().equalsIgnoreCase("ADMIN")) {
            logger.error("Rôle invalide pour username: {}. Rôle trouvé: {}", 
                username, user.getRole() != null ? user.getRole().getLibelle() : "null");
            model.addAttribute("error", "Accès réservé aux administrateurs.");
            return "admin/login";
        }

        logger.info("Authentification réussie pour username: {}", username);
        return "redirect:/admin/dashboard";
    }
}