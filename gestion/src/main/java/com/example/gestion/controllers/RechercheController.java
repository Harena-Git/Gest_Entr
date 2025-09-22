package com.example.gestion.controller;

import com.example.gestion.models.Candidat;
import com.example.gestion.models.Diplome;
import com.example.gestion.models.Lieu;
import com.example.gestion.repository.CandidatRepository;
import com.example.gestion.repository.DiplomeRepository;
import com.example.gestion.repository.LieuRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
public class RechercheController {

    @Autowired
    private CandidatRepository candidatRepository;

    @Autowired
    private LieuRepository lieuRepository;

    @Autowired
    private DiplomeRepository diplomeRepository;

    @GetMapping("/admin_recherche")
    public String afficherFormulaireRecherche(Model model) {
        List<Lieu> lieux = lieuRepository.findAll();
        List<Diplome> diplomes = diplomeRepository.findAll();
        model.addAttribute("lieux", lieux);
        model.addAttribute("diplomes", diplomes);
        return "Recherche";
    }

    @GetMapping("/recherche")
    public String rechercherCandidats(
            @RequestParam(required = false) String nom,
            @RequestParam(required = false) String lieu,
            @RequestParam(required = false) String experience,
            @RequestParam(required = false) String diplome,
            Model model) {

        List<Lieu> lieux = lieuRepository.findAll();
        List<Diplome> diplomes = diplomeRepository.findAll();
        model.addAttribute("lieux", lieux);
        model.addAttribute("diplomes", diplomes);

        // Convertion des parametres
        Integer lieuId = (lieu != null && !lieu.isEmpty()) ? Integer.parseInt(lieu) : null;
        Integer experienceValue = (experience != null && !experience.isEmpty()) ? Integer.parseInt(experience) : null;
        Integer diplomeId = (diplome != null && !diplome.isEmpty()) ? Integer.parseInt(diplome) : null;
        String nomValue = (nom != null && !nom.isEmpty()) ? nom : null;

        // Récuperation
        List<Candidat> candidats = candidatRepository.findByCriteria(nomValue, lieuId, experienceValue, diplomeId);
        model.addAttribute("candidats", candidats);

        return "Recherche";
    }
}