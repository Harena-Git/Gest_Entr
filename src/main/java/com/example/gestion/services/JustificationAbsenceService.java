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
public class JustificationAbsenceService {

    @Autowired
    private JustificationAbsenceRepository justificationAbsenceRepository;

    @Autowired
    private PersonnelRepository personnelRepository;

    @Autowired
    private AuditLogService auditLogService;

    private static final String UPLOAD_DIR = "E:/HP/Documents/S5/Mr Tovo/Gest_Entr/src/main/resources/static/justificatifs/absences/";

    // ========== CRÉER JUSTIFICATION ABSENCE ==========
    public JustificationAbsence creerJustificationAbsence(Integer idPersonnel, LocalDate dateAbsence, 
                                                           MultipartFile fichier, String motif) throws IOException {
        Personnel personnel = personnelRepository.findById(idPersonnel)
                .orElseThrow(() -> new RuntimeException("Personnel non trouvé"));

        // Vérifier si une justification existe déjà
        if (justificationAbsenceRepository.existsByPersonnelAndDateAbsence(personnel, dateAbsence)) {
            throw new RuntimeException("Une justification existe déjà pour cette date");
        }

        JustificationAbsence justification = new JustificationAbsence();
        justification.setPersonnel(personnel);
        justification.setDateAbsence(dateAbsence);
        justification.setDateDemande(LocalDate.now());
        justification.setEstJustifie(false);

        // Upload du fichier si fourni
        if (fichier != null && !fichier.isEmpty()) {
            String cheminFichier = sauvegarderFichier(fichier);
            justification.setFichierJustification(cheminFichier);
        }

        JustificationAbsence saved = justificationAbsenceRepository.save(justification);

        // Audit log
        auditLogService.log("justification_absence", saved.getIdJustificationAbsence(), 
                "CREATE", idPersonnel, AuditLog.UserType.PERSONNEL,
                "Création justification absence pour le " + dateAbsence);

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

        return "justificatifs/absences/" + nomFichier;
    }

    // ========== AJOUTER FICHIER À UNE JUSTIFICATION EXISTANTE ==========
    public JustificationAbsence ajouterFichier(Integer idJustification, MultipartFile fichier) throws IOException {
        JustificationAbsence justification = justificationAbsenceRepository.findById(idJustification)
                .orElseThrow(() -> new RuntimeException("Justification non trouvée"));

        String cheminFichier = sauvegarderFichier(fichier);
        justification.setFichierJustification(cheminFichier);

        JustificationAbsence saved = justificationAbsenceRepository.save(justification);

        // Audit log
        auditLogService.log("justification_absence", idJustification, 
                "UPDATE_FILE", justification.getPersonnel().getId_personnel(), 
                AuditLog.UserType.PERSONNEL,
                "Ajout fichier justificatif");

        return saved;
    }

    // ========== RÉCUPÉRER JUSTIFICATION PAR ID ==========
    public JustificationAbsence getJustificationById(Integer id) {
        return justificationAbsenceRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Justification non trouvée"));
    }

    // ========== RÉCUPÉRER JUSTIFICATIONS D'UN PERSONNEL ==========
    public List<JustificationAbsence> getJustificationsByPersonnel(Integer idPersonnel) {
        Personnel personnel = personnelRepository.findById(idPersonnel)
                .orElseThrow(() -> new RuntimeException("Personnel non trouvé"));
        return justificationAbsenceRepository.findByPersonnelOrderByDateDemandeDesc(personnel);
    }

    // ========== RÉCUPÉRER JUSTIFICATIONS EN ATTENTE ==========
    public List<JustificationAbsence> getJustificationsEnAttente() {
        return justificationAbsenceRepository.findJustificationsEnAttente();
    }

    // ========== RÉCUPÉRER JUSTIFICATIONS EN ATTENTE PAR DÉPARTEMENT ==========
    public List<JustificationAbsence> getJustificationsEnAttenteByDepartement(Integer idDepartement) {
        return justificationAbsenceRepository.findJustificationsEnAttenteByDepartement(idDepartement);
    }

    // ========== RÉCUPÉRER JUSTIFICATIONS ACCEPTÉES ==========
    public List<JustificationAbsence> getJustificationsAcceptees() {
        return justificationAbsenceRepository.findByEstJustifieTrue();
    }

    // ========== RÉCUPÉRER JUSTIFICATIONS REFUSÉES ==========
    public List<JustificationAbsence> getJustificationsRefusees() {
        return justificationAbsenceRepository.findJustificationsRefusees();
    }

    // ========== RÉCUPÉRER JUSTIFICATIONS PAR PÉRIODE ==========
    public List<JustificationAbsence> getJustificationsByPeriode(LocalDate dateDebut, LocalDate dateFin) {
        return justificationAbsenceRepository.findByDateAbsenceBetween(dateDebut, dateFin);
    }

    // ========== STATISTIQUES ==========
    public long compterJustificationsAcceptees(Integer idPersonnel) {
        Personnel personnel = personnelRepository.findById(idPersonnel)
                .orElseThrow(() -> new RuntimeException("Personnel non trouvé"));
        return justificationAbsenceRepository.countByPersonnelAndEstJustifieTrue(personnel);
    }

    public long compterJustificationsRefusees(Integer idPersonnel) {
        Personnel personnel = personnelRepository.findById(idPersonnel)
                .orElseThrow(() -> new RuntimeException("Personnel non trouvé"));
        return justificationAbsenceRepository.countByPersonnelAndEstJustifieFalse(personnel);
    }

    // ========== SUPPRIMER JUSTIFICATION ==========
    public void supprimerJustification(Integer id, Integer userId) {
        JustificationAbsence justification = getJustificationById(id);
        justificationAbsenceRepository.delete(justification);

        // Audit log
        auditLogService.log("justification_absence", id, "DELETE", userId, 
                AuditLog.UserType.USER,
                "Suppression justification absence");
    }
}