package com.example.gestion.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.InputStreamResource;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import com.example.gestion.models.*;
import com.example.gestion.repository.*;
import com.example.gestion.services.CandidatService;
import com.example.gestion.services.ExcelExportService;
import com.example.gestion.services.ExcelImportService;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;


import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.OutputStream;
import java.time.LocalDate;

import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.Date;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.IOException; 

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;




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
    
    @Autowired
    private ExcelExportService excelExportService;

    @Autowired
    private ExcelImportService excelImportService;
   


    
    @GetMapping("/form")
    public String showForm(@RequestParam(required = false) Integer idAnnonce,
                        Model model) throws Exception {
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
  
            return "candidat-form";
    }


    @PostMapping("/save")
    public String saveCandidat(@RequestParam Integer idAnnonce,
                            @ModelAttribute Candidat candidat,
                            @RequestParam MultipartFile file,
                            @RequestParam Map<String, String> requestParams,
                            Model model,HttpSession session) throws Exception {

            session.setAttribute("idAnnonce", idAnnonce);
        
        if (!file.isEmpty()) {
            // 1️⃣ Définir le dossier d'upload
            String uploadDir = "E:/FENITRA/S5/Gestion Entreprise (Mr Tovo)/o";
            File uploadDirFile = new File(uploadDir);
            if (!uploadDirFile.exists()) {
                uploadDirFile.mkdirs(); // créer le dossier si inexistant
            }

            // 2️⃣ Récupérer l'extension du fichier
            String originalFilename = file.getOriginalFilename();
            String extension = "";
            if (originalFilename != null && originalFilename.contains(".")) {
                extension = originalFilename.substring(originalFilename.lastIndexOf("."));
            }

            // 3️⃣ Générer un nom unique pour éviter les collisions
            String uniqueFilename = UUID.randomUUID().toString() + extension;

            // 4️⃣ Créer le fichier de destination correctement
            File destinationFile = new File(uploadDirFile, uniqueFilename);

            // 5️⃣ Transférer le fichier
            try {
                file.transferTo(destinationFile);
                System.out.println("Fichier uploadé avec succès : " + destinationFile.getAbsolutePath());
            } catch (IOException e) {
                e.printStackTrace();
                // gérer l'erreur, par ex. renvoyer un message à la JSP
                model.addAttribute("erreurUpload", "Erreur lors de l'upload du fichier.");
            }

            // 6️⃣ Sauvegarder le nom du fichier dans l'entité
            candidat.setPhoto(uniqueFilename);
        }

        try {
            // Photo
  
            candidat.setDate_candidature(new Date());

            EtatCandidat etatAttente = etatCandidatRepository.findById(1)
                    .orElseThrow(() -> new RuntimeException("Etat 'En attente' introuvable"));
            candidat.setEtatCandidat(etatAttente);

            // --- Sauvegarde du candidat ---
            Candidat savedCandidat = candidatRepository.save(candidat);
            if (savedCandidat == null || savedCandidat.getId_candidat() == null) {
                System.err.println("Erreur lors de la sauvegarde du candidat"); // log dans la console
                model.addAttribute("erreur", "Erreur lors de la sauvegarde du candidat"); // tu peux garder le message pour la JSP si besoin
                // on ne fait pas return, on continue
            }

            // --- Historique ---
            HistoriqueEtat historique = new HistoriqueEtat();
            historique.setCandidat(savedCandidat);
            historique.setEtatCandidat(etatAttente);
            historique.setDate_changement(java.time.LocalDate.now().toString());
            historiqueEtatRepository.save(historique);
            
         
            
            session.setAttribute("idCandidat", savedCandidat.getId_candidat());

           
             return "redirect:/candidat/diplome-form";

        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("erreur", "Erreur inattendue: " + e.getMessage());
            return "candidat-error";
        }
    }

    @GetMapping("/diplome-form")
    public String showDiplomeForm(HttpSession session, Model model) {
        // 🔹 Récupération de l'idCandidat depuis la session
        Integer idCandidat = (Integer) session.getAttribute("idCandidat");

        if (idCandidat == null) {
            model.addAttribute("erreur", "Aucun candidat trouvé dans la session.");
            return "candidat-error";
        }

        // 🔹 Chargement des listes
        List<Filiere> filieres = filiereRepository.findAll();
        List<Niveau> niveaux = niveauRepository.findAll();

        // 🔹 Envoi des données à la vue
        model.addAttribute("filieres", filieres);
        model.addAttribute("niveaux", niveaux);
        model.addAttribute("candidatId", idCandidat);

        return "diplom-form";
    }

    @PostMapping("/diplome-save")
    public String saveDiplome(@RequestParam Integer idCandidat,
                            @RequestParam("diplomes.etablissement") String etablissement,
                            @RequestParam("diplomes.annee_obtention") Integer anneeObtention,
                            @RequestParam("diplomes.idFiliere") Integer idFiliere, // radio
                            @RequestParam("diplomes.id_niveau") Integer id_niveau,
                            @RequestParam String action,
                            Model model,
                            HttpSession session) {

        // 🔹 Récupérer le candidat
        Candidat candidat = candidatRepository.findById(idCandidat)
                .orElseThrow(() -> new RuntimeException("Candidat introuvable"));

        // 🔹 Créer un DiplomeCandidat
        DiplomeCandidat dc = new DiplomeCandidat();
        dc.setCandidat(candidat);
        dc.setEtablissement(etablissement);
        dc.setAnnee_obtention(anneeObtention);

        // 🔹 Récupérer le Diplome correspondant à la filière choisie
        Diplome diplome = diplomeRepository.findById(idFiliere) // ici idFiliere correspond à id_diplome
                .orElseThrow(() -> new RuntimeException("Diplome introuvable"));
        dc.setDiplome(diplome);

        // 🔹 Sauvegarde
        diplomeCandidatRepository.save(dc);

        if ("ajouter".equals(action)) {
            // 🔹 Recharger le formulaire pour ajouter un autre diplôme
            List<Filiere> filieres = filiereRepository.findAll();
            List<Niveau> niveaux = niveauRepository.findAll();
            model.addAttribute("filieres", filieres);
            model.addAttribute("niveaux", niveaux);
            model.addAttribute("candidatId", idCandidat);
            return "diplom-form";
        } else {
            // 🔹 Passer à la section parcours professionnel
            return "redirect:/candidat/parcours-form";
        }
    }

    @GetMapping("/parcours-form")
    public String showParcoursForm(HttpSession session, Model model) {
        Integer idCandidat = (Integer) session.getAttribute("idCandidat");
        if (idCandidat == null) {
            model.addAttribute("erreur", "Aucun candidat trouvé dans la session");
            return "candidat-error";
        }
        model.addAttribute("candidatId", idCandidat);
        return "parcours-form";
    }
   

    @PostMapping("/parcours-save")
    public String saveParcours(@ModelAttribute ParcoursProfessionel parcours,
                            @RequestParam Integer idCandidat,
                            @RequestParam String action,
                            Model model,
                            HttpSession session) {
        Candidat candidat = candidatRepository.findById(idCandidat)
                .orElseThrow(() -> new RuntimeException("Candidat introuvable"));

        parcours.setCandidat(candidat);
        parcoursProfessionelRepository.save(parcours);

        session.setAttribute("idCandidat", idCandidat);

        if ("ajouter".equals(action)) {
            model.addAttribute("candidatId", idCandidat);
            return "parcours-form";
        } else {
            return "redirect:/candidat/termine";
        }
    }


    // 🔹 Page de confirmation
    @GetMapping("/termine")
    public String finCandidature(Model model,
                            HttpSession session) {
           // Vérification avant enregistrement
        Integer idCandidat = (Integer) session.getAttribute("idCandidat");
        Integer idAnnonce = (Integer) session.getAttribute("idAnnonce");

        Candidat candidat = candidatRepository.findById(idCandidat)
                .orElseThrow(() -> new RuntimeException("Candidat introuvable"));

        Annonce annonce = annonceRepository.findById(idAnnonce)
                .orElseThrow(() -> new RuntimeException("Annonce introuvable"));
        
        Profil profil = annonce.getProfil();
        
        session.setAttribute("idCandidat", idCandidat);
        session.setAttribute("idAnnonce", idAnnonce);
        

        String verification = candidatService.verifierEtEnregistrer(candidat, profil);
        if (!"OK".equals(verification)) {

            EtatCandidat etatProfilRefuse = etatCandidatRepository.findById(7)
                    .orElseThrow(() -> new RuntimeException("Etat 'Candidat rejete' introuvable"));
            candidat.setEtatCandidat(etatProfilRefuse);

            candidatRepository.save(candidat);

            
        
            HistoriqueEtat historique = new HistoriqueEtat();
                historique.setCandidat(candidat);
                historique.setEtatCandidat(etatProfilRefuse);
                historique.setDate_changement(java.time.LocalDate.now().toString());
                historiqueEtatRepository.save(historique);
            model.addAttribute("erreur", verification);
            return "candidat-error";
        } 

         return "redirect:/candidat/success";
    }

    
    @GetMapping("/success")
    public String showSuccessPage(Model model, HttpSession session) {
        Integer idCandidat = (Integer) session.getAttribute("idCandidat");
        Integer idAnnonce = (Integer) session.getAttribute("idAnnonce");

        Candidat candidat = candidatRepository.findById(idCandidat)
                .orElseThrow(() -> new RuntimeException("Candidat introuvable"));

        

        EtatCandidat etatProfilAccepte = etatCandidatRepository.findById(2)
                    .orElseThrow(() -> new RuntimeException("Etat 'En attente' introuvable"));
            candidat.setEtatCandidat(etatProfilAccepte);

        candidatRepository.save(candidat);
        
        HistoriqueEtat historique = new HistoriqueEtat();
            historique.setCandidat(candidat);
            historique.setEtatCandidat(etatProfilAccepte);
            historique.setDate_changement(java.time.LocalDate.now().toString());
            historiqueEtatRepository.save(historique);

            session.setAttribute("idCandidat", idCandidat);
    
        // Récupérer l'ID du QCM associé à l'annonce
        Integer qcmId = annonceRepository.findQcmIdByAnnonceId(idAnnonce);
        
        if (qcmId != null) {
            // Rediriger vers le QCM avec l'ID du candidat
            return "redirect:/qcm/" + qcmId + "?candidatId=" + idCandidat;
        } else {
            // Si aucun QCM n'est trouvé, rester sur la page de succès
            model.addAttribute("message", "Votre candidature a été enregistrée avec succès !");
            return "candidat-success";
        }
        }
        
        /**
     * Import des candidats depuis un fichier Excel .xlsx
     * @param file fichier Excel envoyé depuis le formulaire
     * @return message de succès ou erreur
     */
    @PostMapping("/export-excel")
    public ResponseEntity<InputStreamResource> exportCandidatsExcel(@RequestParam List<Integer> candidatIds, HttpServletResponse response) throws IOException {
        // 🔹 Récupérer tous les candidats correspondant aux IDs reçus
        List<Candidat> candidats = candidatRepository.findAllById(candidatIds);
        ByteArrayInputStream in = excelExportService.candidatsToExcel(candidats);

        HttpHeaders headers = new HttpHeaders();
        headers.add("Content-Disposition", "attachment; filename=candidats.xlsx");

        return ResponseEntity.ok()
                .headers(headers)
                .contentType(MediaType.parseMediaType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"))
                .body(new InputStreamResource(in));
    }

   @PostMapping("/import")
    public String importCandidats(@RequestParam MultipartFile file, Model model) {
        if (file.isEmpty()) {
            model.addAttribute("error", "Le fichier est vide !");
            return "importResult"; // view qui affichera l’erreur
        }

        try {
            // Sauvegarde temporaire du fichier uploadé
            String tempFilePath = System.getProperty("java.io.tmpdir") + "/" + file.getOriginalFilename();
            file.transferTo(new java.io.File(tempFilePath));

            // Appel du service d’import
            excelImportService.importCandidatsAvecDiplomes(tempFilePath);

            // Récupération des candidats récents depuis le repository
            List<Candidat> candidats = candidatRepository.findAllOrderByDateCandidatureDesc();

            // Envoi de la liste vers la vue
            model.addAttribute("candidats", candidats);
            return "listeCandidats"; // le nom du fichier HTML/Thymeleaf à afficher

        } catch (Exception e) {
            model.addAttribute("error", "Erreur lors de l'import : " + e.getMessage());
            return "importResult";
        }
    }

    @GetMapping("/importer_f")
    public String importerFichier() {
       

        return "import_fichier";
    }
    @GetMapping("/list")
    public String listCandidats(Model model) {
        // Récupération des candidats récents depuis le repository
        List<Candidat> candidats = candidatRepository.findAllOrderByDateCandidatureDesc();

        // Envoi de la liste vers la vue
        model.addAttribute("candidats", candidats);
        return "listeCandidats";
    }
        
    }

    
