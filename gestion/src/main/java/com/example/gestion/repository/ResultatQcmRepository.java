package com.example.gestion.repository;


import com.example.gestion.models.ResultatQcm;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ResultatQcmRepository extends JpaRepository<ResultatQcm, Integer> {
}

