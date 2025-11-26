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

        /* Sidebar - Même style que le dashboard */
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
            display: flex;
            justify-content: between;
            align-items: center;
        }

        .content-header h2 {
            color: #495057;
            font-size: 1.8em;
            font-weight: 600;
            margin: 0;
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

        .empty-state {
            background: white;
            border-radius: 12px;
            padding: 60px 20px;
            text-align: center;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.05);
        }

        .empty-state h3 {
            color: #495057;
            margin-bottom: 10px;
        }

        .empty-state p {
            color: #6c757d;
        }

        .error-message {
            background: #f8d7da;
            color: #721c24;
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid #dc3545;
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
                <p>Gestion des personnels</p>
            </div>
            
            <ul class="nav-menu">
                <li class="nav-item">
                    <a href="/admin/annonces" class="nav-link">
                        <span class="nav-icon">📋</span>
                        Annonces
                    </a>
                </li>
                <li class="nav-item">
                    <a href="/Embauche" class="nav-link">
                        <span class="nav-icon">👔</span>
                        Embaucher
                    </a>
                </li>
                <li class="nav-item">
                    <a href="/mes-entretiens" class="nav-link">
                        <span class="nav-icon">📅</span>
                        Mes entretiens
                    </a>
                </li>
                <li class="nav-item">
                    <a href="/expirees" class="nav-link">
                        <span class="nav-icon">⏰</span>
                        Annonces expirées
                    </a>
                </li>
                <li class="nav-item">
                    <a href="/candidat/list" class="nav-link">
                        <span class="nav-icon">📋</span>
                        Liste des Candidats 
                    </a>
                </li>
                <li class="nav-item">
                    <a href="/personnel/list" class="nav-link active">
                        <span class="nav-icon">📋</span>
                        Liste des personnels 
                    </a>
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
                <h2>👥 Liste des Personnels</h2>
                <div class="header-actions">
                    <a href="/Embauche" class="btn-primary">➕ Nouveau Personnel</a>
                </div>
            </div>

            <c:if test="${not empty error}">
                <div class="error-message">
                    ${error}
                </div>
            </c:if>

            <c:choose>
                <c:when test="${empty personnels}">
                    <div class="empty-state">
                        <h3>Aucun personnel trouvé</h3>
                        <p>Il n'y a actuellement aucun personnel enregistré dans le système.</p>
                        <a href="/Embauche" class="btn-primary" style="margin-top: 20px; display: inline-block;">
                            👔 Embaucher du personnel
                        </a>
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
</body>
</html>