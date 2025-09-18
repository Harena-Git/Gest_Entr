package com.example.gestion.controllers;

import com.example.gestion.models.Profil;
import com.example.gestion.models.Annonce;
import com.example.gestion.repository.AnnonceRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.List;
import com.example.gestion.repository.ProfilRepository;

@Controller
public class ProfilController {

    @Autowired
    private ProfilRepository profilRepository;

    @GetMapping("/profilAll")
    public String getAllProfil(Model model) {
        List<Profil> profils = profilRepository.findAll();
        model.addAttribute("profils", profils);
        return "#";
    }

    @GetMapping("/profil")
    public String getProfilById(@RequestParam("idProfil") Long idProfil, Model model) {
        Profil profil = profilRepository.findById(idProfil).orElse(null);
        model.addAttribute("profil", profil);
        return "profil";
    }
}