package com.example.gestion.services;

import com.example.gestion.models.*;
import com.example.gestion.repository.*;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.file.Path;
import java.time.LocalDate;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Service
public class PaieIntegrationService {

    @Autowired
    private PersonnelRepository personnelRepository;

    @Autowired
    private PresenceAbsenceRepository presenceAbsenceRepository;

    @Autowired
    private JustificationAbsenceRepository justificationAbsenceRepository;

    @Autowired
    private JustificationRetardRepository justificationRetardRepository;

    @Autowired
    private PresenceAbsenceService presenceAbsenceService;

    @Autowired
    private PersonnelHeureSuppRepository personnelHeureSuppRepository;

    @Autowired
    private HoraireEntrepriseRepository horaireEntrepriseRepository;

    // ========== WEB SERVICE JSON ==========

    /**
     * Données pour intégration paie - Format JSON
     */
    public Map<String, Object> getDonneesPaieJSON(Integer idPersonnel, Integer mois, Integer annee) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            Personnel personnel = personnelRepository.findById(idPersonnel)
                    .orElseThrow(() -> new RuntimeException("Personnel non trouvé"));

            // Période du mois
            YearMonth yearMonth = YearMonth.of(annee, mois);
            LocalDate debutMois = yearMonth.atDay(1);
            LocalDate finMois = yearMonth.atEndOfMonth();

            // Calcul des données
            Map<String, Object> donnees = calculerDonneesPaie(personnel, debutMois, finMois);

            response.put("status", "success");
            response.put("data", donnees);
            response.put("message", "Données paie générées avec succès");

        } catch (Exception e) {
            response.put("status", "error");
            response.put("data", null);
            response.put("message", "Erreur: " + e.getMessage());
        }

        return response;
    }

    /**
     * Données pour tous les personnels - Format JSON (pour RH)
     */
    public Map<String, Object> getDonneesPaieGlobaleJSON(Integer mois, Integer annee) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            List<Personnel> tousPersonnels = personnelRepository.findAll();
            Map<String, Object> donneesGlobales = new HashMap<>();
            
            YearMonth yearMonth = YearMonth.of(annee, mois);
            LocalDate debutMois = yearMonth.atDay(1);
            LocalDate finMois = yearMonth.atEndOfMonth();

            for (Personnel personnel : tousPersonnels) {
                Map<String, Object> donneesPersonnel = calculerDonneesPaie(personnel, debutMois, finMois);
                donneesGlobales.put("personnel_" + personnel.getId_personnel(), donneesPersonnel);
            }

            response.put("status", "success");
            response.put("data", donneesGlobales);
            response.put("message", "Données paie globale générées avec succès");
            response.put("total_personnels", tousPersonnels.size());

        } catch (Exception e) {
            response.put("status", "error");
            response.put("data", null);
            response.put("message", "Erreur: " + e.getMessage());
        }

        return response;
    }

    // ========== EXPORT EXCEL ==========

    /**
     * Générer fichier Excel pour intégration paie
     */
    public String genererFichierPaieExcel(Integer mois, Integer annee) {
        try (Workbook workbook = new XSSFWorkbook()) {
            Sheet sheet = workbook.createSheet("Export_Paie_" + mois + "_" + annee);

            // Style en-têtes
            CellStyle headerStyle = creerStyleEnTete(workbook);

            // En-têtes
            String[] headers = {
                "ID Personnel", "Nom", "Prénom", "Département", "Salaire Base",
                "Heures Normales", "Heures Supplémentaires", "Montant Heures Sup",
                "Absences Non Justifiées", "Retards Non Justifiés", "Retenues Total",
                "Net à Payer"
            };

            creerLigneEnTete(sheet, headerStyle, headers);

            // Données pour tous les personnels
            List<Personnel> personnels = personnelRepository.findAll();
            YearMonth yearMonth = YearMonth.of(annee, mois);
            LocalDate debutMois = yearMonth.atDay(1);
            LocalDate finMois = yearMonth.atEndOfMonth();

            int rowNum = 1;
            for (Personnel personnel : personnels) {
                Map<String, Object> donnees = calculerDonneesPaie(personnel, debutMois, finMois);
                creerLigneDonneesPaie(sheet, rowNum++, personnel, donnees);
            }

            // Auto-size columns
            for (int i = 0; i < headers.length; i++) {
                sheet.autoSizeColumn(i);
            }

            // Sauvegarde
            String fileName = "export_paie_" + mois + "_" + annee + "_" + 
                            LocalDate.now().format(DateTimeFormatter.BASIC_ISO_DATE) + ".xlsx";
            return sauvegarderFichierPaie(workbook, fileName);

        } catch (Exception e) {
            throw new RuntimeException("Erreur génération fichier paie", e);
        }
    }

    // ========== CALCUL DES DONNÉES PAIE ==========

    private Map<String, Object> calculerDonneesPaie(Personnel personnel, LocalDate dateDebut, LocalDate dateFin) {
        Map<String, Object> donnees = new HashMap<>();

        // 1. INFORMATIONS BASE
        donnees.put("id_personnel", personnel.getId_personnel());
        donnees.put("nom", personnel.getCandidat().getNom());
        donnees.put("prenom", personnel.getCandidat().getPrenom());
        donnees.put("departement", personnel.getPoste().getDepartement().getDepartement());
        donnees.put("poste", personnel.getPoste().getLibelle());

        // 2. SALAIRE BASE
        Double salaireBase = personnel.getPoste().getSalaire().doubleValue();
        donnees.put("salaire_base", salaireBase);

        // 3. HEURES TRAVAILLÉES
        List<PresenceAbsence> presences = presenceAbsenceRepository
                .findByPersonnelAndDateBetween(personnel, dateDebut, dateFin);
        
        int heuresNormales = calculerHeuresNormales(presences);
        donnees.put("heures_normales", heuresNormales);

        // 4. HEURES SUPPLÉMENTAIRES
        int heuresSupplementaires = calculerHeuresSupplementairesTotal(presences);
        donnees.put("heures_supplementaires", heuresSupplementaires);

        // 5. MONTANT HEURES SUP
        Double montantHeuresSup = calculerMontantHeuresSup(personnel, heuresSupplementaires);
        donnees.put("montant_heures_sup", montantHeuresSup);

        // 6. ABSENCES ET RETARDS
        int absencesNonJustifiees = calculerAbsencesNonJustifiees(personnel, dateDebut, dateFin);
        int retardsNonJustifies = calculerRetardsNonJustifies(personnel, dateDebut, dateFin);
        
        donnees.put("absences_non_justifiees", absencesNonJustifiees);
        donnees.put("retards_non_justifies", retardsNonJustifies);

        // 7. RETENUES
        // Double retenues = calculerRetenues(personnel, absencesNonJustifiees, retardsNonJustifies, salaireBase);
        // donnees.put("retenues_total", retenues);

        // 8. NET À PAYER
        // Double netAPayer = salaireBase + montantHeuresSup - retenues;
        // donnees.put("net_a_payer", netAPayer);

        // 9. MÉTADONNÉES
        donnees.put("periode_debut", dateDebut.toString());
        donnees.put("periode_fin", dateFin.toString());
        donnees.put("date_generation", LocalDate.now().toString());

        return donnees;
    }

    // ========== MÉTHODES DE CALCUL ==========

    private int calculerHeuresNormales(List<PresenceAbsence> presences) {
        // Jours présents * 8 heures (simplifié)
        long joursPresents = presences.stream()
                .filter(p -> p.getPresent() != null && p.getPresent() && p.getHeureArrivee() != null)
                .count();
        return (int) joursPresents * 8;
    }

    private int calculerHeuresSupplementairesTotal(List<PresenceAbsence> presences) {
        PresenceAbsenceService presenceService = new PresenceAbsenceService(); // À injecter proprement
        return presences.stream()
                .mapToInt(presenceService::calculerHeuresSupplementaires)
                .sum() / 60; // Conversion minutes → heures
    }

    private Double calculerMontantHeuresSup(Personnel personnel, int heuresSup) {
        if (heuresSup <= 0) return 0.0;
        
        Double tauxHoraire = personnel.getPoste().getSalaire().doubleValue() / 176.0; // 176h/mois
        return heuresSup * tauxHoraire * 1.25; // Majoration 25%
    }

    private int calculerAbsencesNonJustifiees(Personnel personnel, LocalDate debut, LocalDate fin) {
        // Jours ouvrables théoriques dans la période (simplifié)
        int joursOuvrables = calculerJoursOuvrables(debut, fin);
        
        // Jours présents
        long joursPresents = presenceAbsenceRepository
                .findByPersonnelAndDateBetween(personnel, debut, fin)
                .stream()
                .filter(p -> p.getPresent() != null && p.getPresent())
                .count();
        
        // Absences totales
        int absencesTotales = joursOuvrables - (int) joursPresents;
        
        // Absences justifiées
        long absencesJustifiees = justificationAbsenceRepository
                .findByPersonnelAndDateAbsenceBetween(personnel, debut, fin)
                .stream()
                .filter(JustificationAbsence::getEstJustifie)
                .count();
        
        return (int) (absencesTotales - absencesJustifiees);
    }

    private int calculerRetardsNonJustifies(Personnel personnel, LocalDate debut, LocalDate fin) {
        long retardsTotaux = justificationRetardRepository
                .findByPersonnelAndDateRetardBetween(personnel, debut, fin)
                .size();
        
        long retardsJustifies = justificationRetardRepository
                .findByPersonnelAndDateRetardBetween(personnel, debut, fin)
                .stream()
                .filter(JustificationRetard::getEstJustifie)
                .count();
        
        return (int) (retardsTotaux - retardsJustifies);
    }

    // private Double calculerRetenues(Personnel personnel, int absencesNonJustifiees, int retardsNonJustifies, Double salaireBase) {
    //     Double retenueAbsence = absencesNonJustifiees * (salaireBase / 22.0); // 22 jours/mois
    //     Double retenueRetard = retardsNonJustifies * (salaireBase / 176.0); // 1 heure de salaire
    //     return retenueAbsence + retenueRetard;
    // }

    private int calculerJoursOuvrables(LocalDate debut, LocalDate fin) {
        // Simplifié : tous les jours sauf weekend
        int jours = 0;
        LocalDate date = debut;
        while (!date.isAfter(fin)) {
            if (date.getDayOfWeek().getValue() < 6) { // Lundi-Vendredi
                jours++;
            }
            date = date.plusDays(1);
        }
        return jours;
    }

    // ========== MÉTHODES UTILITAIRES EXCEL ==========

    private CellStyle creerStyleEnTete(Workbook workbook) {
        CellStyle style = workbook.createCellStyle();
        Font font = workbook.createFont();
        font.setBold(true);
        style.setFont(font);
        style.setFillForegroundColor(IndexedColors.LIGHT_BLUE.getIndex());
        style.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        return style;
    }

    private void creerLigneEnTete(Sheet sheet, CellStyle style, String[] headers) {
        Row headerRow = sheet.createRow(0);
        for (int i = 0; i < headers.length; i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(headers[i]);
            cell.setCellStyle(style);
        }
    }

    private void creerLigneDonneesPaie(Sheet sheet, int rowNum, Personnel personnel, Map<String, Object> donnees) {
        Row row = sheet.createRow(rowNum);
        
        int col = 0;
        row.createCell(col++).setCellValue(personnel.getId_personnel());
        row.createCell(col++).setCellValue(personnel.getCandidat().getNom());
        row.createCell(col++).setCellValue(personnel.getCandidat().getPrenom());
        row.createCell(col++).setCellValue(personnel.getPoste().getDepartement().getDepartement());
        row.createCell(col++).setCellValue((Double) donnees.get("salaire_base"));
        row.createCell(col++).setCellValue((Integer) donnees.get("heures_normales"));
        row.createCell(col++).setCellValue((Integer) donnees.get("heures_supplementaires"));
        row.createCell(col++).setCellValue((Double) donnees.get("montant_heures_sup"));
        row.createCell(col++).setCellValue((Integer) donnees.get("absences_non_justifiees"));
        row.createCell(col++).setCellValue((Integer) donnees.get("retards_non_justifies"));
        row.createCell(col++).setCellValue((Double) donnees.get("retenues_total"));
        row.createCell(col++).setCellValue((Double) donnees.get("net_a_payer"));
    }

    private String sauvegarderFichierPaie(Workbook workbook, String fileName) throws IOException {
        String directory = "E:/HP/Documents/S5/Mr Tovo/Gest_Entr/src/main/resources/static/exports/paie/";
        java.nio.file.Path path = Path.of(directory);
        if (!java.nio.file.Files.exists(path)) {
            java.nio.file.Files.createDirectories(path);
        }
        
        String filePath = directory + fileName;
        try (FileOutputStream outputStream = new FileOutputStream(filePath)) {
            workbook.write(outputStream);
        }
        
        return "exports/paie/" + fileName;
    }
}