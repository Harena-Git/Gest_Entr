<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Validation des demandes de congé - Chef</title>
    <link rel="stylesheet" href="/css/styles.css" />
    <style>
        body { font-family: Arial, sans-serif; background-color: #f5f5f5; }
        .container { max-width: 1000px; margin: 20px auto; background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        h2 { color: #333; margin-bottom: 20px; border-bottom: 3px solid #667eea; padding-bottom: 10px; }
        .info-box { background-color: #f0f8ff; color: #003366; padding: 15px; border-radius: 4px; margin-bottom: 20px; border-left: 4px solid #667eea; }
        table { width: 100%; border-collapse: collapse; margin: 20px 0; }
        table thead { background-color: #667eea; color: white; }
        table th { padding: 12px; text-align: left; }
        table td { padding: 10px; border-bottom: 1px solid #ddd; }
        table tbody tr:hover { background-color: #f9f9f9; }
        .alert { padding: 12px; margin-bottom: 20px; border-radius: 4px; }
        .alert-success { background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .alert-danger { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
        .btn { padding: 8px 12px; background-color: #667eea; color: white; border: none; border-radius: 4px; cursor: pointer; text-decoration: none; display: inline-block; font-size: 14px; }
        .btn:hover { background-color: #5568d3; }
        .btn-danger { background-color: #dc3545; }
        .btn-danger:hover { background-color: #c82333; }
        .btn-secondary { background-color: #6c757d; }
        .btn-secondary:hover { background-color: #5a6268; }
        .badge { display: inline-block; padding: 4px 8px; border-radius: 4px; font-size: 12px; font-weight: bold; }
        .badge-warning { background-color: #fff3cd; color: #856404; }
        .badge-info { background-color: #d1ecf1; color: #0c5460; }
        .badge-success { background-color: #d4edda; color: #155724; }
        .badge-danger { background-color: #f8d7da; color: #721c24; }
        .empty-state { text-align: center; padding: 40px; color: #999; }
        .empty-state p { font-size: 16px; }
    </style>
</head>
<body>
<div class="container">
    <h2>📋 Validation des demandes de congé</h2>
    
    <div class="info-box">
        <strong>👤 Chef de département</strong><br>
        <strong>Nom :</strong> ${chef.candidat.prenom} ${chef.candidat.nom}<br>
        <strong>Email :</strong> ${chef.candidat.email}<br>
        <strong>Département :</strong> ${chef.poste.departement.departement}
    </div>

    <c:if test="${not empty succes}">
        <div class="alert alert-success">${succes}</div>
    </c:if>
    <c:if test="${not empty erreur}">
        <div class="alert alert-danger">${erreur}</div>
    </c:if>

    <c:if test="${empty demandes}">
        <div class="empty-state">
            <p>✅ Aucune demande en attente de validation</p>
        </div>
    </c:if>

    <c:if test="${not empty demandes}">
        <table>
            <thead>
                <tr>
                    <th>Personnel</th>
                    <th>Poste</th>
                    <th>Dates</th>
                    <th>Jours</th>
                    <th>Motif</th>
                    <th>Date demande</th>
                    <th>Statut</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${demandes}" var="demande">
                    <tr>
                        <td>
                            <strong>${demande.personnel.candidat.prenom} ${demande.personnel.candidat.nom}</strong><br>
                            <small style="color: #666;">${demande.personnel.candidat.email}</small>
                        </td>
                        <td>
                            <strong>${demande.personnel.poste.libelle}</strong><br>
                            <small>${demande.personnel.poste.departement.departement}</small>
                        </td>
                        <td>
                            <fmt:formatDate value="${demande.date_debut}" pattern="dd/MM/yyyy"/> 
                            à 
                            <fmt:formatDate value="${demande.date_fin}" pattern="dd/MM/yyyy"/>
                        </td>
                        <td>
                            <span class="badge badge-info">${demande.nombre_jours} jour(s)</span>
                        </td>
                        <td>${demande.motif}</td>
                        <td>
                            <small><fmt:formatDate value="${demande.date_demande}" pattern="dd/MM/yyyy HH:mm"/></small>
                        </td>
                        <td>
                            <span class="badge badge-warning">${demande.statutDemande.libelle}</span>
                        </td>
                        <td>
                            <a href="/public/chef/conge/valider/${demande.id_demande_conge}?idChef=${idChef}" class="btn">Examiner</a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </c:if>

    <p style="margin-top: 30px;">
        <a href="/" class="btn btn-secondary">← Retour</a>
    </p>
</div>
</body>
</html>
