<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Liste des Candidats Importés</title>
    <style>
        :root {
            --primary-color: #3498db;
            --secondary-color: #2980b9;
            --success-color: #2ecc71;
            --danger-color: #e74c3c;
            --warning-color: #f39c12;
            --light-color: #f8f9fa;
            --dark-color: #343a40;
            --border-color: #dee2e6;
            --shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            --radius: 8px;
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
            padding: 20px;
            color: #333;
            line-height: 1.6;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
        }
        
        .header {
            text-align: center;
            margin-bottom: 30px;
        }
        
        h1 {
            color: var(--dark-color);
            font-size: 2.2rem;
            margin-bottom: 10px;
            font-weight: 700;
        }
        
        .subtitle {
            color: #6c757d;
            font-size: 1.1rem;
        }
        
        .stats-card {
            background: white;
            border-radius: var(--radius);
            padding: 20px;
            margin-bottom: 25px;
            box-shadow: var(--shadow);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .stats-info {
            display: flex;
            gap: 20px;
        }
        
        .stat-item {
            text-align: center;
            padding: 10px 15px;
            background: var(--light-color);
            border-radius: var(--radius);
        }
        
        .stat-number {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--primary-color);
        }
        
        .stat-label {
            font-size: 0.9rem;
            color: #6c757d;
        }
        
        .navigation {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 20px;
            background: white;
            border-radius: var(--radius);
            margin-bottom: 25px;
            box-shadow: var(--shadow);
        }
        
        .btn-retour {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 20px;
            background: var(--light-color);
            color: var(--dark-color);
            text-decoration: none;
            border-radius: var(--radius);
            font-weight: 500;
            transition: all 0.3s ease;
            border: 1px solid var(--border-color);
        }
        
        .btn-retour:hover {
            background: var(--primary-color);
            color: white;
            transform: translateX(-3px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
        }
        
        .nav-link {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 25px;
            background: var(--success-color);
            color: white;
            text-decoration: none;
            border-radius: var(--radius);
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .nav-link:hover {
            background: #27ae60;
            transform: translateY(-2px);
            box-shadow: 0 6px 12px rgba(46, 204, 113, 0.3);
        }
        
        .nav-icon {
            font-size: 1.2em;
        }
        
        .table-container {
            background: white;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            overflow: hidden;
            margin-bottom: 30px;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
        }
        
        thead {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
        }
        
        th {
            padding: 15px 12px;
            text-align: left;
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.85rem;
            letter-spacing: 0.5px;
        }
        
        td {
            padding: 12px;
            border-bottom: 1px solid var(--border-color);
        }
        
        tbody tr {
            transition: all 0.3s ease;
        }
        
        tbody tr:hover {
            background-color: rgba(52, 152, 219, 0.05);
            transform: translateY(-1px);
        }
        
        tbody tr:nth-child(even) {
            background-color: #f8f9fa;
        }
        
        tbody tr:nth-child(even):hover {
            background-color: rgba(52, 152, 219, 0.08);
        }
        
        .empty-state {
            text-align: center;
            padding: 40px 20px;
            color: #6c757d;
        }
        
        .empty-icon {
            font-size: 3rem;
            margin-bottom: 15px;
            opacity: 0.5;
        }
        
        .pagination {
            display: flex;
            justify-content: center;
            gap: 10px;
            margin-top: 20px;
        }
        
        .page-btn {
            padding: 8px 15px;
            background: white;
            border: 1px solid var(--border-color);
            border-radius: var(--radius);
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .page-btn:hover {
            background: var(--primary-color);
            color: white;
        }
        
        .page-btn.active {
            background: var(--primary-color);
            color: white;
        }
        
        @media (max-width: 768px) {
            .navigation {
                flex-direction: column;
                gap: 15px;
            }
            
            .stats-info {
                flex-wrap: wrap;
                justify-content: center;
            }
            
            .table-container {
                overflow-x: auto;
            }
            
            table {
                min-width: 700px;
            }
            
            th, td {
                padding: 10px 8px;
                font-size: 0.85rem;
            }
        }
        
        @media (max-width: 576px) {
            body {
                padding: 10px;
            }
            
            h1 {
                font-size: 1.8rem;
            }
            
            .stats-card {
                flex-direction: column;
                gap: 15px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>Liste des Candidats Importés</h1>
            <p class="subtitle">Gestion des candidats importés depuis des fichiers externes</p>
        </div>
        
        <div class="stats-card">
            <div class="stats-info">
                <div class="stat-item">
                    <div class="stat-number">${candidats.size()}</div>
                    <div class="stat-label">Candidats total</div>
                </div>
                <div class="stat-item">
                    <div class="stat-number">
                        <c:set var="maleCount" value="0" />
                        <c:forEach var="candidat" items="${candidats}">
                            <c:if test="${candidat.genre == 'Homme'}">
                                <c:set var="maleCount" value="${maleCount + 1}" />
                            </c:if>
                        </c:forEach>
                        ${maleCount}
                    </div>
                    <div class="stat-label">Hommes</div>
                </div>
                <div class="stat-item">
                    <div class="stat-number">
                        <c:set var="femaleCount" value="0" />
                        <c:forEach var="candidat" items="${candidats}">
                            <c:if test="${candidat.genre == 'Femme'}">
                                <c:set var="femaleCount" value="${femaleCount + 1}" />
                            </c:if>
                        </c:forEach>
                        ${femaleCount}
                    </div>
                    <div class="stat-label">Femmes</div>
                </div>
            </div>
        </div>
        
        <div class="navigation">
            <a href="/admin/dashboard" class="btn-retour">
                <span class="nav-icon">←</span>
                Retour au tableau de bord
            </a>
            <a href="/candidat/importer_f" class="nav-link">
                <span class="nav-icon">📤</span>
                Importer de nouveaux candidats
            </a>
        </div>
        
        <div class="table-container">
            <c:choose>
                <c:when test="${not empty candidats}">
                    <table>
                        <thead>
                            <tr>
                                <th>Nom</th>
                                <th>Prénom</th>
                                <th>Email</th>
                                <th>Téléphone</th>
                                <th>Adresse</th>
                                <th>Genre</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="candidat" items="${candidats}">
                                <tr>
                                    <td>${candidat.nom}</td>
                                    <td>${candidat.prenom}</td>
                                    <td>${candidat.email}</td>
                                    <td>${candidat.telephone}</td>
                                    <td>${candidat.adresse}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${candidat.genre == 'Homme'}">Homme</c:when>
                                            <c:when test="${candidat.genre == 'Femme'}">Femme</c:when>
                                            <c:otherwise>${candidat.genre}</c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <div class="empty-icon">📄</div>
                        <h3>Aucun candidat importé</h3>
                        <p>Il n'y a actuellement aucun candidat dans la liste. Importez des candidats pour commencer.</p>
                        <a href="/candidat/importer_f" class="nav-link" style="margin-top: 15px; display: inline-block;">
                            <span class="nav-icon">📤</span>
                            Importer des candidats
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
        
    </div>
</body>
</html>