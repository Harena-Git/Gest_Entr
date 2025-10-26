package com.example.gestion.repository;

import com.example.gestion.models.Appreciation;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface AppreciationRepository extends JpaRepository<Appreciation, Integer> {
}
