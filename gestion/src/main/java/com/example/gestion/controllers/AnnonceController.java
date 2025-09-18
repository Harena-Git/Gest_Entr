package com.example.gestion.controllers;

import com.example.gestion.models.Annonce;
import com.example.gestion.repository.AnnonceRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.List;

@Controller
public class TestController {

    @Autowired
    private AnnonceRepository annonceRepository;

    @GetMapping("/acceuil")
    public String getAllAnnonces(Model model) {
        List<Annonce> annonces = annonceRepository.findAll();
        model.addAttribute("annonces", annonces);
        return "Acceuil";
    }
}