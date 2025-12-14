package com.example.gestion.controllers;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.example.gestion.models.DocumentPersonnel;
import com.example.gestion.models.Personnel;
import com.example.gestion.repository.PersonnelRepository;
import com.example.gestion.repository.TypeDocumentRepository;
import com.example.gestion.services.DocumentPersonnelService;

@Controller
@RequestMapping("/admin/documents")
public class AdminDocumentPersonnelController {
    
    @Autowired
    private DocumentPersonnelService documentPersonnelService;
    
    @Autowired
    private PersonnelRepository personnelRepository;
    
    @Autowired
    private TypeDocumentRepository typeDocumentRepository;
    
    // Répertoire de stockage des documents
    private static final String UPLOAD_DIR = "uploads/documents/";
    
    @GetMapping
    public String listDocuments(Model model) {
        List<DocumentPersonnel> documents = documentPersonnelService.getAllDocuments();
        
        model.addAttribute("documents", documents);
        model.addAttribute("titre", "Gestion des Documents RH");
        
        return "admin/documents/list";
    }
    
    @GetMapping("/nouveau")
    public String nouveauDocumentForm(Model model) {
        model.addAttribute("document", new DocumentPersonnel());
        model.addAttribute("personnels", personnelRepository.findAll());
        model.addAttribute("typesDocument", typeDocumentRepository.findAll());
        model.addAttribute("titre", "Nouveau Document");
        
        return "admin/documents/form";
    }
    
    @GetMapping("/modifier/{id}")
    public String modifierDocumentForm(@PathVariable Integer id, Model model) {
        DocumentPersonnel document = documentPersonnelService.getDocumentById(id)
                .orElseThrow(() -> new IllegalArgumentException("Document invalide: " + id));
        
        model.addAttribute("document", document);
        model.addAttribute("personnels", personnelRepository.findAll());
        model.addAttribute("typesDocument", typeDocumentRepository.findAll());
        model.addAttribute("titre", "Modifier Document");
        
        return "admin/documents/form";
    }
    
    @PostMapping("/enregistrer")
    public String enregistrerDocument(@ModelAttribute DocumentPersonnel document,
                                     @RequestParam(value = "fichier", required = false) MultipartFile fichier) {
        
        // Gestion de l'upload du fichier
        if (fichier != null && !fichier.isEmpty()) {
            try {
                // Créer le répertoire s'il n'existe pas
                Path uploadPath = Paths.get(UPLOAD_DIR);
                if (!Files.exists(uploadPath)) {
                    Files.createDirectories(uploadPath);
                }
                
                // Générer un nom unique pour le fichier
                String nomFichier = UUID.randomUUID().toString() + "_" + fichier.getOriginalFilename();
                Path cheminFichier = uploadPath.resolve(nomFichier);
                
                // Sauvegarder le fichier
                Files.copy(fichier.getInputStream(), cheminFichier);
                
                // Mettre à jour les informations du document
                document.setNom_fichier(fichier.getOriginalFilename());
                document.setChemin_fichier(UPLOAD_DIR + nomFichier);
                
            } catch (IOException e) {
                e.printStackTrace();
                return "redirect:/admin/documents/nouveau?error=upload";
            }
        }
        
        // Définir la date d'upload
        if (document.getDate_upload() == null) {
            document.setDate_upload(new Date());
        }
        
        documentPersonnelService.saveDocument(document);
        return "redirect:/admin/documents?success=1";
    }
    
    @GetMapping("/supprimer/{id}")
    public String supprimerDocument(@PathVariable Integer id) {
        // Récupérer le document pour supprimer le fichier physique
        DocumentPersonnel document = documentPersonnelService.getDocumentById(id).orElse(null);
        
        if (document != null && document.getChemin_fichier() != null) {
            try {
                Path fichier = Paths.get(document.getChemin_fichier());
                Files.deleteIfExists(fichier);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        
        documentPersonnelService.deleteDocument(id);
        return "redirect:/admin/documents?deleted=1";
    }
    
    @GetMapping("/personnel/{id}")
    public String documentsByPersonnel(@PathVariable Integer id, Model model) {
        Personnel personnel = personnelRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Personnel invalide: " + id));
        
        List<DocumentPersonnel> documents = documentPersonnelService.getDocumentsByPersonnel(personnel);
        
        model.addAttribute("personnel", personnel);
        model.addAttribute("documents", documents);
        model.addAttribute("titre", "Documents de " + personnel.getCandidat().getNom());
        
        return "admin/documents/personnel";
    }
}
