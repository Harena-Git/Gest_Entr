package com.example.gestion.controllers;

import com.example.gestion.models.*;
import com.example.gestion.services.*;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import java.time.format.DateTimeFormatter;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;
import java.util.Optional;

@Controller
public class EvaluationEntretien2Controller {

    private final EvaluationEntretien2Service evaluationEntretien2Service;
    private final AppreciationService appreciationService;
    private final Entretien2Service entretien2Service;
    private final UserService userService;
    private final HistoriqueEtatService historiqueEtatService;
    private final EtatCandidatService etatCandidatService;


    public EvaluationEntretien2Controller(
            EvaluationEntretien2Service evaluationEntretien2Service,
            AppreciationService appreciationService,
            UserService userService,
            Entretien2Service entretien2Service,
            HistoriqueEtatService historiqueEtatService,
            EtatCandidatService etatCandidatService) {
        this.evaluationEntretien2Service = evaluationEntretien2Service;
        this.appreciationService = appreciationService;
        this.userService = userService;
        this.entretien2Service = entretien2Service;
        this.historiqueEtatService = historiqueEtatService;
        this.etatCandidatService = etatCandidatService;
    }

    // Page pour choisir l’appréciation
    @GetMapping("/evaluation-entretien2")
    public String afficherEvaluation(@RequestParam("id_entretien") Integer idEntretien, @RequestParam("id_user") Integer idUser, Model model) {
        List<Appreciation> appreciations = appreciationService.findAll();
        model.addAttribute("appreciations", appreciations);
        model.addAttribute("idEntretien", idEntretien); 
        model.addAttribute("id_user", idUser); 
        return "evaluation-entretien2"; // JSP
    }

    // POST pour enregistrer l’évaluation
    @PostMapping("/eval2")
    public String insertEvaluation(
            @RequestParam("id_appreciation") Integer idAppreciation,
            @RequestParam("id_entretien") Integer idEntretien,
            @RequestParam("id_user") Integer idUser,
            Model model) {

        Appreciation appreciation = appreciationService.findById(idAppreciation)
                .orElseThrow(() -> new RuntimeException("Appreciation non trouvée"));

        Entretien2 entretien2 = entretien2Service.findById(idEntretien)
                .orElseThrow(() -> new RuntimeException("Entretien non trouvé"));

        // Vérifier si une évaluation existe déjà
        Optional<EvaluationEntretien2> existingEval = evaluationEntretien2Service.findByEntretien(entretien2);

        EvaluationEntretien2 eval2;
        if (existingEval.isPresent()) {
            eval2 = existingEval.get();
            eval2.setAppreciation(appreciation);
            eval2.setPresence(true);
        } else {
            eval2 = new EvaluationEntretien2();
            eval2.setEntretien2(entretien2);
            eval2.setAppreciation(appreciation);
            eval2.setPresence(true);
        }

        evaluationEntretien2Service.save(eval2);
        HistoriqueEtat histo = new HistoriqueEtat();
        LocalDateTime today = LocalDateTime.now();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        String todayAsString = today.format(formatter);
        histo.setDate_changement(todayAsString);
        histo.setCandidat(eval2.getEntretien2().getEntretien1().getCandidat());
        histo.setEtatCandidat(etatCandidatService.findById(4).get());
        historiqueEtatService.save(histo);

        List<EvaluationEntretien2> evalent2 = evaluationEntretien2Service.findAll();

        for (EvaluationEntretien2 eval : evalent2) {
            histo.setDate_changement(LocalDateTime.now().format(formatter));
            if (eval.getAppreciation().getNote() > 2) {
                histo.setEtatCandidat(etatCandidatService.findById(5).get());
            } else {
                histo.setEtatCandidat(etatCandidatService.findById(7).get());
            }

            historiqueEtatService.save(histo);
        }
            return "redirect:/mes-entretiens"; // Sinon retour à la liste
    }
}
