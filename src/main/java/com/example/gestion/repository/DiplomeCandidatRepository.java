package com.example.gestion.repository;


import com.example.gestion.models.DiplomeCandidat;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface DiplomeCandidatRepository extends JpaRepository<DiplomeCandidat, Integer> {
    
    @Query("SELECT d FROM DiplomeCandidat d WHERE d.candidat.id_candidat = :id")
    List<DiplomeCandidat> findDiplomesByCandidatId(@Param("id") Integer id_candidat);



}
