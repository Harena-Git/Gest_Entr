package com.example.gestion.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.example.gestion.models.Personnel;
import com.example.gestion.models.SoldeConge;

@Repository
public interface SoldeCongeRepository extends JpaRepository<SoldeConge, Integer> {

    // Trouver le solde par personnel
    Optional<SoldeConge> findByPersonnel(Personnel personnel);

    // Vérifier si un personnel a un solde
    @Query("SELECT CASE WHEN COUNT(s) > 0 THEN true ELSE false END FROM SoldeConge s WHERE s.personnel.id_personnel = :idPersonnel")
    Boolean existsByPersonnelId(@Param("idPersonnel") Integer idPersonnel);

    // Récupérer le solde restant d'un personnel
    @Query("SELECT s.solde_restant FROM SoldeConge s WHERE s.personnel.id_personnel = :idPersonnel")
    Optional<Integer> getSoldeRestantByPersonnel(@Param("idPersonnel") Integer idPersonnel);
}
