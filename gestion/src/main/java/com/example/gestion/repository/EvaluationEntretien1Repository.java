package com.example.gestion.repository;


import com.example.gestion.models.*;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.Optional;

@Repository
public interface EvaluationEntretien1Repository extends JpaRepository<EvaluationEntretien1, Integer> {
    Optional<EvaluationEntretien1> findByEntretien1(Entretien1 entretien1);
}
