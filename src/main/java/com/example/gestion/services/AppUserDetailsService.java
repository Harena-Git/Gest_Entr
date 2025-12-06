package com.example.gestion.services;

import com.example.gestion.models.User;
import com.example.gestion.repository.UserRepository;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.core.userdetails.User.UserBuilder;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Collection;

@Service
public class AppUserDetailsService implements UserDetailsService {

    private final UserRepository userRepository;

    public AppUserDetailsService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        User user = userRepository.findByUsername(username)
            .orElseThrow(() -> new UsernameNotFoundException("Utilisateur non trouvé: " + username));

        // Construire les autorités (rôles) à partir du rôle de l'utilisateur
        Collection<GrantedAuthority> authorities = new ArrayList<>();
        if (user.getRole() != null) {
            // Ajoute le rôle avec le préfixe "ROLE_" pour Spring Security
            authorities.add(new SimpleGrantedAuthority("ROLE_" + user.getRole().getLibelle().toUpperCase()));
        }

        // Retourner un UserDetails avec username, mot de passe haché (BCrypt) et rôles
        UserBuilder builder = org.springframework.security.core.userdetails.User.builder();
        return builder
            .username(user.getUsername())
            .password(user.getMot_de_passe())  // Doit être en BCrypt
            .authorities(authorities)
            .accountExpired(false)
            .accountLocked(false)
            .credentialsExpired(false)
            .disabled(false)
            .build();
    }
}
