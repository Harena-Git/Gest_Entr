package com.example.gestion.services;

import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.gestion.models.ContratTravail;
import com.example.gestion.models.Personnel;
import com.example.gestion.repository.ContratTravailRepository;

@Service
public class ContratTravailService {
    
    @Autowired
    private ContratTravailRepository contratTravailRepository;
    
    public List<ContratTravail> getAllContrats() {
        return contratTravailRepository.findAll();
    }
    
    public Optional<ContratTravail> getContratById(Integer id) {
        return contratTravailRepository.findById(id);
    }
    
    public List<ContratTravail> getContratsByPersonnel(Personnel personnel) {
        return contratTravailRepository.findByPersonnel(personnel);
    }
    
    public ContratTravail saveContrat(ContratTravail contrat) {
        // Calculer la date d'alerte (15 jours avant la fin du contrat)
        if (contrat.getDate_fin() != null) {
            Calendar cal = Calendar.getInstance();
            cal.setTime(contrat.getDate_fin());
            cal.add(Calendar.DAY_OF_MONTH, -15);
            contrat.setDate_alerte(cal.getTime());
        }
        return contratTravailRepository.save(contrat);
    }
    
    public void deleteContrat(Integer id) {
        contratTravailRepository.deleteById(id);
    }
    
    public List<ContratTravail> getContratsExpirantBientot() {
        Date dateActuelle = new Date();
        return contratTravailRepository.findContratsExpirantAvant(dateActuelle);
    }
    
    public List<ContratTravail> getContratsByStatut(String statut) {
        return contratTravailRepository.findByStatut(statut);
    }
}
