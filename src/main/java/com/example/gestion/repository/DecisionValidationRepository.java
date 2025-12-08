package com.example.gestion.repository;

import com.example.gestion.models.DecisionValidation;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface DecisionValidationRepository extends JpaRepository<DecisionValidation, Integer> {

    // Trouver une décision par libellé
    Optional<DecisionValidation> findByLibelle(String libelle);

    // Vérifier si une décision existe
    boolean existsByLibelle(String libelle);
}