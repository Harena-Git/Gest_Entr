package com.example.gestion.repository;


import com.example.gestion.models.EtatCandidat;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface EtatCandidatRepository extends JpaRepository<EtatCandidat, Integer> {
}
