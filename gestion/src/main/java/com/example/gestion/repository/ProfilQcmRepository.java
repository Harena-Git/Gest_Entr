package com.example.gestion.repository;


import com.example.gestion.models.ProfilQcm;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ProfilQcmRepository extends JpaRepository<ProfilQcm, Integer> {
}

