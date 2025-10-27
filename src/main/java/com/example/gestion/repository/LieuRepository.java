package com.example.gestion.repository;


import com.example.gestion.models.Lieu;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.Optional;

@Repository
public interface LieuRepository extends JpaRepository<Lieu, Integer> {
     Optional<Lieu> findByLieuIgnoreCase(String libelle);
}
