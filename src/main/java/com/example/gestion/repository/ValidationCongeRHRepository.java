package com.example.gestion.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.example.gestion.models.ValidationCongeChef;
import com.example.gestion.models.ValidationCongeRH;

@Repository
public interface ValidationCongeRHRepository extends JpaRepository<ValidationCongeRH, Integer> {

    // Trouver la validation RH d'une validation chef
    Optional<ValidationCongeRH> findByValidationCongeChef(ValidationCongeChef validationChef);

    // Vérifier si une validation chef a déjà une validation RH
    @Query("SELECT CASE WHEN COUNT(v) > 0 THEN true ELSE false END FROM ValidationCongeRH v " +
           "WHERE v.validationCongeChef.id_validation_conge_chef = :idValChef")
    Boolean existsByValidationChefId(@Param("idValChef") Integer idValChef);
}
