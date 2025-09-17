package com.example.gestion.repository;


import com.example.gestion.models.HistoriqueEtat;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface HistoriqueEtatRepository extends JpaRepository<HistoriqueEtat, Integer> {
}

