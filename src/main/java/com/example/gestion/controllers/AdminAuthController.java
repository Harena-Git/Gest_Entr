package com.example.gestion.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.gestion.models.User;
import com.example.gestion.repository.UserRepository;

import jakarta.servlet.http.HttpSession;

@Controller
public class AdminAuthController {

    @Autowired
    private UserRepository userRepository;

    @GetMapping("/admin/login")
    public String showLoginForm() {
        return "admin/login";
    }

    @PostMapping("/admin/login")
    public String login(@RequestParam String username,
                        @RequestParam String password,
                        Model model, HttpSession session) {
        
        if (username == null || password == null) {
            model.addAttribute("error", "Veuillez remplir tous les champs.");
            return "admin/login";
        }
        
        String usernameTrim = username.trim();
        String passwordTrim = password.trim();
        
        // Modifiez votre repository pour retourner Optional<User>
        User user = userRepository.findByNom(usernameTrim)
            .orElse(null); // Au lieu de findByNom qui retourne User directement
        
        if (user == null) {
            model.addAttribute("error", "Utilisateur introuvable.");
            return "admin/login";
        }
        
        // ✅ UTILISER BCrypt POUR VÉRIFIER LE MOT DE PASSE
        if (!user.getMot_de_passe().equals(passwordTrim)) {
            model.addAttribute("error", "Mot de passe incorrect.");
            return "admin/login";
        }

        // 🆕 STOCKER LES INFORMATIONS UTILISATEUR DANS LA SESSION
        session.setAttribute("user", user);
        session.setAttribute("userId", user.getId_user());
        session.setAttribute("userNom", user.getNom());
        session.setAttribute("userRole", user.getRole().getLibelle());
        session.setAttribute("userDepartement", user.getDepartement().getId_departement());

        // Redirection selon le rôle
        String userRole = user.getRole().getLibelle();
        switch (userRole) {
            case "Responsable RH":
                return "redirect:/rh/dashboard";
            case "Chef de département":
                return "redirect:/chef/dashboard";
            case "Administrateur":
                return "redirect:/admin/dashboard";
            default:
                model.addAttribute("error", "Rôle non autorisé.");
                return "admin/login";
        }
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/acceuil";
    }
}