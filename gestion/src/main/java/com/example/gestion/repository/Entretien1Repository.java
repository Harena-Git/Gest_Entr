package com.example.gestion.repository;


import com.example.gestion.models.*;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import org.springframework.data.repository.query.Param;
import java.util.List;

@Repository
public interface Entretien1Repository extends JpaRepository<Entretien1, Integer> {
    @Query(value = "SELECT * FROM entretien_1 e " +
                   "WHERE e.id_entretien_ NOT IN " +
                   "(SELECT ev.id_entretien_ FROM evaluation_entretien_1 ev) " +
                   "AND e.id_user = :userId",
           nativeQuery = true)
    List<Entretien1> findAllWithoutEvaluationByUser(@Param("userId") int userId);
}
