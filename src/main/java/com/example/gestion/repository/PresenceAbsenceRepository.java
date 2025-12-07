package com.example.gestion.repository;

import com.example.gestion.models.PresenceAbsence;
import org.springframework.data.jpa.repository.*;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface PresenceAbsenceRepository extends JpaRepository<PresenceAbsence, Integer> {
    
   @Query(value = """
        SELECT d.departement,
            COUNT(CASE WHEN pa.present = false THEN 1 END) AS absences,
            COUNT(pa.id_presence_absence) AS total,
            ROUND(
                COUNT(CASE WHEN pa.present = false THEN 1 END) * 100 / NULLIF(COUNT(pa.id_presence_absence), 0), 2
            ) AS taux_absenteisme
        FROM presence_absence pa
        JOIN personnel p ON pa.id_personnel = p.id_personnel
        JOIN poste po ON p.id_poste = po.id_poste
        JOIN departement d ON po.id_departement = d.id_departement
        WHERE pa.date_ BETWEEN :start AND :end
        GROUP BY d.departement
    """, nativeQuery = true)
    List<Object[]> getAbsenceRateByDepartement(@Param("start") java.sql.Date start, 
                                            @Param("end") java.sql.Date end);

    // @Query("SELECT COUNT(pa) FROM PresenceAbsence pa " +
    //        "WHERE pa.date BETWEEN :start AND :end " +
    //        "AND (:deptId IS NULL OR pa.personnel.poste.departement.idDepartement = :deptId)")
    // long countTotalBetween(@Param("start") LocalDate start, @Param("end") LocalDate end, @Param("deptId") Integer deptId);

    // @Query("SELECT COUNT(pa) FROM PresenceAbsence pa " +
    //        "WHERE pa.date BETWEEN :start AND :end AND pa.present = false " +
    //        "AND (:deptId IS NULL OR pa.personnel.poste.departement.idDepartement = :deptId)")
    // long countAbsentsBetween(@Param("start") LocalDate start, @Param("end") LocalDate end, @Param("deptId") Integer deptId);

    //  @Query("SELECT pa FROM PresenceAbsence pa WHERE pa.date_ BETWEEN :start AND :end AND (:departementId IS NULL OR pa.personnel.poste.departement.id_departement = :departementId)")
    // List<PresenceAbsence> findByDateAndDepartement(LocalDate start, LocalDate end, Integer departementId);
}