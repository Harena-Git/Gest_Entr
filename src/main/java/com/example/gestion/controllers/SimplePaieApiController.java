package com.example.gestion.controllers;

import com.example.gestion.services.PaieIntegrationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api")
public class SimplePaieApiController {
    
    @Autowired
    private PaieIntegrationService paieService;
    
    /**
     * Toutes les données de paie
     * GET /api/paie?mois=12&annee=2025
     */
    @GetMapping("/paie")
    public Map<String, Object> getPaieAll(
            @RequestParam int mois,
            @RequestParam int annee) {
        return paieService.getDonneesPaieGlobaleJSON(mois, annee);
    }
    
    /**
     * Par personnel : GET /api/paie?personnel=49&mois=12&annee=2025
     */
    @GetMapping(value = "/paie", params = "personnel")
    public Map<String, Object> getPaiePersonnel(
            @RequestParam int personnel,
            @RequestParam int mois,
            @RequestParam int annee) {
        return paieService.getDonneesPaieJSON(personnel, mois, annee);
    }
    
    /**
     * Par département : GET /api/paie?departement=1&mois=12&annee=2025
     */
    @GetMapping(value = "/paie", params = "departement")
    public Map<String, Object> getPaieDepartement(
            @RequestParam int departement,
            @RequestParam int mois,
            @RequestParam int annee) {
        return paieService.getDonneesPaieDepartementJSON(departement, mois, annee);
    }
}