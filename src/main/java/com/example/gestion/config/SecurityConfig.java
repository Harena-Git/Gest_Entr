package com.example.gestion.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

/**
 * Configuration de sécurité basée sur Personnel
 */
@Configuration
@EnableWebSecurity
public class SecurityConfig {

    private final UserDetailsService personnelUserDetailsService;

    public SecurityConfig(UserDetailsService personnelUserDetailsService) {
        this.personnelUserDetailsService = personnelUserDetailsService;
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public DaoAuthenticationProvider authenticationProvider() {
        DaoAuthenticationProvider authProvider = new DaoAuthenticationProvider();
        authProvider.setUserDetailsService(personnelUserDetailsService);
        authProvider.setPasswordEncoder(passwordEncoder());
        return authProvider;
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .csrf(csrf -> csrf.disable())
            .authorizeHttpRequests(authz -> authz
                // Pages publiques - accessibles sans authentification
                .requestMatchers("/", "/acceuil", "/index.jsp").permitAll()
                .requestMatchers("/login", "/logout", "/css/**", "/js/**", "/static/**", "/images/**", "/uploads/**").permitAll()
                // Pages admin - réservées aux administrateurs
                .requestMatchers("/admin/**").hasRole("ADMIN")
                // Toutes les autres pages - authentification requise (Personnel)
                .anyRequest().authenticated()
            )
            .formLogin(form -> form
                .loginPage("/login")
                .loginProcessingUrl("/login")
                .defaultSuccessUrl("/personnel/conge/nouvelle-demande", true)
                .failureUrl("/login?error=true")
                .permitAll()
            )
            .logout(logout -> logout
                .logoutUrl("/logout")
                .logoutSuccessUrl("/acceuil")
                .permitAll()
            )
            .authenticationProvider(authenticationProvider());
        
        return http.build();
    }
}

