package com.example.gestion.repository;


import com.example.gestion.models.Niveau;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface NiveauRepository extends JpaRepository<Niveau, Integer> {
    // Tu peux ajouter des méthodes personnalisées si nécessaire, par exemple :
    Niveau findByLibelle(String libelle);
}
