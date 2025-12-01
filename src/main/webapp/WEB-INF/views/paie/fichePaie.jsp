<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Fiche de Paie</title>

    <!-- CDN pour PDF -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jexspdf.umd.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>\
    
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background: #f5f5f5; }
        .filtre, .error { 
            background: #f8f9fa; padding: 15px; border-radius: 8px; margin-bottom: 20px; 
            border: 1px solid #dee2e6;
        }
        .error { background: #f8d7da; color: #721c24; border-color: #f5c6cb; }
        .fiche-paie {
            background: white; padding: 30px; border: 1px solid #ddd; 
            box-shadow: 0 4px 12px rgba(0,0,0,0.1); border-radius: 8px;
            max-width: 900px; margin: 0 auto 40px;
        }
        table { width: 100%; border-collapse: collapse; margin: 15px 0; }
        th, td { border: 1px solid #ccc; padding: 10px; text-align: left; }
        th { background: #f2f2f2; }
        .section-header { background: #e9ecef; font-weight: bold; text-align: center; }
        .total-row { background: #d4edda; font-weight: bold; }
        .btn-export {
            background: linear-gradient(135deg, #28a745, #20c997);
            color: white; border: none; padding: 12px 24px;
            border-radius: 6px; cursor: pointer; font-size: 16px;
            transition: all 0.3s; margin-left: 15px;
        }
        .btn-export:hover:not(:disabled) {
            transform: translateY(-2px); box-shadow: 0 6px 12px rgba(0,0,0,0.2);
        }
        .btn-export:disabled {
            background: #6c757d; cursor: not-allowed; transform: none;
        }
        .no-print { display: block; }
        @media print {
            .no-print, .filtre, .error, button { display: none !important; }
            body { background: white; }
        }
    </style>
</head>
<body>

    <!-- FILTRE -->
    <div class="filtre no-print">
        <h3>Filtrer par période</h3>
        <form method="get" action="">
            <label>Mois :</label>
            <select name="mois">
                <c:forEach var="i" begin="1" end="12">
                    <option value="${i}" ${mois == i ? 'selected' : ''}>
                        ${i == 1 ? 'Janvier' : i == 2 ? 'Février' : i == 3 ? 'Mars' : i == 4 ? 'Avril' : 
                          i == 5 ? 'Mai' : i == 6 ? 'Juin' : i == 7 ? 'Juillet' : i == 8 ? 'Août' : 
                          i == 9 ? 'Septembre' : i == 10 ? 'Octobre' : i == 11 ? 'Novembre' : 'Décembre'}
                    </option>
                </c:forEach>
            </select>

            <label style="margin-left: 15px;">Année :</label>
            <select name="annee">
                <option value="2024" ${annee == 2024 ? 'selected' : ''}>2024</option>
                <option value="2025" ${annee == 2025 ? 'selected' : ''}>2025</option>
                <option value="2026" ${annee == 2026 ? 'selected' : ''}>2026</option>
            </select>

            <button type="submit">Afficher</button>

            <c:if test="${not empty fiche}">
                <button type="button" id="btn-export-pdf" class="btn-export">
                    Exporter en PDF
                </button>
            </c:if>
        </form>

        <div style="margin-top: 10px; font-size: 0.9em;">
            Périodes rapides :
            <a href="?mois=${java.time.LocalDate.now().monthValue}&annee=${java.time.LocalDate.now().year}">Mois courant</a> |
            <a href="?mois=11&annee=2025">Novembre 2025</a> |
            <a href="?mois=10&annee=2025">Octobre 2025</a>
        </div>
    </div>

    <!-- ERREUR -->
    <c:if test="${not empty error}">
        <div class="error no-print">${error}</div>
    </c:if>

    <!-- FICHE DE PAIE -->
    <c:if test="${not empty fiche}">
        
        <!-- Données cachées pour le JS (sécurisé, pas d'EL dans le JS) -->
        <div style="display: none;">
            <span id="data-nom">${fiche.personnel.candidat.nom}</span>
            <span id="data-prenom">${fiche.personnel.candidat.prenom}</span>
            <span id="data-mois">${fiche.getMoisString(fiche.mois)} ${fiche.annee}</span>
            <span id="data-matricule">${fiche.personnel.matricule}</span>
        </div>

        <!-- Calculs des totaux (comme avant) -->
        <c:set var="totalHeureSup" value="0"/>
        <c:set var="totalIndemnite" value="0"/><c:set var="totalHeureSup" value="${fiche.totalHeureSup != null ? fiche.totalHeureSup : 0}"/>
        <c:set var="totalRappel" value="0"/>
        <c:set var="totalAutresPrimes" value="0"/>
        <c:set var="totalAvance" value="0"/>
        <c:set var="cnapsEmploye" value="0"/>
        <c:set var="ostieEmploye" value="0"/>
        <c:set var="absenceEmploye" value="0"/>
        <c:set var="autresRetenus" value="0"/>
        <c:set var="impotDu" value="0"/>
        <c:set var="igrnet" value="0"/>
        <c:set var="autresImpots" value="0"/>
        <c:set var="totalEnfantsCharge" value="0"/>

        <c:forEach var="prime" items="${fiche.primes}">
            <c:set var="totalIndemnite" value="${totalIndemnite + prime.indemnite}"/>
            <c:set var="totalRappel" value="${totalRappel + prime.rappels}"/>
            <c:set var="totalAutresPrimes" value="${totalAutresPrimes + prime.autres}"/>
            <c:set var="totalAvance" value="${totalAvance + prime.avance}"/>
        </c:forEach>

        <c:forEach var="retenu" items="${fiche.retenus}">
            <c:if test="${retenu.typeRetenu.libelle.contains('CNaPS') and retenu.typeRetenu.typeEnum.name() == 'EMPLOYE'}">
                <c:set var="cnapsEmploye" value="${retenu.calculRetenu(fiche.personnel.poste.salaire)}"/>
            </c:if>
            <c:if test="${retenu.typeRetenu.libelle.contains('OSTIE') and retenu.typeRetenu.typeEnum.name() == 'EMPLOYE'}">
                <c:set var="ostieEmploye" value="${retenu.calculRetenu(fiche.personnel.poste.salaire)}"/>
            </c:if>
            <c:if test="${retenu.typeRetenu.libelle.contains('ABSENCE') and retenu.typeRetenu.typeEnum.name() == 'ABSENCE'}">
                <c:set var="absenceEmploye" value="${retenu.calculAbsence(fiche.personnel.poste.salaire, fiche.totalAbsence)}"/>
            </c:if>
            <c:if test="${retenu.typeRetenu.typeEnum.name() == 'AUTRE'}">
                <c:set var="autresRetenus" value="${autresRetenus + retenu.calculRetenu(fiche.personnel.poste.salaire)}"/>
            </c:if>
        </c:forEach>

        
            <c:set var="impotDu" value="${impotDu + fiche.impot.impotDu}"/>
            <c:set var="igrnet" value="${igrnet + fiche.impot.igrnet}"/>
            <c:set var="autresImpots" value="${autresImpots + fiche.impot.autresImpots}"/>
            <c:set var="totalEnfantsCharge" value="${totalEnfantsCharge + fiche.impot.calculerTotalChargesEnfants()}"/>
       

        <c:set var="totalRetenues" value="${cnapsEmploye + ostieEmploye + autresRetenus + absenceEmploye}"/>
        <c:set var="totalPrimes" value="${totalIndemnite + totalRappel + totalAutresPrimes}"/>

        <div class="fiche-paie" id="fiche-paie">
            <h2 style="text-align: center; color: #28a745;">
                FICHE DE PAIE - ${fiche.getMoisString(fiche.mois)} ${fiche.annee}
            </h2>

            <div style="margin-bottom: 20px; line-height: 1.6;">
                <p><strong>Matricule :</strong> ${fiche.personnel.matricule}</p>
                <p><strong>Nom complet :</strong> ${fiche.personnel.candidat.nom} ${fiche.personnel.candidat.prenom}</p>
                <p><strong>Fonction :</strong> ${fiche.personnel.poste.libelle}</p>
                <p><strong>Date embauche :</strong> ${fiche.personnel.date_embauche}</p>
                <p><strong>N° CNAPS :</strong> ${fiche.personnel.num_cnaps}</p>
            </div>

            <table>
                <thead>
                    <tr><th>Désignation</th><th>Nombre</th><th>Taux</th><th>Montant</th></tr>
                </thead>
                <tbody>
                    <tr class="section-header"><td colspan="4">PRODUITS</td></tr>
                    <tr><td>Salaire de base</td><td>1</td><td>${fiche.personnel.poste.salaire}</td><td>${fiche.personnel.poste.salaire}</td></tr>
                    <c:if test="${totalHeureSup > 0}"><tr><td>Heures supplémentaires</td><td>1</td><td>${totalHeureSup}</td><td>${totalHeureSup}</td></tr></c:if>
                    <c:if test="${totalIndemnite > 0}"><tr><td>Indemnité</td><td>1</td><td>${totalIndemnite}</td><td>${totalIndemnite}</td></tr></c:if>
                    <c:if test="${totalRappel > 0}"><tr><td>Rappel</td><td>1</td><td>${totalRappel}</td><td>${totalRappel}</td></tr></c:if>
                    <c:if test="${totalAutresPrimes > 0}"><tr><td>Autres primes</td><td>1</td><td>${totalAutresPrimes}</td><td>${totalAutresPrimes}</td></tr></c:if>
                    <tr class="total-row"><td colspan="3"><strong>TOTAL PRODUITS (Salaire Brut)</strong></td><td><strong>${fiche.salaireBrut}</strong></td></tr>

                    <tr class="section-header"><td colspan="4">RETENUES</td></tr>
                    <c:if test="${cnapsEmploye > 0}"><tr><td>CNAPS employé (1%)</td><td>1</td><td>1%</td><td>${cnapsEmploye}</td></tr></c:if>
                    <c:if test="${ostieEmploye > 0}"><tr><td>OSTIE employé (1%)</td><td>1</td><td>1%</td><td>${ostieEmploye}</td></tr></c:if>
                    <c:if test="${absenceEmploye > 0}"><tr><td>Absence employé</td><td>1</td><td>-</td><td>${absenceEmploye}</td></tr></c:if>
                    <c:if test="${autresRetenus > 0}"><tr><td>Autres retenues</td><td>1</td><td>-</td><td>${autresRetenus}</td></tr></c:if>
                    <tr class="total-row"><td colspan="3"><strong>TOTAL RETENUES</strong></td><td><strong>${totalRetenues}</strong></td></tr>

                    <tr class="section-header"><td colspan="4">DÉTAIL CALCUL IRSA</td></tr>
                    <c:choose>
                        <c:when test="${not empty detailIrsa}">
                            <c:set var="totalIrsaCalcule" value="0"/>
                            <c:forEach var="tranche" items="${detailIrsa}">
                                <tr>
                                    <td>${tranche.libelle}</td>
                                    <td style="text-align: right;"> ${tranche.montantTranche}
                                        <fmt:formatNumber value="${tranche.montantTranche}" type="number" maxFractionDigits="0"/> Ar
                                    </td>
                                    <td style="text-align: center;">${tranche.taux}%</td>
                                    <td style="text-align: right;"> ${tranche.impotTranche}
                                        <fmt:formatNumber value="${tranche.impotTranche}" type="number" maxFractionDigits="0"/> Ar
                                    </td>
                                </tr>
                                <c:set var="totalIrsaCalcule" value="${totalIrsaCalcule + tranche.impotTranche}"/>
                            </c:forEach>
                            <tr class="total-row">
                                <td colspan="3"><strong>TOTAL IRSA</strong></td>
                                <td style="text-align: right;">${totalIrsaCalcule}
                                    <strong><fmt:formatNumber value="${totalIrsaCalcule}" type="number" maxFractionDigits="0"/> Ar</strong>
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="4" style="text-align: center; color: #999;">
                                    Aucun détail de calcul IRSA disponible
                                </td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                    <c:set var="totalImpots" value="${totalIrsaCalcule + igrnet + autresImpots }"/>
                    <tr class="section-header"><td colspan="4">AUTRES IMPÔTS</td></tr>
                    <c:if test="${igrnet > 0}">
                        <tr><td>IGR Net</td><td>1</td><td>-</td><td>${igrnet} Ar</td></tr>
                    </c:if>
                    <c:if test="${autresImpots > 0}">
                        <tr><td>Autres impôts</td><td>1</td><td>-</td><td>${autresImpots} Ar</td></tr>
                    </c:if>

                    <tr class="total-row">
                        <td colspan="3"><strong>TOTAL IMPÔTS</strong></td>
                        <td><strong>${totalImpots} Ar</strong></td>
                    </tr>
                    <tr class="section-header"><td colspan="4">DÉDUCTIONS</td></tr>
                    <c:if test="${totalAvance > 0}"><tr><td>Avances</td><td>1</td><td>-</td><td>${totalAvance}</td></tr></c:if>
                    <c:if test="${totalEnfantsCharge > 0}"><tr><td>Charges familiales</td><td>1</td><td>-</td><td>${totalEnfantsCharge}</td></tr></c:if>

                    <tr class="total-row" style="font-size: 1.2em; background: #c3e6cb;">
                        <td colspan="3"><strong>NET À PAYER</strong></td>
                        <td><strong>${fiche.netAPayer} Ar</strong></td>
                    </tr>
                </tbody>
            </table>

            <div style="margin-top: 20px; font-size: 0.9em; color: #555;">
                <p><strong>Salaire imposable :</strong> ${fiche.salaireImposable} Ar</p>
                <p><strong>Enfants à charge :</strong> 
                    <c:set var="nbEnfants" value="0"/>
                    
                        <c:set var="nbEnfants" value="${nbEnfants + fiche.impot.enfantChargeNbr}"/>
                   
                    ${nbEnfants}
                </p>
            </div>
        </div>
    </c:if>

    <script>
        document.getElementById('btn-export-pdf')?.addEventListener('click', async function() {
            const btn = this;
            const original = btn.innerHTML;
            btn.disabled = true;
            btn.innerHTML = 'Génération du PDF...';

            try {
                const { jsPDF } = window.jspdf;
                const element = document.getElementById('fiche-paie');

                // Récupération des données propres
                const nom = document.getElementById('data-nom')?.textContent.trim() || 'Inconnu';
                const prenom = document.getElementById('data-prenom')?.textContent.trim() || '';
                const periode = document.getElementById('data-mois')?.textContent.trim() || 'Periode';

                const canvas = await html2canvas(element, { scale: 2, useCORS: true, backgroundColor: '#ffffff' });
                const imgData = canvas.toDataURL('image/png');

                const pdf = new jsPDF('p', 'mm', 'a4');
                const width = pdf.internal.pageSize.getWidth();
                const height = pdf.internal.pageSize.getHeight();
                const imgWidth = width - 20;
                const imgHeight = (canvas.height * imgWidth) / canvas.width;

                let y = 15;
                pdf.setFontSize(16);
                pdf.text(`FICHE DE PAIE - ${periode}`, width / 2, 10, { align: 'center' });

                pdf.addImage(imgData, 'PNG', 10, y, imgWidth, imgHeight);
                let remaining = imgHeight - (height - y - 10);

                while (remaining > 0) {
                    pdf.addPage();
                    pdf.addImage(imgData, 'PNG', 10, 10, imgWidth, imgHeight, '', 'FAST', 0, [0, - (imgHeight - remaining)]);
                    remaining -= height - 20;
                }

                const filename = `Fiche_Paie_${nom}_${prenom}_${periode}.pdf`.replace(/[^a-zA-Z0-9_]/g, '_');
                pdf.save(filename);

            } catch (e) {
                console.error(e);
                alert("Erreur lors de la génération du PDF");
            } finally {
                btn.disabled = false;
                btn.innerHTML = original;
            }
        });
    </script>
</body>
</html>