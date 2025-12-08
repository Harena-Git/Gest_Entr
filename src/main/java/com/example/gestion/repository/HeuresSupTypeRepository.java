package com.example.gestion.repository;

import com.example.gestion.models.HeuresSupType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface HeuresSupTypeRepository extends JpaRepository<HeuresSupType, Integer> {

    // Trouver un type d'heures sup par libellé
    Optional<HeuresSupType> findByLibelle(String libelle);

    // Vérifier si un type existe
    boolean existsByLibelle(String libelle);
}