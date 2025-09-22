package com.example.gestion.repository;

import com.example.gestion.models.ParcoursProfessionel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ParcoursProfessionelRepository extends JpaRepository<ParcoursProfessionel, Integer> {

  

}
