package com.example.gestion.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.example.gestion.models.Personnel;

@Repository
public interface PersonnelRepository extends JpaRepository<Personnel, Integer> {
    Optional<Personnel> findByUsername(String username);
    
    @Query("SELECT p FROM Personnel p WHERE p.poste.departement.id_departement = :departementId")
    List<Personnel> findByPoste_departement_id_departement(@Param("departementId") Integer departementId);
}
