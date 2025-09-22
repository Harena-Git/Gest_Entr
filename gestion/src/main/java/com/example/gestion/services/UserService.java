package com.example.gestion.services;

import com.example.gestion.models.*;
import com.example.gestion.repository.UserRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class UserService {

    private final UserRepository userRepository;

    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    public List<User> findAll() {
        return userRepository.findAll();
    }

    public Optional<User> findById(Integer id) {
        return userRepository.findById(id);
    }

    public User save(User entretien) {
        return userRepository.save(entretien);
    }

    public void deleteById(Integer id) {
        userRepository.deleteById(id);
    }

    public List<User> findByDepartement(Departement departement)
    {
        return userRepository.findByDepartement(departement);
    }

}
