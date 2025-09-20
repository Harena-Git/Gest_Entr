package com.example.gestion.controllers;

import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.example.gestion.models.Annonce;
import com.example.gestion.repository.AnnonceRepository;

@Controller
public class AnnonceController {

    @Autowired
    private AnnonceRepository annonceRepository;

    @GetMapping("/acceuil")
    public String getAllAnnonces(Model model) {
        List<Annonce> annonces = annonceRepository.findAll();
        LocalDate today = LocalDate.now();
        annonces = annonces.stream()
                .filter(annonce -> {
                    // Convertir java.util.Date en LocalDate
                    LocalDate dateFin = annonce.getDate_fin().toInstant()
                            .atZone(java.time.ZoneId.systemDefault())
                            .toLocalDate();
                    return !dateFin.isBefore(today); // Montrer les annonces actives et futures
                })
                .collect(Collectors.toList());
        model.addAttribute("annonces", annonces);
        return "Acceuil";
    }
}