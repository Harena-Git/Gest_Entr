<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Personnel Test</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background: #f5f5f5; }
        .container { max-width: 1000px; margin: 0 auto; background: white; padding: 20px; border-radius: 8px; }
        h1 { color: #333; border-bottom: 2px solid #667eea; padding-bottom: 10px; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th { background: #667eea; color: white; padding: 12px; text-align: left; }
        td { border: 1px solid #ddd; padding: 12px; }
        tr:nth-child(even) { background: #f9f9f9; }
        .personnel-id { font-weight: bold; color: #667eea; font-size: 16px; }
        .success { color: green; }
        .error { color: red; }
    </style>
</head>
<body>
<div class="container">
    <h1>📊 AFFICHAGE DES PERSONNELS</h1>
    
    <h2>✅ Contrôleur appelé - Données reçues</h2>
    <c:if test="${tousLesPersonnels != null}">
        <p><strong>Nombre de personnels:</strong> <span class="personnel-id">${tousLesPersonnels.size()}</span></p>
        
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>USERNAME</th>
                    <th>NOM</th>
                    <th>PRENOM</th>
                    <th>EMAIL</th>
                    <th>ACTIF</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="p" items="${tousLesPersonnels}">
                    <tr>
                        <td><strong class="personnel-id">${p.id_personnel}</strong></td>
                        <td>${p.username}</td>
                        <td><c:if test="${p.candidat != null}">${p.candidat.nom}</c:if></td>
                        <td><c:if test="${p.candidat != null}">${p.candidat.prenom}</c:if></td>
                        <td><c:if test="${p.candidat != null}">${p.candidat.email}</c:if></td>
                        <td><c:if test="${p.actif == 1}"><span class="success">✅ OUI</span></c:if><c:if test="${p.actif == 0}"><span class="error">❌ NON</span></c:if></td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </c:if>
    
    <c:if test="${tousLesPersonnels == null || tousLesPersonnels.size() == 0}">
        <p class="error"><strong>ERREUR:</strong> Aucun personnel trouvé !</p>
    </c:if>
    
    <hr style="margin-top: 40px;">
    <p><a href="/">← Retour accueil</a> | <a href="/test/personnel/1">Voir ID 1</a></p>
</div>
</body>
</html>
