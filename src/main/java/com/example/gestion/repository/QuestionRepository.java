package com.example.gestion.repository;

import com.example.gestion.models.Question;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface QuestionRepository extends JpaRepository<Question, Integer> {

    @Query("SELECT q FROM Question q WHERE q.qcm.id = :qcmId ORDER BY q.ordre")
    List<Question> findQuestionsByQcmId(@Param("qcmId") Integer qcmId);
    
}