package com.example.gestion.controllers;

import com.example.gestion.models.*;
import com.example.gestion.services.*;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import jakarta.servlet.http.HttpSession;
import java.util.List;
import java.util.ArrayList;

@Controller
public class Entretien1Controller {

    private final Entretien1Service entretien1Service;
    private final Entretien2Service entretien2Service;
    private final UserService userService;

    public Entretien1Controller(Entretien1Service entretien1Service, Entretien2Service entretien2Service, UserService userService) {
        this.entretien1Service = entretien1Service;
        this.entretien2Service = entretien2Service;
        this.userService = userService;
    }

    @GetMapping("/mes-entretiens")
    public String afficherMesEntretiens(HttpSession session, Model model) {
        Integer userId = 3; // exemple
        if (userId == null) {
            return "redirect:/login"; 
        }

        User user = userService.findById(userId)
            .orElseThrow(() -> new RuntimeException("Utilisateur non trouvé"));
        List<Entretien1> entretiens = new ArrayList<>();
        List<Entretien2> entretiens2 = new ArrayList<>();

        if ("Ressources Humaines".equals(user.getDepartement().getDepartement())) {
            entretiens = entretien1Service.getEntretien1(user);
            model.addAttribute("entretiens", entretiens);
        } else {
            entretiens2 = entretien2Service.getEntretien2(user);
            model.addAttribute("entretiens", entretiens2);
        }

        model.addAttribute("departement", user.getDepartement().getDepartement());
        model.addAttribute("id_user", userId);

        return "mes_entretiens"; 
    }

}
