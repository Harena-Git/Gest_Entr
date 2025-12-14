<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Contrats</title>
    <style>
        /* [Garder tous les styles CSS précédents] */
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
            justify-content: space-between;
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

        .alert-section {
            margin-bottom: 25px;
        }

        .alert-expired {
            background: #f8d7da;
            color: #721c24;
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 10px;
            border-left: 4px solid #dc3545;
        }

        .alert-warning {
            background: #fff3cd;
            color: #856404;
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 10px;
            border-left: 4px solid #ffc107;
        }

        .table-container {
            background: white;
            border-radius: 12px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
            overflow: hidden;
        }

        .contrat-table {
            width: 100%;
            border-collapse: collapse;
        }

        .contrat-table th,
        .contrat-table td {
            padding: 15px 20px;
            text-align: left;
            border-bottom: 1px solid #e9ecef;
        }

        .contrat-table th {
            background: #495057;
            color: white;
            font-weight: 600;
            font-size: 0.95em;
        }

        .contrat-table tbody tr {
            transition: all 0.3s ease;
        }

        .contrat-table tbody tr:hover {
            background: #f8f9fa;
        }

        .status-expired {
            background: #f8d7da;
            color: #721c24;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 0.85em;
            font-weight: 500;
        }

        .status-warning {
            background: #fff3cd;
            color: #856404;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 0.85em;
            font-weight: 500;
        }

        .status-active {
            background: #d4edda;
            color: #155724;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 0.85em;
            font-weight: 500;
        }

        .action-buttons {
            display: flex;
            gap: 8px;
        }

        .btn-edit {
            background: #28a745;
            color: white;
            padding: 6px 12px;
            text-decoration: none;
            border-radius: 6px;
            font-size: 0.85em;
            transition: all 0.3s ease;
        }

        .btn-edit:hover {
            background: #218838;
            transform: translateY(-1px);
        }

        .btn-delete {
            background: #dc3545;
            color: white;
            padding: 6px 12px;
            text-decoration: none;
            border-radius: 6px;
            font-size: 0.85em;
            transition: all 0.3s ease;
        }

        .btn-delete:hover {
            background: #c82333;
            transform: translateY(-1px);
        }

        .btn-renew {
            background: #17a2b8;
            color: white;
            padding: 6px 12px;
            text-decoration: none;
            border-radius: 6px;
            font-size: 0.85em;
            transition: all 0.3s ease;
        }

        .btn-renew:hover {
            background: #138496;
            transform: translateY(-1px);
        }

        .btn-pdf {
            background: #6f42c1;
            color: white;
            padding: 6px 12px;
            text-decoration: none;
            border-radius: 6px;
            font-size: 0.85em;
            transition: all 0.3s ease;
        }

        .btn-pdf:hover {
            background: #5a359c;
            transform: translateY(-1px);
        }

        .alert-message {
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-weight: 500;
        }

        .alert-success {
            background: #d4edda;
            color: #155724;
            border-left: 4px solid #28a745;
        }

        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border-left: 4px solid #dc3545;
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

            .contrat-table {
                display: block;
                overflow-x: auto;
            }

            .action-buttons {
                flex-direction: column;
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
                <p>Gestion des contrats</p>
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
                    <a href="/personnel/list" class="nav-link">
                        <span class="nav-icon">📋</span>
                        Liste des personnels 
                    </a>
                </li>
                <li class="nav-item">
                    <a href="/contrat/list" class="nav-link active">
                        <span class="nav-icon">📑</span>
                        Gestion contrats
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
                <h2>📑 Gestion des Contrats d'Essai</h2>
                <div class="header-actions">
                    <a href="/contrat/add" class="btn-primary">➕ Nouveau Contrat</a>
                </div>
            </div>

            <!-- Messages de succès/erreur -->
            <c:if test="${not empty success}">
                <div class="alert-message alert-success">
                    ✅ ${success}
                </div>
            </c:if>

            <c:if test="${not empty error}">
                <div class="alert-message alert-error">
                    ❌ ${error}
                </div>
            </c:if>

            <!-- Alertes des contrats -->
            <div class="alert-section">
                <c:forEach var="contrat" items="${contrats}">
                    <c:if test="${contratExpireMap[contrat.id_contrat_essai]}">
                        <div class="alert-expired">
                            ⚠️ <strong>Alerte :</strong> Le contrat de 
                            <strong>${contrat.candidat.nom} ${contrat.candidat.prenom}</strong> 
                            a expiré le <strong><fmt:formatDate value="${contrat.date_fin}" pattern="dd/MM/yyyy" /></strong>
                        </div>
                    </c:if>
                    <c:if test="${contratBientotExpireMap[contrat.id_contrat_essai]}">
                        <div class="alert-warning">
                            🔔 <strong>Rappel :</strong> Le contrat de 
                            <strong>${contrat.candidat.nom} ${contrat.candidat.prenom}</strong> 
                            expire le <strong><fmt:formatDate value="${contrat.date_fin}" pattern="dd/MM/yyyy" /></strong>
                        </div>
                    </c:if>
                </c:forEach>
            </div>

            <c:choose>
                <c:when test="${empty contrats}">
                    <div class="empty-state">
                        <h3>Aucun contrat trouvé</h3>
                        <p>Il n'y a actuellement aucun contrat d'essai enregistré dans le système.</p>
                        <a href="/contrat/add" class="btn-primary" style="margin-top: 20px; display: inline-block;">
                            📑 Créer un nouveau contrat
                        </a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="table-container">
                        <table class="contrat-table">
                            <thead>
                                <tr>
                                    <th>Candidat</th>
                                    <th>Date Début</th>
                                    <th>Date Fin</th>
                                    <th>Statut</th>
                                    <th>Jours Restants</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="contrat" items="${contrats}">
                                    <tr>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty contrat.candidat}">
                                                    <strong>${contrat.candidat.nom} ${contrat.candidat.prenom}</strong>
                                                </c:when>
                                                <c:otherwise>
                                                    <em>Non spécifié</em>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td><fmt:formatDate value="${contrat.date_debut}" pattern="dd/MM/yyyy" /></td>
                                        <td><fmt:formatDate value="${contrat.date_fin}" pattern="dd/MM/yyyy" /></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${contratExpireMap[contrat.id_contrat_essai]}">
                                                    <span class="status-expired">Expiré</span>
                                                </c:when>
                                                <c:when test="${contratBientotExpireMap[contrat.id_contrat_essai]}">
                                                    <span class="status-warning">Bientôt expiré</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="status-active">Actif</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${contratExpireMap[contrat.id_contrat_essai]}">
                                                    <span style="color: #dc3545;">-</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:set var="joursRestants" value="${joursRestantsMap[contrat.id_contrat_essai]}" />
                                                    <c:choose>
                                                        <c:when test="${joursRestants < 0}">
                                                            <span style="color: #dc3545;">-</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <strong>${joursRestants}</strong> jours
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <div class="action-buttons">
                                                <a href="/contrat/edit/${contrat.id_contrat_essai}" class="btn-edit" title="Modifier">✏️</a>
                                                <a href="/contrat/renew/${contrat.id_contrat_essai}" class="btn-renew" title="Renouveler">🔄</a>
                                                <c:if test="${not empty contrat.candidat}">
                                                    <a href="/contrat/generer?id_candidat=${contrat.candidat.id_candidat}" class="btn-pdf" title="Générer PDF">📄</a>
                                                </c:if>
                                                <a href="/contrat/delete/${contrat.id_contrat_essai}" 
                                                   class="btn-delete"
                                                   title="Supprimer"
                                                   onclick="return confirm('Êtes-vous sûr de vouloir supprimer ce contrat ?')">🗑️</a>
                                            </div>
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
        // Confirmation pour la suppression
        document.addEventListener('DOMContentLoaded', function() {
            const deleteButtons = document.querySelectorAll('.btn-delete');
            deleteButtons.forEach(button => {
                button.addEventListener('click', function(e) {
                    if (!confirm('Êtes-vous sûr de vouloir supprimer ce contrat ?')) {
                        e.preventDefault();
                    }
                });
            });
        });
    </script>
</body>
</html>