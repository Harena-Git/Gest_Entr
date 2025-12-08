package com.example.gestion.services;

import com.example.gestion.models.*;
import com.example.gestion.repository.*;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.stereotype.Service;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

@Service
@Transactional(readOnly = true) 
public class RelevePresenceService {

    @Autowired
    private PresenceAbsenceRepository presenceAbsenceRepository;

    @Autowired
    private PersonnelRepository personnelRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private DepartementRepository departementRepository;

    @Autowired
    private HoraireEntrepriseRepository horaireEntrepriseRepository;

    @Autowired
    private JustificationAbsenceRepository justificationAbsenceRepository;

    @Autowired
    private JustificationRetardRepository justificationRetardRepository;

    @Autowired
    private ValidationAbsChefRepository validationAbsChefRepository;

    @Autowired
    private ValidationAbsRhRepository validationAbsRhRepository;

    @Autowired
    private PersonnelHeureSuppRepository personnelHeureSuppRepository;

    @Autowired
    private FileStorageService fileStorageService;

    @Autowired
    private RelevePresenceServicePDF relevePresenceServicePDF;

    @Autowired
    private RelevePresenceServiceExcel relevePresenceServiceExcel;

    @Value("${app.file.releves-dir}")
    private String relevesBaseDir;

    // ========== GÉNÉRER RELEVÉ POUR UN PERSONNEL ==========
    public String genererRelevePersonnel(Integer idPersonnel, LocalDate dateDebut, 
                                        LocalDate dateFin, String format) throws IOException {
        
        Personnel personnel = personnelRepository.findById(idPersonnel)
                .orElseThrow(() -> new RuntimeException("Personnel non trouvé"));

        List<PresenceAbsence> presences = presenceAbsenceRepository
                .findByPersonnelAndDateBetween(personnel, dateDebut, dateFin);

        byte[] fileContent;
        String fileName;
        String fileExtension;

        if ("excel".equalsIgnoreCase(format)) {
            fileContent = genererExcelPersonnel(personnel, presences, dateDebut, dateFin);
            fileExtension = ".xlsx";
        } else {
            fileContent = genererRelevePDFPersonnel(personnel, presences, dateDebut, dateFin);
            fileExtension = ".pdf";
        }

        // Générer un nom de fichier unique
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMdd");
        fileName = String.format("releve_personnel_%s_%s_%s_%s%s",
                personnel.getCandidat().getNom(),
                personnel.getCandidat().getPrenom(),
                dateDebut.format(formatter),
                dateFin.format(formatter),
                fileExtension);

        // Stocker le fichier
        return fileStorageService.storeReleveFile(fileContent, fileName, "personnel");
    }

    // ========== GÉNÉRER RELEVÉ POUR UN DÉPARTEMENT ==========
    public String genererReleveDepartement(Integer idDepartement, LocalDate dateDebut, 
                                          LocalDate dateFin, String format) throws IOException {
        
        List<PresenceAbsence> presences = presenceAbsenceRepository
                .findByDepartementAndDateBetween(idDepartement, dateDebut, dateFin);

        Departement departement = departementRepository.findById(idDepartement)
                .orElseThrow(() -> new RuntimeException("Département non trouvé"));

        byte[] fileContent;
        String fileName;
        String fileExtension;

        if ("excel".equalsIgnoreCase(format)) {
            fileContent = genererExcelDepartement(departement, presences, dateDebut, dateFin);
            fileExtension = ".xlsx";
        } else {
            fileContent = genererRelevePDFDepartement(idDepartement, presences, dateDebut, dateFin);
            fileExtension = ".pdf";
        }

        // Générer un nom de fichier unique
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMdd");
        
        fileName = String.format("releve_departement_%s_%s_%s%s",
                departement.getDepartement().replace(" ", "_"),
                dateDebut.format(formatter),
                dateFin.format(formatter),
                fileExtension);

        // Stocker le fichier
        return fileStorageService.storeReleveFile(fileContent, fileName, "departement");
    }

    // ========== GÉNÉRER RELEVÉ GLOBAL (RH) ==========
    public String genererReleveGlobal(LocalDate dateDebut, LocalDate dateFin, String format) throws IOException {
        List<PresenceAbsence> presences = presenceAbsenceRepository
                .findByDateBetween(dateDebut, dateFin);

        byte[] fileContent;
        String fileName;
        String fileExtension;

        if ("excel".equalsIgnoreCase(format)) {
            fileContent = genererExcelGlobal(presences, dateDebut, dateFin);
            fileExtension = ".xlsx";
        } else {
            fileContent = genererRelevePDFGlobal(presences, dateDebut, dateFin);
            fileExtension = ".pdf";
        }

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMdd");
        fileName = String.format("releve_global_%s_%s%s",
                dateDebut.format(formatter),
                dateFin.format(formatter),
                fileExtension);

        return fileStorageService.storeReleveFile(fileContent, fileName, "global");
    }

    // ========== GÉNÉRER EXCEL POUR PERSONNEL ==========
    public byte[] genererExcelPersonnel(Personnel personnel,
                                    List<PresenceAbsence> presences,
                                    LocalDate dateDebut,
                                    LocalDate dateFin) throws IOException {

        return relevePresenceServiceExcel.genererReleveExcelPersonnel(
                personnel, presences, dateDebut, dateFin
        );
    }

    public byte[] genererExcelDepartement(Departement departement,
                                        List<PresenceAbsence> presences,
                                        LocalDate dateDebut,
                                        LocalDate dateFin) throws IOException {

        return relevePresenceServiceExcel.genererReleveExcelDepartement(
                departement, presences, dateDebut, dateFin
        );
    }

    public byte[] genererExcelGlobal(List<PresenceAbsence> presences,
                                    LocalDate dateDebut,
                                    LocalDate dateFin) throws IOException {

        return relevePresenceServiceExcel.genererReleveExcelGlobal(
                presences, dateDebut, dateFin
        );
    }


    private long calculerJoursOuvrables(LocalDate dateDebut, LocalDate dateFin) {
        long jours = 0;
        LocalDate date = dateDebut;
        while (!date.isAfter(dateFin)) {
            if (date.getDayOfWeek().getValue() < 6) { // Lundi à vendredi
                jours++;
            }
            date = date.plusDays(1);
        }
        return jours;
    }

    // ========== MÉTHODES PDF (SIMPLIFIÉES - À IMPLÉMENTER AVEC iText) ==========

    private byte[] genererRelevePDFPersonnel(Personnel personnel, List<PresenceAbsence> presences,
                                           LocalDate dateDebut, LocalDate dateFin) throws IOException {
        
        return relevePresenceServicePDF.genererRelevePDFPersonnel(personnel, presences, dateDebut, dateFin);
    }

    private byte[] genererRelevePDFDepartement(Integer idDepartement, List<PresenceAbsence> presences,
                                              LocalDate dateDebut, LocalDate dateFin) throws IOException {
        // for (PresenceAbsence presence : presences) {
        //     if (presence.getValidationsChef() != null) {
        //         presence.getValidationsChef().size(); // Force l'initialisation
        //     }
        //     if (presence.getPersonnel() != null && presence.getPersonnel().getCandidat() != null) {
        //         // Force l'initialisation des relations nécessaires
        //     }
        // }
        Departement Dept = departementRepository.findById(idDepartement)
            .orElseThrow(() -> new IOException("Département non trouvé"));
        
        return relevePresenceServicePDF.genererRelevePDFDepartement(Dept, presences, dateDebut, dateFin);
    }

    private byte[] genererRelevePDFGlobal(List<PresenceAbsence> presences, 
                                         LocalDate dateDebut, LocalDate dateFin) throws IOException {
        return relevePresenceServicePDF.genererRelevePDFGlobal(presences, dateDebut, dateFin);
    }

    // ========== MÉTHODES DE TÉLÉCHARGEMENT ET GESTION DES FICHIERS ==========

    public byte[] telechargerReleve(String fileName, String type) throws IOException {
        Path filePath = Paths.get(relevesBaseDir, type, fileName);
        
        if (!Files.exists(filePath)) {
            throw new IOException("Fichier non trouvé: " + filePath);
        }
        
        return Files.readAllBytes(filePath);
    }

    public List<Map<String, Object>> listerReleves(String type) throws IOException {
        Path dirPath = Paths.get(relevesBaseDir, type);
        
        if (!Files.exists(dirPath)) {
            Files.createDirectories(dirPath);
            return new ArrayList<>();
        }
        
        return Files.list(dirPath)
                .filter(Files::isRegularFile)
                .map(path -> {
                    Map<String, Object> fileInfo = new HashMap<>();
                    fileInfo.put("nom", path.getFileName().toString());
                    fileInfo.put("chemin", path.toString());
                    try {
                        fileInfo.put("taille", Files.size(path));
                        fileInfo.put("dateModification", 
                            Files.getLastModifiedTime(path).toInstant());
                    } catch (IOException e) {
                        fileInfo.put("taille", 0);
                        fileInfo.put("dateModification", null);
                    }
                    return fileInfo;
                })
                .toList();
    }

    public boolean supprimerReleve(String fileName, String type) throws IOException {
        Path filePath = Paths.get(relevesBaseDir, type, fileName);
        return Files.deleteIfExists(filePath);
    }

    public Map<String, Object> obtenirInfosReleve(String fileName, String type) throws IOException {
        Path filePath = Paths.get(relevesBaseDir, type, fileName);
        
        if (!Files.exists(filePath)) {
            throw new IOException("Fichier non trouvé");
        }
        
        Map<String, Object> infos = new HashMap<>();
        infos.put("nom", fileName);
        infos.put("cheminAbsolu", filePath.toAbsolutePath().toString());
        infos.put("taille", Files.size(filePath));
        infos.put("dateCreation", 
            Files.getAttribute(filePath, "creationTime").toString());
        infos.put("dateModification", 
            Files.getLastModifiedTime(filePath).toString());
        
        // Extraire des informations du nom de fichier
        if (fileName.contains("_")) {
            String[] parts = fileName.split("_");
            if (parts.length >= 4) {
                infos.put("typeReleve", parts[0]);
                infos.put("cible", parts[1]);
                infos.put("periode", parts[2] + "_" + parts[3].split("\\.")[0]);
            }
        }
        
        return infos;
    }

    // ========== MÉTHODE DE PRÉVISUALISATION ==========

    public Map<String, Object> previewReleve(String type, LocalDate dateDebut, 
                                            LocalDate dateFin, String format) {
        Map<String, Object> preview = new HashMap<>();
        
        try {
            preview.put("success", true);
            preview.put("type", type);
            preview.put("dateDebut", dateDebut);
            preview.put("dateFin", dateFin);
            preview.put("format", format);
            
            // Estimation du nombre de lignes
            long nbLignes = 0;
            if ("personnel".equals(type)) {
                // Estimation basée sur la période
                nbLignes = calculerJoursOuvrables(dateDebut, dateFin);
            } else if ("departement".equals(type)) {
                // Estimation pour un département
                nbLignes = calculerJoursOuvrables(dateDebut, dateFin) * 10; // Estimation
            } else if ("global".equals(type)) {
                // Estimation globale
                nbLignes = calculerJoursOuvrables(dateDebut, dateFin) * 50; // Estimation
            }
            
            preview.put("nbLignesEstime", nbLignes);
            
            // Estimation de la taille
            double tailleMo = nbLignes * 0.5 / 1024; // 0.5KB par ligne
            preview.put("tailleEstimeeMo", String.format("%.2f", tailleMo));
            
            // Temps de génération estimé
            int tempsSecondes = (int) (nbLignes * 0.01);
            preview.put("tempsGeneration", 
                tempsSecondes < 60 ? 
                tempsSecondes + " secondes" : 
                (tempsSecondes / 60) + " minutes");
                
        } catch (Exception e) {
            preview.put("success", false);
            preview.put("message", e.getMessage());
        }
        
        return preview;
    }
}