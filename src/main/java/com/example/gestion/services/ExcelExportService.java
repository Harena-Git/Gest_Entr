package com.example.gestion.services;

import com.example.gestion.models.Candidat;
import com.example.gestion.models.DiplomeCandidat;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Service;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.List;

@Service
public class ExcelExportService {

    public ByteArrayInputStream candidatsToExcel(List<Candidat> candidats) throws IOException {
        String[] columns = {
                "ID", "Nom", "Prénom", "Email", "Téléphone", "Adresse",
                "Genre", "Date Naissance", "Année Expérience",
                "Lieu", "État Candidat", "Diplômes"
        };

        try (Workbook workbook = new XSSFWorkbook(); ByteArrayOutputStream out = new ByteArrayOutputStream()) {

            Sheet sheet = workbook.createSheet("Candidats");

            // Style d’en-tête
            CellStyle headerCellStyle = workbook.createCellStyle();
            Font font = workbook.createFont();
            font.setBold(true);
            headerCellStyle.setFont(font);

            // Ligne d’en-tête
            Row headerRow = sheet.createRow(0);
            for (int i = 0; i < columns.length; i++) {
                Cell cell = headerRow.createCell(i);
                cell.setCellValue(columns[i]);
                cell.setCellStyle(headerCellStyle);
            }

            int rowIdx = 1;
            for (Candidat c : candidats) {
                Row row = sheet.createRow(rowIdx++);

                row.createCell(0).setCellValue(c.getId_candidat());
                row.createCell(1).setCellValue(c.getNom());
                row.createCell(2).setCellValue(c.getPrenom());
                row.createCell(3).setCellValue(c.getEmail());
                row.createCell(4).setCellValue(c.getTelephone());
                row.createCell(5).setCellValue(c.getAdresse());
                row.createCell(6).setCellValue(c.getGenre());
                row.createCell(7).setCellValue(
                        c.getDate_naissance() != null ? c.getDate_naissance().toString() : ""
                );
                row.createCell(8).setCellValue(
                        c.getAnnee_experience() != null ? c.getAnnee_experience() : 0
                );
                row.createCell(9).setCellValue(
                        c.getLieu() != null ? c.getLieu().getLieu() : ""
                );
                row.createCell(10).setCellValue(
                        c.getEtatCandidat() != null ? c.getEtatCandidat().getLibelle() : ""
                );

                // Liste des diplômes du candidat
                StringBuilder diplomeStr = new StringBuilder();
                for (DiplomeCandidat dc : c.getDiplomesCandidats()) {
                    diplomeStr.append(dc.getDiplome().getNiveau().getLibelle());
                    if (dc.getDiplome().getFiliere() != null) {
                        diplomeStr.append(" - ").append(dc.getDiplome().getFiliere().getLibelle());
                    }
                    diplomeStr.append(" (").append(dc.getAnnee_obtention()).append(")\n");
                }
                row.createCell(11).setCellValue(diplomeStr.toString());
            }

            workbook.write(out);
            return new ByteArrayInputStream(out.toByteArray());
        }
    }
}
