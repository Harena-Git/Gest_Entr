<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Liste des Personnels</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f8f9fa;
            min-height: 100vh;
        }

        .dashboard-container {
            display: flex;
            min-height: 100vh;
        }

        /* Sidebar */
        .sidebar {
            width: 260px;
            background: #495057;
            color: white;
            padding: 0;
            box-shadow: 2px 0 10px rgba(0, 0, 0, 0.1);
            position: fixed;
            height: 100vh;
            overflow-y: auto;
        }

        .sidebar-header {
            padding: 30px 20px;
            background: #343a40;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }

        .sidebar-header h4 {
            font-size: 1.5em;
            font-weight: 600;
            margin-bottom: 5px;
        }

        .sidebar-header p {
            font-size: 0.85em;
            opacity: 0.8;
        }

        .nav-menu {
            padding: 20px 0;
        }

        .nav-item {
            margin-bottom: 5px;
        }

        .nav-link {
            display: flex;
            align-items: center;
            padding: 12px 20px;
            color: rgba(255, 255, 255, 0.8);
            text-decoration: none;
            transition: all 0.3s ease;
            border-left: 3px solid transparent;
        }

        .nav-link:hover {
            background: rgba(255, 255, 255, 0.1);
            color: white;
            border-left-color: white;
        }

        .nav-link.active {
            background: rgba(255, 255, 255, 0.15);
            color: white;
            border-left-color: white;
            font-weight: 500;
        }

        .nav-icon {
            margin-right: 12px;
            font-size: 1.2em;
        }

        /* Section repliable */
        .nav-section {
            margin-bottom: 5px;
        }

        .section-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 12px 20px;
            color: white;
            background: rgba(255, 255, 255, 0.05);
            cursor: pointer;
            transition: all 0.3s ease;
            border-left: 3px solid transparent;
            font-weight: 500;
        }

        .section-header:hover {
            background: rgba(255, 255, 255, 0.1);
            border-left-color: white;
        }

        .section-header.active {
            background: rgba(255, 255, 255, 0.15);
            border-left-color: white;
        }

        .section-title {
            display: flex;
            align-items: center;
        }

        .chevron {
            font-size: 0.8em;
            transition: transform 0.3s ease;
        }

        .chevron.open {
            transform: rotate(180deg);
        }

        .section-content {
            max-height: 0;
            overflow: hidden;
            transition: max-height 0.3s ease;
            background: rgba(0, 0, 0, 0.1);
        }

        .section-content.open {
            max-height: 500px;
        }

        .section-content .nav-link {
            padding-left: 52px;
            font-size: 0.95em;
        }

        .logout-section {
            padding: 20px;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            margin-top: auto;
        }

        .btn-logout {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 100%;
            padding: 12px;
            background: rgba(220, 53, 69, 0.2);
            color: white;
            border: 1px solid rgba(220, 53, 69, 0.3);
            border-radius: 8px;
            text-decoration: none;
            transition: all 0.3s ease;
        }

        .btn-logout:hover {
            background: #dc3545;
            border-color: #dc3545;
        }

        /* Main Content */
        .main-content {
            flex: 1;
            margin-left: 260px;
            padding: 30px;
        }

        .content-header {
            background: white;
            padding: 25px 30px;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            margin-bottom: 30px;
        }

        .content-header h2 {
            color: #495057;
            font-size: 1.8em;
            font-weight: 600;
        }

        @media (max-width: 768px) {
            .sidebar {
                width: 100%;
                height: auto;
                position: relative;
            }

            .main-content {
                margin-left: 0;
                padding: 20px;
            }
        }

        /* État vide */
        .empty-state {
            background: white;
            padding: 40px;
            border-radius: 12px;
            text-align: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            margin-top: 20px;
        }

        .empty-state h3 {
            color: #495057;
            font-size: 1.6em;
            margin-bottom: 10px;
        }

        .empty-state p {
            color: #6c757d;
            font-size: 1em;
        }

        .header-actions {
            display: flex;
            gap: 15px;
        }

        .btn-primary {
            background: #007bff;
            color: white;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 8px;
            transition: all 0.3s ease;
            font-weight: 500;
            border: none;
            cursor: pointer;
        }

        .btn-primary:hover {
            background: #0056b3;
            transform: translateY(-2px);
        }

        /* Filtres et Recherche */
        .filters-section {
            background: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
            margin-bottom: 25px;
        }

        .search-box {
            display: flex;
            gap: 15px;
            margin-bottom: 20px;
            align-items: center;
        }

        .search-input {
            flex: 1;
            padding: 12px 15px;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            font-size: 1em;
            transition: all 0.3s ease;
        }

        .search-input:focus {
            outline: none;
            border-color: #007bff;
            box-shadow: 0 0 0 3px rgba(0, 123, 255, 0.1);
        }

        .btn-search {
            background: #28a745;
            color: white;
            padding: 12px 25px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .btn-search:hover {
            background: #218838;
            transform: translateY(-2px);
        }

        .btn-reset {
            background: #6c757d;
            color: white;
            padding: 12px 20px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 500;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
        }

        .btn-reset:hover {
            background: #545b62;
            transform: translateY(-2px);
        }

        .filters-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 15px;
        }

        .filter-group {
            display: flex;
            flex-direction: column;
        }

        .filter-label {
            font-weight: 600;
            margin-bottom: 8px;
            color: #495057;
            font-size: 0.9em;
        }

        .filter-select {
            padding: 10px 12px;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            font-size: 0.95em;
            background: white;
            transition: all 0.3s ease;
        }

        .filter-select:focus {
            outline: none;
            border-color: #007bff;
            box-shadow: 0 0 0 3px rgba(0, 123, 255, 0.1);
        }

        .quick-filters {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .quick-filter-btn {
            background: #e9ecef;
            color: #495057;
            padding: 8px 16px;
            border: none;
            border-radius: 20px;
            cursor: pointer;
            font-size: 0.9em;
            transition: all 0.3s ease;
        }

        .quick-filter-btn:hover {
            background: #dee2e6;
            transform: translateY(-1px);
        }

        .quick-filter-btn.active {
            background: #007bff;
            color: white;
        }

        /* Indicateurs de filtre */
        .department-filter-info {
            background: #fff3cd;
            color: #856404;
            padding: 12px 20px;
            border-radius: 8px;
            margin-bottom: 15px;
            border-left: 4px solid #ffc107;
            font-size: 0.95em;
        }
        
        .rh-badge {
            background: #17a2b8;
            color: white;
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 0.8em;
            margin-left: 10px;
        }

        .rh-full-access {
            background: #d1ecf1;
            color: #0c5460;
            padding: 12px 20px;
            border-radius: 8px;
            margin-bottom: 15px;
            border-left: 4px solid #17a2b8;
            font-size: 0.95em;
        }

        /* Table Styles */
        .table-container {
            background: white;
            border-radius: 12px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
            overflow: hidden;
        }

        .personnel-table {
            width: 100%;
            border-collapse: collapse;
        }

        .personnel-table th,
        .personnel-table td {
            padding: 15px 20px;
            text-align: left;
            border-bottom: 1px solid #e9ecef;
        }

        .personnel-table th {
            background: #495057;
            color: white;
            font-weight: 600;
            font-size: 0.95em;
        }

        .personnel-table tbody tr {
            transition: all 0.3s ease;
        }

        .personnel-table tbody tr:hover {
            background: #f8f9fa;
        }

        .status-active {
            background: #d4edda;
            color: #155724;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 0.85em;
            font-weight: 500;
        }

        .status-inactive {
            background: #f8d7da;
            color: #721c24;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 0.85em;
            font-weight: 500;
        }

        .btn-details {
            background: #495057;
            color: white;
            padding: 8px 16px;
            text-decoration: none;
            border-radius: 6px;
            transition: all 0.3s ease;
            font-size: 0.9em;
            border: none;
            cursor: pointer;
        }

        .btn-details:hover {
            background: #343a40;
            transform: translateY(-2px);
        }

        .error-message {
            background: #f8d7da;
            color: #721c24;
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid #dc3545;
        }

        .results-info {
            background: #e7f3ff;
            color: #004085;
            padding: 12px 20px;
            border-radius: 8px;
            margin-bottom: 15px;
            border-left: 4px solid #007bff;
            font-size: 0.95em;
        }

        @media (max-width: 768px) {
            .sidebar {
                width: 100%;
                height: auto;
                position: relative;
            }

            .main-content {
                margin-left: 0;
                padding: 20px;
            }

            .content-header {
                flex-direction: column;
                gap: 15px;
                align-items: flex-start;
            }

            .search-box {
                flex-direction: column;
            }

            .filters-row {
                grid-template-columns: 1fr;
            }

            .personnel-table {
                display: block;
                overflow-x: auto;
            }
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <!-- Sidebar -->
        <nav class="sidebar">
            <div class="sidebar-header">
                <h4>👨‍💼 Admin Panel</h4>
            </div>
            
            <ul class="nav-menu">
                <!-- Section Candidat -->
                <li class="nav-section">
                    <div class="section-header" onclick="toggleSection('candidat')">
                        <div class="section-title">
                            <span class="nav-icon">👔</span>
                            Candidat
                        </div>
                        <span class="chevron" id="chevron-candidat">▼</span>
                    </div>
                    <div class="section-content" id="section-candidat">
                        <a href="/admin/annonces" class="nav-link">
                            <span class="nav-icon">📋</span>
                            Annonces
                        </a>
                        <a href="/Embauche" class="nav-link">
                            <span class="nav-icon">👔</span>
                            Embaucher
                        </a>
                        <a href="/mes-entretiens" class="nav-link">
                            <span class="nav-icon">📅</span>
                            Mes entretiens
                        </a>
                        <a href="/expirees" class="nav-link">
                            <span class="nav-icon">⏰</span>
                            Annonces expirées
                        </a>
                    </div>
                </li>

                <!-- Section Personnel -->
                <li class="nav-section">
                    <div class="section-header" onclick="toggleSection('personnel')">
                        <div class="section-title">
                            <span class="nav-icon">👥</span>
                            Personnel
                        </div>
                        <span class="chevron" id="chevron-personnel">▼</span>
                    </div>
                    <div class="section-content" id="section-personnel">
                        <a href="/stat/personnel" class="nav-link">
                            <span class="nav-icon">📊</span>
                            Statistique
                        </a>
                        <a href="/personnel/list" class="nav-link ">
                            <span class="nav-icon">📋</span>
                            Liste des personnels 
                        </a>
                        <a href="/contrat/list" class="nav-link ">
                            <span class="nav-icon">📋</span>
                            Gestion contrats
                    </a>
                    </div>
                    
               
                </li>
            </ul>      

            <div class="logout-section">
                <a href="/acceuil" class="btn-logout">
                    <span style="margin-right: 8px;">🚪</span>
                    Déconnexion
                </a>
            </div>
        </nav>

        <!-- Main Content -->
        <div class="main-content">
            <div class="content-header">
                <h2>👥 Liste des Personnels
                    <c:if test="${isRH}">
                        <span class="rh-badge">RH</span>
                    </c:if>
                </h2>
                <div class="header-actions">
                    <c:if test="${isRH}">
                        <a href="/Embauche" class="btn-primary">➕ Nouveau Personnel</a>
                    </c:if>
                </div>
            </div>

            <!-- Indicateurs de permissions -->
            <c:if test="${not empty connectedUser && not empty userDepartement && !isRH}">
                <div class="department-filter-info">
                    🔒 <strong>Vue restreinte</strong> : Vous visualisez uniquement les personnels de votre département
                </div>
            </c:if>
            
            <c:if test="${isRH}">
                <div class="rh-full-access">
                    👁️ <strong>Vue complète</strong> : En tant que RH, vous visualisez tous les personnels de l'entreprise
                </div>
            </c:if>

            <c:if test="${not empty error}">
                <div class="error-message">
                    ${error}
                </div>
            </c:if>

            <!-- Section Recherche et Filtres -->
            <div class="filters-section">
                <form id="searchForm" method="GET" action="/personnel/list">
                    <div class="search-box">
                        <input type="text" 
                               name="search" 
                               class="search-input" 
                               placeholder="🔍 Rechercher par nom, prénom, poste..."
                               value="${param.search}">
                        <button type="submit" class="btn-search">Rechercher</button>
                        <a href="/personnel/list" class="btn-reset">Tout afficher</a>
                    </div>

                    <div class="filters-row">
                        <div class="filter-group">
                            <label class="filter-label">Statut</label>
                            <select name="statut" class="filter-select">
                                <option value="">Tous les statuts</option>
                                <option value="actif" ${param.statut == 'actif' ? 'selected' : ''}>Actif</option>
                                <option value="inactif" ${param.statut == 'inactif' ? 'selected' : ''}>Inactif</option>
                            </select>
                        </div>
                        
                        <div class="filter-group">
                            <label class="filter-label">Poste</label>
                            <select name="poste" class="filter-select">
                                <option value="">Tous les postes</option>
                                <option value="Developpeur" ${param.poste == 'Developpeur' ? 'selected' : ''}>Développeur</option>
                                <option value="Designer" ${param.poste == 'Designer' ? 'selected' : ''}>Designer</option>
                                <option value="Manager" ${param.poste == 'Manager' ? 'selected' : ''}>Manager</option>
                                <option value="Commercial" ${param.poste == 'Commercial' ? 'selected' : ''}>Commercial</option>
                                <option value="RH" ${param.poste == 'RH' ? 'selected' : ''}>RH</option>
                            </select>
                        </div>
                        
                        <div class="filter-group">
                            <label class="filter-label">Tri par</label>
                            <select name="tri" class="filter-select">
                                <option value="date_desc" ${param.tri == 'date_desc' ? 'selected' : ''}>Date embauche (récent)</option>
                                <option value="date_asc" ${param.tri == 'date_asc' ? 'selected' : ''}>Date embauche (ancien)</option>
                                <option value="nom_asc" ${param.tri == 'nom_asc' ? 'selected' : ''}>Nom (A-Z)</option>
                                <option value="nom_desc" ${param.tri == 'nom_desc' ? 'selected' : ''}>Nom (Z-A)</option>
                            </select>
                        </div>
                    </div>

                    <div class="quick-filters">
                        <button type="button" class="quick-filter-btn ${empty param.statut && empty param.search && empty param.poste ? 'active' : ''}" 
                                onclick="resetFilters()">Tout</button>
                        <button type="button" class="quick-filter-btn ${param.statut == 'actif' ? 'active' : ''}" 
                                onclick="setFilter('statut', 'actif')">👥 Actifs</button>
                        <button type="button" class="quick-filter-btn ${param.statut == 'inactif' ? 'active' : ''}" 
                                onclick="setFilter('statut', 'inactif')">⏸️ Inactifs</button>
                        <button type="button" class="quick-filter-btn ${param.poste == 'Developpeur' ? 'active' : ''}" 
                                onclick="setFilter('poste', 'Developpeur')">💻 Développeurs</button>
                        <button type="button" class="quick-filter-btn ${param.poste == 'Manager' ? 'active' : ''}" 
                                onclick="setFilter('poste', 'Manager')">👔 Managers</button>
                    </div>
                </form>
            </div>

            <c:if test="${not empty param.search || not empty param.statut || not empty param.poste}">
                <div class="results-info">
                    🔍 Résultats filtrés 
                    <c:if test="${not empty param.search}">pour "<strong>${param.search}</strong>"</c:if>
                    <c:if test="${not empty param.statut}"> | Statut: <strong>${param.statut}</strong></c:if>
                    <c:if test="${not empty param.poste}"> | Poste: <strong>${param.poste}</strong></c:if>
                    <c:if test="${not empty personnels}"> | <strong>${personnels.size()}</strong> résultat(s)</c:if>
                </div>
            </c:if>

            <c:choose>
                <c:when test="${empty personnels}">
                    <div class="empty-state">
                        <h3>
                            <c:choose>
                                <c:when test="${not empty param.search || not empty param.statut || not empty param.poste}">
                                    Aucun résultat trouvé
                                </c:when>
                                <c:otherwise>
                                    <c:choose>
                                        <c:when test="${isRH}">
                                            Aucun personnel trouvé
                                        </c:when>
                                        <c:otherwise>
                                            Aucun personnel dans votre département
                                        </c:otherwise>
                                    </c:choose>
                                </c:otherwise>
                            </c:choose>
                        </h3>
                        <p>
                            <c:choose>
                                <c:when test="${not empty param.search || not empty param.statut || not empty param.poste}">
                                    Aucun personnel ne correspond à vos critères de recherche.
                                </c:when>
                                <c:when test="${isRH}">
                                    Il n'y a actuellement aucun personnel enregistré dans le système.
                                </c:when>
                                <c:otherwise>
                                    Il n'y a actuellement aucun personnel dans votre département.
                                </c:otherwise>
                            </c:choose>
                        </p>
                        <c:if test="${not empty param.search || not empty param.statut || not empty param.poste}">
                            <a href="/personnel/list" class="btn-primary" style="margin-top: 20px; display: inline-block;">
                                📋 Afficher tout le personnel
                            </a>
                        </c:if>
                        <c:if test="${isRH}">
                            <a href="/Embauche" class="btn-primary" style="margin-top: 20px; display: inline-block; margin-left: 10px;">
                                👔 Embaucher du personnel
                            </a>
                        </c:if>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="table-container">
                        <table class="personnel-table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Candidat</th>
                                    <th>Poste</th>
                                    <th>Date d'embauche</th>
                                    <th>Statut</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="personnel" items="${personnels}">
                                    <tr>
                                        <td>${personnel.id_personnel}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty personnel.candidat}">
                                                    ${personnel.candidat.nom} ${personnel.candidat.prenom}
                                                </c:when>
                                                <c:otherwise>
                                                    <em>Non spécifié</em>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty personnel.poste}">
                                                    ${personnel.poste.libelle}
                                                </c:when>
                                                <c:otherwise>
                                                    <em>Non spécifié</em>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty personnel.date_embauche}">
                                                    ${personnel.date_embauche}
                                                </c:when>
                                                <c:otherwise>
                                                    <em>Non spécifié</em>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${personnel.actif}">
                                                    <span class="status-active">Actif</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="status-inactive">Inactif</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <a href="/personnel/details?idPersonnel=${personnel.id_personnel}" 
                                               class="btn-details">
                                                👁️ Détails
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <script>
        // Fonctions pour les filtres rapides
        function setFilter(type, value) {
            const form = document.getElementById('searchForm');
            const searchInput = form.querySelector('input[name="search"]');
            const statutSelect = form.querySelector('select[name="statut"]');
            const posteSelect = form.querySelector('select[name="poste"]');
            
            // Réinitialiser les autres filtres sauf celui qu'on veut appliquer
            if (type === 'statut') {
                statutSelect.value = value;
                posteSelect.value = '';
                searchInput.value = '';
            } else if (type === 'poste') {
                posteSelect.value = value;
                statutSelect.value = '';
                searchInput.value = '';
            }
            
            form.submit();
        }

        function resetFilters() {
            window.location.href = '/personnel/list';
        }

        // Soumission automatique des selects
        document.addEventListener('DOMContentLoaded', function() {
            const filterSelects = document.querySelectorAll('.filter-select');
            filterSelects.forEach(select => {
                select.addEventListener('change', function() {
                    document.getElementById('searchForm').submit();
                });
            });
        });

        // Mise en évidence des filtres actifs
        document.addEventListener('DOMContentLoaded', function() {
            const quickFilterBtns = document.querySelectorAll('.quick-filter-btn');
            
            quickFilterBtns.forEach(btn => {
                if (btn.classList.contains('active')) {
                    btn.style.transform = 'translateY(-2px)';
                    btn.style.boxShadow = '0 4px 8px rgba(0, 123, 255, 0.3)';
                }
            });
        });
    </script>
     <script>
        let currentOpenSection = null;

        function toggleSection(sectionName) {
            const section = document.getElementById('section-' + sectionName);
            const chevron = document.getElementById('chevron-' + sectionName);
            const header = chevron.parentElement;

            // Si on clique sur la section déjà ouverte, on la ferme
            if (currentOpenSection === sectionName) {
                section.classList.remove('open');
                chevron.classList.remove('open');
                header.classList.remove('active');
                currentOpenSection = null;
                return;
            }

            // Fermer la section actuellement ouverte
            if (currentOpenSection) {
                const oldSection = document.getElementById('section-' + currentOpenSection);
                const oldChevron = document.getElementById('chevron-' + currentOpenSection);
                const oldHeader = oldChevron.parentElement;
                
                oldSection.classList.remove('open');
                oldChevron.classList.remove('open');
                oldHeader.classList.remove('active');
            }

            // Ouvrir la nouvelle section
            section.classList.add('open');
            chevron.classList.add('open');
            header.classList.add('active');
            currentOpenSection = sectionName;
        }
    </script>
</body>
</html>