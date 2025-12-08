package com.example.gestion.repository;

import com.example.gestion.models.PresenceAbsence;
import com.example.gestion.models.Personnel;
import com.example.gestion.models.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

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


    // Trouver la présence d'un personnel pour une date donnée
    Optional<PresenceAbsence> findByPersonnelAndDate(Personnel personnel, LocalDate date);

       // Trouver la présence d'un personnel pour une date donnée (par id)
       @Query("SELECT pa FROM PresenceAbsence pa WHERE pa.personnel.id_personnel = :personnelId AND pa.date = :date")
       Optional<PresenceAbsence> findByPersonnelIdAndDate(@Param("personnelId") Integer personnelId, @Param("date") LocalDate date);

    // Trouver la présence d'un user pour une date donnée
    Optional<PresenceAbsence> findByUserAndDate(User user, LocalDate date);

    // Vérifier si une entrée existe déjà pour un personnel à une date
    @Query("SELECT COUNT(pa) > 0 FROM PresenceAbsence pa WHERE pa.personnel = :personnel AND pa.date = :date AND pa.heureArrivee IS NOT NULL")
    boolean existsEntreeByPersonnelAndDate(@Param("personnel") Personnel personnel, @Param("date") LocalDate date);

    // Vérifier si une entrée existe déjà pour un user à une date
    @Query("SELECT COUNT(pa) > 0 FROM PresenceAbsence pa WHERE pa.user = :user AND pa.date = :date AND pa.heureArrivee IS NOT NULL")
    boolean existsEntreeByUserAndDate(@Param("user") User user, @Param("date") LocalDate date);

    // Récupérer toutes les présences d'un personnel
    List<PresenceAbsence> findByPersonnelOrderByDateDesc(Personnel personnel);

    // Récupérer les présences d'un personnel sur une période
    @Query("SELECT pa FROM PresenceAbsence pa WHERE pa.personnel = :personnel AND pa.date BETWEEN :dateDebut AND :dateFin ORDER BY pa.date DESC")
    List<PresenceAbsence> findByPersonnelAndDateBetween(@Param("personnel") Personnel personnel, 
                                                          @Param("dateDebut") LocalDate dateDebut, 
                                                          @Param("dateFin") LocalDate dateFin);

    // Récupérer toutes les présences du jour pour un département
    @Query("SELECT pa FROM PresenceAbsence pa " +
           "LEFT JOIN pa.personnel p " +
           "LEFT JOIN p.poste po " +
           "LEFT JOIN pa.user u " +
           "WHERE (po.departement.id_departement = :idDepartement OR u.departement.id_departement = :idDepartement) " +
           "AND pa.date = :date " +
           "ORDER BY pa.heureArrivee")
    List<PresenceAbsence> findByDepartementAndDate(@Param("idDepartement") Integer idDepartement, 
                                                     @Param("date") LocalDate date);

    // Récupérer toutes les présences du jour
    List<PresenceAbsence> findByDate(LocalDate date);

    // Présences sans sortie (oubli de pointage sortie)
    @Query("SELECT pa FROM PresenceAbsence pa WHERE pa.heureArrivee IS NOT NULL AND pa.heureDepart IS NULL AND pa.date < :date")
    List<PresenceAbsence> findPresencesSansSortie(@Param("date") LocalDate date);

    // Présences avec retard
    // Note: This method needs to be called with HoraireEntreprise filtering in the service layer
    @Query("SELECT pa FROM PresenceAbsence pa WHERE pa.date = :date AND pa.heureArrivee IS NOT NULL")
    List<PresenceAbsence> findPresencesAvecRetard(@Param("date") LocalDate date);

    // Présences en attente de validation chef
    @Query("SELECT pa FROM PresenceAbsence pa " +
           "WHERE pa.present = true " +
           "AND NOT EXISTS (SELECT vc FROM ValidationAbsChef vc WHERE vc.presenceAbsence = pa)")
    List<PresenceAbsence> findPresencesEnAttenteValidationChef();

    // Présences validées par chef mais pas par RH
    @Query("SELECT pa FROM PresenceAbsence pa " +
           "WHERE EXISTS (SELECT vc FROM ValidationAbsChef vc WHERE vc.presenceAbsence = pa) " +
           "AND NOT EXISTS (SELECT vr FROM ValidationAbsRh vr JOIN vr.validationAbsChef vc WHERE vc.presenceAbsence = pa)")
    List<PresenceAbsence> findPresencesEnAttenteValidationRh();

    // Présences d'un département en attente de validation chef
    @Query("SELECT pa FROM PresenceAbsence pa " +
           "LEFT JOIN pa.personnel p " +
           "LEFT JOIN p.poste po " +
           "WHERE po.departement.id_departement = :idDepartement " +
           "AND pa.present = true " +
           "AND NOT EXISTS (SELECT vc FROM ValidationAbsChef vc WHERE vc.presenceAbsence = pa)")
    List<PresenceAbsence> findPresencesEnAttenteValidationChefByDepartement(@Param("idDepartement") Integer idDepartement);

    // Compter les présences d'un personnel sur une période
    @Query("SELECT COUNT(pa) FROM PresenceAbsence pa WHERE pa.personnel = :personnel AND pa.date BETWEEN :dateDebut AND :dateFin AND pa.present = true")
    long countPresencesByPersonnelAndPeriode(@Param("personnel") Personnel personnel, 
                                              @Param("dateDebut") LocalDate dateDebut, 
                                              @Param("dateFin") LocalDate dateFin);

    // Compter les absences d'un personnel sur une période
    @Query("SELECT COUNT(pa) FROM PresenceAbsence pa WHERE pa.personnel = :personnel AND pa.date BETWEEN :dateDebut AND :dateFin AND (pa.present = false OR pa.present IS NULL)")
    long countAbsencesByPersonnelAndPeriode(@Param("personnel") Personnel personnel, 
                                             @Param("dateDebut") LocalDate dateDebut, 
                                             @Param("dateFin") LocalDate dateFin);

    @Query("SELECT pa FROM PresenceAbsence pa WHERE pa.date BETWEEN :dateDebut AND :dateFin ORDER BY pa.date DESC")
    List<PresenceAbsence> findByDateBetween(@Param("dateDebut") LocalDate dateDebut, 
                                           @Param("dateFin") LocalDate dateFin);
                                           
    @Query("SELECT pa FROM PresenceAbsence pa " +
           "LEFT JOIN pa.personnel p " +
           "LEFT JOIN p.poste po " +
           "LEFT JOIN pa.user u " +
           "WHERE (po.departement.id_departement = :idDepartement OR u.departement.id_departement = :idDepartement) " +
           "AND pa.date BETWEEN :dateDebut AND :dateFin " +
           "ORDER BY pa.date DESC")
    List<PresenceAbsence> findByDepartementAndDateBetween(@Param("idDepartement") Integer idDepartement,
                                                         @Param("dateDebut") LocalDate dateDebut,
                                                         @Param("dateFin") LocalDate dateFin);

    @Query("SELECT DISTINCT pa.user, COUNT(pa) FROM PresenceAbsence pa " +
           "WHERE pa.user IS NOT NULL AND pa.date BETWEEN :debutMois AND :finMois " +
           "GROUP BY pa.user")
    List<Object[]> findDistinctUsersWithPresenceInPeriod(@Param("debutMois") LocalDate debutMois, 
                                                         @Param("finMois") LocalDate finMois);

    List<PresenceAbsence> findByUserAndDateBetween(User user, LocalDate debut, LocalDate fin);

    @Query("SELECT pa FROM PresenceAbsence pa " +
           "LEFT JOIN FETCH pa.validationsChef vc " +
           "WHERE pa.idPresenceAbsence = :id")
    PresenceAbsence findWithValidations(@Param("id") Integer id);

    @Query(value = "SELECT COALESCE(SUM(ROUND(vps.minutes_supplementaires / 60, 0)), 0) " +
                   "FROM view_heures_sup_possibles vps " +
                   "WHERE vps.Id_personnel = :idPersonnel " +
                   "AND vps.date_ BETWEEN :dateDebut AND :dateFin", 
           nativeQuery = true)
    Double sumHeuresSupplementairesParPersonnel(@Param("idPersonnel") Integer idPersonnel,
                                                 @Param("dateDebut") LocalDate dateDebut,
                                                 @Param("dateFin") LocalDate dateFin);

}