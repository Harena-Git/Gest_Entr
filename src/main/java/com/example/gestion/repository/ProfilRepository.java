package com.example.gestion.repository;


import com.example.gestion.models.Lieu;
import com.example.gestion.models.Profil;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ProfilRepository extends JpaRepository<Profil, Integer> {
    Profil findByLieu( Lieu lieu);
}

