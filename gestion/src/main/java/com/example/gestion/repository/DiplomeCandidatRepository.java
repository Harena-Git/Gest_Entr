package com.example.gestion.repository;


import com.example.gestion.models.DiplomeCandidat;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface DiplomeCandidatRepository extends JpaRepository<DiplomeCandidat, Integer> {
}
