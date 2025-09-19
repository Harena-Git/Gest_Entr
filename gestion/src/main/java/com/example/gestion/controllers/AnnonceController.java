package com.example.gestion.controllers;

import java.time.LocalDate;

import com.example.gestion.models.Annonce;
import com.example.gestion.repository.AnnonceRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.List;
import java.time.LocalDate;
import java.util.stream.Collectors;

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
                    LocalDate dateFin = LocalDate.parse(annonce.getDate_fin());
                    return !dateFin.isAfter(today);
                })
                .collect(Collectors.toList());
        model.addAttribute("annonces", annonces);
        return "Acceuil";
    }
}