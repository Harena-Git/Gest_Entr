package com.example.gestion.repository;


import com.example.gestion.models.Diplome;
import com.example.gestion.models.Filiere;

import com.example.gestion.models.Niveau;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface DiplomeRepository extends JpaRepository<Diplome, Integer> {
      Optional<Diplome> findByNiveauAndFiliere(Niveau niveau, Filiere filiere);
}
