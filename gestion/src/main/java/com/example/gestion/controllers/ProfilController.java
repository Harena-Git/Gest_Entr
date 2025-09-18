package com.example.gestion.controllers;

import com.example.gestion.models.Profil;
import com.example.gestion.repository.ProfilRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.List;

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
    public String getProfil(@RequestParam("idProfil") Integer idProfil, Model model) {
        Profil profil = profilRepository.findById(idProfil).orElse(null);
        if (profil != null) {
            model.addAttribute("profil", profil);
        } else {
            model.addAttribute("error", "Profil non trouvé avec l'ID : " + idProfil);
        }
        return "profil";
    }
}