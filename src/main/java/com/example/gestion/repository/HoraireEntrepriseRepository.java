package com.example.gestion.repository;

import com.example.gestion.models.HoraireEntreprise;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface HoraireEntrepriseRepository extends JpaRepository<HoraireEntreprise, Integer> {

    // Récupérer l'horaire actif (généralement il n'y en a qu'un seul)
    @Query("SELECT he FROM HoraireEntreprise he ORDER BY he.idHoraire DESC")
    Optional<HoraireEntreprise> findHoraireActif();

    // Trouver le premier horaire (pour compatibilité)
    Optional<HoraireEntreprise> findFirstByOrderByIdHoraireAsc();
}