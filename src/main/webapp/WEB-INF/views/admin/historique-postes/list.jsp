<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${titre}</title>
    <style>
        .container { max-width: 1400px; margin: 20px auto; padding: 20px; }
        .alert { padding: 12px 20px; margin: 10px 0; border-radius: 5px; }
        .alert-success { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .btn { padding: 10px 20px; border: none; border-radius: 5px; cursor: pointer; text-decoration: none; display: inline-block; margin-right: 10px; }
        .btn-primary { background: #007bff; color: white; }
        .btn-success { background: #28a745; color: white; }
        .btn-danger { background: #dc3545; color: white; }
        .btn-warning { background: #ffc107; color: #000; }
        .btn-secondary { background: #6c757d; color: white; }
        table { width: 100%; border-collapse: collapse; margin: 20px 0; }
        table th, table td { padding: 12px; text-align: left; border: 1px solid #ddd; }
        table th { background: #f8f9fa; font-weight: 600; }
        table tr:hover { background: #f8f9fa; }
        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .badge { padding: 5px 10px; border-radius: 3px; font-size: 0.85em; }
        .badge-primary { background: #007bff; color: white; }
        .badge-success { background: #28a745; color: white; }
        .badge-info { background: #17a2b8; color: white; }
        .badge-warning { background: #ffc107; color: #000; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>${titre}</h1>
            <div>
                <a href="<c:url value='/admin/dashboard'/>" class="btn btn-secondary">← Retour Dashboard</a>
                <a href="<c:url value='/admin/historique-postes/nouveau'/>" class="btn btn-primary">+ Nouveau Mouvement</a>
            </div>
        </div>

        <c:if test="${param.success}">
            <div class="alert alert-success">✓ Mouvement enregistré avec succès!</div>
        </c:if>
        <c:if test="${param.deleted}">
            <div class="alert alert-success">✓ Mouvement supprimé avec succès!</div>
        </c:if>

        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Employé</th>
                    <th>Poste</th>
                    <th>Département</th>
                    <th>Date Début</th>
                    <th>Date Fin</th>
                    <th>Type Mouvement</th>
                    <th>Salaire</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${historiques}" var="hist">
                    <tr>
                        <td>${hist.id_historique_poste}</td>
                        <td>
                            ${hist.personnel.candidat.nom} ${hist.personnel.candidat.prenom}
                        </td>
                        <td>${hist.poste.libelle}</td>
                        <td>${hist.poste.departement.departement}</td>
                        <td><fmt:formatDate value="${hist.date_debut}" pattern="dd/MM/yyyy"/></td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty hist.date_fin}">
                                    <fmt:formatDate value="${hist.date_fin}" pattern="dd/MM/yyyy"/>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-success">En cours</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${hist.type_mouvement == 'Promotion'}">
                                    <span class="badge badge-success">${hist.type_mouvement}</span>
                                </c:when>
                                <c:when test="${hist.type_mouvement == 'Mutation'}">
                                    <span class="badge badge-info">${hist.type_mouvement}</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-primary">${hist.type_mouvement}</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:if test="${not empty hist.salaire}">
                                <fmt:formatNumber value="${hist.salaire}" type="currency" currencySymbol="Ar"/>
                            </c:if>
                        </td>
                        <td>
                            <a href="<c:url value='/admin/historique-postes/modifier/${hist.id_historique_poste}'/>" class="btn btn-warning btn-sm">Modifier</a>
                            <a href="<c:url value='/admin/historique-postes/supprimer/${hist.id_historique_poste}'/>" 
                               class="btn btn-danger btn-sm"
                               onclick="return confirm('Êtes-vous sûr de vouloir supprimer ce mouvement?')">Supprimer</a>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty historiques}">
                    <tr>
                        <td colspan="9" style="text-align: center; padding: 40px; color: #999;">
                            Aucun historique de poste enregistré.
                        </td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>
</body>
</html>
