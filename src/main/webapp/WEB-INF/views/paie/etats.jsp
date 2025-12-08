<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Etat de Paie</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
    <!-- CDN pour l'export PDF -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
    <style>
        :root {
            --primary: #2c3e50;
            --secondary: #3498db;
            --success: #27ae60;
            --warning: #f39c12;
            --danger: #e74c3c;
            --light: #ecf0f1;
            --dark: #34495e;
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        
        .container {
            max-width: 95%;
            margin: 0 auto;
        }
        
        .header {
            background: white;
            padding: 25px;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            margin-bottom: 25px;
            text-align: center;
        }
        
        .header h1 {
            color: var(--primary);
            font-size: 2.2em;
            margin-bottom: 10px;
            font-weight: 600;
        }
        
        .header p {
            color: var(--dark);
            font-size: 1.1em;
            opacity: 0.8;
        }
        
        .filters-card {
            background: white;
            padding: 25px;
            border-radius: 15px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
            margin-bottom: 25px;
        }
        
        .filters-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            align-items: end;
        }
        
        .filter-group {
            display: flex;
            flex-direction: column;
        }
        
        .filter-group label {
            font-weight: 600;
            color: var(--primary);
            margin-bottom: 8px;
            font-size: 0.9em;
        }
        
        .filter-input {
            padding: 12px 15px;
            border: 2px solid #e9ecef;
            border-radius: 10px;
            font-size: 14px;
            transition: all 0.3s ease;
            background: white;
        }
        
        .filter-input:focus {
            outline: none;
            border-color: var(--secondary);
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
        }
        
        .btn {
            padding: 12px 25px;
            border: none;
            border-radius: 10px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
        }
        
        .btn-primary {
            background: var(--secondary);
            color: white;
        }
        
        .btn-primary:hover {
            background: #2980b9;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(52, 152, 219, 0.3);
        }
        
        .btn-outline {
            background: transparent;
            border: 2px solid var(--secondary);
            color: var(--secondary);
        }
        
        .btn-outline:hover {
            background: var(--secondary);
            color: white;
        }
        
        .table-container {
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        
        .table-header {
            padding: 20px;
            background: var(--primary);
            color: white;
            display: flex;
            justify-content: between;
            align-items: center;
        }
        
        .table-header h3 {
            font-size: 1.3em;
            font-weight: 600;
        }
        
        .table-tools {
            display: flex;
            gap: 10px;
            align-items: center;
        }
        
        .search-box {
            position: relative;
        }
        
        .search-input {
            padding: 10px 15px 10px 40px;
            border: none;
            border-radius: 8px;
            width: 250px;
            font-size: 14px;
        }
        
        .search-icon {
            position: absolute;
            left: 12px;
            top: 50%;
            transform: translateY(-50%);
            color: #6c757d;
        }
        
        .table-wrapper {
            overflow-x: auto;
            max-height: 70vh;
            position: relative;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
            font-size: 13px;
            min-width: 2000px;
        }
        
        thead {
            position: sticky;
            top: 0;
            z-index: 10;
        }
        
        th {
            background: linear-gradient(135deg, var(--primary), var(--dark));
            color: white;
            padding: 15px 12px;
            text-align: left;
            font-weight: 600;
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            position: relative;
        }
        
        th:after {
            content: '';
            position: absolute;
            right: 0;
            top: 50%;
            transform: translateY(-50%);
            width: 1px;
            height: 60%;
            background: rgba(255,255,255,0.3);
        }
        
        th:last-child:after {
            display: none;
        }
        
        th.sortable {
            cursor: pointer;
            transition: background 0.3s ease;
        }
        
        th.sortable:hover {
            background: linear-gradient(135deg, var(--dark), var(--primary));
        }
        
        td {
            padding: 12px;
            border-bottom: 1px solid #e9ecef;
            background: white;
            transition: background 0.3s ease;
        }
        
        tbody tr:hover td {
            background: #f8f9fa;
        }
        
        tbody tr:nth-child(even) td {
            background: #f8f9fa;
        }
        
        tbody tr:nth-child(even):hover td {
            background: #e9ecef;
        }
        
        .amount {
            text-align: right;
            font-family: 'Courier New', monospace;
            font-weight: 600;
        }
        
        .positive {
            color: var(--success);
        }
        
        .negative {
            color: var(--danger);
        }
        
        .summary-card {
            background: white;
            padding: 20px;
            border-radius: 15px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
            margin-top: 25px;
        }
        
        .summary-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
        }
        
        .summary-item {
            text-align: center;
            padding: 15px;
            border-radius: 10px;
            background: var(--light);
        }
        
        .summary-value {
            font-size: 1.5em;
            font-weight: 700;
            color: var(--primary);
            margin: 5px 0;
        }
        
        .summary-label {
            font-size: 0.9em;
            color: var(--dark);
            opacity: 0.8;
        }
        
        .export-buttons {
            display: flex;
            gap: 10px;
            justify-content: center;
            margin-top: 20px;
        }
        
        /* Styles pour l'export PDF */
        .loading-pdf {
            display: none;
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background: rgba(0,0,0,0.8);
            color: white;
            padding: 20px 30px;
            border-radius: 10px;
            z-index: 10000;
            text-align: center;
        }
        
        .loading-pdf i {
            font-size: 2em;
            margin-bottom: 10px;
            display: block;
        }
        
        .btn:disabled {
            opacity: 0.6;
            cursor: not-allowed;
            transform: none !important;
        }
        
        @media (max-width: 768px) {
            .filters-grid {
                grid-template-columns: 1fr;
            }
            
            .table-header {
                flex-direction: column;
                gap: 15px;
            }
            
            .search-input {
                width: 100%;
            }
            
            .export-buttons {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Header -->
        <div class="header">
            <h1><i class="fas fa-file-invoice-dollar"></i> État de Paie</h1>
            <p>Gestion et consultation des fiches de paie</p>
        </div>
        
        <!-- Filtres -->
        <div class="filters-card">
            <div class="filters-grid">
                <div class="filter-group">
                    <label for="searchEmploye"><i class="fas fa-search"></i> Recherche Employé</label>
                    <input type="text" id="searchEmploye" class="filter-input" placeholder="Nom, prénom ou matricule...">
                </div>
                
                <div class="filter-group">
                    <label for="selectMois"><i class="fas fa-calendar"></i> Mois</label>
                    <select id="selectMois" class="filter-input">
                        <option value="">Tous les mois</option>
                        <option value="1">Janvier</option>
                        <option value="2">Février</option>
                        <option value="3">Mars</option>
                        <option value="4">Avril</option>
                        <option value="5">Mai</option>
                        <option value="6">Juin</option>
                        <option value="7">Juillet</option>
                        <option value="8">Août</option>
                        <option value="9">Septembre</option>
                        <option value="10">Octobre</option>
                        <option value="11">Novembre</option>
                        <option value="12">Décembre</option>
                    </select>
                </div>
                
                <div class="filter-group">
                    <label for="selectAnnee"><i class="fas fa-calendar-alt"></i> Année</label>
                    <select id="selectAnnee" class="filter-input">
                        <option value="">Toutes les années</option>
                        <option value="2024">2024</option>
                        <option value="2023">2023</option>
                        <option value="2022">2022</option>
                    </select>
                </div>
                
                <div class="filter-group">
                    <label for="selectFonction"><i class="fas fa-briefcase"></i> Fonction</label>
                    <select id="selectFonction" class="filter-input">
                        <option value="">Toutes les fonctions</option>
                        <option value="Directeur">Directeur</option>
                        <option value="Manager">Manager</option>
                        <option value="Développeur">Développeur</option>
                        <option value="Designer">Designer</option>
                    </select>
                </div>
                
                <div class="filter-group">
                    <label for="minSalaire"><i class="fas fa-money-bill-wave"></i> Salaire Min</label>
                    <input type="number" id="minSalaire" class="filter-input" placeholder="Salaire minimum">
                </div>
                
                <div class="filter-group">
                    <label for="maxSalaire"><i class="fas fa-money-bill-wave"></i> Salaire Max</label>
                    <input type="number" id="maxSalaire" class="filter-input" placeholder="Salaire maximum">
                </div>
                
                <div class="filter-group">
                    <button class="btn btn-primary" onclick="appliquerFiltres()">
                        <i class="fas fa-filter"></i> Appliquer les Filtres
                    </button>
                </div>
                
                <div class="filter-group">
                    <button class="btn btn-outline" onclick="reinitialiserFiltres()">
                        <i class="fas fa-redo"></i> Réinitialiser
                    </button>
                </div>
            </div>
        </div>
        
        <!-- Tableau -->
        <div class="table-container">
            <div class="table-header">
                <h3><i class="fas fa-table"></i> Liste des Fiches de Paie</h3>
                <div class="table-tools">
                    <div class="search-box">
                        <i class="fas fa-search search-icon"></i>
                        <input type="text" id="globalSearch" class="search-input" placeholder="Recherche globale...">
                    </div>
                    <span id="resultCount" class="result-count">0 résultats</span>
                </div>
            </div>
            
            <div class="table-wrapper">
                <table id="paieTable">
                    <thead>
                        <tr>
                            <th class="sortable" onclick="sortTable(0)">Date <i class="fas fa-sort"></i></th>
                            <th class="sortable" onclick="sortTable(1)">N Matricule <i class="fas fa-sort"></i></th>
                            <th class="sortable" onclick="sortTable(2)">Nom et prénom(s) <i class="fas fa-sort"></i></th>
                            <th class="sortable" onclick="sortTable(3)">Date embauche <i class="fas fa-sort"></i></th>
                            <th class="sortable" onclick="sortTable(4)">Fonction <i class="fas fa-sort"></i></th>
                            <th class="sortable" onclick="sortTable(5)">Salaire base <i class="fas fa-sort"></i></th>
                            <th class="sortable" onclick="sortTable(6)">Indemnité <i class="fas fa-sort"></i></th>
                            <th class="sortable" onclick="sortTable(7)">Rappel <i class="fas fa-sort"></i></th>
                            <th class="sortable" onclick="sortTable(8)">Heure Supplementaire <i class="fas fa-sort"></i></th>
                            <th class="sortable" onclick="sortTable(9)">Autres <i class="fas fa-sort"></i></th>
                            <th class="sortable" onclick="sortTable(10)">Salaire Brut <i class="fas fa-sort"></i></th>
                            <th class="sortable" onclick="sortTable(11)">N Cnaps <i class="fas fa-sort"></i></th>
                            <th class="sortable" onclick="sortTable(12)">Cnaps employé <i class="fas fa-sort"></i></th>
                            <th class="sortable" onclick="sortTable(13)">Cnaps patronal <i class="fas fa-sort"></i></th>
                            <th class="sortable" onclick="sortTable(14)">Ostie employé <i class="fas fa-sort"></i></th>
                            <th class="sortable" onclick="sortTable(15)">Ostie patronal <i class="fas fa-sort"></i></th>
                            <th class="sortable" onclick="sortTable(16)">Nombre d'Absence<i class="fas fa-sort"></i></th>
                            <th class="sortable" onclick="sortTable(17)">Retenu Absence<i class="fas fa-sort"></i></th>
                            <th class="sortable" onclick="sortTable(18)">Autres retenus <i class="fas fa-sort"></i></th>
                            <th class="sortable" onclick="sortTable(19)">Total Retenu <i class="fas fa-sort"></i></th>
                            <th class="sortable" onclick="sortTable(20)">Salaire Imposable <i class="fas fa-sort"></i></th>
                            <th class="sortable" onclick="sortTable(21)">Impot du <i class="fas fa-sort"></i></th>
                            <th class="sortable" onclick="sortTable(22)">Enfant(s) charge <i class="fas fa-sort"></i></th>
                            <th class="sortable" onclick="sortTable(23)">Montant Enfant(s) <i class="fas fa-sort"></i></th>
                            <th class="sortable" onclick="sortTable(24)">IGR NET <i class="fas fa-sort"></i></th>
                            <th class="sortable" onclick="sortTable(25)">Autre impot <i class="fas fa-sort"></i></th>
                            <th class="sortable" onclick="sortTable(26)">Salaire Net <i class="fas fa-sort"></i></th>
                            <th class="sortable" onclick="sortTable(27)">Avance <i class="fas fa-sort"></i></th>
                            <th class="sortable" onclick="sortTable(28)">Net à payer <i class="fas fa-sort"></i></th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="etat" items="${etatsPaie}">
                            <c:forEach var="fiche" items="${etat.fichePaie}">
                                <tr class="paie-row">
                                    <td>${fiche.getMoisString(fiche.mois)} ${fiche.annee}</td>
                                    <td>${fiche.personnel.matricule}</td>
                                    <td>${fiche.personnel.candidat.nom} ${fiche.personnel.candidat.prenom}</td>
                                    <td>${fiche.personnel.date_embauche}</td>
                                    <td>${fiche.personnel.poste.libelle}</td>
                                    <td class="amount">${fiche.personnel.poste.salaire}</td>
                                    <td class="amount positive">
                                        <c:set var="totalIndemnite" value="0"/>
                                        <c:forEach var="prime" items="${fiche.primes}">
                                            <c:set var="totalIndemnite" value="${totalIndemnite + prime.indemnite}"/>
                                        </c:forEach>
                                        ${totalIndemnite}
                                    </td>
                                    <td class="amount positive">
                                        <c:set var="totalRappel" value="0"/>
                                        <c:forEach var="prime" items="${fiche.primes}">
                                            <c:set var="totalRappel" value="${totalRappel + prime.rappels}"/>
                                        </c:forEach>
                                        ${totalRappel}
                                    </td>
                                    <td>${fiche.totalHeureSup}</td>
                                    <td class="amount positive">
                                        <c:set var="totalAutres" value="0"/>
                                        <c:forEach var="prime" items="${fiche.primes}">
                                            <c:set var="totalAutres" value="${totalAutres + prime.autres}"/>
                                        </c:forEach>
                                        ${totalAutres}
                                    </td>
                                    <td class="amount positive">${fiche.salaireBrut}</td>
                                    <td>${fiche.personnel.num_cnaps}</td>
                                    <td class="amount negative">
                                        <c:set var="cnapsEmploye" value="0"/>
                                        <c:forEach var="retenu" items="${fiche.retenus}">
                                            <c:if test="${retenu.typeRetenu.libelle.contains('CNaPS') and retenu.typeRetenu.typeEnum.name() == 'EMPLOYE'}">
                                                <c:set var="cnapsEmploye" value="${retenu.calculRetenu(fiche.personnel.poste.salaire)}"/>
                                            </c:if>
                                        </c:forEach>
                                        ${cnapsEmploye}
                                    </td>
                                    <td class="amount negative">
                                        <c:set var="cnapsPatronal" value="0"/>
                                        <c:forEach var="retenu" items="${fiche.retenus}">
                                            <c:if test="${retenu.typeRetenu.libelle.contains('CNaPS') and retenu.typeRetenu.typeEnum.name() == 'PATRONIAL'}">
                                                <c:set var="cnapsPatronal" value="${retenu.calculRetenu(fiche.personnel.poste.salaire)}"/>
                                            </c:if>
                                        </c:forEach>
                                        ${cnapsPatronal}
                                    </td>
                                    <td class="amount negative">
                                        <c:set var="ostieEmploye" value="0"/>
                                        <c:forEach var="retenu" items="${fiche.retenus}">
                                            <c:if test="${retenu.typeRetenu.libelle.contains('OSTIE') and retenu.typeRetenu.typeEnum.name() == 'EMPLOYE'}">
                                                <c:set var="ostieEmploye" value="${retenu.calculRetenu(fiche.personnel.poste.salaire)}"/>
                                            </c:if>
                                        </c:forEach>
                                        ${ostieEmploye}
                                    </td>
                                    <td class="amount negative">
                                        <c:set var="ostiePatronal" value="0"/>
                                        <c:forEach var="retenu" items="${fiche.retenus}">
                                            <c:if test="${retenu.typeRetenu.libelle.contains('OSTIE') and retenu.typeRetenu.typeEnum.name() == 'PATRONIAL'}">
                                                <c:set var="ostiePatronal" value="${retenu.calculRetenu(fiche.personnel.poste.salaire)}"/>
                                            </c:if>
                                        </c:forEach>
                                        ${ostiePatronal}
                                    </td>
                                    <td>${fiche.totalAbsence}</td>
                                    <td class="amount negative">
                                        <c:set var="Absence" value="0"/>
                                        <c:forEach var="retenu" items="${fiche.retenus}">
                                            <c:if test="${retenu.typeRetenu.typeEnum.name() == 'ABSENCE'}">
                                                <c:set var="Absence" value="${Absence + retenu.calculAbsence(fiche.personnel.poste.salaire, fiche.totalAbsence)}"/>
                                            </c:if>
                                        </c:forEach>
                                        ${Absence}
                                    </td>
                                    <td class="amount negative">
                                        <c:set var="autresRetenus" value="0"/>
                                        <c:forEach var="retenu" items="${fiche.retenus}">
                                            <c:if test="${retenu.typeRetenu.typeEnum.name() == 'AUTRE'}">
                                                <c:set var="autresRetenus" value="${autresRetenus + retenu.calculRetenu(fiche.personnel.poste.salaire)}"/>
                                            </c:if>
                                        </c:forEach>
                                        ${autresRetenus}
                                    </td>
                                    <td class="amount negative">${fiche.totalRetenus}</td>
                                    <td class="amount">${fiche.salaireImposable}</td>
                                    <td class="amount negative">
                                        <c:set var="impotDu" value="0"/>
                                        
                                            <c:set var="impotDu" value="${impotDu + fiche.impot.impotDu}"/>
                                        
                                        ${impotDu}
                                    </td>
                                    <td class="amount">
                                        <c:set var="enfantsCharge" value="0"/>
                                        
                                            <c:set var="enfantsCharge" value="${enfantsCharge + (fiche.impot.enfantChargeNbr)}"/>
                                        
                                        ${enfantsCharge}
                                    </td>
                                    <td class="amount positive">
                                        <c:set var="montantEnfants" value="0"/>
                                        
                                            <c:set var="montantEnfants" value="${montantEnfants + fiche.impot.calculerTotalChargesEnfants()}"/>
                                        
                                        ${montantEnfants}
                                    </td>
                                    <td class="amount negative">
                                        <c:set var="igrnet" value="0"/>
                                        
                                            <c:set var="igrnet" value="${igrnet + (fiche.impot.igrnet)}"/>
                                        
                                        ${igrnet}
                                    </td>
                                    <td class="amount negative">
                                        <c:set var="autresImpots" value="0"/>
                                        
                                            <c:set var="autresImpots" value="${autresImpots + (fiche.impot.autresImpots)}"/>
                                        
                                        ${autresImpots}
                                    </td>
                                    <td class="amount positive">${fiche.salaireNet}</td>
                                    <td class="amount negative">
                                        <c:set var="avance" value="0"/>
                                        <c:forEach var="prime" items="${fiche.primes}">
                                            <c:set var="avance" value="${avance + prime.avance}"/>
                                        </c:forEach>
                                        ${avance}
                                    </td>
                                    <td class="amount positive">${fiche.netAPayer}</td>
                                </tr>
                            </c:forEach>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
        
        <!-- Résumé -->
        <div class="summary-card">
            <h3 style="text-align: center; margin-bottom: 20px; color: var(--primary);">
                <i class="fas fa-chart-bar"></i> Résumé Global
            </h3>
            <div class="summary-grid">
                <div class="summary-item">
                    <div class="summary-label">Total Salaire Brut</div>
                    <div class="summary-value" id="totalBrut">0</div>
                </div>
                <div class="summary-item">
                    <div class="summary-label">Total Retenus</div>
                    <div class="summary-value" id="totalRetenus">0</div>
                </div>
                <div class="summary-item">
                    <div class="summary-label">Total Net à Payer</div>
                    <div class="summary-value" id="totalNet">0</div>
                </div>
                <div class="summary-item">
                    <div class="summary-label">Nombre de Fiches</div>
                    <div class="summary-value" id="totalFiches">0</div>
                </div>
            </div>
            
            <div class="export-buttons">
                <button class="btn btn-primary" onclick="exporterPDF()">
                    <i class="fas fa-file-pdf"></i> Exporter en PDF
                </button>
                <button class="btn btn-outline" onclick="imprimerTableau()">
                    <i class="fas fa-print"></i> Imprimer
                </button>
            </div>
        </div>
    </div>

    <!-- Loading pour l'export PDF -->
    <div id="loadingPDF" class="loading-pdf">
        <i class="fas fa-spinner fa-spin"></i>
        <div>Génération du PDF en cours...</div>
        <div style="font-size: 12px; margin-top: 5px;">Veuillez patienter</div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
    <script>
        // Initialiser jsPDF
        const { jsPDF } = window.jspdf;

        // Initialisation
        document.addEventListener('DOMContentLoaded', function() {
            mettreAJourResume();
            mettreAJourCompteur();
            
            // Initialiser Select2 pour les selects
            $('#selectMois, #selectAnnee, #selectFonction').select2({
                width: '100%',
                placeholder: "Sélectionner...",
                allowClear: true
            });
            
            // Recherche en temps réel
            $('#globalSearch').on('input', function() {
                filtrerTableau();
            });
        });
        
        let ordreTri = {};
        
        function sortTable(columnIndex) {
            const table = document.getElementById('paieTable');
            const tbody = table.getElementsByTagName('tbody')[0];
            const rows = Array.from(tbody.getElementsByTagName('tr'));
            
            // Déterminer l'ordre de tri
            ordreTri[columnIndex] = !ordreTri[columnIndex];
            const ordre = ordreTri[columnIndex] ? 1 : -1;
            
            rows.sort((a, b) => {
                const cellA = a.cells[columnIndex].textContent.trim();
                const cellB = b.cells[columnIndex].textContent.trim();
                
                // Essayer de convertir en nombre si possible
                const numA = parseFloat(cellA.replace(/[^\d.-]/g, ''));
                const numB = parseFloat(cellB.replace(/[^\d.-]/g, ''));
                
                if (!isNaN(numA) && !isNaN(numB)) {
                    return (numA - numB) * ordre;
                }
                
                return cellA.localeCompare(cellB) * ordre;
            });
            
            // Réorganiser les lignes
            rows.forEach(row => tbody.appendChild(row));
            
            // Mettre à jour les icônes de tri
            mettreAJourIconesTri(columnIndex);
        }
        
        function mettreAJourIconesTri(columnIndexActif) {
            const headers = document.querySelectorAll('th.sortable');
            headers.forEach((header, index) => {
                const icon = header.querySelector('i');
                if (index === columnIndexActif) {
                    icon.className = ordreTri[columnIndexActif] ? 
                        'fas fa-sort-up' : 'fas fa-sort-down';
                } else {
                    icon.className = 'fas fa-sort';
                }
            });
        }
        
        function appliquerFiltres() {
            filtrerTableau();
        }
        
        function reinitialiserFiltres() {
            document.getElementById('searchEmploye').value = '';
            document.getElementById('selectMois').value = '';
            document.getElementById('selectAnnee').value = '';
            document.getElementById('selectFonction').value = '';
            document.getElementById('minSalaire').value = '';
            document.getElementById('maxSalaire').value = '';
            document.getElementById('globalSearch').value = '';
            
            // Réinitialiser Select2
            $('#selectMois, #selectAnnee, #selectFonction').val(null).trigger('change');
            
            filtrerTableau();
        }
        
        function filtrerTableau() {
            const searchEmploye = document.getElementById('searchEmploye').value.toLowerCase();
            const selectedMois = document.getElementById('selectMois').value;
            const selectedAnnee = document.getElementById('selectAnnee').value;
            const selectedFonction = document.getElementById('selectFonction').value;
            const minSalaire = parseFloat(document.getElementById('minSalaire').value) || 0;
            const maxSalaire = parseFloat(document.getElementById('maxSalaire').value) || Infinity;
            const globalSearch = document.getElementById('globalSearch').value.toLowerCase();
            
            const rows = document.querySelectorAll('#paieTable tbody tr');
            let visibleCount = 0;
            
            rows.forEach(row => {
                const matricule = row.cells[1].textContent.toLowerCase();
                const nomPrenom = row.cells[2].textContent.toLowerCase();
                const date = row.cells[0].textContent.toLowerCase();
                const fonction = row.cells[4].textContent;
                const salaireBase = parseFloat(row.cells[5].textContent) || 0;
                
                let correspond = true;
                
                // Filtre employé
                if (searchEmploye && !matricule.includes(searchEmploye) && !nomPrenom.includes(searchEmploye)) {
                    correspond = false;
                }
                
                // Filtre mois
                if (selectedMois && !date.includes(getMoisNom(selectedMois))) {
                    correspond = false;
                }
                
                // Filtre année
                if (selectedAnnee && !date.includes(selectedAnnee)) {
                    correspond = false;
                }
                
                // Filtre fonction
                if (selectedFonction && fonction !== selectedFonction) {
                    correspond = false;
                }
                
                // Filtre salaire
                if (salaireBase < minSalaire || salaireBase > maxSalaire) {
                    correspond = false;
                }
                
                // Recherche globale
                if (globalSearch) {
                    let trouve = false;
                    for (let i = 0; i < row.cells.length; i++) {
                        if (row.cells[i].textContent.toLowerCase().includes(globalSearch)) {
                            trouve = true;
                            break;
                        }
                    }
                    if (!trouve) correspond = false;
                }
                
                row.style.display = correspond ? '' : 'none';
                if (correspond) visibleCount++;
            });
            
            document.getElementById('resultCount').textContent = visibleCount + ' résultat(s)';
            mettreAJourResume();
        }
        
        function getMoisNom(numeroMois) {
            const mois = {
                '1': 'janvier', '2': 'fevrier', '3': 'mars', '4': 'avril',
                '5': 'mai', '6': 'juin', '7': 'juillet', '8': 'aout',
                '9': 'septembre', '10': 'octobre', '11': 'novembre', '12': 'decembre'
            };
            return mois[numeroMois] || '';
        }
        
        function mettreAJourResume() {
            let totalBrut = 0;
            let totalRetenus = 0;
            let totalNet = 0;
            let count = 0;
            
            document.querySelectorAll('#paieTable tbody tr').forEach(row => {
                if (row.style.display !== 'none') {
                    const brut = parseFloat(row.cells[9].textContent) || 0;
                    const retenus = parseFloat(row.cells[16].textContent) || 0;
                    const net = parseFloat(row.cells[25].textContent) || 0;
                    
                    totalBrut += brut;
                    totalRetenus += retenus;
                    totalNet += net;
                    count++;
                }
            });
            
            document.getElementById('totalBrut').textContent = formatMontant(totalBrut);
            document.getElementById('totalRetenus').textContent = formatMontant(totalRetenus);
            document.getElementById('totalNet').textContent = formatMontant(totalNet);
            document.getElementById('totalFiches').textContent = count;
        }
        
        function mettreAJourCompteur() {
            const totalRows = document.querySelectorAll('#paieTable tbody tr').length;
            document.getElementById('resultCount').textContent = totalRows + ' résultat(s)';
        }
        
        function formatMontant(montant) {
            return new Intl.NumberFormat('fr-FR', {
                minimumFractionDigits: 2,
                maximumFractionDigits: 2
            }).format(montant);
        }
        
        // Fonction d'export PDF
        async function exporterPDF() {
            const btnExport = document.querySelector('.btn-primary[onclick="exporterPDF()"]');
            const loadingDiv = document.getElementById('loadingPDF');
            
            try {
                // Afficher le loading et désactiver le bouton
                if (loadingDiv) loadingDiv.style.display = 'block';
                if (btnExport) {
                    btnExport.disabled = true;
                    btnExport.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Génération...';
                }
                
                // Créer un conteneur temporaire pour l'export
                const exportContainer = document.createElement('div');
                exportContainer.style.position = 'absolute';
                exportContainer.style.left = '-9999px';
                exportContainer.style.top = '0';
                exportContainer.style.width = '297mm'; // Format A4 paysage
                exportContainer.style.background = 'white';
                exportContainer.style.padding = '20px';
                exportContainer.style.fontFamily = 'Arial, sans-serif';
                
                // Cloner le contenu à exporter
                const header = document.querySelector('.header').cloneNode(true);
                const tableContainer = document.querySelector('.table-container').cloneNode(true);
                const summaryCard = document.querySelector('.summary-card').cloneNode(true);
                
                // Appliquer des styles optimisés pour le PDF
                header.style.textAlign = 'center';
                header.style.marginBottom = '20px';
                
                const table = tableContainer.querySelector('table');
                table.style.fontSize = '8px';
                table.style.minWidth = '1800px';
                
                // Construire le contenu de l'export
                exportContainer.appendChild(header);
                exportContainer.appendChild(tableContainer);
                exportContainer.appendChild(summaryCard);
                document.body.appendChild(exportContainer);
                
                // Générer le PDF avec html2canvas
                const canvas = await html2canvas(exportContainer, {
                    scale: 2, // Haute résolution
                    useCORS: true,
                    logging: false,
                    backgroundColor: '#ffffff',
                    width: exportContainer.scrollWidth,
                    height: exportContainer.scrollHeight
                });
                
                // Nettoyer le conteneur temporaire
                document.body.removeChild(exportContainer);
                
                const imgData = canvas.toDataURL('image/jpeg', 0.9);
                
                // Créer le PDF
                const pdf = new jsPDF({
                    orientation: 'landscape', // Paysage pour le tableau large
                    unit: 'mm',
                    format: 'a4'
                });
                
                const pdfWidth = pdf.internal.pageSize.getWidth();
                const pdfHeight = pdf.internal.pageSize.getHeight();
                const imgWidth = pdfWidth;
                const imgHeight = (canvas.height * pdfWidth) / canvas.width;
                
                // Ajouter l'image au PDF
                pdf.addImage(imgData, 'JPEG', 0, 0, imgWidth, imgHeight);
                
                // Générer le nom du fichier
                const date = new Date();
                const dateStr = date.toISOString().split('T')[0];
                const fileName = `etat_paie_${dateStr}.pdf`;
                
                // Télécharger le PDF
                pdf.save(fileName);
                
            } catch (error) {
                console.error('Erreur lors de la génération du PDF:', error);
                alert('Erreur lors de la génération du PDF: ' + error.message);
            } finally {
                // Réactiver le bouton et cacher le loading
                if (loadingDiv) loadingDiv.style.display = 'none';
                if (btnExport) {
                    btnExport.disabled = false;
                    btnExport.innerHTML = '<i class="fas fa-file-pdf"></i> Exporter en PDF';
                }
            }
        }
        
        function exporterExcel() {
            alert('Fonctionnalité Excel à implémenter');
            // Implémentation avec SheetJS ou autre bibliothèque
        }
        
        function imprimerTableau() {
            window.print();
        }
    </script>
</body>
</html>