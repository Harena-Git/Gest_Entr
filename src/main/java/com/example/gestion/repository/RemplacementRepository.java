package com.example.gestion.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.example.gestion.models.DemandeConge;
import com.example.gestion.models.Personnel;
import com.example.gestion.models.Remplacement;

@Repository
public interface RemplacementRepository extends JpaRepository<Remplacement, Integer> {

    // Trouver le remplacement d'une demande
    Optional<Remplacement> findByDemandeConge(DemandeConge demandeConge);

    // Trouver les remplaçants d'un personnel
    List<Remplacement> findByPersonnel(Personnel personnel);

    // Trouver les remplaçants qui n'ont pas accepté
    @Query("SELECT r FROM Remplacement r WHERE r.remplacant_accepte = false")
    List<Remplacement> findUnacceptedRemplacements();

    // Trouver les remplaçants qui n'ont pas été notifiés
    @Query("SELECT r FROM Remplacement r WHERE r.notifiee = false")
    List<Remplacement> findNotNotifiedRemplacements();

    // Vérifier si un personnel a été assigné comme remplaçant pour une période
    @Query("SELECT CASE WHEN COUNT(r) > 0 THEN true ELSE false END FROM Remplacement r " +
           "WHERE r.personnel.id_personnel = :idPersonnel " +
           "AND r.demandeConge.date_debut <= :fin " +
           "AND r.demandeConge.date_fin >= :debut")
    Boolean hasConflictingReplacement(@Param("idPersonnel") Integer idPersonnel,
                                      @Param("debut") java.util.Date debut,
                                      @Param("fin") java.util.Date fin);
}
