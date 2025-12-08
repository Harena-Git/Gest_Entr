package com.example.gestion.repository;

import com.example.gestion.models.Irsa;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import java.time.LocalDate;
import java.util.List;

@Repository
public interface IrsaRepository extends JpaRepository<Irsa, Long> {
    
    // Trouver les tranches actives à une date donnée
    @Query("SELECT i FROM Irsa i " +
         "WHERE i.estActif = true AND i.dateDebut <= :date " +
        "AND (i.dateFin IS NULL OR i.dateFin >= :date) ORDER BY i.trancheMin ASC")
    List<Irsa> findTranchesActivesByDate(LocalDate date);
    
    // Trouver les tranches actives actuellement
    @Query("SELECT i FROM Irsa i " +
         "WHERE i.estActif = true AND i.dateDebut <= CURRENT_DATE " +
    "AND (i.dateFin IS NULL OR i.dateFin >= CURRENT_DATE) ORDER BY i.trancheMin ASC")
    List<Irsa> findTranchesActivesCourantes();
}