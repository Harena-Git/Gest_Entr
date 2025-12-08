package com.example.gestion.services;

import com.example.gestion.models.AuditLog;
import com.example.gestion.repository.AuditLogRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Service
@Transactional
public class AuditLogService {

    @Autowired
    private AuditLogRepository auditLogRepository;

    // ========== CRÉER LOG ==========
    public AuditLog log(String tableName, Integer recordId, String action, 
                        Integer userId, AuditLog.UserType userType, String details) {
        AuditLog log = new AuditLog();
        log.setTableName(tableName);
        log.setRecordId(recordId);
        log.setAction(action);
        log.setUserId(userId);
        log.setUserType(userType);
        log.setDetails(details);
        log.setTimestamp(LocalDateTime.now());

        return auditLogRepository.save(log);
    }

    // ========== RÉCUPÉRER LOG PAR ID ==========
    public AuditLog getLogById(Integer id) {
        return auditLogRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Log non trouvé"));
    }

    // ========== RÉCUPÉRER LOGS PAR TABLE ==========
    public List<AuditLog> getLogsByTable(String tableName) {
        return auditLogRepository.findByTableNameOrderByTimestampDesc(tableName);
    }

    // ========== RÉCUPÉRER LOGS PAR UTILISATEUR ==========
    public List<AuditLog> getLogsByUser(Integer userId, AuditLog.UserType userType) {
        return auditLogRepository.findByUserIdAndUserTypeOrderByTimestampDesc(userId, userType);
    }

    // ========== RÉCUPÉRER LOGS PAR ACTION ==========
    public List<AuditLog> getLogsByAction(String action) {
        return auditLogRepository.findByActionOrderByTimestampDesc(action);
    }

    // ========== RÉCUPÉRER LOGS PAR TABLE ET RECORD ==========
    public List<AuditLog> getLogsByTableAndRecord(String tableName, Integer recordId) {
        return auditLogRepository.findByTableNameAndRecordIdOrderByTimestampDesc(tableName, recordId);
    }

    // ========== RÉCUPÉRER LOGS PAR PÉRIODE ==========
    public List<AuditLog> getLogsByPeriode(LocalDateTime dateDebut, LocalDateTime dateFin) {
        return auditLogRepository.findByTimestampBetween(dateDebut, dateFin);
    }

    // ========== RÉCUPÉRER LOGS D'UN UTILISATEUR SUR PÉRIODE ==========
    public List<AuditLog> getLogsByUserAndPeriode(Integer userId, AuditLog.UserType userType,
                                                   LocalDateTime dateDebut, LocalDateTime dateFin) {
        return auditLogRepository.findByUserAndTimestampBetween(userId, userType, dateDebut, dateFin);
    }

    // ========== RÉCUPÉRER LES DERNIERS LOGS ==========
    public List<AuditLog> getDerniersLogs() {
        return auditLogRepository.findTop100ByOrderByTimestampDesc();
    }

    // ========== RÉCUPÉRER TOUS LES LOGS ==========
    public List<AuditLog> getTousLesLogs() {
        return auditLogRepository.findAll();
    }
}