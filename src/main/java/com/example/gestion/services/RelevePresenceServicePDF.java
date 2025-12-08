package com.example.gestion.services;

import com.example.gestion.models.Departement;
import com.example.gestion.models.HoraireEntreprise;
import com.example.gestion.models.Personnel;
import com.example.gestion.models.PresenceAbsence;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDPage;
import org.apache.pdfbox.pdmodel.PDPageContentStream;
import org.apache.pdfbox.pdmodel.common.PDRectangle;
import org.apache.pdfbox.pdmodel.font.PDType1Font;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import java.util.Locale;

@Service
public class RelevePresenceServicePDF {

    @Autowired
    private HoraireEntrepriseService horaireEntrepriseService;

    private static final float MARGIN_LEFT = 50f;
    private static final float MARGIN_TOP = 780f;
    private static final float LINE_HEIGHT = 16f;
    private static final float BOTTOM_MARGIN = 70f;

    // ---------------------------
    // GENERER PDF PERSONNEL
    // ---------------------------
    public byte[] genererRelevePDFPersonnel(Personnel personnel,
                                            List<PresenceAbsence> presences,
                                            LocalDate dateDebut,
                                            LocalDate dateFin) throws IOException {

        try (PDDocument document = new PDDocument();
             ByteArrayOutputStream out = new ByteArrayOutputStream()) {

            PDPage page = new PDPage(PDRectangle.A4);
            document.addPage(page);

            try (PDPageContentStream cs = new PDPageContentStream(document, page)) {
                float y = MARGIN_TOP;

                // Titre
                y = drawTitle(cs, "RELEVÉ DE PRÉSENCE - PERSONNEL", y);

                // Infos personnel
                String nom = safePersonnelFullName(personnel);
                String matricule = personnel != null && personnel.getId_personnel() != null
                        ? String.valueOf(personnel.getId_personnel()) : "-";
                y = drawLine(cs, "Nom : " + nom, y);
                y = drawLine(cs, "Matricule : " + matricule, y);
                y = drawLine(cs, "Période : " + safe(dateDebut) + " au " + safe(dateFin), y);
                y -= LINE_HEIGHT;

                // Entête tableau (Date, Arrivée, Départ, Retard (min), Heures travaillées)
                String[] headers = {"Date", "Arrivée", "Départ", "Retard (min)", "Heures travaillées"};
                y = drawTableHeader(cs, headers, y, page, document);
                // Données
                for (PresenceAbsence pa : presences) {
                    if (y < BOTTOM_MARGIN) {
                        // nouvelle page
                        cs.close();
                        page = new PDPage(PDRectangle.A4);
                        document.addPage(page);
                        try (PDPageContentStream cs2 = new PDPageContentStream(document, page)) {
                            y = MARGIN_TOP;
                            drawTableHeader(cs2, headers, y, page, document);
                            y -= LINE_HEIGHT;
                            // write remaining rows with cs2
                            y = drawPresenceRow(cs2, pa, y);
                            // rebind cs to cs2 for next loop iterations
                            // but because cs2 is inside try-with-resources, we need a different approach:
                            // to keep code simple, re-open a new content stream for the rest of this page below
                        }
                        // reopen a fresh content stream for continuing writing on the new page
                        // (we'll open one outside the loop to avoid complexity)
                        // For simplicity in this block we will re-create a content stream for the whole page below.
                        // To keep control flow simple we will instead close the outer cs and create a new one here:
                        try (PDPageContentStream csNew = new PDPageContentStream(document, page)) {
                            y = MARGIN_TOP - LINE_HEIGHT; // position after header
                            // continue with remaining items — but we can't easily continue previous loop with this structure.
                            // To avoid complicated nested streams, we'll simplify: close current stream and then
                            // write the rest of the loop rows using a helper that creates/handles new pages as needed.
                            // So break out and use the helper to write the rest.
                            writePresenceListWithPagination(document, csNew, presences, presences.indexOf(pa), y);
                            break; // finished writing
                        }
                    } else {
                        y = drawPresenceRow(cs, pa, y);
                    }
                }
            }

            document.save(out);
            return out.toByteArray();
        }
    }

    // ---------------------------
    // GENERER PDF DEPARTEMENT
    // ---------------------------
    public byte[] genererRelevePDFDepartement(Departement departement,
                                              List<PresenceAbsence> presences,
                                              LocalDate dateDebut,
                                              LocalDate dateFin) throws IOException {

        try (PDDocument document = new PDDocument();
             ByteArrayOutputStream out = new ByteArrayOutputStream()) {

            PDPage page = new PDPage(PDRectangle.A4);
            document.addPage(page);

            try (PDPageContentStream cs = new PDPageContentStream(document, page)) {
                float y = MARGIN_TOP;

                y = drawTitle(cs, "RELEVÉ DE PRÉSENCE - DÉPARTEMENT", y);
                y = drawLine(cs, "Département : " + safeDepartementName(departement), y);
                y = drawLine(cs, "Période : " + safe(dateDebut) + " au " + safe(dateFin), y);
                y -= LINE_HEIGHT;

                String[] headers = {"Personnel", "Date", "Arrivée", "Départ", "Retard (min)"};
                y = drawTableHeader(cs, headers, y, page, document);

                // Write rows with pagination helper
                writePresenceListWithPagination(document, cs, presences, 0, y);
            }

            document.save(out);
            return out.toByteArray();
        }
    }

    // ---------------------------
    // GENERER PDF GLOBAL
    // ---------------------------
    public byte[] genererRelevePDFGlobal(List<PresenceAbsence> presences,
                                         LocalDate dateDebut,
                                         LocalDate dateFin) throws IOException {

        try (PDDocument document = new PDDocument();
             ByteArrayOutputStream out = new ByteArrayOutputStream()) {

            PDPage page = new PDPage(PDRectangle.A4);
            document.addPage(page);

            try (PDPageContentStream cs = new PDPageContentStream(document, page)) {
                float y = MARGIN_TOP;

                y = drawTitle(cs, "RELEVÉ GLOBAL DES PRÉSENCES", y);
                y = drawLine(cs, "Période : " + safe(dateDebut) + " au " + safe(dateFin), y);
                y -= LINE_HEIGHT;

                String[] headers = {"Personnel", "Département", "Date", "Arrivée", "Départ", "Retard (min)", "Heures travaillées"};
                y = drawTableHeader(cs, headers, y, page, document);

                // Write rows with pagination helper
                writePresenceListWithPagination(document, cs, presences, 0, y);
            }

            document.save(out);
            return out.toByteArray();
        }
    }

    // ===========================
    // Helpers: draw and pagination
    // ===========================

    // Draw table header and return new y
    private float drawTableHeader(PDPageContentStream cs, String[] cols, float y, PDPage page, PDDocument doc) throws IOException {
        cs.setFont(PDType1Font.HELVETICA_BOLD, 11);
        float x = MARGIN_LEFT;
        float colWidth = computeColWidth(page, cols.length);
        for (String c : cols) {
            cs.beginText();
            cs.newLineAtOffset(x, y);
            cs.showText(c);
            cs.endText();
            x += colWidth;
        }
        return y - LINE_HEIGHT;
    }

    // Draw a simple title
    private float drawTitle(PDPageContentStream cs, String texte, float y) throws IOException {
        cs.beginText();
        cs.setFont(PDType1Font.HELVETICA_BOLD, 14);
        cs.newLineAtOffset(MARGIN_LEFT, y);
        cs.showText(texte);
        cs.endText();
        return y - (LINE_HEIGHT * 1.5f);
    }

    // Draw a line of text and return new y
    private float drawLine(PDPageContentStream cs, String texte, float y) throws IOException {
        cs.beginText();
        cs.setFont(PDType1Font.HELVETICA, 11);
        cs.newLineAtOffset(MARGIN_LEFT, y);
        cs.showText(texte);
        cs.endText();
        return y - LINE_HEIGHT;
    }

    // Draw one presence row and return new y (does not handle page creation)
    private float drawPresenceRow(PDPageContentStream cs, PresenceAbsence pa, float y) throws IOException {
        cs.setFont(PDType1Font.HELVETICA, 10);
        float x = MARGIN_LEFT;
        float colWidth = computeColWidth(new PDPage(), 5); // largeur générique pour 7 colonnes

        // Nom du personnel
        String personnelNom = (pa.getPersonnel() != null)
                ? safePersonnelFullName(pa.getPersonnel())
                : "-";

        // Département
        // String depNom = "-";
        // if (pa.getPersonnel() != null && pa.getPersonnel().getPoste() != null
        //         && pa.getPersonnel().getPoste().getDepartement() != null) {
        //     depNom = safe(pa.getPersonnel().getPoste().getDepartement().getDepartement());
        // } else if (pa.getUser() != null && pa.getUser().getDepartement() != null) {
        //     depNom = safe(pa.getUser().getDepartement().getDepartement());
        // }

        // Date, arrivée, départ
        String dateStr = safe(pa.getDate());
        String arrivee = safe(pa.getHeureArrivee());
        String depart = safe(pa.getHeureDepart());

        // Retard
        Integer retard = 0;
        try {
            HoraireEntreprise h = horaireEntrepriseService.getHoraire();
            if (pa.getHeureArrivee() != null && h != null) {
                retard = horaireEntrepriseService.calculerMinutesRetard(pa.getHeureArrivee());
            }
        } catch (Exception ignored) {}

        // // Heures travaillées
        // String heuresTrav = "-";
        // if (pa.getHeuresTravaillees() != null) {
        //     heuresTrav = String.format(Locale.ROOT, "%.2f", pa.getHeuresTravaillees());
        // }

        // Choisir colonnes selon si personnel est disponible ou non
        String[] values = (pa.getPersonnel() != null)
                ? new String[]{personnelNom, dateStr, arrivee, depart, String.valueOf(retard)}
                : new String[]{personnelNom, dateStr, arrivee, depart, String.valueOf(retard)};

        // Affichage horizontal
        for (String v : values) {
            cs.beginText();
            cs.newLineAtOffset(x, y);
            cs.showText(v != null ? v : "-");
            cs.endText();
            x += colWidth;
        }

        return y - LINE_HEIGHT;
    }


    // Write list of presences starting at index startIndex, handling pagination.
    // This method will close and reopen content streams as pages are added.
    private void writePresenceListWithPagination(PDDocument document, PDPageContentStream initialCs,
                                                 List<PresenceAbsence> presences, int startIndex, float startY) throws IOException {
        PDPageContentStream cs = initialCs;
        float y = startY;

        for (int i = startIndex; i < presences.size(); i++) {
            PresenceAbsence pa = presences.get(i);

            if (y < BOTTOM_MARGIN) {
                cs.close();
                // new page
                PDPage currentPage = new PDPage(PDRectangle.A4);
                document.addPage(currentPage);
                cs = new PDPageContentStream(document, currentPage);
                // draw header on new page
                String[] headerSmall = {"", "", "Date", "Arrivée", "Départ", "Retard (min)", "Heures travaillées"};
                y = MARGIN_TOP;
                drawTableHeader(cs, headerSmall, y, currentPage, document);
                y -= LINE_HEIGHT;
            }

            y = drawPresenceRow(cs, pa, y);
        }

        // close last stream (if not already closed)
        if (cs != null) cs.close();
    }

    // Compute a generic column width based on page width and number of columns
    private float computeColWidth(PDPage page, int cols) {
        float usableWidth = page.getMediaBox().getWidth() - (MARGIN_LEFT * 2);
        return usableWidth / (float) Math.max(1, cols);
    }

    // ===========================
    // Safe helpers
    // ===========================
    private String safe(Object o) {
        if (o == null) return "-";
        return o.toString();
    }

    private String safe(LocalDate date) {
        return date == null ? "-" : date.toString();
    }

    private String safe(LocalTime time) {
        return time == null ? "-" : time.toString();
    }

    private String safePersonnelFullName(Personnel p) {
        if (p == null) return "-";
        try {
            if (p.getCandidat() != null) {
                String n = p.getCandidat().getNom();
                String pr = p.getCandidat().getPrenom();
                return (n == null ? "-" : n) + " " + (pr == null ? "-" : pr);
            }
        } catch (Exception ignored) {}
        return "-";
    }

    private String safeDepartementName(Departement d) {
        if (d == null) return "-";
        try {
            return d.getDepartement() != null ? d.getDepartement() : "-";
        } catch (Exception ignored) {
            return "-";
        }
    }

    private String fallbackUserName(PresenceAbsence pa) {
        try {
            if (pa.getUser() != null) {
                return pa.getUser().getNom() != null ? pa.getUser().getNom() : "-";
            }
        } catch (Exception ignored) {}
        return "-";
    }
}
