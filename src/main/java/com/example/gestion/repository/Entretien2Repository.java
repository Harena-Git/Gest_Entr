package com.example.gestion.repository;


import com.example.gestion.models.*;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.util.List;

@Repository
public interface Entretien2Repository extends JpaRepository<Entretien2, Integer> {
    @Query(value = "SELECT * FROM entretien_2 e " +
                   "WHERE e.id_entretien_2 NOT IN " +
                   "(SELECT ev.id_entretien_2 FROM evaluation_entretien_2 ev) " +
                   "AND e.id_user = :userId",
           nativeQuery = true)
    List<Entretien2> findAllWithoutEvaluationByUser(@Param("userId") int userId);
}
