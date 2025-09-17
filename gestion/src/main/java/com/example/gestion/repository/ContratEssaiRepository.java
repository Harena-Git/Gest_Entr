package com.example.gestion.repository;

import com.example.gestion.models.ContratEssai;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ContratEssaiRepository extends JpaRepository<ContratEssai, Integer> {
}
