package com.example.gestion.controllers;

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

    @Autowired
    private UserRepository userRepository;

    @GetMapping("/admin/login")
    public String showLoginForm() {
        return "admin/login";
    }

    @PostMapping("/admin/login")
    public String login(@RequestParam("username") String username,
                        @RequestParam("password") String password,
                        Model model) {
        if (username == null || password == null) {
            model.addAttribute("error", "Veuillez remplir tous les champs.");
            return "admin/login";
        }
        String usernameTrim = username.trim();
        String passwordTrim = password.trim();

        User user = userRepository.findByNom(usernameTrim);
        if (user == null) {
            model.addAttribute("error", "Utilisateur introuvable.");
            return "admin/login";
        }
        if (!user.getMot_de_passe().equals(passwordTrim)) {
            model.addAttribute("error", "Mot de passe incorrect.");
            return "admin/login";
        }
        if (user.getRole() == null || !user.getRole().getLibelle().equalsIgnoreCase("ADMIN")) {
            model.addAttribute("error", "Accès réservé à l'administrateur.");
            return "admin/login";
        }
        // Authentification réussie
        return "redirect:/admin/dashboard";
    }
}