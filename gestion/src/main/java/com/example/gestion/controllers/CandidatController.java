package com.example.gestion.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import com.example.gestion.models.*;
import com.example.gestion.repository.*;
import com.example.gestion.service.CandidatService;


import java.util.List;


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
    public String saveCandidat( @RequestParam("idAnnonce") Integer idAnnonce,@ModelAttribute Candidat candidat,
                            @RequestParam("file") MultipartFile file) {
        Annonce annonce = annonceRepository.findById(idAnnonce)
            .orElseThrow(() -> new RuntimeException("Annonce non trouvée"));

        // 2. Récupérer le profil de l'annonce
        Profil profil = annonce.getProfil();



        try {
            // Photo
            if (!file.isEmpty()) {
                String photoName = file.getOriginalFilename();
                candidat.setPhoto(photoName);
                // TODO : sauvegarder le fichier physiquement
            }
            // Sauvegarder le candidat // --- Etat du candidat ---
            EtatCandidat etatAttente = etatCandidatRepository.findById(1)
                    .orElseThrow(() -> new RuntimeException("Etat 'En attente' introuvable"));
            candidat.setEtatCandidat(etatAttente);

            // --- Sauvegarder le candidat ---
            Candidat savedCandidat = candidatRepository.save(candidat);

            // --- Ajouter historique ---
            HistoriqueEtat historique = new HistoriqueEtat();
            historique.setCandidat(savedCandidat);
            historique.setEtatCandidat(etatAttente);
            historique.setDate_changement(java.time.LocalDate.now().toString()); // current date
            historiqueEtatRepository.save(historique);

             // Pour chaque diplôme candidat
            if (candidat.getDiplomesCandidats() != null) {
                for (DiplomeCandidat dc : candidat.getDiplomesCandidats()) {
                    Niveau niveau = niveauRepository.findById(dc.getDiplome().getNiveau().getIdNiveau())
                            .orElseThrow(() -> new RuntimeException("Niveau introuvable"));

                    Filiere filiere = filiereRepository.findById(dc.getDiplome().getFiliere().getIdFiliere())
                            .orElseThrow(() -> new RuntimeException("Filiere introuvable"));

                    // Vérifier si Diplome existe déjà
                    Diplome diplome = diplomeRepository.findByNiveauAndFiliere(niveau, filiere)
                            .orElseGet(() -> {
                                // sinon créer
                                Diplome newDiplome = new Diplome();
                                newDiplome.setNiveau(niveau);
                                newDiplome.setFiliere(filiere);
                                return diplomeRepository.save(newDiplome);
                            });

                    // Associer diplome existant au DiplomeCandidat
                    dc.setDiplome(diplome);
                    dc.setCandidat(savedCandidat);
                    diplomeCandidatRepository.save(dc);
                }
            }

            if (candidat.getParcoursProfessionels() != null) {
                for (ParcoursProfessionel parcours : candidat.getParcoursProfessionels()) {
                    parcours.setCandidat(savedCandidat);
                    parcoursProfessionelRepository.save(parcours);
                }
            }


        } catch (Exception e) {
            e.printStackTrace();
        }
        return "redirect:/candidat/list";
    }


    @GetMapping("/list")
    public String listCandidats(Model model) {
        model.addAttribute("candidats", candidatRepository.findAll());
        return "candidat-list";
    }
}

    
