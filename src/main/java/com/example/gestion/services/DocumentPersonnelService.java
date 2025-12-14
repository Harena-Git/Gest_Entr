package com.example.gestion.services;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.gestion.models.DocumentPersonnel;
import com.example.gestion.models.Personnel;
import com.example.gestion.repository.DocumentPersonnelRepository;

@Service
public class DocumentPersonnelService {
    
    @Autowired
    private DocumentPersonnelRepository documentPersonnelRepository;
    
    public List<DocumentPersonnel> getAllDocuments() {
        return documentPersonnelRepository.findAll();
    }
    
    public Optional<DocumentPersonnel> getDocumentById(Integer id) {
        return documentPersonnelRepository.findById(id);
    }
    
    public List<DocumentPersonnel> getDocumentsByPersonnel(Personnel personnel) {
        return documentPersonnelRepository.findByPersonnel(personnel);
    }
    
    public DocumentPersonnel saveDocument(DocumentPersonnel document) {
        return documentPersonnelRepository.save(document);
    }
    
    public void deleteDocument(Integer id) {
        documentPersonnelRepository.deleteById(id);
    }
}
