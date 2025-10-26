package com.example.gestion.repository;


import com.example.gestion.models.Entretien2;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface Entretien2Repository extends JpaRepository<Entretien2, Integer> {
}
