package com.example.gestion.controllers;

import com.example.gestion.models.Personnel;
import com.example.gestion.repository.PersonnelRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
public class PersonnelController {
    
    @Autowired
    private PersonnelRepository personnelRepository;

    @GetMapping("/personnelAll")
    public String getAllPersonnel(Model model) {
        List<Personnel> personnels = personnelRepository.findAll();
        model.addAttribute("personnels", personnels);
        return "#";
    }

    @GetMapping("/personnel")
    public String getPersonnel(@RequestParam("idPersonnel") Integer idPersonnel, Model model) {
        try {
            Personnel personnel = personnelRepository.findById(idPersonnel).orElse(null);
            if (personnel != null) {
                model.addAttribute("personnel", personnel);
            } else {
                model.addAttribute("error", "Personnel non trouvé avec l'ID : " + idPersonnel);
            }
            return "Personnel";
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "Personnel";
    }

}