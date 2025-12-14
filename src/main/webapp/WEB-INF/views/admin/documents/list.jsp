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
        .alert-danger { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
        .btn { padding: 10px 20px; border: none; border-radius: 5px; cursor: pointer; text-decoration: none; display: inline-block; margin-right: 10px; }
        .btn-primary { background: #007bff; color: white; }
        .btn-success { background: #28a745; color: white; }
        .btn-danger { background: #dc3545; color: white; }
        .btn-warning { background: #ffc107; color: #000; }
        .btn-secondary { background: #6c757d; color: white; }
        .btn-sm { padding: 6px 12px; font-size: 0.875rem; }
        table { width: 100%; border-collapse: collapse; margin: 20px 0; }
        table th, table td { padding: 12px; text-align: left; border: 1px solid #ddd; }
        table th { background: #f8f9fa; font-weight: 600; }
        table tr:hover { background: #f8f9fa; }
        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .badge { padding: 5px 10px; border-radius: 3px; font-size: 0.85em; }
        .badge-info { background: #17a2b8; color: white; }
        .badge-success { background: #28a745; color: white; }
        .badge-warning { background: #ffc107; color: #000; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>${titre}</h1>
            <div>
                <a href="<c:url value='/admin/dashboard'/>" class="btn btn-secondary">← Retour Dashboard</a>
                <a href="<c:url value='/admin/documents/nouveau'/>" class="btn btn-primary">+ Nouveau Document</a>
            </div>
        </div>

        <c:if test="${param.success}">
            <div class="alert alert-success">✓ Document enregistré avec succès!</div>
        </c:if>
        <c:if test="${param.deleted}">
            <div class="alert alert-success">✓ Document supprimé avec succès!</div>
        </c:if>
        <c:if test="${param.error == 'upload'}">
            <div class="alert alert-danger">✗ Erreur lors de l'upload du fichier!</div>
        </c:if>

        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Employé</th>
                    <th>Type Document</th>
                    <th>Nom Fichier</th>
                    <th>N° Document</th>
                    <th>Date Upload</th>
                    <th>Date Expiration</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${documents}" var="doc">
                    <tr>
                        <td>${doc.id_document}</td>
                        <td>
                            ${doc.personnel.candidat.nom} ${doc.personnel.candidat.prenom}
                            <br><small>${doc.personnel.poste.libelle}</small>
                        </td>
                        <td>
                            <span class="badge badge-info">${doc.typeDocument.libelle}</span>
                        </td>
                        <td>${doc.nom_fichier}</td>
                        <td>${doc.numero_document != null ? doc.numero_document : '-'}</td>
                        <td><fmt:formatDate value="${doc.date_upload}" pattern="dd/MM/yyyy"/></td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty doc.date_expiration}">
                                    <fmt:formatDate value="${doc.date_expiration}" pattern="dd/MM/yyyy"/>
                                    <c:set var="currentDate" value="<%= new java.util.Date() %>"/>
                                    <c:if test="${doc.date_expiration < currentDate}">
                                        <span class="badge badge-warning">Expiré</span>
                                    </c:if>
                                </c:when>
                                <c:otherwise>-</c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <a href="<c:url value='/admin/documents/modifier/${doc.id_document}'/>" class="btn btn-warning btn-sm">Modifier</a>
                            <a href="<c:url value='/admin/documents/supprimer/${doc.id_document}'/>" 
                               class="btn btn-danger btn-sm"
                               onclick="return confirm('Êtes-vous sûr de vouloir supprimer ce document?')">Supprimer</a>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty documents}">
                    <tr>
                        <td colspan="8" style="text-align: center; padding: 40px; color: #999;">
                            Aucun document enregistré.
                        </td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>
</body>
</html>
