package com.example.gestion.services;

import com.example.gestion.models.HeuresSupType;
import com.example.gestion.models.AuditLog;
import com.example.gestion.repository.HeuresSupTypeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class HeuresSupTypeService {

    @Autowired
    private HeuresSupTypeRepository heuresSupTypeRepository;

    @Autowired
    private AuditLogService auditLogService;

    // ========== CRÉER TYPE HEURES SUP ==========
    public HeuresSupType creerTypeHeuresSup(String libelle, Double taux, Integer userId) {
        // Vérifier si le type existe déjà
        if (heuresSupTypeRepository.existsByLibelle(libelle)) {
            throw new RuntimeException("Un type avec ce libellé existe déjà");
        }

        HeuresSupType type = new HeuresSupType();
        type.setLibelle(libelle);
        type.setTaux(taux);

        HeuresSupType saved = heuresSupTypeRepository.save(type);

        // Audit log
        auditLogService.log("heures_sup_type", saved.getIdHeuresSup(), 
                "CREATE", userId, AuditLog.UserType.USER,
                "Création type heures sup: " + libelle + " (taux: " + taux + ")");

        return saved;
    }

    // ========== MODIFIER TYPE HEURES SUP ==========
    public HeuresSupType modifierTypeHeuresSup(Integer id, String libelle, Double taux, Integer userId) {
        HeuresSupType type = heuresSupTypeRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Type d'heures sup non trouvé"));

        type.setLibelle(libelle);
        type.setTaux(taux);

        HeuresSupType saved = heuresSupTypeRepository.save(type);

        // Audit log
        auditLogService.log("heures_sup_type", id, 
                "UPDATE", userId, AuditLog.UserType.USER,
                "Modification type heures sup: " + libelle);

        return saved;
    }

    // ========== RÉCUPÉRER TYPE PAR ID ==========
    public HeuresSupType getTypeById(Integer id) {
        return heuresSupTypeRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Type d'heures sup non trouvé"));
    }

    // ========== RÉCUPÉRER TYPE PAR LIBELLÉ ==========
    public HeuresSupType getTypeByLibelle(String libelle) {
        return heuresSupTypeRepository.findByLibelle(libelle)
                .orElseThrow(() -> new RuntimeException("Type d'heures sup non trouvé"));
    }

    // ========== RÉCUPÉRER TOUS LES TYPES ==========
    public List<HeuresSupType> getTousLesTypes() {
        return heuresSupTypeRepository.findAll();
    }

    // ========== SUPPRIMER TYPE ==========
    public void supprimerType(Integer id, Integer userId) {
        HeuresSupType type = getTypeById(id);
        
        // Vérifier s'il n'y a pas d'heures sup associées
        if (type.getHeuresSupplementaires() != null && !type.getHeuresSupplementaires().isEmpty()) {
            throw new RuntimeException("Impossible de supprimer ce type, des heures supplémentaires y sont associées");
        }

        heuresSupTypeRepository.delete(type);

        // Audit log
        auditLogService.log("heures_sup_type", id, "DELETE", userId, 
                AuditLog.UserType.USER,
                "Suppression type heures sup: " + type.getLibelle());
    }
}