package com.example.gestion.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.gestion.models.HistoriquePoste;
import com.example.gestion.models.Personnel;

@Repository
public interface HistoriquePosteRepository extends JpaRepository<HistoriquePoste, Integer> {
    List<HistoriquePoste> findByPersonnelOrderByDateDebutDesc(Personnel personnel);
    List<HistoriquePoste> findByTypeMouvement(String typeMouvement);
}
