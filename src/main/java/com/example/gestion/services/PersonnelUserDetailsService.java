package com.example.gestion.services;

import java.util.Collection;
import java.util.Collections;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.example.gestion.models.Personnel;
import com.example.gestion.repository.PersonnelRepository;

/**
 * Service de gestion des détails utilisateur basé sur la table Personnel
 */
@Service
public class PersonnelUserDetailsService implements UserDetailsService {

    private final PersonnelRepository personnelRepository;

    public PersonnelUserDetailsService(PersonnelRepository personnelRepository) {
        this.personnelRepository = personnelRepository;
    }

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        Personnel personnel = personnelRepository.findByUsername(username)
            .orElseThrow(() -> new UsernameNotFoundException("Personnel non trouvé: " + username));

        // Vérifier que le personnel est actif
        if (personnel.getActif() == null || !personnel.getActif()) {
            throw new UsernameNotFoundException("Personnel inactif: " + username);
        }

        // Construire les autorités (rôles)
        Collection<GrantedAuthority> authorities = Collections.singleton(
            new SimpleGrantedAuthority("ROLE_PERSONNEL")
        );

        // Retourner un UserDetails
        return org.springframework.security.core.userdetails.User.builder()
            .username(personnel.getUsername())
            .password(personnel.getPassword())  // BCrypt
            .authorities(authorities)
            .accountExpired(false)
            .accountLocked(false)
            .credentialsExpired(false)
            .disabled(false)
            .build();
    }
}
