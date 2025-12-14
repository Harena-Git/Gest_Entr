<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Candidats recrutés - ${annonce.poste.libelle}</title>
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
        }

        .header {
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
            padding: 30px;
            margin-bottom: 30px;
            text-align: center;
        }

        h1 {
            color: #495057;
            font-size: 1.8em;
            font-weight: 600;
            margin-bottom: 10px;
        }

        .subtitle {
            color: #6c757d;
            font-size: 1em;
        }

        .actions-bar {
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
            padding: 20px;
            margin-bottom: 30px;
            display: flex;
            justify-content: center;
            gap: 15px;
            flex-wrap: wrap;
            align-items: center;
        }

        .btn-export {
            background: #495057;
            color: white;
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 500;
            transition: all 0.3s ease;
            font-size: 0.95em;
        }

        .btn-export:hover {
            background: #343a40;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(73, 80, 87, 0.3);
        }

        .import-section {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .file-input {
            padding: 8px 12px;
            border: 2px solid #dee2e6;
            border-radius: 8px;
            cursor: pointer;
            font-size: 0.9em;
            background: white;
        }

        .btn-import {
            background: #6c757d;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .btn-import:hover {
            background: #5a6268;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(108, 117, 125, 0.3);
        }

        .candidat-card {
            display: flex;
            align-items: flex-start;
            background: white;
            border-radius: 12px;
            margin-bottom: 20px;
            padding: 25px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
            transition: all 0.3s ease;
        }

        .candidat-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.12);
        }

        .candidat-photo {
            flex: 0 0 120px;
            height: 120px;
            margin-right: 25px;
        }

        .candidat-photo img {
            width: 120px;
            height: 120px;
            object-fit: cover;
            border-radius: 50%;
            border: 3px solid #495057;
            box-shadow: 0 3px 10px rgba(0, 0, 0, 0.15);
        }

        .candidat-info {
            flex: 1;
        }

        .candidat-info h3 {
            margin: 0 0 15px 0;
            color: #495057;
            font-size: 1.4em;
            font-weight: 600;
        }

        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 12px;
        }

        .info-item {
            display: flex;
            align-items: baseline;
        }

        .info-item strong {
            color: #495057;
            margin-right: 8px;
            min-width: 110px;
            font-size: 0.95em;
        }

        .info-item span {
            color: #6c757d;
            line-height: 1.5;
        }

        .competences {
            margin-top: 15px;
            padding-top: 15px;
            border-top: 1px solid #e9ecef;
        }

        .competences strong {
            color: #495057;
            display: block;
            margin-bottom: 8px;
            font-size: 0.95em;
        }

        .competences span {
            color: #6c757d;
            line-height: 1.6;
        }

        .back-link {
            display: inline-block;
            background: #495057;
            color: white;
            padding: 12px 24px;
            text-decoration: none;
            border-radius: 8px;
            margin: 20px auto;
            text-align: center;
            font-weight: 500;
            transition: all 0.3s ease;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
        }

        .back-link:hover {
            background: #343a40;
            transform: translateY(-2px);
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.15);
        }

        .back-container {
            text-align: center;
            margin-top: 30px;
        }

        .empty-state {
            background: white;
            border-radius: 15px;
            padding: 60px 20px;
            text-align: center;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
        }

        .empty-state h2 {
            color: #495057;
            margin-bottom: 10px;
        }

        .empty-state p {
            color: #6c757d;
        }

        @media (max-width: 768px) {
            .candidat-card {
                flex-direction: column;
                align-items: center;
                text-align: center;
            }

            .candidat-photo {
                margin-right: 0;
                margin-bottom: 20px;
            }

            .info-grid {
                grid-template-columns: 1fr;
            }

            .info-item {
                flex-direction: column;
                align-items: center;
            }

            .actions-bar {
                flex-direction: column;
            }

            .import-section {
                flex-direction: column;
                width: 100%;
            }

            .file-input, .btn-import, .btn-export {
                width: 100%;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>👔 Candidats Recrutés</h1>
            <p class="subtitle">${annonce.poste.libelle}</p>
        </div>

        <div class="actions-bar">
            <form action="/candidat/export-excel" method="post" style="margin: 0;">
                <c:forEach var="candidat" items="${recrutes}">
                    <input type="hidden" name="candidatIds" value="${candidat.id_candidat}" />
                </c:forEach>
                <button type="submit" class="btn-export">
                    📊 Exporter en Excel
                </button>
            </form>

           
        </div>

        <c:choose>
            <c:when test="${empty recrutes}">
                <div class="empty-state">
                    <h2>Aucun candidat recruté</h2>
                    <p>Il n'y a pas encore de candidats recrutés pour cette annonce.</p>
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach var="candidat" items="${recrutes}">
                    <div class="candidat-card">
                        <div class="candidat-photo">
                            <c:if test="${not empty candidat.photo}">
                                <img src="/uploads/${candidat.photo}" alt="Photo de ${candidat.nom} ${candidat.prenom}">
                            </c:if>
                            <c:if test="${empty candidat.photo}">
                                <img src="/images/default-avatar.png" alt="Photo par défaut">
                            </c:if>
                        </div>

                        <div class="candidat-info">
                            <h3>${candidat.nom} ${candidat.prenom}</h3>
                            
                            <div class="info-grid">
                                <div class="info-item">
                                    <strong>📧 Email:</strong>
                                    <span>${candidat.email}</span>
                                </div>
                                <div class="info-item">
                                    <strong>📱 Téléphone:</strong>
                                    <span>${candidat.telephone}</span>
                                </div>
                                <div class="info-item">
                                    <strong>📍 Adresse:</strong>
                                    <span>${candidat.adresse}</span>
                                </div>
                                <div class="info-item">
                                    <strong>🎂 Naissance:</strong>
                                    <span>${candidat.date_naissance}</span>
                                </div>
                                <div class="info-item">
                                    <strong>💼 Expérience:</strong>
                                    <span>${candidat.annee_experience} ans</span>
                                </div>
                            </div>

                            <div class="competences">
                                <strong>🎯 Compétences:</strong>
                                <span>${candidat.competences_personnelles}</span>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>

        <div class="back-container">
            <a class="back-link" href="/expirees">← Retour aux annonces expirées</a>
        </div>
    </div>
</body>
</html>