package com.example.gestion.repository;

import com.example.gestion.models.*;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface AnnonceRepository extends JpaRepository<Annonce, Integer> {
    List<Annonce> findByProfil( Profil profil);
}
