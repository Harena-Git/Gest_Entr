package com.example.gestion.services;

import com.example.gestion.models.*;
import com.example.gestion.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;

@Service
@Transactional
public class ValidationAbsRhService {

    @Autowired
    private ValidationAbsRhRepository validationAbsRhRepository;

    @Autowired
    private ValidationAbsChefRepository validationAbsChefRepository;

    @Autowired
    private DecisionValidationRepository decisionValidationRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private AuditLogService auditLogService;

    // ========== VALIDER DÉCISION CHEF ==========
    public ValidationAbsRh validerDecisionChef(Integer idRh, Integer idValidationChef, String decision) {
        User rh = userRepository.findById(idRh)
                .orElseThrow(() -> new RuntimeException("RH non trouvé"));

        // Vérifier que c'est bien un RH
        if (!"Responsable RH".equals(rh.getRole().getLibelle())) {
            throw new RuntimeException("Seul un RH peut effectuer cette validation");
        }

        ValidationAbsChef validationChef = validationAbsChefRepository.findById(idValidationChef)
                .orElseThrow(() -> new RuntimeException("Validation chef non trouvée"));

        // Vérifier qu'il n'y a pas déjà une validation RH
        if (validationAbsRhRepository.findByValidationAbsChef(validationChef).isPresent()) {
            throw new RuntimeException("Cette validation a déjà été traitée par les RH");
        }

        DecisionValidation dec = decisionValidationRepository.findByLibelle(decision)
                .orElseThrow(() -> new RuntimeException("Décision invalide"));

        ValidationAbsRh validation = new ValidationAbsRh();
        validation.setUser(rh);
        validation.setValidationAbsChef(validationChef);
        validation.setDecisionValidation(dec);
        validation.setDateValidation(LocalDate.now());

        ValidationAbsRh saved = validationAbsRhRepository.save(validation);

        // Audit log
        String typeValidation = validationChef.getTypeJustification();
        auditLogService.log("validationAbs_Rh", saved.getIdValidationAbsRh(), 
                "VALIDATION_RH", idRh, AuditLog.UserType.USER,
                "Validation RH (" + typeValidation + ") - Décision: " + decision);

        return saved;
    }

    // ========== RÉCUPÉRER VALIDATION PAR ID ==========
    public ValidationAbsRh getValidationById(Integer id) {
        return validationAbsRhRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Validation RH non trouvée"));
    }

    // ========== RÉCUPÉRER VALIDATIONS D'UN RH ==========
    public List<ValidationAbsRh> getValidationsByRh(Integer idRh) {
        User rh = userRepository.findById(idRh)
                .orElseThrow(() -> new RuntimeException("RH non trouvé"));
        return validationAbsRhRepository.findByUserOrderByDateValidationDesc(rh);
    }

    // ========== RÉCUPÉRER TOUTES LES VALIDATIONS RH ==========
    public List<ValidationAbsRh> getToutesLesValidationsRh() {
        return validationAbsRhRepository.findAllOrderByDateValidationDesc();
    }

    // ========== RÉCUPÉRER VALIDATIONS CONTRADICTOIRES ==========
    public List<ValidationAbsRh> getValidationsContradictoires() {
        return validationAbsRhRepository.findValidationsContradictoires();
    }

    // ========== RÉCUPÉRER VALIDATIONS PAR DÉPARTEMENT ==========
    public List<ValidationAbsRh> getValidationsByDepartement(Integer idDepartement) {
        return validationAbsRhRepository.findByDepartement(idDepartement);
    }

    // ========== STATISTIQUES ==========
    public long compterValidations(Integer idRh) {
        User rh = userRepository.findById(idRh)
                .orElseThrow(() -> new RuntimeException("RH non trouvé"));
        return validationAbsRhRepository.countByUser(rh);
    }

    public long compterValidationsAcceptees(Integer idRh) {
        User rh = userRepository.findById(idRh)
                .orElseThrow(() -> new RuntimeException("RH non trouvé"));
        return validationAbsRhRepository.countValidationsAccepteesByRh(rh);
    }

    public long compterValidationsRefusees(Integer idRh) {
        User rh = userRepository.findById(idRh)
                .orElseThrow(() -> new RuntimeException("RH non trouvé"));
        return validationAbsRhRepository.countValidationsRefuseesByRh(rh);
    }
}