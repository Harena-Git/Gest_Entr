package com.example.gestion.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.example.gestion.models.Departement;
import com.example.gestion.models.User;

@Repository
public interface UserRepository extends JpaRepository<User, Integer> {
     User findByNom(String username);

     Optional<User> findByUsername(String username);  // Nouveau: pour Spring Security

     List<User> findByDepartement( Departement departement);

    @Query("SELECT u.id FROM User u WHERE u.nom = ?1 AND u.mot_de_passe = ?2")
     Integer findIdUser(String username, String password);
}

