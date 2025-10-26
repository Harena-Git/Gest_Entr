package com.example.gestion.controllers;

import com.example.gestion.models.*;
import com.example.gestion.services.*;
import org.springframework.web.bind.annotation.*;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import java.util.Optional;

@RestController
@RequestMapping("/contrat")
public class ContratEssaiController {

    private final ContratEssaiService contratService;
    private final CandidatService candidatService;
    private final ProfilService profilService;

    public ContratEssaiController(ContratEssaiService contratService, CandidatService candidatService, ProfilService profilService) {
        this.contratService = contratService;
        this.candidatService = candidatService;
        this.profilService = profilService;
    }

    @GetMapping("/generer")
    public String genererContratPdf(@RequestParam("id_candidat") Integer idCandidat,
                                   HttpServletResponse response,
                                   RedirectAttributes redirectAttributes) throws IOException {
        // 1️⃣ Récupérer les infos depuis la base (exemple)
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

        infos.setPoste( profilService.getPosteDuCandidat(candidat).getLibelle() );
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

        // 2️⃣ Préparer la réponse HTTP
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=contrat_essai.pdf");

        try {
            // 3️⃣ Générer le PDF directement dans le flux de sortie HTTP
            ContratEssaiGenerator.genererContrat(infos, response.getOutputStream());
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Erreur lors de la génération du PDF");
        }
        redirectAttributes.addFlashAttribute("message", "Le contrat d'essai a été créé avec succès.");
        return "redirect:/Embauche";
    }
}
