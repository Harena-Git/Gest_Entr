package com.example.gestion.repository;

import com.example.gestion.models.*;
import com.example.gestion.dto.*;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import jakarta.transaction.Transactional;
import java.util.List;

@Repository
public interface ImpotRepository extends JpaRepository<Impot, Integer> {
    Impot findByPersonnelAndMoisAndAnnee(Personnel personnel, int mois, int annee);
    @Modifying
    @Transactional
    @Query("UPDATE Impot i SET i.impotDu = :impotDu WHERE i.id = :id")
    void updateImpotDuById(@Param("id") Integer id, @Param("impotDu") Double impotDu);
}