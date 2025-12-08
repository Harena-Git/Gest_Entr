package com.example.gestion.repository;

import com.example.gestion.models.HeuresSupplementaire;
import com.example.gestion.models.HeuresSupType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

// montant is a Double in the entity, return Double here
import java.util.List;

@Repository
public interface HeuresSupplementaireRepository extends JpaRepository<HeuresSupplementaire, Integer> {

    // Trouver par type
    List<HeuresSupplementaire> findByHeuresSupType(HeuresSupType heuresSupType);

    // Trouver par nombre d'heures minimum
    @Query("SELECT hs FROM HeuresSupplementaire hs WHERE hs.nbHeures >= :nbHeures")
    List<HeuresSupplementaire> findByNbHeuresGreaterThanEqual(@Param("nbHeures") Integer nbHeures);

    // Calculer le montant total des heures sup
    @Query("SELECT COALESCE(SUM(hs.montant), 0) FROM HeuresSupplementaire hs")
    Double sumAllMontants();

    // Calculer le nombre total d'heures sup
    @Query("SELECT SUM(hs.nbHeures) FROM HeuresSupplementaire hs")
    Long sumAllNbHeures();
}