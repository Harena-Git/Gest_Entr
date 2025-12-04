package com.example.gestion.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.example.gestion.models.DecisionValidation;

@Repository
public interface DecisionValidationRepository extends JpaRepository<DecisionValidation, Integer> {

    // Trouver une décision par libellé
    Optional<DecisionValidation> findByLibelle(String libelle);

    // Vérifier si une décision existe
    @Query("SELECT CASE WHEN COUNT(d) > 0 THEN true ELSE false END FROM DecisionValidation d WHERE d.libelle = :libelle")
    Boolean existsByLibelle(@Param("libelle") String libelle);
}
