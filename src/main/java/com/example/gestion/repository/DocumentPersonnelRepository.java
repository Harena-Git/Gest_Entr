package com.example.gestion.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.gestion.models.DocumentPersonnel;
import com.example.gestion.models.Personnel;

@Repository
public interface DocumentPersonnelRepository extends JpaRepository<DocumentPersonnel, Integer> {
    List<DocumentPersonnel> findByPersonnel(Personnel personnel);
}
