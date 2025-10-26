package com.example.gestion.repository;


import com.example.gestion.models.Reponse;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface ReponseRepository extends JpaRepository<Reponse, Integer> {
    @Query("SELECT r FROM Reponse r WHERE r.candidat.id_candidat = :idCandidat")
    List<Reponse> findByIdCandidat(@Param("idCandidat") Integer idCandidat);
}
