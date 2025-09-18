package com.example.gestion.controllers;

import com.example.gestion.models.Annonce;
import com.example.gestion.models.Profil;
import com.example.gestion.repository.AnnonceRepository;
import com.example.gestion.repository.ProfilRepository;
import com.example.gestion.repository.PosteRepository;
import com.example.gestion.repository.DepartementRepository;
import com.example.gestion.repository.LieuRepository;
import com.example.gestion.repository.NiveauRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/admin/annonces")
public class AdminAnnonceController {

    @Autowired
    private AnnonceRepository annonceRepository;
    @Autowired
    private ProfilRepository profilRepository;
    @Autowired
    private PosteRepository posteRepository;
    @Autowired
    private DepartementRepository departementRepository;
    @Autowired
    private LieuRepository lieuRepository;
    @Autowired
    private NiveauRepository niveauRepository;

    @GetMapping
    public String listAnnonces(Model model) {
        model.addAttribute("annonces", annonceRepository.findAll());
        return "admin/annonces";
    }

    @GetMapping("/new")
    public String showAddForm(Model model) {
        model.addAttribute("annonce", new Annonce());
        model.addAttribute("profils", profilRepository.findAll());
        model.addAttribute("postes", posteRepository.findAll());
        model.addAttribute("lieux", lieuRepository.findAll());
        model.addAttribute("niveaux", niveauRepository.findAll());
        model.addAttribute("departements", departementRepository.findAll());
        return "admin/annonce-form";
    }

    @PostMapping
    public String saveAnnonce(
        @ModelAttribute Annonce annonce,
        @RequestParam("libelle_poste") String libellePoste,
        @RequestParam("salaire_poste") Integer salairePoste,
        @RequestParam("id_departement") Integer idDepartement,
        @RequestParam("genre") String genre,
        @RequestParam("age") Integer age,
        @RequestParam("annee_experience") String anneeExperience,
        @RequestParam("id_lieu") Integer idLieu,
        @RequestParam("id_niveau") Integer idNiveau
    ) {
        // Créer le poste avec le département sélectionné
        var departement = departementRepository.findById(idDepartement).orElse(null);
        var poste = new com.example.gestion.models.Poste();
        poste.setLibelle(libellePoste);
        poste.setSalaire(salairePoste);
        poste.setDepartement(departement);
        posteRepository.save(poste);
        annonce.setPoste(poste);

        // Créer ou mettre à jour le profil lié à l'annonce
        Profil profil = annonce.getProfil() != null ? annonce.getProfil() : new Profil();
        profil.setGenre(genre);
        profil.setAge(age);
        profil.setAnnee_experience(anneeExperience);
        profil.setLieu(lieuRepository.findById(idLieu).orElse(null));
        // Associer le niveau au diplôme du profil si besoin
        // profil.getDiplome().setNiveau(niveauRepository.findById(idNiveau).orElse(null));
        profilRepository.save(profil);
        annonce.setProfil(profil);

        annonceRepository.save(annonce);
        return "redirect:/admin/annonces";
    }

    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable("id") Integer id, Model model) {
        Annonce annonce = annonceRepository.findById(id).orElseThrow();
        model.addAttribute("annonce", annonce);
        model.addAttribute("profils", profilRepository.findAll());
        model.addAttribute("postes", posteRepository.findAll());
        model.addAttribute("lieux", lieuRepository.findAll());
        model.addAttribute("niveaux", niveauRepository.findAll());
        return "admin/annonce-form";
    }

    @PostMapping("/delete/{id}")
    public String deleteAnnonce(@PathVariable("id") Integer id) {
        annonceRepository.deleteById(id);
        return "redirect:/admin/annonces";
    }
}