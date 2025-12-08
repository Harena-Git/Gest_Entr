package com.example.gestion.repository;

import com.example.gestion.models.HeuresSupType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface HeuresSupTypeRepository extends JpaRepository<HeuresSupType, Long> {
}