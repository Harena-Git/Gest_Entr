package com.example.gestion.repository;

import com.example.gestion.models.AuditLog;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface AuditLogRepository extends JpaRepository<AuditLog, Integer> {

    // Logs par table
    List<AuditLog> findByTableNameOrderByTimestampDesc(String tableName);

    // Logs par utilisateur
    List<AuditLog> findByUserIdAndUserTypeOrderByTimestampDesc(Integer userId, AuditLog.UserType userType);

    // Logs par action
    List<AuditLog> findByActionOrderByTimestampDesc(String action);

    // Logs par table et record
    List<AuditLog> findByTableNameAndRecordIdOrderByTimestampDesc(String tableName, Integer recordId);

    // Logs sur une période
    @Query("SELECT al FROM AuditLog al WHERE al.timestamp BETWEEN :dateDebut AND :dateFin ORDER BY al.timestamp DESC")
    List<AuditLog> findByTimestampBetween(@Param("dateDebut") LocalDateTime dateDebut, 
                                           @Param("dateFin") LocalDateTime dateFin);

    // Derniers logs
    List<AuditLog> findTop100ByOrderByTimestampDesc();

    // Logs d'un utilisateur sur une période
    @Query("SELECT al FROM AuditLog al WHERE al.userId = :userId AND al.userType = :userType " +
           "AND al.timestamp BETWEEN :dateDebut AND :dateFin ORDER BY al.timestamp DESC")
    List<AuditLog> findByUserAndTimestampBetween(@Param("userId") Integer userId, 
                                                   @Param("userType") AuditLog.UserType userType,
                                                   @Param("dateDebut") LocalDateTime dateDebut, 
                                                   @Param("dateFin") LocalDateTime dateFin);
}