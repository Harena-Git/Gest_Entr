package com.example.gestion.models;

import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.io.OutputStream;
import com.example.gestion.models.*;
import java.io.FileOutputStream;


public class ContratEssaiGenerator {

    private static final Font TITRE_FONT = new Font(Font.FontFamily.HELVETICA, 18, Font.BOLD);
    private static final Font SECTION_FONT = new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD);
    private static final Font TEXTE_FONT = new Font(Font.FontFamily.HELVETICA, 11, Font.NORMAL);
    private static final Font PETIT_TEXTE_FONT = new Font(Font.FontFamily.HELVETICA, 9, Font.ITALIC, BaseColor.GRAY);

    public static void genererContrat(InfosContrat infos, OutputStream outputStream) {
        try {
            Document document = new Document(PageSize.A4, 50, 50, 50, 50);
            PdfWriter writer = PdfWriter.getInstance(document, outputStream);
            
            // Ajouter pied de page avec numéro de page
            writer.setPageEvent(new PdfPageEventHelper() {
                @Override
                public void onEndPage(PdfWriter writer, Document document) {
                    PdfContentByte cb = writer.getDirectContent();
                    Phrase footer = new Phrase("Page " + writer.getPageNumber(), PETIT_TEXTE_FONT);
                    ColumnText.showTextAligned(cb, Element.ALIGN_CENTER, footer,
                            (document.right() - document.left()) / 2 + document.leftMargin(),
                            document.bottom() - 10, 0);
                }
            });
            
            document.open();
            
            // En-tête avec logo (optionnel)
            if ("gestion/src/main/webapp/WEB-INF/image/logo.png" != null && !"gestion/src/main/webapp/WEB-INF/image/logo.png".isEmpty()) {
                try {
                    Image logo = Image.getInstance("gestion/src/main/webapp/WEB-INF/image/logo.png");
                    logo.scaleToFit(100, 50);
                    logo.setAlignment(Element.ALIGN_RIGHT);
                    document.add(logo);
                    document.add(new Paragraph(" ", TEXTE_FONT));
                } catch (Exception e) {
                    System.out.println("Logo non trouvé, continuation sans logo.");
                }
            }
            
            // Titre
            Paragraph titre = new Paragraph("CONTRAT DE TRAVAIL À DURÉE DÉTERMINÉE\nPÉRIODE D'ESSAI", TITRE_FONT);
            titre.setAlignment(Element.ALIGN_CENTER);
            titre.setSpacingAfter(30);
            document.add(titre);
            
            // Numéro de contrat et date
            Paragraph reference = new Paragraph("Contrat n° 217" + 
                    " - Établi le " + new SimpleDateFormat("dd/MM/yyyy").format(new Date()), PETIT_TEXTE_FONT);
            reference.setAlignment(Element.ALIGN_RIGHT);
            reference.setSpacingAfter(20);
            document.add(reference);
            
            // Parties
            document.add(new Paragraph("ENTRE LES SOUSSIGNÉS :", SECTION_FONT));
            document.add(new Paragraph(" ", TEXTE_FONT));
            
            Paragraph employeur = new Paragraph();
            employeur.add(new Chunk("L'EMPLOYEUR :\n", SECTION_FONT));
            employeur.add(new Chunk("Société : " + infos.getNomSociete() + "\n", TEXTE_FONT));
            employeur.add(new Chunk("Forme juridique : Non Renseigné" + "\n", TEXTE_FONT));
            employeur.add(new Chunk("Adresse : " + infos.getAdresseSociete() + "\n", TEXTE_FONT));
            employeur.add(new Chunk("SIRET : " + infos.getSiret() + "\n", TEXTE_FONT));
            if ("Code Naf" != null && !"Code Naf".isEmpty()) {
                employeur.add(new Chunk("Code NAF : " + "Code Naf" + "\n", TEXTE_FONT));
            }
            employeur.add(new Chunk("Représentée par : Jean Dupont, Directeur Général\n", TEXTE_FONT));
            employeur.setSpacingAfter(15);
            document.add(employeur);
            
            Paragraph employe = new Paragraph();
            employe.add(new Chunk("L'EMPLOYÉ :\n", SECTION_FONT));
            employe.add(new Chunk("Nom et Prénom : " + infos.getNomEmploye() + "\n", TEXTE_FONT));
            employe.add(new Chunk("Date de naissance : " + infos.getDateNaissance() + "\n", TEXTE_FONT));
            employe.add(new Chunk("Adresse : " + infos.getAdresseEmploye() + "\n", TEXTE_FONT));
            employe.add(new Chunk("Numéro de Sécurité Sociale : " + infos.getNumSecu() + "\n", TEXTE_FONT));
            employe.setSpacingAfter(20);
            document.add(employe);
            
            // Articles du contrat
            ajouterArticle(document, "Article 1 - OBJET DU CONTRAT",
                "Le présent contrat a pour objet l'engagement de " + infos.getNomEmploye() + 
                " au poste de " + infos.getPoste() + 
                " au sein de la société " + infos.getNomSociete() + ".");
            
            ajouterArticle(document, "Article 2 - DURÉE DU CONTRAT",
                "Le contrat est conclu pour une durée déterminée de " + infos.getDureeContrat() + 
                " mois, à compter du " + infos.getDateDebut() + " jusqu'au " + infos.getDateFin() + ".\n\n" +
                "Il est assorti d'une période d'essai de " + infos.getDureeEssai() + 
                " mois, renouvelable une fois par accord écrit des deux parties. Durant cette période, " +
                "le contrat pourra être rompu à tout moment par l'une ou l'autre des parties avec un délai de prévenance " +
                "conforme aux dispositions légales.");
            
            ajouterArticle(document, "Article 3 - FONCTIONS ET RESPONSABILITÉS",
                "L'employé exercera les fonctions de " + infos.getPoste() + 
                ". Il s'engage à accomplir toutes les tâches inhérentes à sa fonction et " +
                "à se conformer aux directives de la direction.\n\n" +
                "L'employé s'engage à consacrer l'intégralité de son activité professionnelle à l'entreprise " +
                "et à exercer ses fonctions avec diligence et loyauté.");
            
            ajouterArticle(document, "Article 4 - LIEU DE TRAVAIL",
                "Le lieu principal de travail est situé à : " + infos.getLieuSignature() + ".\n\n" +
                "L'employé pourra être amené à se déplacer ponctuellement dans le cadre de ses fonctions. " +
                "Le télétravail est autorisé selon les modalités définies " +
                "par l'entreprise et dans le respect de la législation en vigueur." +
                "Le télétravail n'est pas prévu dans le cadre de ce contrat.");
            
            ajouterArticle(document, "Article 5 - RÉMUNÉRATION ET AVANTAGES",
                "En contrepartie de ses services, l'employé percevra :\n\n" +
                "• Une rémunération brute mensuelle de " + infos.getSalaireBrut() + " €, " +
                "correspondant à un salaire brut annuel de " + (Double.parseDouble(infos.getSalaireBrut()) * 12) + " €\n" +
                "• Payable le dernier jour ouvrable de chaque mois par virement bancaire\n" +
                "• Tickets restaurant selon la politique de l'entreprise\n" +
                "• Mutuelle santé d'entreprise (participation employeur)\n"  +
                "\nCette rémunération pourra être révisée à l'issue de la période d'essai selon les résultats obtenus.");
            
            ajouterArticle(document, "Article 6 - DURÉE ET HORAIRES DE TRAVAIL",
                """
                La durée hebdomadaire de travail est fixée à 35\
                 heures, réparties sur 5 jours par semaine.
                
                Les horaires de travail sont les suivants : \
                8h00 - 12h00 et 14h00 - 17h00
                
                En fonction des nécessités du service, l'employé pourra être amené à effectuer des heures supplémentaires \
                qui seront rémunérées ou récupérées conformément aux dispositions légales et conventionnelles.""");
            
            ajouterArticle(document, "Article 7 - CONGÉS PAYÉS",
                """
                L'employé bénéficie de congés payés conformément aux dispositions légales en vigueur, \
                soit 2,5 jours ouvrables par mois de travail effectif.
                
                Les dates de congés sont fixées d'un commun accord entre les parties, en tenant compte \
                des nécessités du service et des souhaits de l'employé.""");
            
            ajouterArticle(document, "Article 8 - PÉRIODE D'ESSAI",
                "Durant la période d'essai de " + infos.getDureeContrat() + " mois, chacune des parties peut rompre " +
                "le contrat sans préavis ni indemnité durant les 48 premières heures de travail effectif, " +
                "puis en respectant un délai de prévenance :\n\n" +
                "• 24 heures si la présence est inférieure à 8 jours\n" +
                "• 48 heures si la présence est comprise entre 8 jours et 1 mois\n" +
                "• 2 semaines si la présence est supérieure à 1 mois\n\n" +
                "La période d'essai peut être renouvelée une fois, pour une durée égale, " +
                "par accord écrit et exprès des deux parties avant son terme initial.");
            
            ajouterArticle(document, "Article 9 - CONFIDENTIALITÉ ET NON-CONCURRENCE",
                """
                L'employé s'engage à ne divulguer aucune information confidentielle concernant l'entreprise, \
                ses clients, ses fournisseurs, ses partenaires, ses méthodes de travail ou tout élément \
                relevant du secret des affaires, tant pendant la durée du contrat qu'après sa cessation.
                
                """);
            
            ajouterArticle(document, "Article 10 - PROPRIÉTÉ INTELLECTUELLE",
                "Toutes les créations, inventions, développements ou améliorations réalisés par l'employé " +
                "dans le cadre de l'exécution du présent contrat sont et demeureront la propriété exclusive de l'entreprise.");
            
            ajouterArticle(document, "Article 11 - RUPTURE DU CONTRAT",
                """
                Le contrat prendra fin automatiquement à son terme, sauf renouvellement par accord des parties.
                
                Il peut également être rompu avant son terme :
                • Durant la période d'essai dans les conditions de l'article 8
                • Pour motif économique ou personnel grave
                • D'un commun accord entre les parties
                • En cas de force majeure""");
            
            ajouterArticle(document, "Article 12 - DISPOSITIONS GÉNÉRALES",
                """
                Le présent contrat est soumis au droit français et à la Convention Collective \
                Nationale des Cadres de la Métallurgie.
                
                Toute modification du présent contrat devra faire l'objet d'un avenant écrit signé par les deux parties.
                
                En cas de litige relatif à l'interprétation ou l'exécution du présent contrat, les parties s'engagent \
                à rechercher une solution amiable avant toute action contentieuse.""");
            
            // Signatures
            document.add(new Paragraph(" ", TEXTE_FONT));
            Paragraph mentionLu = new Paragraph("IL A ÉTÉ CONVENU ET ARRÊTÉ CE QUI SUIT :", SECTION_FONT);
            mentionLu.setSpacingBefore(10);
            mentionLu.setSpacingAfter(15);
            document.add(mentionLu);
            
            document.add(new Paragraph("Fait en deux exemplaires originaux, dont un remis à chaque partie.", TEXTE_FONT));
            document.add(new Paragraph(" ", TEXTE_FONT));
            document.add(new Paragraph("Fait à " + infos.getLieuSignature() + ", le " +
                    new SimpleDateFormat("dd/MM/yyyy").format(new Date()), TEXTE_FONT));
            document.add(new Paragraph(" ", TEXTE_FONT));
            
            PdfPTable tableSignatures = new PdfPTable(2);
            tableSignatures.setWidthPercentage(100);
            tableSignatures.setSpacingBefore(20);
            
            PdfPCell cellEmployeur = new PdfPCell(new Phrase("Signature de l'employeur\n\n\n\n", TEXTE_FONT));
            cellEmployeur.setBorder(Rectangle.NO_BORDER);
            cellEmployeur.setHorizontalAlignment(Element.ALIGN_CENTER);
            
            PdfPCell cellEmploye = new PdfPCell(new Phrase("Signature de l'employé\n(précédée de la mention « Lu et approuvé »)\n\n\n", TEXTE_FONT));
            cellEmploye.setBorder(Rectangle.NO_BORDER);
            cellEmploye.setHorizontalAlignment(Element.ALIGN_CENTER);
            
            tableSignatures.addCell(cellEmployeur);
            tableSignatures.addCell(cellEmploye);
            document.add(tableSignatures);
            
            document.close();
            System.out.println("Contrat généré avec succès");
            
        } catch (Exception e) {
            System.err.println("Erreur lors de la génération du contrat : " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    // Méthode pour générer dans un fichier (surcharge pratique)
    public static void genererContrat(InfosContrat infos, String fichierSortie) {
        try (FileOutputStream fos = new FileOutputStream(fichierSortie)) {
            genererContrat(infos, fos);
            System.out.println("Fichier créé : " + fichierSortie);
        } catch (Exception e) {
            System.err.println("Erreur lors de la création du fichier : " + e.getMessage());
            e.printStackTrace();
        }
    }

    private static void ajouterArticle(Document doc, String titre, String contenu) throws DocumentException {
        Paragraph article = new Paragraph();
        article.add(new Chunk(titre + "\n", SECTION_FONT));
        article.add(new Chunk(contenu, TEXTE_FONT));
        article.setSpacingAfter(15);
        doc.add(article);
    }
}
