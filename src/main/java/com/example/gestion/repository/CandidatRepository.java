package com.example.gestion.repository;

import com.example.gestion.models.Candidat;
import com.example.gestion.models.DiplomeCandidat;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface CandidatRepository extends JpaRepository<Candidat, Integer> {
     @Query("""
        SELECT c
        FROM Candidat c
        JOIN Personnel p ON c = p.candidat
        JOIN Poste po ON p.poste = po
        JOIN Annonce a ON po = a.poste
        WHERE 
        a.id_annonce = :annonceId 
         AND a.id_annonce = (
            SELECT MAX(a2.id_annonce)
            FROM Annonce a2
            WHERE a2.poste = po
        )
        """)
    List<Candidat> findRecrutesByAnnonceId(Integer annonceId);

    // Nouvelle méthode : récupérer tous les candidats classés par date_candidature DESC
    @Query("""
        SELECT c
        FROM Candidat c
        ORDER BY c.date_candidature DESC
        """)
    List<Candidat> findAllOrderByDateCandidatureDesc();
}
