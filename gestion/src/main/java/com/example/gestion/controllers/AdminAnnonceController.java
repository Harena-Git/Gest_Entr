// ...existing code...
package com.example.gestion.controllers;

import com.example.gestion.models.Niveau;
import com.example.gestion.models.Diplome;
import com.example.gestion.models.Filiere; // Ajout de l'import pour Filiere

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
import com.example.gestion.models.Lieu;
import com.example.gestion.models.Poste;
import com.example.gestion.models.Profil;
import com.example.gestion.repository.AnnonceRepository;
import com.example.gestion.repository.DiplomeRepository;
import com.example.gestion.repository.FiliereRepository; // Ajout du repository Filiere
import com.example.gestion.repository.LieuRepository;
import com.example.gestion.repository.NiveauRepository;
import com.example.gestion.repository.PosteRepository;
import com.example.gestion.repository.ProfilRepository;

@Controller
@RequestMapping("/admin/annonces")
public class AdminAnnonceController {
    @Autowired
    private com.example.gestion.repository.DepartementRepository departementRepository;
    // Étape 1 : Choix du département
    @GetMapping("/choose-department")
    public String showChooseDepartmentForm(Model model) {
        model.addAttribute("departements", departementRepository.findAll());
        return "annonces/choose_department";
    }

    @PostMapping("/choose-department")
    public String processDepartmentChoice(@RequestParam("departementId") Integer departementId) {
        return "redirect:/admin/annonces/new?departementId=" + departementId;
    }

    // Étape 2 : Formulaire d'annonce filtré par département
    @GetMapping("/new")
    public String showCreateForm(@RequestParam("departementId") Integer departementId, Model model) {
        model.addAttribute("annonce", new Annonce());
        model.addAttribute("postes", posteRepository.findAll().stream().filter(p -> p.getDepartement() != null && p.getDepartement().getId_departement().equals(departementId)).toList());
        model.addAttribute("lieux", lieuRepository.findAll());
        model.addAttribute("niveaux", niveauRepository.findAll());
        model.addAttribute("filieres", filiereRepository.findAll());
        model.addAttribute("departementId", departementId);
        return "annonces/form";
    }
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
    @Autowired
    private FiliereRepository filiereRepository;
    
    @GetMapping
    public String list(Model model) {
        model.addAttribute("annonces", annonceRepository.findAll());
        return "annonces/admin_list";
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
            @RequestParam("filiereId") Integer filiereId,
            @RequestParam("date_fin") String dateFinStr,
            @RequestParam("departementId") Integer departementId,
            Model model
    ) {
        try {
            Poste poste = posteRepository.findById(posteId).orElse(null);
            Lieu lieu = lieuRepository.findById(lieuId).orElse(null);
            Niveau niveau = niveauRepository.findById(niveauId).orElse(null);

            Filiere filiere = filiereRepository.findById(filiereId).orElse(null);
            if (filiere == null) {
                model.addAttribute("error", "La filière est obligatoire.");
                model.addAttribute("postes", posteRepository.findAll().stream().filter(p -> p.getDepartement() != null && p.getDepartement().getId_departement().equals(departementId)).toList());
                model.addAttribute("lieux", lieuRepository.findAll());
                model.addAttribute("niveaux", niveauRepository.findAll());
                model.addAttribute("filieres", filiereRepository.findAll());
                model.addAttribute("departementId", departementId);
                return "annonces/form";
            }

            Diplome diplome = new Diplome();
            diplome.setNiveau(niveau);
            diplome.setFiliere(filiere);
            diplome = diplomeRepository.save(diplome);

            Profil profil = new Profil();
            profil.setGenre(genre);
            profil.setAge(age);
            profil.setAnnee_experience(Integer.parseInt(annee_experience));
            profil.setLieu(lieu);
            profil.setDiplome(diplome);
            profil = profilRepository.save(profil);

            Annonce annonce = new Annonce();
            annonce.setResponsabilite(responsabilite);
            annonce.setPoste(poste);
            annonce.setProfil(profil);
            annonce.setDate_annonce(new java.util.Date());
            annonce.setDate_fin(java.sql.Date.valueOf(dateFinStr));

            annonceRepository.save(annonce);
            return "redirect:/admin/annonces";
        } catch (Exception e) {
            model.addAttribute("error", "Erreur lors de la création: " + e.getMessage());
            model.addAttribute("postes", posteRepository.findAll().stream().filter(p -> p.getDepartement() != null && p.getDepartement().getId_departement().equals(departementId)).toList());
            model.addAttribute("lieux", lieuRepository.findAll());
            model.addAttribute("niveaux", niveauRepository.findAll());
            model.addAttribute("filieres", filiereRepository.findAll());
            model.addAttribute("departementId", departementId);
            return "annonces/form";
        }
    }

    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable("id") Integer id, Model model) {
        Optional<Annonce> annonce = annonceRepository.findById(id);
        if (annonce.isPresent()) {
            model.addAttribute("annonce", annonce.get());
            model.addAttribute("postes", posteRepository.findAll());
            model.addAttribute("lieux", lieuRepository.findAll());
            model.addAttribute("niveaux", niveauRepository.findAll());
            model.addAttribute("filieres", filiereRepository.findAll());
            return "annonces/form";
        }
        return "redirect:/admin/annonces";
    }

    @PostMapping("/update/{id}")
    public String update(@PathVariable("id") Integer id, @ModelAttribute Annonce annonce, Model model) {
        try {
            annonce.setId_annonce(id);
            annonceRepository.save(annonce);
            return "redirect:/admin/annonces";
        } catch (Exception e) {
            model.addAttribute("error", "Erreur lors de la mise à jour: " + e.getMessage());
            model.addAttribute("postes", posteRepository.findAll());
            model.addAttribute("lieux", lieuRepository.findAll());
            model.addAttribute("niveaux", niveauRepository.findAll());
            model.addAttribute("filieres", filiereRepository.findAll());
            return "annonces/form";
        }
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