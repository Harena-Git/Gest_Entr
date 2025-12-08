package com.example.gestion.repository;


import com.example.gestion.models.Departement;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface DepartementRepository extends JpaRepository<Departement, Integer> {

    @Query("SELECT d.id_departement, d.departement, COUNT(p.id_personnel) AS total " +
           "FROM Departement d " +
           "LEFT JOIN Poste po ON po.departement = d " +
           "LEFT JOIN Personnel p ON p.poste = po " +
           "GROUP BY d.id_departement")
    List<Object[]> countPersonnelByDepartement();

}

