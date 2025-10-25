package com.example.gestion.controllers;

import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.gestion.models.Annonce;
import com.example.gestion.models.Departement;
import com.example.gestion.models.Lieu;
import com.example.gestion.repository.AnnonceRepository;
import com.example.gestion.repository.LieuRepository;
import com.example.gestion.repository.DepartementRepository;

@Controller
public class AnnonceController {

    @Autowired
    private AnnonceRepository annonceRepository;

    @Autowired
    private LieuRepository lieuRepository;

    @Autowired
    private DepartementRepository departementRepository;

   @GetMapping("/acceuil")
    public String getAllAnnonces(@RequestParam(value = "lieu", required = false) Integer idLieu,
                                @RequestParam(value = "departement", required = false) Integer idDepartement,
                                @RequestParam(value = "experience", required = false) String experience,
                                @RequestParam(value = "salaireMax", required = false) Integer salaireMax,
                                @RequestParam(value = "motCle", required = false) String motCle,
                                Model model) {
        LocalDate today = LocalDate.now();

       
        // Liste des départements pour le filtre
        List<Departement> departements = departementRepository.findAll();

        // Récupération de toutes les annonces initialement
        List<Annonce> annonces = annonceRepository.findAll();

        // Filtrer les annonces par date
       /*   annonces = annonces.stream()
                .filter(annonce -> {
                    LocalDate dateFin = annonce.getDate_fin().toInstant()
                            .atZone(java.time.ZoneId.systemDefault())
                            .toLocalDate();
                    return !dateFin.isBefore(today);
                })
                .collect(Collectors.toList()); */

        // Si un lieu est sélectionné, filtrer par lieu
        if (idLieu != null) {
            annonces = annonces.stream()
                    .filter(annonce -> annonce.getProfil().getLieu() != null
                            && annonce.getProfil().getLieu().getId_lieu().equals(idLieu))
                    .collect(Collectors.toList());
        }
        if (idDepartement != null) {
            annonces = annonces.stream()
                    .filter(annonce -> annonce.getPoste() != null
                            && annonce.getPoste().getDepartement() != null
                            && annonce.getPoste().getDepartement().getId_departement().equals(idDepartement))
                    .collect(Collectors.toList());
        }
        if (experience != null && !experience.isEmpty()) {
            annonces = annonces.stream()
                    .filter(a -> {
                        int anneeExp = a.getProfil().getAnnee_experience(); // Assure-toi que Profil a un champ experience en années
                        switch (experience) {
                            case "0-0": return anneeExp == 0;
                            case "1-2": return anneeExp >= 1 && anneeExp <= 2;
                            case "3-5": return anneeExp >= 3 && anneeExp <= 5;
                            case "5+":  return anneeExp > 5;
                        }
                        return true;
                    })
                    .collect(Collectors.toList());
        }
        
        if (salaireMax != null) {
            annonces = annonces.stream()
                    .filter(a -> a.getPoste() != null
                            && a.getPoste().getSalaire() != null
                            && a.getPoste().getSalaire() <= salaireMax)
                    .collect(Collectors.toList());
        }

        // Filtrer par mot-clé sur le champ responsabilite
        if (motCle != null && !motCle.isEmpty()) {
            String motCleLower = motCle.toLowerCase();
            annonces = annonces.stream()
                    .filter(a -> a.getResponsabilite() != null &&
                            a.getResponsabilite().toLowerCase().contains(motCleLower))
                    .collect(Collectors.toList());
        }

        // Construire la liste unique des lieux pour le filtre
        List<Lieu> lieux = annonces.stream() // <-- utiliser la liste filtrée par date (optionnel)
                .map(a -> a.getProfil().getLieu())
                .filter(l -> l != null)
                .distinct()
                .collect(Collectors.toList());

        model.addAttribute("annonces", annonces);
        model.addAttribute("lieux", lieux);
        model.addAttribute("lieuSelectionne", idLieu);
        model.addAttribute("departementSelectionne", idDepartement);
        model.addAttribute("departements", departements);
        model.addAttribute("experienceSelectionnee", experience);
        model.addAttribute("salaireMax", salaireMax);
        model.addAttribute("motCle", motCle);

        return "Acceuil";
    }


}
/*package com.example.gestion.controllers;
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
*/