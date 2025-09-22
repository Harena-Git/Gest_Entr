package com.example.gestion.controllers;

import com.example.gestion.models.*;
import com.example.gestion.services.*;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
<<<<<<< Updated upstream

import java.time.LocalDate;
=======
import java.time.format.DateTimeFormatter;
import java.time.LocalDate;
import java.time.LocalDateTime;
>>>>>>> Stashed changes
import java.time.LocalTime;
import java.util.List;
import java.util.Optional;

@Controller
public class EvaluationEntretien1Controller {

    private final EvaluationEntretien1Service evaluationEntretien1Service;
    private final AppreciationService appreciationService;
    private final Entretien1Service entretien1Service;
    private final UserService userService;
    private final Entretien2Service entretien2Service;
    private final ProfilService profilService;
    private final AnnonceService annonceService;
<<<<<<< Updated upstream
=======
    private final HistoriqueEtatService historiqueEtatService;
    private final EtatCandidatService etatCandidatService;

>>>>>>> Stashed changes

    public EvaluationEntretien1Controller(
            EvaluationEntretien1Service evaluationEntretien1Service,
            AppreciationService appreciationService,
            Entretien1Service entretien1Service,
            UserService userService,
            Entretien2Service entretien2Service,
            ProfilService profilService,
<<<<<<< Updated upstream
            AnnonceService annonceService) {
=======
            AnnonceService annonceService,
            HistoriqueEtatService historiqueEtatService,
            EtatCandidatService etatCandidatService) {
>>>>>>> Stashed changes
        this.evaluationEntretien1Service = evaluationEntretien1Service;
        this.appreciationService = appreciationService;
        this.entretien1Service = entretien1Service;
        this.userService = userService;
        this.entretien2Service = entretien2Service;
        this.profilService = profilService;
        this.annonceService = annonceService;
<<<<<<< Updated upstream
=======
        this.historiqueEtatService = historiqueEtatService;
        this.etatCandidatService = etatCandidatService;
>>>>>>> Stashed changes
    }

    // Page pour choisir l’appréciation
    @GetMapping("/evaluation-entretien1")
    public String afficherEvaluation(@RequestParam("id_entretien") Integer idEntretien, @RequestParam("id_user") Integer idUser, Model model) {
        List<Appreciation> appreciations = appreciationService.findAll();
        model.addAttribute("appreciations", appreciations);
        model.addAttribute("idEntretien", idEntretien); 
        model.addAttribute("id_user", idUser); 
        return "evaluation-entretien1"; // JSP
    }

    // POST pour enregistrer l’évaluation
    @PostMapping("/eval")
    public String insertEvaluation(
            @RequestParam("id_appreciation") Integer idAppreciation,
            @RequestParam("id_entretien") Integer idEntretien,
            @RequestParam("id_user") Integer idUser,
            Model model) {

        Appreciation appreciation = appreciationService.findById(idAppreciation)
                .orElseThrow(() -> new RuntimeException("Appreciation non trouvée"));

        Entretien1 entretien1 = entretien1Service.findById(idEntretien)
                .orElseThrow(() -> new RuntimeException("Entretien non trouvé"));

        // Vérifier si une évaluation existe déjà
        Optional<EvaluationEntretien1> existingEval = evaluationEntretien1Service.findByEntretien(entretien1);
<<<<<<< Updated upstream
=======
        

>>>>>>> Stashed changes

        EvaluationEntretien1 eval1;
        if (existingEval.isPresent()) {
            eval1 = existingEval.get();
            eval1.setAppreciation(appreciation);
            eval1.setPresence(true);
        } else {
            eval1 = new EvaluationEntretien1();
            eval1.setEntretien1(entretien1);
            eval1.setAppreciation(appreciation);
            eval1.setPresence(true);
        }

        evaluationEntretien1Service.save(eval1);
<<<<<<< Updated upstream
=======
        HistoriqueEtat histo = new HistoriqueEtat();
        LocalDateTime today = LocalDateTime.now();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        String todayAsString = today.format(formatter);
        histo.setDate_changement(todayAsString);
        histo.setCandidat(eval1.getEntretien1().getCandidat());
        histo.setEtatCandidat(etatCandidatService.findById(4).get());
        historiqueEtatService.save(histo);
>>>>>>> Stashed changes

        // Si note >= 3, créer Entretien2
        if (appreciation.getNote() >= 3) {
            Entretien2 entretien2 = new Entretien2();

            User user = userService.findById(idUser)
                    .orElseThrow(() -> new RuntimeException("Utilisateur non trouvé"));

            entretien2.setUser(user);
            entretien2.setEntretien1(entretien1);

            // On peut mettre des valeurs par défaut pour date/heure, elles seront remplacées via formulaire
            entretien2.setDateEntretien(null);
            entretien2.setHeureEntretien(null);

            // Ajouter dans le modèle pour le formulaire suivant
            model.addAttribute("entretien2", entretien2);
            // Departement departement = annonceService.findByProfil(profilService.findByLieu(entretien1.getCandidat().getLieu())).get(0).getPoste().getDepartement();
            Departement departement = profilService.getDepartementDuCandidat(entretien1.getCandidat());
            List<User> usersDept = userService.findByDepartement(departement);
            model.addAttribute("usersDept", usersDept);

            return "date-entretien2"; // Page pour saisir date et heure
        } else {
<<<<<<< Updated upstream
=======
            histo.setDate_changement(LocalDateTime.now().format(formatter));
            histo.setEtatCandidat(etatCandidatService.findById(7).get());
            historiqueEtatService.save(histo);
>>>>>>> Stashed changes
            return "redirect:/mes-entretiens"; // Sinon retour à la liste
        }
    }

    // GET pour enregistrer date et heure de Entretien2
    @GetMapping("/date-entretien")
    public String saveEntretien2(
            @RequestParam("id_entretien") Integer idEntretien,
            @RequestParam("id_user") Integer idUser,
            @RequestParam("date_entretien") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dateEntretien,
            @RequestParam("heure_entretien") @DateTimeFormat(iso = DateTimeFormat.ISO.TIME) LocalTime heureEntretien) {

        Entretien1 entretien1 = entretien1Service.findById(idEntretien)
                .orElseThrow(() -> new RuntimeException("Entretien non trouvé"));

        User user = userService.findById(idUser)
                .orElseThrow(() -> new RuntimeException("Utilisateur non trouvé"));

        Entretien2 entretien2 = new Entretien2();
        entretien2.setEntretien1(entretien1);
        entretien2.setUser(user);
        entretien2.setDateEntretien(dateEntretien);
        entretien2.setHeureEntretien(heureEntretien);

        entretien2Service.save(entretien2);
<<<<<<< Updated upstream
=======
        HistoriqueEtat histo = new HistoriqueEtat();
        LocalDateTime today = LocalDateTime.now();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        String todayAsString = today.format(formatter);
        histo.setDate_changement(todayAsString);
        histo.setCandidat(entretien1.getCandidat());
        histo.setEtatCandidat(etatCandidatService.findById(3).get());
        historiqueEtatService.save(histo);
>>>>>>> Stashed changes

        return "redirect:/mes-entretiens";
    }
}
