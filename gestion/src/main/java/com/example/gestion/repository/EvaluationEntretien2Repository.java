package com.example.gestion.repository;


import com.example.gestion.models.EvaluationEntretien2;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface EvaluationEntretien2Repository extends JpaRepository<EvaluationEntretien2, Integer> {
}

