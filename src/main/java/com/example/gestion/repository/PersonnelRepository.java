package com.example.gestion.repository;


import com.example.gestion.models.Personnel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface PersonnelRepository extends JpaRepository<Personnel, Integer> {

        @Query("SELECT p FROM Personnel p WHERE (:departementId IS NULL OR p.poste.departement.id_departement = :departementId)")
        List<Personnel> findByDepartementOptional(Integer departementId);

        @Query("SELECT p FROM Personnel p")
        List<Personnel> findAllPersonnel();

        @Query("""
        SELECT 
            d.departement AS departement,
            CASE
                WHEN FUNCTION('DATEDIFF', CURRENT_DATE, p.date_embauche) < 365 THEN '0-1 an'
                WHEN FUNCTION('DATEDIFF', CURRENT_DATE, p.date_embauche) BETWEEN 365 AND 1095 THEN '1-3 ans'
                WHEN FUNCTION('DATEDIFF', CURRENT_DATE, p.date_embauche) BETWEEN 1096 AND 1825 THEN '3-5 ans'
                ELSE '5+ ans'
            END AS rangeAnciennete,
            COUNT(p.id_personnel) AS total
        FROM Personnel p
        JOIN p.poste po
        JOIN po.departement d
        GROUP BY d.departement, rangeAnciennete
        ORDER BY d.departement, rangeAnciennete
    """)
    List<Object[]> countByAncienneteAndDepartement();

}

