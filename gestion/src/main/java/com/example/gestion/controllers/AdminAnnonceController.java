package com.example.gestion.controllers;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.gestion.models.Annonce;
import com.example.gestion.models.Diplome;
import com.example.gestion.models.Lieu;
import com.example.gestion.models.Poste;
import com.example.gestion.models.Profil;
import com.example.gestion.repository.AnnonceRepository;
import com.example.gestion.repository.DiplomeRepository;
import com.example.gestion.repository.LieuRepository;
import com.example.gestion.repository.NiveauRepository;
import com.example.gestion.repository.PosteRepository;
import com.example.gestion.repository.ProfilRepository;
// ...existing code...
// ...existing code...

@Controller
@RequestMapping("/admin/annonces")
public class AdminAnnonceController {
    @Autowired
    private AnnonceRepository annonceRepository;
    @Autowired
    private PosteRepository posteRepository;
    @Autowired
    private ProfilRepository profilRepository;
    @Autowired
    private LieuRepository lieuRepository;
    @Autowired
    private NiveauRepository niveauRepository;
    @Autowired
    private DiplomeRepository diplomeRepository;

    @GetMapping
    public String list(Model model) {
        model.addAttribute("annonces", annonceRepository.findAll());
        return "annonces/admin_list";
    }

    @GetMapping("/new")
    public String showCreateForm(Model model) {
        model.addAttribute("annonce", new Annonce());
        model.addAttribute("postes", posteRepository.findAll());
        model.addAttribute("lieux", lieuRepository.findAll());
        model.addAttribute("niveaux", niveauRepository.findAll());
        model.addAttribute("diplomes", diplomeRepository.findAll());
        return "annonces/form";
    }

    @PostMapping
    public String create(
            @RequestParam("responsabilite") String responsabilite,
            @RequestParam("posteId") Integer posteId,
            @RequestParam("genre") String genre,
            @RequestParam("age") Integer age,
            @RequestParam("annee_experience") String annee_experience,
            @RequestParam("lieuId") Integer lieuId,
            @RequestParam("niveauId") Integer niveauId,
            @RequestParam("diplomeId") Integer diplomeId,
            @RequestParam("date_fin") String dateFinStr
    ) {
        Poste poste = posteRepository.findById(posteId).orElse(null);
        Lieu lieu = lieuRepository.findById(lieuId).orElse(null);
        Diplome diplome = diplomeRepository.findById(diplomeId).orElse(null);

        Profil profil = new Profil();
        profil.setGenre(genre);
        profil.setAge(age);
        profil.setAnnee_experience(annee_experience);
        profil.setLieu(lieu);
        profil.setDiplome(diplome);
        profil = profilRepository.save(profil);

        Annonce annonce = new Annonce();
        annonce.setResponsabilite(responsabilite);
        annonce.setPoste(poste);
        annonce.setProfil(profil);
        annonce.setDate_annonce(LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd")));
        annonce.setDate_fin(java.sql.Date.valueOf(dateFinStr));

        annonceRepository.save(annonce);
        return "redirect:/admin/annonces";
    }

    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable("id") Integer id, Model model) {
        Optional<Annonce> annonce = annonceRepository.findById(id);
        if (annonce.isPresent()) {
            model.addAttribute("annonce", annonce.get());
            model.addAttribute("postes", posteRepository.findAll());
            model.addAttribute("lieux", lieuRepository.findAll());
            model.addAttribute("niveaux", niveauRepository.findAll());
            model.addAttribute("diplomes", diplomeRepository.findAll());
            return "annonces/form";
        }
        return "redirect:/admin/annonces";
    }

    @PostMapping("/update/{id}")
    public String update(@PathVariable("id") Integer id, @ModelAttribute Annonce annonce) {
        annonce.setId_annonce(id);
        annonceRepository.save(annonce);
        return "redirect:/admin/annonces";
    }

    @GetMapping("/delete/{id}")
    public String delete(@PathVariable("id") Integer id) {
        annonceRepository.deleteById(id);
        return "redirect:/admin/annonces";
    }

    @GetMapping("/{id}")
    public String detail(@PathVariable("id") Integer id, Model model) {
        Optional<Annonce> annonce = annonceRepository.findById(id);
        if (annonce.isPresent()) {
            model.addAttribute("annonce", annonce.get());
            return "annonces/detail";
        }
        return "redirect:/admin/annonces";
    }
}
