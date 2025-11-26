package com.example.gestion.controllers;

import java.util.List;

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
    public String getAllPersonnel(Model model) {
        try {
            List<Personnel> personnels = personnelRepository.findAll();
            model.addAttribute("personnels", personnels);
            return "personnelList"; // Retourne la vue correcte
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "Erreur lors de la récupération des personnels");
            return "personnelList";
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
            return "personnelDetails"; // Renommé pour plus de clarté
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "Erreur lors de la récupération du personnel");
            return "personnelDetails";
        }
    }
}