package com.example.gestion.services;

import com.example.gestion.models.*;
import com.example.gestion.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

@Service
@Transactional
public class JustificationRetardService {

    @Autowired
    private JustificationRetardRepository justificationRetardRepository;

    @Autowired
    private PersonnelRepository personnelRepository;

    @Autowired
    private AuditLogService auditLogService;

    private static final String UPLOAD_DIR = "E:/HP/Documents/S5/Mr Tovo/Gest_Entr/src/main/resources/static/justificatifs/retards/";

    // ========== CRÉER JUSTIFICATION RETARD ==========
    public JustificationRetard creerJustificationRetard(Integer idPersonnel, LocalDate dateRetard, 
                                                         Integer minutesRetard, MultipartFile fichier) throws IOException {
        Personnel personnel = personnelRepository.findById(idPersonnel)
                .orElseThrow(() -> new RuntimeException("Personnel non trouvé"));

        // Vérifier si une justification existe déjà
        if (justificationRetardRepository.existsByPersonnelAndDateRetard(personnel, dateRetard)) {
            throw new RuntimeException("Une justification existe déjà pour cette date");
        }

        JustificationRetard justification = new JustificationRetard();
        justification.setPersonnel(personnel);
        justification.setDateRetard(dateRetard);
        justification.setMinutesRetard(minutesRetard);
        justification.setEstJustifie(false);

        // Upload du fichier si fourni
        if (fichier != null && !fichier.isEmpty()) {
            String cheminFichier = sauvegarderFichier(fichier);
            justification.setFichierJustification(cheminFichier);
        }

        JustificationRetard saved = justificationRetardRepository.save(justification);

        // Audit log
        auditLogService.log("justification_retard", saved.getIdJustificationRetard(), 
                "CREATE", idPersonnel, AuditLog.UserType.PERSONNEL,
                "Création justification retard pour le " + dateRetard + " (" + minutesRetard + " min)");

        return saved;
    }

    // ========== SAUVEGARDER FICHIER ==========
    private String sauvegarderFichier(MultipartFile fichier) throws IOException {
        // Créer le répertoire s'il n'existe pas
        Path uploadPath = Path.of(UPLOAD_DIR);
        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }

        // Générer un nom unique
        String nomOriginal = fichier.getOriginalFilename();
        String extension = nomOriginal.substring(nomOriginal.lastIndexOf("."));
        String nomFichier = UUID.randomUUID().toString() + extension;

        // Sauvegarder le fichier
        Path cheminFichier = uploadPath.resolve(nomFichier);
        Files.copy(fichier.getInputStream(), cheminFichier);

        return "justificatifs/retards/" + nomFichier;
    }

    // ========== AJOUTER FICHIER À UNE JUSTIFICATION EXISTANTE ==========
    public JustificationRetard ajouterFichier(Integer idJustification, MultipartFile fichier) throws IOException {
        JustificationRetard justification = justificationRetardRepository.findById(idJustification)
                .orElseThrow(() -> new RuntimeException("Justification non trouvée"));

        String cheminFichier = sauvegarderFichier(fichier);
        justification.setFichierJustification(cheminFichier);

        JustificationRetard saved = justificationRetardRepository.save(justification);

        // Audit log
        auditLogService.log("justification_retard", idJustification, 
                "UPDATE_FILE", justification.getPersonnel().getId_personnel(), 
                AuditLog.UserType.PERSONNEL,
                "Ajout fichier justificatif");

        return saved;
    }

    // ========== RÉCUPÉRER JUSTIFICATION PAR ID ==========
    public JustificationRetard getJustificationById(Integer id) {
        return justificationRetardRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Justification non trouvée"));
    }

    // ========== RÉCUPÉRER JUSTIFICATIONS D'UN PERSONNEL ==========
    public List<JustificationRetard> getJustificationsByPersonnel(Integer idPersonnel) {
        Personnel personnel = personnelRepository.findById(idPersonnel)
                .orElseThrow(() -> new RuntimeException("Personnel non trouvé"));
        return justificationRetardRepository.findByPersonnelOrderByDateRetardDesc(personnel);
    }

    // ========== RÉCUPÉRER JUSTIFICATIONS EN ATTENTE ==========
    public List<JustificationRetard> getJustificationsEnAttente() {
        return justificationRetardRepository.findJustificationsEnAttente();
    }

    // ========== RÉCUPÉRER JUSTIFICATIONS EN ATTENTE PAR DÉPARTEMENT ==========
    public List<JustificationRetard> getJustificationsEnAttenteByDepartement(Integer idDepartement) {
        return justificationRetardRepository.findJustificationsEnAttenteByDepartement(idDepartement);
    }

    // ========== RÉCUPÉRER RETARDS SIGNIFICATIFS EN ATTENTE ==========
    public List<JustificationRetard> getRetardsSignificatifsEnAttente() {
        return justificationRetardRepository.findRetardsSignificatifsEnAttente();
    }

    // ========== RÉCUPÉRER JUSTIFICATIONS PAR PÉRIODE ==========
    public List<JustificationRetard> getJustificationsByPeriode(LocalDate dateDebut, LocalDate dateFin) {
        return justificationRetardRepository.findByDateRetardBetween(dateDebut, dateFin);
    }

    // ========== STATISTIQUES ==========
    public Long calculerTotalMinutesRetard(Integer idPersonnel, LocalDate dateDebut, LocalDate dateFin) {
        Personnel personnel = personnelRepository.findById(idPersonnel)
                .orElseThrow(() -> new RuntimeException("Personnel non trouvé"));
        Long total = justificationRetardRepository.sumMinutesRetardByPersonnelAndPeriode(personnel, dateDebut, dateFin);
        return total != null ? total : 0L;
    }

    public long compterJustificationsAcceptees(Integer idPersonnel) {
        Personnel personnel = personnelRepository.findById(idPersonnel)
                .orElseThrow(() -> new RuntimeException("Personnel non trouvé"));
        return justificationRetardRepository.countByPersonnelAndEstJustifieTrue(personnel);
    }

    public long compterJustificationsRefusees(Integer idPersonnel) {
        Personnel personnel = personnelRepository.findById(idPersonnel)
                .orElseThrow(() -> new RuntimeException("Personnel non trouvé"));
        return justificationRetardRepository.countByPersonnelAndEstJustifieFalse(personnel);
    }

    // ========== SUPPRIMER JUSTIFICATION ==========
    public void supprimerJustification(Integer id, Integer userId) {
        JustificationRetard justification = getJustificationById(id);
        justificationRetardRepository.delete(justification);

        // Audit log
        auditLogService.log("justification_retard", id, "DELETE", userId, 
                AuditLog.UserType.USER,
                "Suppression justification retard");
    }
}