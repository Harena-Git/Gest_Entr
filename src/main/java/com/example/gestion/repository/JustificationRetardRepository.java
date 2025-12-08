package com.example.gestion.repository;

import com.example.gestion.models.JustificationRetard;
import com.example.gestion.models.Personnel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public interface JustificationRetardRepository extends JpaRepository<JustificationRetard, Integer> {

    // Trouver une justification par personnel et date de retard
    Optional<JustificationRetard> findByPersonnelAndDateRetard(Personnel personnel, LocalDate dateRetard);

    // Toutes les justifications d'un personnel
    List<JustificationRetard> findByPersonnelOrderByDateRetardDesc(Personnel personnel);

    // Justifications en attente (non justifiées et sans validation)
    @Query("SELECT jr FROM JustificationRetard jr WHERE jr.estJustifie = false " +
           "AND NOT EXISTS (SELECT vc FROM ValidationAbsChef vc WHERE vc.justificationRetard = jr)")
    List<JustificationRetard> findJustificationsEnAttente();

    // Justifications en attente pour un département
    @Query("SELECT jr FROM JustificationRetard jr " +
           "JOIN jr.personnel p " +
           "JOIN p.poste po " +
           "WHERE po.departement.id_departement = :idDepartement " +
           "AND jr.estJustifie = false " +
           "AND NOT EXISTS (SELECT vc FROM ValidationAbsChef vc WHERE vc.justificationRetard = jr)")
    List<JustificationRetard> findJustificationsEnAttenteByDepartement(@Param("idDepartement") Integer idDepartement);

    // Justifications acceptées
    List<JustificationRetard> findByEstJustifieTrue();

    // Justifications refusées
    @Query("SELECT jr FROM JustificationRetard jr WHERE jr.estJustifie = false " +
           "AND EXISTS (SELECT vc FROM ValidationAbsChef vc WHERE vc.justificationRetard = jr)")
    List<JustificationRetard> findJustificationsRefusees();

    // Retards significatifs (>= 15 minutes) en attente
    @Query("SELECT jr FROM JustificationRetard jr WHERE jr.minutesRetard >= 15 " +
           "AND jr.estJustifie = false " +
           "AND NOT EXISTS (SELECT vc FROM ValidationAbsChef vc WHERE vc.justificationRetard = jr)")
    List<JustificationRetard> findRetardsSignificatifsEnAttente();

    // Justifications par période
    @Query("SELECT jr FROM JustificationRetard jr WHERE jr.dateRetard BETWEEN :dateDebut AND :dateFin ORDER BY jr.dateRetard DESC")
    List<JustificationRetard> findByDateRetardBetween(@Param("dateDebut") LocalDate dateDebut, 
                                                        @Param("dateFin") LocalDate dateFin);

    // Somme des minutes de retard pour un personnel sur une période
    @Query("SELECT SUM(jr.minutesRetard) FROM JustificationRetard jr WHERE jr.personnel = :personnel " +
           "AND jr.dateRetard BETWEEN :dateDebut AND :dateFin")
    Long sumMinutesRetardByPersonnelAndPeriode(@Param("personnel") Personnel personnel, 
                                                 @Param("dateDebut") LocalDate dateDebut, 
                                                 @Param("dateFin") LocalDate dateFin);

    // Compter les retards justifiés d'un personnel
    long countByPersonnelAndEstJustifieTrue(Personnel personnel);

    // Compter les retards non justifiés d'un personnel
    long countByPersonnelAndEstJustifieFalse(Personnel personnel);

    // Vérifier si une justification existe déjà pour une date
    boolean existsByPersonnelAndDateRetard(Personnel personnel, LocalDate dateRetard);

    // Trouver les justifications de retard par personnel et période  
@Query("SELECT jr FROM JustificationRetard jr WHERE jr.personnel = :personnel " +
       "AND jr.dateRetard BETWEEN :dateDebut AND :dateFin")
List<JustificationRetard> findByPersonnelAndDateRetardBetween(@Param("personnel") Personnel personnel,
                                                             @Param("dateDebut") LocalDate dateDebut,
                                                             @Param("dateFin") LocalDate dateFin);

}