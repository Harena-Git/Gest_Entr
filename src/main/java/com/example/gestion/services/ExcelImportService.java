package com.example.gestion.services;

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.example.gestion.models.*;
import com.example.gestion.repository.*;

import java.io.FileInputStream;
import java.util.Date;

@Service
public class ExcelImportService {

    private final CandidatRepository candidatRepository;
    private final DiplomeRepository diplomeRepository;
    private final DiplomeCandidatRepository diplomeCandidatRepository;
    private final FiliereRepository filiereRepository;
    private final NiveauRepository niveauRepository;
    private final LieuRepository lieuRepository;
    private final EtatCandidatRepository etatCandidatRepository;
    private final HistoriqueEtatRepository historiqueEtatRepository;

    public ExcelImportService(CandidatRepository candidatRepository,
                              DiplomeRepository diplomeRepository,
                              DiplomeCandidatRepository diplomeCandidatRepository,
                              FiliereRepository filiereRepository,
                              NiveauRepository niveauRepository,
                              LieuRepository lieuRepository,
                              EtatCandidatRepository etatCandidatRepository,
                              HistoriqueEtatRepository historiqueEtatRepository) {
        this.candidatRepository = candidatRepository;
        this.diplomeRepository = diplomeRepository;
        this.diplomeCandidatRepository = diplomeCandidatRepository;
        this.filiereRepository = filiereRepository;
        this.niveauRepository = niveauRepository;
        this.lieuRepository = lieuRepository;
        this.etatCandidatRepository = etatCandidatRepository;
        this.historiqueEtatRepository = historiqueEtatRepository;
    }

    @Transactional
    public void importCandidatsAvecDiplomes(String cheminFichierExcel) throws Exception {
        try (FileInputStream fis = new FileInputStream(cheminFichierExcel);
             Workbook workbook = new XSSFWorkbook(fis)) {

            Sheet sheet = workbook.getSheetAt(0);

            for (Row row : sheet) {
                if (row.getRowNum() == 0) continue; // ignorer l’en-tête

                // Lecture des cellules
                String nom = row.getCell(0).getStringCellValue();
                String prenom = row.getCell(1).getStringCellValue();
                String email = row.getCell(2).getStringCellValue();
                String telephone = row.getCell(3).getStringCellValue();
                String adresse = row.getCell(4).getStringCellValue();
                String genre = row.getCell(5).getStringCellValue();
                Date dateNaissance = row.getCell(6).getDateCellValue();
                int anneeExperience = (int) row.getCell(7).getNumericCellValue();
                String lieuLibelle = row.getCell(8).getStringCellValue();
                String filiereLibelle = row.getCell(9).getStringCellValue();
                String niveauLibelle = row.getCell(10).getStringCellValue();
                String etablissement = row.getCell(11).getStringCellValue();
                int anneeObtention = (int) row.getCell(12).getNumericCellValue();

                // Création du candidat
                Candidat candidat = new Candidat();
                candidat.setNom(nom);
                candidat.setPrenom(prenom);
                candidat.setEmail(email);
                candidat.setTelephone(telephone);
                candidat.setAdresse(adresse);
                candidat.setGenre(genre);
                candidat.setDate_naissance(dateNaissance);
                Date dateCandidature = new Date(); // récupère la date et l'heure actuelles
                candidat.setDate_candidature(dateCandidature);
                candidat.setAnnee_experience(anneeExperience);

                // Recherche du lieu
                Lieu lieu = lieuRepository.findByLieuIgnoreCase(lieuLibelle)
                        .orElseThrow(() -> new RuntimeException("Lieu non trouvé : " + lieuLibelle));
                candidat.setLieu(lieu);

                EtatCandidat etatAttente = etatCandidatRepository.findById(1)
                    .orElseThrow(() -> new RuntimeException("Etat 'En attente' introuvable"));
                candidat.setEtatCandidat(etatAttente);
                // Sauvegarde du candidat
                candidatRepository.save(candidat);

                 HistoriqueEtat historique = new HistoriqueEtat();
                    historique.setCandidat(candidat);
                    historique.setEtatCandidat(etatAttente);
                    historique.setDate_changement(java.time.LocalDate.now().toString());
                    historiqueEtatRepository.save(historique);


                // Recherche de la filière et du niveau
                Filiere filiere = filiereRepository.findByLibelleIgnoreCase(filiereLibelle)
                        .orElseThrow(() -> new RuntimeException("Filière non trouvée : " + filiereLibelle));

                Niveau niveau = niveauRepository.findByLibelleIgnoreCase(niveauLibelle)
                        .orElseThrow(() -> new RuntimeException("Niveau non trouvé : " + niveauLibelle));

                // Recherche du diplôme existant
                Diplome diplome = diplomeRepository.findByNiveauAndFiliere(niveau, filiere)
                        .orElseThrow(() -> new RuntimeException(
                                "Diplôme non trouvé pour " + filiereLibelle + " - " + niveauLibelle));

                // Création du lien diplome_candidat
                DiplomeCandidat dc = new DiplomeCandidat();
                dc.setCandidat(candidat);
                dc.setDiplome(diplome);
                dc.setEtablissement(etablissement);
                dc.setAnnee_obtention(anneeObtention);

                diplomeCandidatRepository.save(dc);
            }
        }
    }
}
