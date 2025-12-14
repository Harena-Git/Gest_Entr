package com.example.gestion.repository;

import java.util.Date;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.example.gestion.models.ContratTravail;
import com.example.gestion.models.Personnel;

@Repository
public interface ContratTravailRepository extends JpaRepository<ContratTravail, Integer> {
    List<ContratTravail> findByPersonnel(Personnel personnel);
    
    @Query("SELECT c FROM ContratTravail c WHERE c.date_alerte <= :date AND c.statut = 'Actif'")
    List<ContratTravail> findContratsExpirantAvant(Date date);
    
    List<ContratTravail> findByStatut(String statut);
}
