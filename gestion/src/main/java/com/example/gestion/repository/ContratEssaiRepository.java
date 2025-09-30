package com.example.gestion.repository;

import com.example.gestion.models.*;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import  java.util.Optional;

@Repository
public interface ContratEssaiRepository extends JpaRepository<ContratEssai, Integer> {
    Optional<ContratEssai> findByCandidat(Candidat candidat);
}
