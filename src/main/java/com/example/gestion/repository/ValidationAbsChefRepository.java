package com.example.gestion.repository;

import com.example.gestion.models.ValidationAbsChef;
import com.example.gestion.models.User;
import com.example.gestion.models.PresenceAbsence;
import com.example.gestion.models.JustificationAbsence;
import com.example.gestion.models.JustificationRetard;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public interface ValidationAbsChefRepository extends JpaRepository<ValidationAbsChef, Integer> {

    // Trouver validation par présence
    Optional<ValidationAbsChef> findByPresenceAbsence(PresenceAbsence presenceAbsence);

    // Trouver validation par justification d'absence
    Optional<ValidationAbsChef> findByJustificationAbsence(JustificationAbsence justificationAbsence);

    // Trouver validation par justification de retard
    Optional<ValidationAbsChef> findByJustificationRetard(JustificationRetard justificationRetard);

    // Toutes les validations d'un chef
    List<ValidationAbsChef> findByUserOrderByDateValidationDesc(User user);

    // Validations d'un chef sur une période
    @Query("SELECT vc FROM ValidationAbsChef vc WHERE vc.user = :user " +
           "AND vc.dateValidation BETWEEN :dateDebut AND :dateFin ORDER BY vc.dateValidation DESC")
    List<ValidationAbsChef> findByUserAndDateValidationBetween(@Param("user") User user, 
                                                                 @Param("dateDebut") LocalDate dateDebut, 
                                                                 @Param("dateFin") LocalDate dateFin);

    // Validations acceptées par un chef
    @Query("SELECT vc FROM ValidationAbsChef vc JOIN vc.decisionValidation dv " +
           "WHERE vc.user = :user AND dv.libelle = 'accepté' ORDER BY vc.dateValidation DESC")
    List<ValidationAbsChef> findValidationsAccepteesByChef(@Param("user") User user);

    // Validations refusées par un chef
    @Query("SELECT vc FROM ValidationAbsChef vc JOIN vc.decisionValidation dv " +
           "WHERE vc.user = :user AND dv.libelle = 'refusé' ORDER BY vc.dateValidation DESC")
    List<ValidationAbsChef> findValidationsRefuseesByChef(@Param("user") User user);

    // Validations en attente de validation RH
    @Query("SELECT vc FROM ValidationAbsChef vc WHERE NOT EXISTS " +
           "(SELECT vr FROM ValidationAbsRh vr WHERE vr.validationAbsChef = vc)")
    List<ValidationAbsChef> findValidationsEnAttenteRh();

    // Validations d'un département
    @Query("SELECT vc FROM ValidationAbsChef vc " +
           "JOIN vc.user u " +
           "WHERE u.departement.id_departement = :idDepartement " +
           "ORDER BY vc.dateValidation DESC")
    List<ValidationAbsChef> findByDepartement(@Param("idDepartement") Integer idDepartement);

    // Validations d'un département en attente RH
    @Query("SELECT vc FROM ValidationAbsChef vc " +
           "JOIN vc.user u " +
           "WHERE u.departement.id_departement = :idDepartement " +
           "AND NOT EXISTS (SELECT vr FROM ValidationAbsRh vr WHERE vr.validationAbsChef = vc)")
    List<ValidationAbsChef> findValidationsEnAttenteRhByDepartement(@Param("idDepartement") Integer idDepartement);

    // Compter les validations d'un chef
    long countByUser(User user);

    // Compter les validations acceptées d'un chef
    @Query("SELECT COUNT(vc) FROM ValidationAbsChef vc JOIN vc.decisionValidation dv " +
           "WHERE vc.user = :user AND dv.libelle = 'accepté'")
    long countValidationsAccepteesByChef(@Param("user") User user);

    // Compter les validations refusées d'un chef
    @Query("SELECT COUNT(vc) FROM ValidationAbsChef vc JOIN vc.decisionValidation dv " +
           "WHERE vc.user = :user AND dv.libelle = 'refusé'")
    long countValidationsRefuseesByChef(@Param("user") User user);
}