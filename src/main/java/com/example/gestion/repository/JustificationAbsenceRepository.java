package com.example.gestion.repository;

import com.example.gestion.models.JustificationAbsence;
import com.example.gestion.models.Personnel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public interface JustificationAbsenceRepository extends JpaRepository<JustificationAbsence, Integer> {

    // Trouver une justification par personnel et date d'absence
    Optional<JustificationAbsence> findByPersonnelAndDateAbsence(Personnel personnel, LocalDate dateAbsence);

    // Toutes les justifications d'un personnel
    List<JustificationAbsence> findByPersonnelOrderByDateDemandeDesc(Personnel personnel);

    // Justifications en attente (non justifiées et sans validation)
    @Query("SELECT ja FROM JustificationAbsence ja WHERE ja.estJustifie = false " +
           "AND NOT EXISTS (SELECT vc FROM ValidationAbsChef vc WHERE vc.justificationAbsence = ja)")
    List<JustificationAbsence> findJustificationsEnAttente();

    // Justifications en attente pour un département
    @Query("SELECT ja FROM JustificationAbsence ja " +
           "JOIN ja.personnel p " +
           "JOIN p.poste po " +
           "WHERE po.departement.id_departement = :idDepartement " +
           "AND ja.estJustifie = false " +
           "AND NOT EXISTS (SELECT vc FROM ValidationAbsChef vc WHERE vc.justificationAbsence = ja)")
    List<JustificationAbsence> findJustificationsEnAttenteByDepartement(@Param("idDepartement") Integer idDepartement);

    // Justifications acceptées
    List<JustificationAbsence> findByEstJustifieTrue();

    // Justifications refusées (validées mais non justifiées)
    @Query("SELECT ja FROM JustificationAbsence ja WHERE ja.estJustifie = false " +
           "AND EXISTS (SELECT vc FROM ValidationAbsChef vc WHERE vc.justificationAbsence = ja)")
    List<JustificationAbsence> findJustificationsRefusees();

    // Justifications sans fichier
    @Query("SELECT ja FROM JustificationAbsence ja WHERE ja.fichierJustification IS NULL OR ja.fichierJustification = ''")
    List<JustificationAbsence> findJustificationsSansFichier();

    // Justifications par période
    @Query("SELECT ja FROM JustificationAbsence ja WHERE ja.dateAbsence BETWEEN :dateDebut AND :dateFin ORDER BY ja.dateAbsence DESC")
    List<JustificationAbsence> findByDateAbsenceBetween(@Param("dateDebut") LocalDate dateDebut, 
                                                          @Param("dateFin") LocalDate dateFin);

    // Compter les absences justifiées d'un personnel
    long countByPersonnelAndEstJustifieTrue(Personnel personnel);

    // Compter les absences non justifiées d'un personnel
    long countByPersonnelAndEstJustifieFalse(Personnel personnel);

    // Vérifier si une justification existe déjà pour une date
    boolean existsByPersonnelAndDateAbsence(Personnel personnel, LocalDate dateAbsence);

    // Trouver les justifications d'absence par personnel et période
@Query("SELECT ja FROM JustificationAbsence ja WHERE ja.personnel = :personnel " +
       "AND ja.dateAbsence BETWEEN :dateDebut AND :dateFin")
List<JustificationAbsence> findByPersonnelAndDateAbsenceBetween(@Param("personnel") Personnel personnel,
                                                               @Param("dateDebut") LocalDate dateDebut,
                                                               @Param("dateFin") LocalDate dateFin);

}