package com.example.gestion.repository;

import com.example.gestion.models.Choix;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface ChoixRepository extends JpaRepository<Choix, Integer> {
    
    List<Choix> findByQuestionIdQuestion(Integer questionId);
    
    List<Choix> findByQuestionGeneraleIdQuestionGenerale(Integer questionGeneraleId);
    
    @Query("SELECT c FROM Choix c WHERE c.est_correct = true AND c.question.id = :questionId")
    List<Choix> findCorrectChoicesByQuestionId(@Param("questionId") Integer questionId);
}