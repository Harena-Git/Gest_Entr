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
        User user = userRepository.findByNom(username);
        if (user != null && user.getMot_de_passe().equals(password) && user.getRole() != null && user.getRole().getLibelle().equalsIgnoreCase("ADMIN")) {
            // Authentification réussie, redirige vers la page admin (à adapter)
            return "redirect:/admin/dashboard";
        } else {
            model.addAttribute("error", "Identifiants invalides ou accès refusé.");
            return "admin/login";
        }
    }
}