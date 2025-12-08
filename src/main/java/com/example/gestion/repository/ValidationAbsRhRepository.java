package com.example.gestion.repository;

import com.example.gestion.models.ValidationAbsRh;
import com.example.gestion.models.ValidationAbsChef;
import com.example.gestion.models.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public interface ValidationAbsRhRepository extends JpaRepository<ValidationAbsRh, Integer> {

    // Trouver validation RH par validation chef
    Optional<ValidationAbsRh> findByValidationAbsChef(ValidationAbsChef validationAbsChef);

    // Toutes les validations d'un RH
    List<ValidationAbsRh> findByUserOrderByDateValidationDesc(User user);

    // Validations RH sur une période
    @Query("SELECT vr FROM ValidationAbsRh vr WHERE vr.user = :user " +
           "AND vr.dateValidation BETWEEN :dateDebut AND :dateFin ORDER BY vr.dateValidation DESC")
    List<ValidationAbsRh> findByUserAndDateValidationBetween(@Param("user") User user, 
                                                               @Param("dateDebut") LocalDate dateDebut, 
                                                               @Param("dateFin") LocalDate dateFin);

    // Validations acceptées par RH
    @Query("SELECT vr FROM ValidationAbsRh vr JOIN vr.decisionValidation dv " +
           "WHERE vr.user = :user AND dv.libelle = 'accepté' ORDER BY vr.dateValidation DESC")
    List<ValidationAbsRh> findValidationsAccepteesByRh(@Param("user") User user);

    // Validations refusées par RH
    @Query("SELECT vr FROM ValidationAbsRh vr JOIN vr.decisionValidation dv " +
           "WHERE vr.user = :user AND dv.libelle = 'refusé' ORDER BY vr.dateValidation DESC")
    List<ValidationAbsRh> findValidationsRefuseesByRh(@Param("user") User user);

    // Toutes les validations RH (pour audit)
    @Query("SELECT vr FROM ValidationAbsRh vr ORDER BY vr.dateValidation DESC")
    List<ValidationAbsRh> findAllOrderByDateValidationDesc();

    // Validations RH qui contredisent le chef
    @Query("SELECT vr FROM ValidationAbsRh vr " +
           "JOIN vr.validationAbsChef vc " +
           "WHERE vr.decisionValidation.idDecisionValidation != vc.decisionValidation.idDecisionValidation")
    List<ValidationAbsRh> findValidationsContradictoires();

    // Validations RH par département
    @Query("SELECT vr FROM ValidationAbsRh vr " +
           "JOIN vr.validationAbsChef vc " +
           "JOIN vc.user u " +
           "WHERE u.departement.id_departement = :idDepartement " +
           "ORDER BY vr.dateValidation DESC")
    List<ValidationAbsRh> findByDepartement(@Param("idDepartement") Integer idDepartement);

    // Compter les validations d'un RH
    long countByUser(User user);

    // Compter les validations acceptées d'un RH
    @Query("SELECT COUNT(vr) FROM ValidationAbsRh vr JOIN vr.decisionValidation dv " +
           "WHERE vr.user = :user AND dv.libelle = 'accepté'")
    long countValidationsAccepteesByRh(@Param("user") User user);

    // Compter les validations refusées d'un RH
    @Query("SELECT COUNT(vr) FROM ValidationAbsRh vr JOIN vr.decisionValidation dv " +
           "WHERE vr.user = :user AND dv.libelle = 'refusé'")
    long countValidationsRefuseesByRh(@Param("user") User user);
}