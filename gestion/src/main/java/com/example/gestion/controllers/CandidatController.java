package com.example.gestion.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import com.example.gestion.models.*;
import com.example.gestion.repository.*;
import com.example.gestion.service.CandidatService;


import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Date;

@Controller
@RequestMapping("/candidat")
public class CandidatController {

    @Autowired
    private CandidatRepository candidatRepository;

    @Autowired
    private LieuRepository lieuRepository;

    @Autowired
    private AnnonceRepository annonceRepository;

    @Autowired
    private NiveauRepository niveauRepository;

    @Autowired
    private FiliereRepository filiereRepository;

    @Autowired
    private DiplomeRepository diplomeRepository;

    @Autowired
    private DiplomeCandidatRepository diplomeCandidatRepository;

    @Autowired
    private EtatCandidatRepository etatCandidatRepository;

    @Autowired
    private HistoriqueEtatRepository historiqueEtatRepository;

    @Autowired
    private ParcoursProfessionelRepository parcoursProfessionelRepository;

    @Autowired
    private CandidatService candidatService;
    
    @GetMapping("/form")
    public String showForm(@RequestParam(name = "idAnnonce", required = false) Integer idAnnonce,
                        Model model) {
        model.addAttribute("candidat", new Candidat());

        // Lieux
        List<Lieu> lieux = lieuRepository.findAll();
        model.addAttribute("lieux", lieux);

        model.addAttribute("idAnnonce", idAnnonce);

        // Poste lié à l'annonce
        if (idAnnonce != null) {
            String posteNom = annonceRepository.findPosteByIdAnnonce(idAnnonce);
            model.addAttribute("posteNom", posteNom);
        }

        // Ajouter niveaux et filières
        model.addAttribute("niveaux", niveauRepository.findAll());
        model.addAttribute("filieres", filiereRepository.findAll());

        return "candidat-form";
    }


    @PostMapping("/save")
public String saveCandidat(@RequestParam("idAnnonce") Integer idAnnonce,
                           @ModelAttribute Candidat candidat,
                           @RequestParam("file") MultipartFile file,
                           @RequestParam Map<String, String> requestParams,
                           Model model) {

    Annonce annonce = annonceRepository.findById(idAnnonce)
            .orElseThrow(() -> new RuntimeException("Annonce non trouvée"));
    Profil profil = annonce.getProfil();

    List<DiplomeCandidat> diplomesPrepares = new ArrayList<>();
    if (requestParams.containsKey("diplomesCount")) {
        int nbDiplomes = Integer.parseInt(requestParams.get("diplomesCount"));
        for (int i = 0; i < nbDiplomes; i++) {
            Integer idNiveau = Integer.valueOf(requestParams.get("diplomes[" + i + "].idNiveau"));
            Integer idFiliere = Integer.valueOf(requestParams.get("diplomes[" + i + "].idFiliere"));
            String etab = requestParams.get("diplomes[" + i + "].etablissement");
            Integer annee = Integer.valueOf(requestParams.get("diplomes[" + i + "].annee_obtention"));

            Niveau niveau = niveauRepository.findById(idNiveau)
                    .orElseThrow(() -> new RuntimeException("Niveau introuvable"));
            Filiere filiere = filiereRepository.findById(idFiliere)
                    .orElseThrow(() -> new RuntimeException("Filiere introuvable"));

            Diplome diplome = diplomeRepository.findByNiveauAndFiliere(niveau, filiere)
                    .orElseGet(() -> {
                        Diplome newDiplome = new Diplome();
                        newDiplome.setNiveau(niveau);
                        newDiplome.setFiliere(filiere);
                        return diplomeRepository.save(newDiplome);
                    });

            DiplomeCandidat dc = new DiplomeCandidat();
            dc.setDiplome(diplome);
            dc.setCandidat(candidat);
            dc.setEtablissement(etab);
            dc.setAnnee_obtention(annee);

            diplomesPrepares.add(dc);
        }
    }

    // Vérification avant enregistrement
    String verification = candidatService.verifierEtEnregistrer(candidat, profil, diplomesPrepares);
    if (!"OK".equals(verification)) {
        model.addAttribute("erreur", verification);
        return "candidat-error";
    }

    try {
        // Photo
        if (!file.isEmpty()) {
            String photoName = file.getOriginalFilename();
            candidat.setPhoto(photoName);
            // TODO: sauvegarder le fichier physiquement
        }

        candidat.setDate_candidature(new Date());

        EtatCandidat etatAttente = etatCandidatRepository.findById(1)
                .orElseThrow(() -> new RuntimeException("Etat 'En attente' introuvable"));
        candidat.setEtatCandidat(etatAttente);

        // --- Sauvegarde du candidat ---
        Candidat savedCandidat = candidatRepository.save(candidat);
        if (savedCandidat == null || savedCandidat.getId_candidat() == null) {
            model.addAttribute("erreur", "Erreur lors de la sauvegarde du candidat");
            return "candidat-error";
        }

        // --- Historique ---
        HistoriqueEtat historique = new HistoriqueEtat();
        historique.setCandidat(savedCandidat);
        historique.setEtatCandidat(etatAttente);
        historique.setDate_changement(java.time.LocalDate.now().toString());
        historiqueEtatRepository.save(historique);

        // --- Diplômes ---
        for (DiplomeCandidat dc : diplomesPrepares) {
            dc.setCandidat(savedCandidat);
            DiplomeCandidat savedDc = diplomeCandidatRepository.save(dc);
            if (savedDc == null || savedDc.getId_diplome_candidat() == null) {
                model.addAttribute("erreur", "Erreur lors de la sauvegarde d'un diplôme");
                return "candidat-error";
            }
        }

        // --- Parcours professionnel ---
        if (requestParams.containsKey("parcoursCount")) {
            int nbParcours = Integer.parseInt(requestParams.get("parcoursCount"));
            for (int i = 0; i < nbParcours; i++) {
                String entreprise = requestParams.get("parcours[" + i + "].entreprise");
                String poste = requestParams.get("parcours[" + i + "].poste");
                Date dateDebut = java.sql.Date.valueOf(requestParams.get("parcours[" + i + "].dateDebut"));
                Date dateFin = java.sql.Date.valueOf(requestParams.get("parcours[" + i + "].dateFin"));

                ParcoursProfessionel parcours = new ParcoursProfessionel();
                parcours.setEntreprise(entreprise);
                parcours.setPoste(poste);
                parcours.setDateDebut(dateDebut);
                parcours.setDateFin(dateFin);
                parcours.setCandidat(savedCandidat);

                ParcoursProfessionel savedParcours = parcoursProfessionelRepository.save(parcours);
                if (savedParcours == null || savedParcours.getIdParcoursProfessionel() == null) {
                    model.addAttribute("erreur", "Erreur lors de la sauvegarde d'un parcours professionnel");
                    return "candidat-error";
                }
            }
        }

    } catch (Exception e) {
        e.printStackTrace();
        model.addAttribute("erreur", "Erreur inattendue: " + e.getMessage());
        return "candidat-error";
    }

    return "redirect:/candidat/list";
}

    


    @GetMapping("/list")
    public String listCandidats(Model model) {
        model.addAttribute("candidats", candidatRepository.findAll());
        return "candidat-list";
    }
}

    
