package com.example.gestion.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.example.gestion.models.DemandeConge;
import com.example.gestion.models.ValidationCongeChef;

@Repository
public interface ValidationCongeChefRepository extends JpaRepository<ValidationCongeChef, Integer> {

    // Trouver la validation chef d'une demande
    Optional<ValidationCongeChef> findByDemandeConge(DemandeConge demandeConge);

    // Vérifier si une demande a déjà été validée par le chef
    @Query("SELECT CASE WHEN COUNT(v) > 0 THEN true ELSE false END FROM ValidationCongeChef v " +
           "WHERE v.demandeConge.id_demande_conge = :idDemande")
    Boolean existsByDemandeId(@Param("idDemande") Integer idDemande);
}
