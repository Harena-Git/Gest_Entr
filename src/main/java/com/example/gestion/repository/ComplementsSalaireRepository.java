package com.example.gestion.repository;

import com.example.gestion.models.*;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;


@Repository
public interface ComplementsSalaireRepository extends JpaRepository<ComplementsSalaire, Integer> {
    List<ComplementsSalaire> findByPersonnelAndMoisAndAnnee(Personnel personnel, int mois, int annee);
}