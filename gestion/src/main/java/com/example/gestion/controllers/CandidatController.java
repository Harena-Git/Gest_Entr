package com.example.gestion.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import com.example.gestion.models.*;
import com.example.gestion.repository.*;
import java.util.List;


@Controller
@RequestMapping("/candidat")
public class CandidatController {

    @Autowired
    private CandidatRepository candidatRepository;

    @Autowired
    private LieuRepository lieuRepository;

    @Autowired
    private AnnonceRepository annonceRepository;

    @Autowired
    private NiveauRepository niveauRepository;

    @Autowired
    private FiliereRepository filiereRepository;
        

   
    @GetMapping("/form")
    public String showForm(@RequestParam(name = "idAnnonce", required = false) Integer idAnnonce,
                        Model model) {
        model.addAttribute("candidat", new Candidat());

        // Lieux
        List<Lieu> lieux = lieuRepository.findAll();
        model.addAttribute("lieux", lieux);

        model.addAttribute("idAnnonce", idAnnonce);

        // Poste lié à l'annonce
        if (idAnnonce != null) {
            String posteNom = annonceRepository.findPosteByIdAnnonce(idAnnonce);
            model.addAttribute("posteNom", posteNom);
        }

        // Ajouter niveaux et filières
        model.addAttribute("niveaux", niveauRepository.findAll());
        model.addAttribute("filieres", filiereRepository.findAll());

        return "candidat-form";
    }


    @PostMapping("/save")
    public String saveCandidat(@ModelAttribute Candidat candidat,
                               @RequestParam("file") MultipartFile file) {
        try {
            if (!file.isEmpty()) {
                String photoName = file.getOriginalFilename();
                candidat.setPhoto(photoName);
                // tu peux ajouter un service pour sauvegarder physiquement le fichier
            }
            candidatRepository.save(candidat);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "redirect:/candidat/list";
    }

    @GetMapping("/list")
    public String listCandidats(Model model) {
        model.addAttribute("candidats", candidatRepository.findAll());
        return "candidat-list";
    }
}

    
