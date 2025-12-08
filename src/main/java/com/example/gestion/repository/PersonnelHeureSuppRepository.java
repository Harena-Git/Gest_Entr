package com.example.gestion.repository;

import java.time.LocalDate;

import com.example.gestion.models.PersonnelHeureSupp;
import com.example.gestion.models.Personnel;
import com.example.gestion.models.User;
import com.example.gestion.models.HeuresSupplementaire;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

// montant is stored as Double in the entity; use Double for sums

import java.util.List;

@Repository
public interface PersonnelHeureSuppRepository extends JpaRepository<PersonnelHeureSupp, Integer> {

    // Toutes les heures sup d'un personnel
    List<PersonnelHeureSupp> findByPersonnel(Personnel personnel);

    // Toutes les heures sup d'un user
    List<PersonnelHeureSupp> findByUser(User user);

    // Calculer le montant total des heures sup pour un personnel
    @Query("SELECT COALESCE(SUM(phs.heuresSupplementaire.montant), 0) FROM PersonnelHeureSupp phs WHERE phs.personnel = :personnel")
    Double sumMontantsByPersonnel(@Param("personnel") Personnel personnel);

    // Calculer le nombre total d'heures sup pour un personnel
    @Query("SELECT SUM(phs.heuresSupplementaire.nbHeures) FROM PersonnelHeureSupp phs WHERE phs.personnel = :personnel")
    Long sumNbHeuresByPersonnel(@Param("personnel") Personnel personnel);

    // Compter les heures sup d'un personnel
    long countByPersonnel(Personnel personnel);

    // Heures sup par département
    @Query("SELECT phs FROM PersonnelHeureSupp phs " +
           "JOIN phs.personnel p " +
           "JOIN p.poste po " +
           "WHERE po.departement.id_departement = :idDepartement")
    List<PersonnelHeureSupp> findByDepartement(@Param("idDepartement") Integer idDepartement);

    @Query("SELECT phs FROM PersonnelHeureSupp phs " +
           "WHERE (phs.personnel.id_personnel = :employeId OR phs.user.id_user = :employeId) " +
           "AND phs.heuresSupplementaire IS NOT NULL")
    List<PersonnelHeureSupp> findByEmploye(@Param("employeId") Integer employeId);
}