package com.example.gestion.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.example.gestion.models.HistoriquePoste;
import com.example.gestion.models.Personnel;

@Repository
public interface HistoriquePosteRepository extends JpaRepository<HistoriquePoste, Integer> {
    @Query("SELECT h FROM HistoriquePoste h WHERE h.personnel = :personnel ORDER BY h.date_debut DESC")
    List<HistoriquePoste> findByPersonnelOrderByDateDebutDesc(@Param("personnel") Personnel personnel);
}
