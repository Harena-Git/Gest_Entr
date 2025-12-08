package com.example.gestion.controllers;

import com.example.gestion.models.*;
import com.example.gestion.services.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Controller
@RequestMapping("/contrat")
public class ContratEssaiController {

    private final ContratEssaiService contratService;
    private final CandidatService candidatService;
    private final ProfilService profilService;

    @Autowired
    public ContratEssaiController(ContratEssaiService contratService, 
                                CandidatService candidatService, 
                                ProfilService profilService) {
        this.contratService = contratService;
        this.candidatService = candidatService;
        this.profilService = profilService;
    }

    // === GESTION DES CONTRATS ===

    @GetMapping("/list")
    public String listContrats(Model model) {
        List<ContratEssai> contrats = contratService.findAll();
        
        // Créer des maps pour stocker les statuts sans modifier les modèles
        Map<Integer, Boolean> contratExpireMap = new HashMap<>();
        Map<Integer, Boolean> contratBientotExpireMap = new HashMap<>();
        Map<Integer, Long> joursRestantsMap = new HashMap<>();
        
        for (ContratEssai contrat : contrats) {
            boolean isExpire = isContratExpire(contrat);
            boolean isBientotExpire = isContratBientotExpire(contrat);
            long joursRestants = calculerJoursRestants(contrat);
            
            contratExpireMap.put(contrat.getId_contrat_essai(), isExpire);
            contratBientotExpireMap.put(contrat.getId_contrat_essai(), isBientotExpire);
            joursRestantsMap.put(contrat.getId_contrat_essai(), joursRestants);
        }
        
        model.addAttribute("contrats", contrats);
        model.addAttribute("contratExpireMap", contratExpireMap);
        model.addAttribute("contratBientotExpireMap", contratBientotExpireMap);
        model.addAttribute("joursRestantsMap", joursRestantsMap);
        
        return "contratList";
    }

    @GetMapping("/add")
    public String showAddForm(Model model) {
        model.addAttribute("contrat", new ContratEssai());
        model.addAttribute("candidats", candidatService.findAll());
        return "contratForm";
    }

    @PostMapping("/save")
    public String saveContrat(@ModelAttribute ContratEssai contrat, 
                            @RequestParam("candidatId") Integer candidatId,
                            RedirectAttributes redirectAttributes) {
        try {
            Optional<Candidat> candidat = candidatService.findById(candidatId);
            if (candidat.isPresent()) {
                contrat.setCandidat(candidat.get());
                contratService.save(contrat);
                redirectAttributes.addFlashAttribute("success", "Contrat sauvegardé avec succès");
            } else {
                redirectAttributes.addFlashAttribute("error", "Candidat non trouvé");
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur lors de la sauvegarde du contrat");
        }
        return "redirect:/contrat/list";
    }

    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable("id") Integer id, Model model) {
        Optional<ContratEssai> contrat = contratService.findById(id);
        if (contrat.isPresent()) {
            model.addAttribute("contrat", contrat.get());
            model.addAttribute("candidats", candidatService.findAll());
            return "contratForm";
        }
        return "redirect:/contrat/list";
    }

    @GetMapping("/delete/{id}")
    public String deleteContrat(@PathVariable("id") Integer id, RedirectAttributes redirectAttributes) {
        try {
            contratService.deleteById(id);
            redirectAttributes.addFlashAttribute("success", "Contrat supprimé avec succès");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur lors de la suppression du contrat");
        }
        return "redirect:/contrat/list";
    }

    @GetMapping("/renew/{id}")
    public String showRenewForm(@PathVariable("id") Integer id, Model model) {
        Optional<ContratEssai> contrat = contratService.findById(id);
        if (contrat.isPresent()) {
            model.addAttribute("contrat", contrat.get());
            return "contratRenew";
        }
        return "redirect:/contrat/list";
    }

    @PostMapping("/renew")
    public String renewContrat(@RequestParam("id") Integer id,
                             @RequestParam("nouvelleDateFin") String nouvelleDateFin,
                             RedirectAttributes redirectAttributes) {
        try {
            Optional<ContratEssai> contratOpt = contratService.findById(id);
            if (contratOpt.isPresent()) {
                ContratEssai contrat = contratOpt.get();
                // Logique de renouvellement - à adapter selon votre format de date
                // contrat.setDate_fin(...);
                contratService.save(contrat);
                redirectAttributes.addFlashAttribute("success", "Contrat renouvelé avec succès");
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur lors du renouvellement du contrat");
        }
        return "redirect:/contrat/list";
    }

    // === GÉNÉRATION PDF (conservée) ===

    @GetMapping("/generer")
    public String genererContratPdf(@RequestParam("id_candidat") Integer idCandidat,
                                   HttpServletResponse response,
                                   RedirectAttributes redirectAttributes) throws IOException {
        try {
            Candidat candidat = candidatService.findById(idCandidat)
                    .orElseThrow(() -> new RuntimeException("Candidat non trouvé"));

            ContratEssai contrat = contratService.findByCandidat(candidat)
                    .orElseThrow(() -> new RuntimeException("Contrat d'essai non trouvé pour ce candidat"));

            InfosContrat infos = new InfosContrat();
            infos.setNomSociete("TechInnovation SARL");
            infos.setAdresseSociete("123 Avenue de la République, 75011 Paris");
            infos.setSiret("123 456 789 00012");
            infos.setRepresentant("Monsieur Jean Dupont, Directeur Général");

            infos.setNomEmploye(candidat.getNom() + " " + candidat.getPrenom());
            infos.setDateNaissance("18 juillet 1999");
            infos.setAdresseEmploye(candidat.getAdresse());
            infos.setNumSecu("Non renseigné");

            infos.setPoste(profilService.getPosteDuCandidat(candidat).getLibelle());
            long diffMillis = contrat.getDate_fin().getTime() - contrat.getDate_debut().getTime();
            long diffDays = diffMillis / (1000 * 60 * 60 * 24);
            long diffMonths = diffDays / 30;
            infos.setDureeContrat(String.valueOf(diffMonths));
            infos.setDateDebut(contrat.getDate_debut().toString());
            infos.setDateFin(contrat.getDate_fin().toString());
            infos.setDureeEssai("2");
            infos.setSalaireBrut(String.valueOf(profilService.getPosteDuCandidat(candidat).getSalaire()));
            infos.setHeuresHebdo("40");
            infos.setLieuSignature(candidat.getLieu().getLieu());

            // Préparer la réponse HTTP
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "attachment; filename=contrat_essai_" + candidat.getNom() + ".pdf");

            // Générer le PDF
            ContratEssaiGenerator.genererContrat(infos, response.getOutputStream());
            
            return null; // Ne pas rediriger car le PDF est streamé

        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("error", "Erreur lors de la génération du PDF: " + e.getMessage());
            return "redirect:/contrat/list";
        }
    }

    // === MÉTHODES UTILITAIRES ===

    private boolean isContratExpire(ContratEssai contrat) {
        if (contrat.getDate_fin() == null) return false;
        return contrat.getDate_fin().before(new Date());
    }

    private boolean isContratBientotExpire(ContratEssai contrat) {
        if (contrat.getDate_fin() == null) return false;
        
        Date maintenant = new Date();
        Date dateAlerte = new Date(maintenant.getTime() + (15 * 24 * 60 * 60 * 1000L)); // 15 jours
        
        return contrat.getDate_fin().after(maintenant) && contrat.getDate_fin().before(dateAlerte);
    }

    private long calculerJoursRestants(ContratEssai contrat) {
        if (contrat.getDate_fin() == null) return 0;
        
        Date maintenant = new Date();
        long diff = contrat.getDate_fin().getTime() - maintenant.getTime();
        return diff / (1000 * 60 * 60 * 24);
    }
}