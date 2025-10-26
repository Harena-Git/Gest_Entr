package com.example.gestion.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.gestion.models.User;

@Repository
public interface UserRepository extends JpaRepository<User, Integer> {

    User findByNom(String username);
}
