package com.example.gestion.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.gestion.models.TypeContrat;

@Repository
public interface TypeContratRepository extends JpaRepository<TypeContrat, Integer> {
}
