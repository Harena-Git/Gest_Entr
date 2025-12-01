package com.example.gestion.repository;

import com.example.gestion.models.HeuresSupplementaire;
import com.example.gestion.models.Personnel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.time.LocalDate;
import java.util.List;

@Repository
public interface HeuresSupplementaireRepository extends JpaRepository<HeuresSupplementaire, Long> {
    
    // Méthode 1: Query explicite avec extraction mois/année
    @Query("SELECT hs FROM HeuresSupplementaire hs WHERE hs.personnel = :personnel AND MONTH(hs.dateHeureSup) = :mois AND YEAR(hs.dateHeureSup) = :annee")
    List<HeuresSupplementaire> findByPersonnelAndMoisAndAnnee(
        @Param("personnel") Personnel personnel,
        @Param("mois") int mois,
        @Param("annee") int annee
    );
    
    // Méthode 2: Alternative avec période
    @Query("SELECT hs FROM HeuresSupplementaire hs WHERE hs.personnel = :personnel AND hs.dateHeureSup BETWEEN :startDate AND :endDate")
    List<HeuresSupplementaire> findByPersonnelAndPeriode(
        @Param("personnel") Personnel personnel,
        @Param("startDate") LocalDate startDate,
        @Param("endDate") LocalDate endDate
    );
    
    // Méthode 3: Basique - par personnel
    List<HeuresSupplementaire> findByPersonnel(Personnel personnel);
}