package com.example.gestion.repository;

import com.example.gestion.models.*;
import com.example.gestion.dto.*;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface FichePaieRepository extends JpaRepository<FichePaie, Long> {
    List<FichePaie> findByPersonnel(Personnel personnel);
    FichePaie findByPersonnelAndMoisAndAnnee(Personnel personnel, int mois, int annee);
}