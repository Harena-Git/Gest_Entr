package com.example.gestion.repository;

import com.example.gestion.models.Annonce;
import com.example.gestion.models.Departement;
import com.example.gestion.models.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface UserRepository extends JpaRepository<User, Integer> {
     User findByNom(String username);

     List<User> findByDepartement( Departement departement);

    @Query("SELECT u.id FROM User u WHERE u.nom = ?1 AND u.mot_de_passe = ?2")
     Integer findIdUser(String username, String password);

}
