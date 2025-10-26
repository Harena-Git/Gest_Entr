package com.example.gestion.repository;


import com.example.gestion.models.Entretien1;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface Entretien1Repository extends JpaRepository<Entretien1, Integer> {
}
