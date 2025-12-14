package com.example.gestion.services;

import java.time.LocalDate;

import com.example.gestion.models.*;
import com.example.gestion.repository.*;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

import java.time.LocalDate;
import java.util.List;

@Service
@Transactional
public class ValidationAbsChefService {

    @Autowired
    private ValidationAbsChefRepository validationAbsChefRepository;

    @Autowired
    private PresenceAbsenceRepository presenceAbsenceRepository;

    @Autowired
    private JustificationAbsenceRepository justificationAbsenceRepository;

    @Autowired
    private JustificationRetardRepository justificationRetardRepository;

    @Autowired
    private DecisionValidationRepository decisionValidationRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private AuditLogService auditLogService;

    // ========== VALIDER PRÉSENCE ==========
    public ValidationAbsChef validerPresence(Integer idChef, Integer idPresence, String decision) {
        User chef = userRepository.findById(idChef)
                .orElseThrow(() -> new RuntimeException("Chef non trouvé"));

        PresenceAbsence presence = presenceAbsenceRepository.findById(idPresence)
                .orElseThrow(() -> new RuntimeException("Présence non trouvée"));

        // Vérifier que le chef ne valide pas sa propre présence
        if (presence.getUser() != null && presence.getUser().getId_user().equals(idChef)) {
            throw new RuntimeException("Un chef ne peut pas valider sa propre présence");
        }

        // Vérifier que le chef valide son département
        if (presence.getPersonnel() != null) {
            Integer deptPersonnel = presence.getPersonnel().getPoste().getDepartement().getId_departement();
            Integer deptChef = chef.getDepartement().getId_departement();
            
            if (!deptPersonnel.equals(deptChef)) {
                throw new RuntimeException("Le chef ne peut valider que les présences de son département");
            }
        }

        DecisionValidation decisionValidation = decisionValidationRepository.findByLibelle(decision)
                .orElseThrow(() -> new RuntimeException("Décision de validation non trouvée"));
        
        ValidationAbsChef validation = new ValidationAbsChef();
        validation.setUser(chef);
        validation.setPresenceAbsence(presence);
        validation.setDecisionValidation(decisionValidation);
        validation.setDateValidation(LocalDate.now());

        ValidationAbsChef saved = validationAbsChefRepository.save(validation);

        // Audit log
        auditLogService.log("validationAbs_chef", saved.getIdValidationAbsChef(), 
                "VALIDATION_PRESENCE", idChef, AuditLog.UserType.USER,
                "Validation présence - Décision: " + decision);

        return saved;
    }

    // ========== VALIDER JUSTIFICATION ABSENCE ==========
    public ValidationAbsChef validerJustificationAbsence(Integer idChef, Integer idJustification, String decision) {
        User chef = userRepository.findById(idChef)
                .orElseThrow(() -> new RuntimeException("Chef non trouvé"));

        JustificationAbsence justification = justificationAbsenceRepository.findById(idJustification)
                .orElseThrow(() -> new RuntimeException("Justification non trouvée"));

        // RÉCUPÉRER LA PRÉSENCE PAR PERSONNEL ET DATE
        Optional<PresenceAbsence> optionalPresence =
        presenceAbsenceRepository.findByPersonnelAndDate(
                justification.getPersonnel(),
                justification.getDateAbsence()
        );

        PresenceAbsence presence;

        if (optionalPresence.isPresent()) {
                presence = optionalPresence.get();
        } else {
                presence = new PresenceAbsence();
                presence.setPersonnel(justification.getPersonnel());
                presence.setDate(justification.getDateAbsence());
                presence.setPresent(false);
                presence = presenceAbsenceRepository.save(presence);
        }


        // Vérifier département
        Integer deptPersonnel = justification.getPersonnel().getPoste().getDepartement().getId_departement();
        Integer deptChef = chef.getDepartement().getId_departement();

        if (!deptPersonnel.equals(deptChef)) {
                throw new RuntimeException("Le chef ne peut valider que les absences de son département");
        }

        DecisionValidation dec = decisionValidationRepository.findByLibelle(decision)
                .orElseThrow(() -> new RuntimeException("Décision invalide"));

        ValidationAbsChef validation = new ValidationAbsChef();
        validation.setUser(chef);
        validation.setPresenceAbsence(presence);
        validation.setJustificationAbsence(justification);
        validation.setDecisionValidation(dec);
        validation.setDateValidation(LocalDate.now());

        ValidationAbsChef saved = validationAbsChefRepository.save(validation);

        // Mettre à jour le statut de justification
        justification.setEstJustifie("accepté".equals(decision));
        justificationAbsenceRepository.save(justification);

        // Audit log
        auditLogService.log("validationAbs_chef", saved.getIdValidationAbsChef(), 
                "VALIDATION_ABSENCE", idChef, AuditLog.UserType.USER,
                "Validation absence - Décision: " + decision);

        return saved;
        }

    // ========== VALIDER JUSTIFICATION RETARD ==========
    public ValidationAbsChef validerJustificationRetard(Integer idChef, Integer idJustification, String decision) {
                User chef = userRepository.findById(idChef)
                        .orElseThrow(() -> new RuntimeException("Chef non trouvé"));

                JustificationRetard justification = justificationRetardRepository.findById(idJustification)
                        .orElseThrow(() -> new RuntimeException("Justification non trouvée"));

                // RÉCUPÉRER LA PRÉSENCE PAR PERSONNEL ET DATE
                PresenceAbsence presence = presenceAbsenceRepository.findByPersonnelAndDate(
                        justification.getPersonnel(), 
                        justification.getDateRetard()
                ).orElseThrow(() -> new RuntimeException("Présence non trouvée pour cette date de retard"));

                // Vérifier département
                Integer deptPersonnel = justification.getPersonnel().getPoste().getDepartement().getId_departement();
                Integer deptChef = chef.getDepartement().getId_departement();

                if (!deptPersonnel.equals(deptChef)) {
                        throw new RuntimeException("Le chef ne peut valider que les retards de son département");
                }

                DecisionValidation dec = decisionValidationRepository.findByLibelle(decision)
                        .orElseThrow(() -> new RuntimeException("Décision invalide"));

                ValidationAbsChef validation = new ValidationAbsChef();
                validation.setUser(chef);
                validation.setPresenceAbsence(presence);
                validation.setJustificationRetard(justification);
                validation.setDecisionValidation(dec);
                validation.setDateValidation(LocalDate.now());

                ValidationAbsChef saved = validationAbsChefRepository.save(validation);

                // Mettre à jour le statut de justification
                justification.setEstJustifie("accepté".equals(decision));
                justificationRetardRepository.save(justification);

                // Audit log
                auditLogService.log("validationAbs_chef", saved.getIdValidationAbsChef(), 
                        "VALIDATION_RETARD", idChef, AuditLog.UserType.USER,
                        "Validation retard - Décision: " + decision);

                return saved;
        }

    // ========== RÉCUPÉRER VALIDATION PAR ID ==========
    public ValidationAbsChef getValidationById(Integer id) {
        return validationAbsChefRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Validation non trouvée"));
    }

    // ========== RÉCUPÉRER VALIDATIONS D'UN CHEF ==========
    public List<ValidationAbsChef> getValidationsByChef(Integer idChef) {
        User chef = userRepository.findById(idChef)
                .orElseThrow(() -> new RuntimeException("Chef non trouvé"));
        return validationAbsChefRepository.findByUserOrderByDateValidationDesc(chef);
    }

    // ========== RÉCUPÉRER VALIDATIONS EN ATTENTE RH ==========
    public List<ValidationAbsChef> getValidationsEnAttenteRh() {
        return validationAbsChefRepository.findValidationsEnAttenteRh();
    }

    // ========== RÉCUPÉRER VALIDATIONS PAR DÉPARTEMENT ==========
    public List<ValidationAbsChef> getValidationsByDepartement(Integer idDepartement) {
        return validationAbsChefRepository.findByDepartement(idDepartement);
    }

    // ========== STATISTIQUES ==========
    public long compterValidations(Integer idChef) {
        User chef = userRepository.findById(idChef)
                .orElseThrow(() -> new RuntimeException("Chef non trouvé"));
        return validationAbsChefRepository.countByUser(chef);
    }

    public long compterValidationsAcceptees(Integer idChef) {
        User chef = userRepository.findById(idChef)
                .orElseThrow(() -> new RuntimeException("Chef non trouvé"));
        return validationAbsChefRepository.countValidationsAccepteesByChef(chef);
    }

    public long compterValidationsRefusees(Integer idChef) {
        User chef = userRepository.findById(idChef)
                .orElseThrow(() -> new RuntimeException("Chef non trouvé"));
        return validationAbsChefRepository.countValidationsRefuseesByChef(chef);
    }
}