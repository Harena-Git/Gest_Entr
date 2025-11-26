package com.example.gestion.controllers;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.gestion.models.Personnel;
import com.example.gestion.repository.PersonnelRepository;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/personnel")
public class PersonnelController {
    
    @Autowired
    private PersonnelRepository personnelRepository;

    @GetMapping("/list")
    public String getAllPersonnel(
            @RequestParam(value = "search", required = false) String search,
            @RequestParam(value = "statut", required = false) String statut,
            @RequestParam(value = "poste", required = false) String poste,
            @RequestParam(value = "tri", required = false, defaultValue = "date_desc") String tri,
            Model model) {
        
        try {
            List<Personnel> personnels = personnelRepository.findAll();
            
            // Appliquer les filtres
            if (search != null && !search.trim().isEmpty()) {
                String searchLower = search.toLowerCase().trim();
                personnels = personnels.stream()
                    .filter(p -> 
                        (p.getCandidat() != null && 
                         (p.getCandidat().getNom().toLowerCase().contains(searchLower) ||
                          p.getCandidat().getPrenom().toLowerCase().contains(searchLower))) ||
                        (p.getPoste() != null && 
                         p.getPoste().getLibelle().toLowerCase().contains(searchLower))
                    )
                    .collect(Collectors.toList());
            }
            
            if (statut != null && !statut.isEmpty()) {
                boolean isActif = "actif".equals(statut);
                personnels = personnels.stream()
                    .filter(p -> p.getActif() == isActif)
                    .collect(Collectors.toList());
            }
            
            if (poste != null && !poste.isEmpty()) {
                personnels = personnels.stream()
                    .filter(p -> p.getPoste() != null && poste.equals(p.getPoste().getLibelle()))
                    .collect(Collectors.toList());
            }
            
            // Appliquer le tri
            personnels = trierPersonnels(personnels, tri);
            
            model.addAttribute("personnels", personnels);
            return "personnelList";
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "Erreur lors de la récupération des personnels");
            return "personnelList";
        }
    }

    private List<Personnel> trierPersonnels(List<Personnel> personnels, String tri) {
        switch (tri) {
            case "date_asc":
                return personnels.stream()
                    .sorted((p1, p2) -> {
                        if (p1.getDate_embauche() == null) return 1;
                        if (p2.getDate_embauche() == null) return -1;
                        return p1.getDate_embauche().compareTo(p2.getDate_embauche());
                    })
                    .collect(Collectors.toList());
                    
            case "nom_asc":
                return personnels.stream()
                    .sorted((p1, p2) -> {
                        String nom1 = p1.getCandidat() != null ? p1.getCandidat().getNom() : "";
                        String nom2 = p2.getCandidat() != null ? p2.getCandidat().getNom() : "";
                        return nom1.compareToIgnoreCase(nom2);
                    })
                    .collect(Collectors.toList());
                    
            case "nom_desc":
                return personnels.stream()
                    .sorted((p1, p2) -> {
                        String nom1 = p1.getCandidat() != null ? p1.getCandidat().getNom() : "";
                        String nom2 = p2.getCandidat() != null ? p2.getCandidat().getNom() : "";
                        return nom2.compareToIgnoreCase(nom1);
                    })
                    .collect(Collectors.toList());
                    
            case "date_desc":
            default:
                return personnels.stream()
                    .sorted((p1, p2) -> {
                        if (p1.getDate_embauche() == null) return 1;
                        if (p2.getDate_embauche() == null) return -1;
                        return p2.getDate_embauche().compareTo(p1.getDate_embauche());
                    })
                    .collect(Collectors.toList());
        }
    }

    @GetMapping("/details")
    public String getPersonnel(@RequestParam("idPersonnel") Integer idPersonnel, Model model) {
        try {
            Personnel personnel = personnelRepository.findById(idPersonnel).orElse(null);
            if (personnel != null) {
                model.addAttribute("personnel", personnel);
            } else {
                model.addAttribute("error", "Personnel non trouvé avec l'ID : " + idPersonnel);
            }
            return "personnelDetails";
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "Erreur lors de la récupération du personnel");
            return "personnelDetails";
        }
    }
}