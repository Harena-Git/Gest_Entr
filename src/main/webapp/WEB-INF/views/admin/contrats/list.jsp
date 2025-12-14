<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${titre}</title>
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>">
    <style>
        .container { max-width: 1400px; margin: 20px auto; padding: 20px; }
        .alert { padding: 12px 20px; margin: 10px 0; border-radius: 5px; }
        .alert-success { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .alert-danger { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
        .alert-warning { background: #fff3cd; color: #856404; border: 1px solid #ffeeba; }
        .btn { padding: 10px 20px; border: none; border-radius: 5px; cursor: pointer; text-decoration: none; display: inline-block; }
        .btn-primary { background: #007bff; color: white; }
        .btn-success { background: #28a745; color: white; }
        .btn-danger { background: #dc3545; color: white; }
        .btn-warning { background: #ffc107; color: #000; }
        table { width: 100%; border-collapse: collapse; margin: 20px 0; }
        table th, table td { padding: 12px; text-align: left; border: 1px solid #ddd; }
        table th { background: #f8f9fa; font-weight: 600; }
        table tr:hover { background: #f8f9fa; }
        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .badge { padding: 5px 10px; border-radius: 3px; font-size: 0.85em; }
        .badge-success { background: #28a745; color: white; }
        .badge-warning { background: #ffc107; color: #000; }
        .badge-danger { background: #dc3545; color: white; }
        .badge-secondary { background: #6c757d; color: white; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>${titre}</h1>
            <div>
                <a href="<c:url value='/admin/dashboard'/>" class="btn btn-secondary">← Retour Dashboard</a>
                <a href="<c:url value='/admin/contrats/nouveau'/>" class="btn btn-primary">+ Nouveau Contrat</a>
            </div>
        </div>

        <c:if test="${param.success}">
            <div class="alert alert-success">✓ Contrat enregistré avec succès!</div>
        </c:if>
        <c:if test="${param.deleted}">
            <div class="alert alert-success">✓ Contrat supprimé avec succès!</div>
        </c:if>

        <!-- Alertes de contrats expirant bientôt -->
        <c:if test="${not empty alertes}">
            <div class="alert alert-warning">
                <strong>⚠️ Alertes Contrats</strong> - ${alertes.size()} contrat(s) expire(nt) dans moins de 15 jours!
                <ul>
                    <c:forEach items="${alertes}" var="contrat">
                        <li>
                            ${contrat.personnel.candidat.nom} ${contrat.personnel.candidat.prenom} - 
                            ${contrat.typeContrat.libelle} - 
                            Expire le <fmt:formatDate value="${contrat.date_fin}" pattern="dd/MM/yyyy"/>
                        </li>
                    </c:forEach>
                </ul>
            </div>
        </c:if>

        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Employé</th>
                    <th>Type Contrat</th>
                    <th>Date Début</th>
                    <th>Date Fin</th>
                    <th>Durée</th>
                    <th>Statut</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${contrats}" var="contrat">
                    <tr>
                        <td>${contrat.id_contrat_travail}</td>
                        <td>
                            ${contrat.personnel.candidat.nom} ${contrat.personnel.candidat.prenom}
                            <br><small>${contrat.personnel.poste.libelle}</small>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${contrat.typeContrat.libelle == 'CDI'}">
                                    <span class="badge badge-success">${contrat.typeContrat.libelle}</span>
                                </c:when>
                                <c:when test="${contrat.typeContrat.libelle == 'CDD'}">
                                    <span class="badge badge-warning">${contrat.typeContrat.libelle}</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-secondary">${contrat.typeContrat.libelle}</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td><fmt:formatDate value="${contrat.date_debut}" pattern="dd/MM/yyyy"/></td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty contrat.date_fin}">
                                    <fmt:formatDate value="${contrat.date_fin}" pattern="dd/MM/yyyy"/>
                                </c:when>
                                <c:otherwise>Indéterminée</c:otherwise>
                            </c:choose>
                        </td>
                        <td>${contrat.duree_mois != null ? contrat.duree_mois : '-'} mois</td>
                        <td>
                            <c:choose>
                                <c:when test="${contrat.statut == 'Actif'}">
                                    <span class="badge badge-success">${contrat.statut}</span>
                                </c:when>
                                <c:when test="${contrat.statut == 'Terminé'}">
                                    <span class="badge badge-secondary">${contrat.statut}</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-warning">${contrat.statut}</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <a href="<c:url value='/admin/contrats/modifier/${contrat.id_contrat_travail}'/>" class="btn btn-warning btn-sm">Modifier</a>
                            <a href="<c:url value='/admin/contrats/supprimer/${contrat.id_contrat_travail}'/>" 
                               class="btn btn-danger btn-sm"
                               onclick="return confirm('Êtes-vous sûr de vouloir supprimer ce contrat?')">Supprimer</a>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty contrats}">
                    <tr>
                        <td colspan="8" style="text-align: center; padding: 40px; color: #999;">
                            Aucun contrat de travail enregistré.
                        </td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>
</body>
</html>
