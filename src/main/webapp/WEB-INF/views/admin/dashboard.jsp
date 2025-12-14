<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Admin</title>
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

        .annonces-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 25px;
        }

        .annonce-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
            overflow: hidden;
            transition: all 0.3s ease;
        }

        .annonce-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.12);
        }

        .card-header {
            background: #495057;
            color: white;
            padding: 20px;
        }

        .card-title {
            font-size: 1.3em;
            font-weight: 600;
            margin: 0;
        }

        .card-body {
            padding: 20px;
        }

        .card-text {
            color: #6c757d;
            margin-bottom: 12px;
            line-height: 1.5;
        }

        .card-text strong {
            color: #495057;
            display: inline-block;
            min-width: 140px;
        }

        .card-footer {
            padding: 15px 20px;
            background: #f8f9fa;
            border-top: 1px solid #e9ecef;
        }

        .btn-details {
            display: inline-block;
            background: #495057;
            color: white;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 8px;
            transition: all 0.3s ease;
            font-weight: 500;
            font-size: 0.95em;
        }

        .btn-details:hover {
            background: #343a40;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(73, 80, 87, 0.3);
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

            .annonces-grid {
                grid-template-columns: 1fr;
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
                <p>Gestion des annonces</p>
            </div>
            
            <ul class="nav-menu">
                <li class="nav-item">
                    <a href="/admin/annonces" class="nav-link active">
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
                    <a href="/candidat/list" class="nav-link ">
                        <span class="nav-icon">📋</span>
                        Liste des Candidats 
                    </a>
                </li>
                <li class="nav-item">
                    <a href="/personnel/list" class="nav-link ">
                        <span class="nav-icon">📋</span>
                        Liste des personnels 
                    </a>
                </li>
                <li class="nav-item">
                    <a href="/contrat/list" class="nav-link ">
                        <span class="nav-icon">📋</span>
                        Gestion contrats d'essai
                    </a>
                </li>
                
                <!-- Nouvelle section : Gestion du Personnel -->
                <li class="nav-item" style="margin-top: 20px; padding: 10px 20px; background: rgba(255,255,255,0.1);">
                    <strong style="color: white; font-size: 0.9em;">📁 GESTION DU PERSONNEL</strong>
                </li>
                
                <li class="nav-item">
                    <a href="/admin/contrats" class="nav-link">
                        <span class="nav-icon">📝</span>
                        Contrats de Travail
                    </a>
                </li>
                
                <li class="nav-item">
                    <a href="/admin/historique-postes" class="nav-link">
                        <span class="nav-icon">📈</span>
                        Historique Postes
                    </a>
                </li>
                
                <li class="nav-item">
                    <a href="/admin/documents" class="nav-link">
                        <span class="nav-icon">📂</span>
                        Documents RH
                    </a>
                </li>
                
                <li class="nav-item">
                    <a href="/personnel/list" class="nav-link">
                        <span class="nav-icon">👥</span>
                        Fiches Employés
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
                <h2>📊 Tableau de bord - Annonces</h2>
            </div>

            <c:choose>
                <c:when test="${empty annonces}">
                    <div class="empty-state">
                        <h3>Aucune annonce disponible</h3>
                        <p>Il n'y a actuellement aucune annonce à afficher.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="annonces-grid">
                        <c:forEach var="annonce" items="${annonces}">
                            <div class="annonce-card">
                                <div class="card-header">
                                    <h5 class="card-title">${annonce.poste.libelle}</h5>
                                </div>
                                <div class="card-body">
                                    <p class="card-text">${annonce.responsabilite}</p>
                                    <p class="card-text">
                                        <strong>Profil recherché:</strong> ${annonce.profil.genre}
                                    </p>
                                    <p class="card-text">
                                        <strong>Date publication:</strong> ${annonce.date_annonce}
                                    </p>
                                    <p class="card-text">
                                        <strong>Date de fin:</strong> ${annonce.date_fin}
                                    </p>
                                </div>
                                <div class="card-footer">
                                    <a href="/admin/annonces/${annonce.id_annonce}" class="btn-details">
                                        👁️ Voir les détails
                                    </a>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <script>
        // Gestion de la navigation active