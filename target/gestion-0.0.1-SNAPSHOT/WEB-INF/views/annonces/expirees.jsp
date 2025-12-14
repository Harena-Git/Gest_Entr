<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Annonces Expirées</title>
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
            padding: 20px;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }

        .header {
            background: #495057;
            color: white;
            padding: 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        h1 {
            font-size: 2em;
            font-weight: 600;
        }

        .btn-retour {
            background: rgba(255, 255, 255, 0.15);
            color: white;
            padding: 12px 24px;
            text-decoration: none;
            border-radius: 8px;
            transition: all 0.3s ease;
            font-weight: 500;
            border: 2px solid rgba(255, 255, 255, 0.2);
        }

        .btn-retour:hover {
            background: rgba(255, 255, 255, 0.25);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
        }

        .table-container {
            padding: 30px;
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background: white;
        }

        th {
            background: #495057;
            color: white;
            padding: 15px;
            text-align: left;
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.9em;
            letter-spacing: 0.5px;
        }

        td {
            padding: 15px;
            border-bottom: 1px solid #e0e0e0;
            color: #333;
        }

        tr:hover {
            background: #f8f9fa;
            transition: background 0.3s ease;
        }

        tr:last-child td {
            border-bottom: none;
        }

        .btn-candidats {
            background: #495057;
            color: white;
            padding: 8px 16px;
            text-decoration: none;
            border-radius: 6px;
            transition: all 0.3s ease;
            display: inline-block;
            font-size: 0.9em;
            font-weight: 500;
        }

        .btn-candidats:hover {
            background: #343a40;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(73, 80, 87, 0.3);
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #666;
        }

        .empty-state svg {
            width: 100px;
            height: 100px;
            margin-bottom: 20px;
            opacity: 0.3;
        }

        @media (max-width: 768px) {
            .header {
                flex-direction: column;
                gap: 15px;
                text-align: center;
            }

            h1 {
                font-size: 1.5em;
            }

            .table-container {
                padding: 15px;
            }

            th, td {
                padding: 10px;
                font-size: 0.9em;
            }
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            border-radius: 15px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            overflow: hidden;
        }

        .header {
            background: linear-gradient(135deg, #495057 0%, #343a40 100%);
            color: white;
            padding: 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        h1 {
            font-size: 2em;
            font-weight: 600;
        }

        .btn-retour {
            background: rgba(255, 255, 255, 0.15);
            color: white;
            padding: 12px 24px;
            text-decoration: none;
            border-radius: 8px;
            transition: all 0.3s ease;
            font-weight: 500;
            border: 2px solid rgba(255, 255, 255, 0.2);
            backdrop-filter: blur(10px);
        }

        .btn-retour:hover {
            background: rgba(255, 255, 255, 0.25);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
        }

        .table-container {
            padding: 30px;
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background: white;
        }

        th {
            background: linear-gradient(135deg, #495057 0%, #343a40 100%);
            color: white;
            padding: 15px;
            text-align: left;
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.9em;
            letter-spacing: 0.5px;
        }

        td {
            padding: 15px;
            border-bottom: 1px solid #e0e0e0;
            color: #333;
        }

        tr:hover {
            background: #f8f9fa;
            transition: background 0.3s ease;
        }

        tr:last-child td {
            border-bottom: none;
        }

        .btn-candidats {
            background: linear-gradient(135deg, #495057 0%, #343a40 100%);
            color: white;
            padding: 8px 16px;
            text-decoration: none;
            border-radius: 6px;
            transition: all 0.3s ease;
            display: inline-block;
            font-size: 0.9em;
            font-weight: 500;
        }

        .btn-candidats:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(73, 80, 87, 0.4);
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #666;
        }

        .empty-state svg {
            width: 100px;
            height: 100px;
            margin-bottom: 20px;
            opacity: 0.3;
        }

        @media (max-width: 768px) {
            .header {
                flex-direction: column;
                gap: 15px;
                text-align: center;
            }

            h1 {
                font-size: 1.5em;
            }

            .table-container {
                padding: 15px;
            }

            th, td {
                padding: 10px;
                font-size: 0.9em;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>📋 Annonces Expirées</h1>
            <a href="/admin/dashboard" class="btn-retour">← Retour</a>
        </div>
        
        <div class="table-container">
            <c:choose>
                <c:when test="${empty annonces}">
                    <div class="empty-state">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                        </svg>
                        <h2>Aucune annonce expirée</h2>
                        <p>Il n'y a actuellement aucune annonce expirée à afficher.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Poste</th>
                                <th>Date de fin</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="annonce" items="${annonces}">
                                <tr>
                                    <td><strong>#${annonce.id_annonce}</strong></td>
                                    <td>${annonce.poste.libelle}</td>
                                    <td>${annonce.date_fin}</td>
                                    <td>
                                        <a href="/${annonce.id_annonce}/candidats" class="btn-candidats">
                                            👥 Voir candidats
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>