package com.example.gestion.repository;

import com.example.gestion.models.Candidat;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CandidatRepository extends JpaRepository<Candidat, Integer> {

    @Query("SELECT c FROM Candidat c " +
           "LEFT JOIN c.lieu l " +
           "LEFT JOIN c.diplomesCandidats dc " +
           "WHERE (:nom IS NULL OR LOWER(CONCAT(c.nom, ' ', c.prenom)) LIKE LOWER(CONCAT('%', :nom, '%'))) " +
           "AND (:lieuId IS NULL OR l.id_lieu = :lieuId) " +
           "AND (:experience IS NULL OR c.annee_experience >= :experience) " +
           "AND (:diplomeId IS NULL OR dc.diplome.id_diplome = :diplomeId)")
    List<Candidat> findByCriteria(@Param("nom") String nom,
                                  @Param("lieuId") Integer lieuId,
                                  @Param("experience") Integer experience,
                                  @Param("diplomeId") Integer diplomeId);
}