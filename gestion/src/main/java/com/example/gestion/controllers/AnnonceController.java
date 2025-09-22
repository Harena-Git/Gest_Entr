package com.example.gestion.controllers;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import com.example.gestion.models.Annonce;
import com.example.gestion.repository.AnnonceRepository;

@Controller
@RequestMapping("/annonce")
public class AnnonceController {

    @Autowired
    private AnnonceRepository annonceRepository;

    // Liste de toutes les annonces
    @GetMapping("/list")
    public String listAnnonces(Model model) {
        model.addAttribute("annonces", annonceRepository.findAll());
        return "annonce-list"; // JSP correspondant
    }

    // Formulaire pour créer ou éditer une annonce
    @GetMapping("/form")
    public String showForm(@RequestParam(name = "id", required = false) Integer id,
                           Model model) {
        Annonce annonce;
        if (id != null) {
            annonce = annonceRepository.findById(id).orElse(new Annonce());
        } else {
            annonce = new Annonce();
        }
        model.addAttribute("annonce", annonce);
        return "annonce-form"; // JSP correspondant
    }

    // Sauvegarde de l'annonce
    @PostMapping("/save")
    public String saveAnnonce(@ModelAttribute Annonce annonce) {
        annonceRepository.save(annonce);
        return "redirect:/annonce/list";
    }

    // Supprimer une annonce
    @GetMapping("/delete")
    public String deleteAnnonce(@RequestParam("id") Integer id) {
        annonceRepository.deleteById(id);
        return "redirect:/annonce/list";
    }
}
