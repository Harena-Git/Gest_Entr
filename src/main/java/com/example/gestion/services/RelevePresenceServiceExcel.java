package com.example.gestion.services;

import com.example.gestion.models.Personnel;
import com.example.gestion.models.PresenceAbsence;
import com.example.gestion.models.HoraireEntreprise;
import com.example.gestion.models.Departement;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Service;
import org.springframework.beans.factory.annotation.Autowired;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

@Service
public class RelevePresenceServiceExcel {

    @Autowired
    HoraireEntrepriseService horaireEntrepriseService;
    // ================================
    //   RELEVE PERSONNEL EXCEL
    // ================================
    public byte[] genererReleveExcelPersonnel(
            Personnel personnel,
            List<PresenceAbsence> presences,
            LocalDate dateDebut,
            LocalDate dateFin
    ) throws IOException {

        Workbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet("Relevé Personnel");

        // Styles
        CellStyle headerStyle = creerStyleHeader(workbook);

        int rowIndex = 0;

        // TITRE
        Row titleRow = sheet.createRow(rowIndex++);
        titleRow.createCell(0).setCellValue("Relevé de présence - Personnel");

        // INFOS PERSONNEL
        Row info1 = sheet.createRow(rowIndex++);
        info1.createCell(0).setCellValue("Nom : " +
                safe(personnel.getCandidat() != null ? personnel.getCandidat().getNom() : null));

        Row info2 = sheet.createRow(rowIndex++);
        info2.createCell(0).setCellValue("Matricule : " +
                safe(personnel.getId_personnel()));

        Row info3 = sheet.createRow(rowIndex++);
        info3.createCell(0).setCellValue("Période : " + dateDebut + " au " + dateFin);

        rowIndex++; // ligne vide

        // ENTÊTE TABLEAU
        Row header = sheet.createRow(rowIndex++);
        String[] colonnes = {"Date", "Heure Arrivée", "Heure Départ", "Retard (mn)", "Statut"};
        for (int i = 0; i < colonnes.length; i++) {
            Cell c = header.createCell(i);
            c.setCellValue(colonnes[i]);
            c.setCellStyle(headerStyle);
        }

        HoraireEntreprise horaireEntreprise = horaireEntrepriseService.getHoraire();


        // DONNÉES
        for (PresenceAbsence pa : presences) {
            Row row = sheet.createRow(rowIndex++);

            row.createCell(0).setCellValue(safe(pa.getDate()));
            row.createCell(1).setCellValue(safe(pa.getHeureArrivee()));
            row.createCell(2).setCellValue(safe(pa.getHeureDepart()));
            Integer retard = 0;

            if (pa.getHeureArrivee() != null) {
                retard = horaireEntreprise.calculerMinutesRetard(pa.getHeureArrivee());
            }

            row.createCell(3).setCellValue(retard);


            // String statut = pa.getStatut() != null ? pa.getStatut().toString() : "-";
            // row.createCell(4).setCellValue(statut);
        }

        autosize(sheet, colonnes.length);

        return toBytes(workbook);
    }

    // ================================
    //   RELEVE DÉPARTEMENT EXCEL
    // ================================
    public byte[] genererReleveExcelDepartement(
            Departement departement,
            List<PresenceAbsence> presences,
            LocalDate dateDebut,
            LocalDate dateFin
    ) throws IOException {

        Workbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet("Relevé Département");

        CellStyle headerStyle = creerStyleHeader(workbook);

        int rowIndex = 0;

        Row t = sheet.createRow(rowIndex++);
        t.createCell(0).setCellValue("Relevé de présence - Département : " + departement.getDepartement());

        Row d = sheet.createRow(rowIndex++);
        d.createCell(0).setCellValue("Période : " + dateDebut + " au " + dateFin);

        rowIndex++;

        // ENTÊTE
        Row header = sheet.createRow(rowIndex++);
        String[] colonnes = {"Personnel", "Date", "Heure Arrivée", "Heure Départ", "Retard", "Statut"};
        for (int i = 0; i < colonnes.length; i++) {
            Cell c = header.createCell(i);
            c.setCellValue(colonnes[i]);
            c.setCellStyle(headerStyle);
        }
        HoraireEntreprise horaireEntreprise = horaireEntrepriseService.getHoraire();

        // LIGNES
        for (PresenceAbsence pa : presences) {
            Row row = sheet.createRow(rowIndex++);

            String nom = "-";
            if (pa.getPersonnel() != null && pa.getPersonnel().getCandidat() != null)
                nom = safe(pa.getPersonnel().getCandidat().getNom());

            row.createCell(0).setCellValue(nom);
            row.createCell(1).setCellValue(safe(pa.getDate()));
            row.createCell(2).setCellValue(safe(pa.getHeureArrivee()));
            row.createCell(3).setCellValue(safe(pa.getHeureDepart()));
            Integer retard = 0;

            if (pa.getHeureArrivee() != null) {
                retard = horaireEntreprise.calculerMinutesRetard(pa.getHeureArrivee());
            }

            row.createCell(4).setCellValue(retard);


            // row.createCell(5).setCellValue(
            //         pa.getStatut() != null ? pa.getStatut().toString() : "-"
            // );
        }

        autosize(sheet, colonnes.length);

        return toBytes(workbook);
    }

    // ================================
    //   RELEVE GLOBAL EXCEL
    // ================================
    public byte[] genererReleveExcelGlobal(
            List<PresenceAbsence> presences,
            LocalDate dateDebut,
            LocalDate dateFin
    ) throws IOException {

        Workbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet("Relevé Global");

        CellStyle headerStyle = creerStyleHeader(workbook);

        int i = 0;

        Row t = sheet.createRow(i++);
        t.createCell(0).setCellValue("Relevé global des présences");

        Row p = sheet.createRow(i++);
        p.createCell(0).setCellValue("Période : " + dateDebut + " au " + dateFin);

        i++;

        // ENTÊTE
        Row header = sheet.createRow(i++);
        String[] colonnes = {"Personnel", "Département", "Date", "Arrivée", "Départ", "Retard"};
        for (int c = 0; c < colonnes.length; c++) {
            Cell cell = header.createCell(c);
            cell.setCellValue(colonnes[c]);
            cell.setCellStyle(headerStyle);
        }

        // DONNÉES
        for (PresenceAbsence pa : presences) {
            Row row = sheet.createRow(i++);

            String nom = "-";
            String dep = "-";

            HoraireEntreprise horaireEntreprise = horaireEntrepriseService.getHoraire();

            if (pa.getPersonnel() != null) {
                if (pa.getPersonnel().getCandidat() != null)
                    nom = safe(pa.getPersonnel().getCandidat().getNom());

                if (pa.getPersonnel().getPoste() != null && pa.getPersonnel().getPoste().getDepartement() != null)
                    dep = safe(pa.getPersonnel().getPoste().getDepartement().getDepartement());
            }

            row.createCell(0).setCellValue(nom);
            row.createCell(1).setCellValue(dep);

            row.createCell(2).setCellValue(safe(pa.getDate()));
            row.createCell(3).setCellValue(safe(pa.getHeureArrivee()));
            row.createCell(4).setCellValue(safe(pa.getHeureDepart()));
            Integer retard = 0;

            if (pa.getHeureArrivee() != null) {
                retard = horaireEntreprise.calculerMinutesRetard(pa.getHeureArrivee());
            }

            row.createCell(5).setCellValue(retard);

        }

        autosize(sheet, colonnes.length);

        return toBytes(workbook);
    }

    // ===========================================================================
    //  OUTILS
    // ===========================================================================

    private CellStyle creerStyleHeader(Workbook w) {
        CellStyle style = w.createCellStyle();
        Font font = w.createFont();
        font.setBold(true);
        style.setFont(font);
        return style;
    }

    private byte[] toBytes(Workbook workbook) throws IOException {
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        workbook.write(out);
        workbook.close();
        return out.toByteArray();
    }

    private void autosize(Sheet sheet, int cols) {
        for (int i = 0; i < cols; i++) sheet.autoSizeColumn(i);
    }

    private String safe(Object value) {
        return value == null ? "-" : value.toString();
    }
}
