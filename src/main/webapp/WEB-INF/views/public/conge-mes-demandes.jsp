<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Mes demandes de congé</title>
    <link rel="stylesheet" href="/css/styles.css" />
    <style>
        body { font-family: Arial, sans-serif; background-color: #f5f5f5; }
        .container { max-width: 900px; margin: 20px auto; background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        h2 { color: #333; margin-bottom: 20px; }
        table { width: 100%; border-collapse: collapse; margin: 20px 0; }
        table thead { background-color: #667eea; color: white; }
        table th { padding: 12px; text-align: left; }
        table td { padding: 10px; border-bottom: 1px solid #ddd; }
        table tbody tr:hover { background-color: #f9f9f9; }
        .alert { padding: 12px; margin-bottom: 20px; border-radius: 4px; }
        .alert-success { background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .alert-danger { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
        a { color: #667eea; text-decoration: none; }
        a:hover { text-decoration: underline; }
        .btn { padding: 10px 20px; background-color: #667eea; color: white; border: none; border-radius: 4px; cursor: pointer; text-decoration: none; display: inline-block; }
        .btn:hover { background-color: #5568d3; }
    </style>
</head>
<body>
<div class="container">
    <h2>Mes demandes de congé</h2>

    <c:if test="${not empty succes}">
        <div class="alert alert-success">${succes}</div>
    </c:if>
    <c:if test="${not empty erreur}">
        <div class="alert alert-danger">${erreur}</div>
    </c:if>

    <p>Solde restant : <strong>${soldeRestant}</strong> jours</p>

    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Date début</th>
                <th>Date fin</th>
                <th>Jours</th>
                <th>Statut</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach items="${demandes}" var="d">
                <tr>
                    <td>${d.id_demande_conge}</td>
                    <td><fmt:formatDate value="${d.date_debut}" pattern="yyyy-MM-dd"/></td>
                    <td><fmt:formatDate value="${d.date_fin}" pattern="yyyy-MM-dd"/></td>
                    <td>${d.nombre_jours}</td>
                    <td>${d.statutDemande.libelle}</td>
                    <td>
                        <a href="/public/conge/details/${d.id_demande_conge}?id=${employeId}">Voir</a>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty demandes}">
                <tr><td colspan="6">Aucune demande trouvée</td></tr>
            </c:if>
        </tbody>
    </table>

    <p>
        <a href="/public/conge/nouvelle-demande?id=${employeId}" class="btn">+ Créer une nouvelle demande</a>
        <a href="/" class="btn" style="background-color: #ccc; color: #333;">Retour</a>
    </p>
</div>
</body>
</html>
