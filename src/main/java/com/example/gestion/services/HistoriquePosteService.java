package com.example.gestion.services;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.gestion.models.HistoriquePoste;
import com.example.gestion.models.Personnel;
import com.example.gestion.repository.HistoriquePosteRepository;

@Service
public class HistoriquePosteService {
    
    @Autowired
    private HistoriquePosteRepository historiquePosteRepository;
    
    public List<HistoriquePoste> getAllHistoriques() {
        return historiquePosteRepository.findAll();
    }
    
    public Optional<HistoriquePoste> getHistoriqueById(Integer id) {
        return historiquePosteRepository.findById(id);
    }
    
    public List<HistoriquePoste> getHistoriquesByPersonnel(Personnel personnel) {
        return historiquePosteRepository.findByPersonnelOrderByDateDebutDesc(personnel);
    }
    
    public HistoriquePoste saveHistorique(HistoriquePoste historique) {
        return historiquePosteRepository.save(historique);
    }
    
    public void deleteHistorique(Integer id) {
        historiquePosteRepository.deleteById(id);
    }
    
    // Méthode commentée car findByTypeMouvement n'existe plus dans le repository
    // public List<HistoriquePoste> getHistoriquesByType(String type) {
    //     return historiquePosteRepository.findByTypeMouvement(type);
    // }
}
