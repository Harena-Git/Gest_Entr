<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Mes Entretiens</title>
    <style>
        /* Reset et base */
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
            color: #333;
        }

        /* Container principal */
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            border-radius: 15px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            overflow: hidden;
            animation: slideIn 0.6s ease-out;
        }

        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* Header */
        h1 {
            background: linear-gradient(45deg, #2c3e50, #34495e);
            color: white;
            padding: 30px;
            text-align: center;
            font-size: 2.2em;
            font-weight: 300;
            letter-spacing: 2px;
            text-shadow: 0 2px 4px rgba(0,0,0,0.3);
        }

        /* Tableau */
        .table-container {
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background: white;
        }

        th {
            background: linear-gradient(135deg, #3498db, #2980b9);
            color: white;
            padding: 20px 15px;
            text-align: left;
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 1px;
            font-size: 0.9em;
            border: none;
            white-space: nowrap;
        }

        td {
            padding: 18px 15px;
            border-bottom: 1px solid #ecf0f1;
            transition: all 0.3s ease;
            vertical-align: middle;
        }

        tr:hover {
            background-color: #f8f9fa;
            transform: translateX(5px);
        }

        tr:last-child td {
            border-bottom: none;
        }

        /* Liens d'évaluation */
        .btn-evaluer {
            display: inline-block;
            background: linear-gradient(45deg, #27ae60, #2ecc71);
            color: white !important;
            padding: 12px 24px;
            text-decoration: none;
            border-radius: 25px;
            font-weight: 500;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(46, 204, 113, 0.3);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-size: 0.9em;
        }

        .btn-evaluer:hover {
            background: linear-gradient(45deg, #229954, #27ae60);
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(46, 204, 113, 0.4);
        }

        /* Styling pour les noms */
        .candidat-nom {
            font-weight: 600;
            color: #2c3e50;
        }

        .date-heure {
            color: #7f8c8d;
            font-weight: 500;
        }

        /* Empty state */
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #7f8c8d;
        }

        .empty-state h3 {
            font-size: 1.5em;
            margin-bottom: 15px;
            color: #95a5a6;
        }

        .empty-state p {
            font-size: 1.1em;
        }

        /* Responsive */
        @media (max-width: 768px) {
            body {
                padding: 10px;
            }
            
            .container {
                border-radius: 10px;
            }
            
            h1 {
                font-size: 1.8em;
                padding: 20px;
            }
            
            table {
                font-size: 14px;
            }
            
            th, td {
                padding: 12px 8px;
            }
            
            .btn-evaluer {
                padding: 8px 16px;
                font-size: 0.8em;
            }
        }

        /* Animation pour les lignes du tableau */
        tr {
            animation: fadeInRow 0.5s ease-out;
            animation-fill-mode: both;
        }

        @keyframes fadeInRow {
            from {
                opacity: 0;
                transform: translateX(-20px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }

        /* Délai d'animation pour chaque ligne */
        tr:nth-child(1) { animation-delay: 0.1s; }
        tr:nth-child(2) { animation-delay: 0.2s; }
        tr:nth-child(3) { animation-delay: 0.3s; }
        tr:nth-child(4) { animation-delay: 0.4s; }
        tr:nth-child(5) { animation-delay: 0.5s; }
        tr:nth-child(n+6) { animation-delay: 0.6s; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Mes Entretiens</h1>
        <div class="table-container">
            <c:choose>
                <c:when test="${not empty entretiens}">
                    <table>
                        <thead>
                            <tr>
                                <th>Date</th>
                                <th>Heure</th>
                                <th>Candidat</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="entretien" items="${entretiens}">
                                <tr>
                                    <td class="date-heure">${entretien.dateEntretien}</td>
                                    <td class="date-heure">${entretien.heureEntretien}</td>
                                    <td class="candidat-nom">
                                        <c:choose>
                                            <c:when test="${departement == 'Ressources Humaines'}">
                                                ${entretien.candidat.nom} ${entretien.candidat.prenom}
                                            </c:when>
                                            <c:otherwise>
                                                ${entretien.entretien1.candidat.nom} ${entretien.entretien1.candidat.prenom}
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${departement == 'Ressources Humaines'}">
                                                <a href="/evaluation-entretien1?id_entretien=${entretien.idEntretien}&id_user=${id_user}" class="btn-evaluer">Evaluer</a>
                                            </c:when>
                                            <c:otherwise>
                                                <a href="/evaluation-entretien2?id_entretien=${entretien.idEntretien2}&id_user=${id_user}" class="btn-evaluer">Evaluer</a>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <h3>Aucun entretien planifie</h3>
                        <p>Vous n'avez actuellement aucun entretien a evaluer.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>