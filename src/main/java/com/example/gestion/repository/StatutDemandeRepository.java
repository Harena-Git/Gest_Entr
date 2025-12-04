package com.example.gestion.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.example.gestion.models.StatutDemande;

@Repository
public interface StatutDemandeRepository extends JpaRepository<StatutDemande, Integer> {

    // Trouver un statut par libellé
    Optional<StatutDemande> findByLibelle(String libelle);

    // Vérifier si un statut existe
    @Query("SELECT CASE WHEN COUNT(s) > 0 THEN true ELSE false END FROM StatutDemande s WHERE s.libelle = :libelle")
    Boolean existsByLibelle(@Param("libelle") String libelle);
}
