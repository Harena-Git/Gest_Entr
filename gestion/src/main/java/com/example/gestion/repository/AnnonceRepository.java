package com.example.gestion.repository;

import com.example.gestion.models.Annonce;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface AnnonceRepository extends JpaRepository<Annonce, Integer> {
    @Query("SELECT a.poste.departement.departement FROM Annonce a WHERE a.id_annonce = :idAnnonce")
    String findDepartementByIdAnnonce(@Param("idAnnonce") Integer idAnnonce);
}
