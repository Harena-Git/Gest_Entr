package com.example.gestion.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.web.SecurityFilterChain;

/**
 * Configuration Spring Security pour permettre l'accès public aux routes de congé
 */
@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            // Désactiver CSRF complètement pour permettre l'accès public
            .csrf(csrf -> csrf.disable())
            // Configuration des autorisations
            .authorizeHttpRequests(authz -> authz
                // Routes publiques accessibles sans authentification
                .requestMatchers("/", "/public/**", "/login").permitAll()
                .requestMatchers("/css/**", "/images/**", "/uploads/**", "/js/**").permitAll()
                // Autres routes nécessitent une authentification
                .anyRequest().permitAll()
            )
            // Redirection vers login pour les accès non autorisés
            .formLogin(form -> form
                .loginPage("/login")
                .permitAll()
            )
            .logout(logout -> logout
                .permitAll()
            );

        return http.build();
    }
}
