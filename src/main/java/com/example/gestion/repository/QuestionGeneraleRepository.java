package com.example.gestion.repository;

import com.example.gestion.models.QuestionGenerale;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface QuestionGeneraleRepository extends JpaRepository<QuestionGenerale, Integer> {
    
    @Query("SELECT qg FROM QuestionGenerale qg ORDER BY qg.ordre")
    List<QuestionGenerale> findAllOrderByOrdre();
}