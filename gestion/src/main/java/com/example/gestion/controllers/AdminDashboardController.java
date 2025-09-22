
package com.example.gestion.controllers;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.example.gestion.repository.AnnonceRepository;

@Controller
public class AdminDashboardController {
    @Autowired
    private AnnonceRepository annonceRepository;

    @GetMapping("/admin/dashboard")
    public String dashboard(Model model) {
        model.addAttribute("annonces", annonceRepository.findAll());
        return "admin/dashboard";
    }
}
