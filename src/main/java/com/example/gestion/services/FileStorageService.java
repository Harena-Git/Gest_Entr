package com.example.gestion.services;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.UUID;

@Service
public class FileStorageService {
    
    @Value("${app.file.upload-dir}")
    private String uploadDir;
    
    @Value("${app.file.releves-dir}")
    private String relevesDir;
    
    @Value("${app.file.exports-dir}")
    private String exportsDir;
    
    /**
     * Stocker un fichier uploadé (justificatif)
     */
    public String storeUploadedFile(MultipartFile file, String subdirectory) throws IOException {
        // Créer le chemin complet
        Path uploadPath = Paths.get(uploadDir, subdirectory);
        
        // Créer le dossier s'il n'existe pas
        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }
        
        // Générer un nom de fichier unique
        String originalFileName = file.getOriginalFilename();
        String fileExtension = "";
        if (originalFileName != null && originalFileName.contains(".")) {
            fileExtension = originalFileName.substring(originalFileName.lastIndexOf("."));
        }
        
        String uniqueFileName = UUID.randomUUID().toString() + fileExtension;
        Path filePath = uploadPath.resolve(uniqueFileName);
        
        // Copier le fichier
        Files.copy(file.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);
        
        // Retourner le chemin relatif pour la base de données
        return "uploads/" + subdirectory + "/" + uniqueFileName;
    }
    
    /**
     * Stocker un relevé généré
     */
    public String storeReleveFile(byte[] fileContent, String fileName, String subdirectory) throws IOException {
        Path relevesPath = Paths.get(relevesDir, subdirectory);
        
        if (!Files.exists(relevesPath)) {
            Files.createDirectories(relevesPath);
        }
        
        Path filePath = relevesPath.resolve(fileName);
        Files.write(filePath, fileContent);
        
        // Retourner le chemin relatif pour l'URL
        return "releves/" + subdirectory + "/" + fileName;
    }
    
    /**
     * Stocker un fichier d'export paie
     */
    public String storeExportFile(byte[] fileContent, String fileName) throws IOException {
        Path exportsPath = Paths.get(exportsDir, "paie");
        
        if (!Files.exists(exportsPath)) {
            Files.createDirectories(exportsPath);
        }
        
        Path filePath = exportsPath.resolve(fileName);
        Files.write(filePath, fileContent);
        
        return "exports/paie/" + fileName;
    }
    
    /**
     * Récupérer un fichier comme Resource
     */
    public Path loadFile(String filePath) {
        return Paths.get(filePath).normalize();
    }
    
    /**
     * Supprimer un fichier
     */
    public boolean deleteFile(String filePath) throws IOException {
        Path path = Paths.get(filePath);
        return Files.deleteIfExists(path);
    }
    
    /**
     * Vérifier si un fichier existe
     */
    public boolean fileExists(String filePath) {
        return Files.exists(Paths.get(filePath));
    }
}