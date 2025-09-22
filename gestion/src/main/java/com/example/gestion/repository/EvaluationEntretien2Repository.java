package com.example.gestion.repository;


import com.example.gestion.models.*;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.Optional;

@Repository
public interface EvaluationEntretien2Repository extends JpaRepository<EvaluationEntretien2, Integer> {
    Optional<EvaluationEntretien2> findByEntretien2(Entretien2 entretien2);
}

