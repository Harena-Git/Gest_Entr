<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nouvelle demande de congé</title>
    <link rel="stylesheet" href="/css/styles.css" />
    <style>
        body { font-family: Arial, sans-serif; background-color: #f5f5f5; }
        .container { max-width: 600px; margin: 20px auto; background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        h2 { color: #333; margin-bottom: 20px; }
        .form-group { margin-bottom: 15px; }
        label { display: block; margin-bottom: 5px; color: #333; font-weight: bold; }
        input[type="date"], input[type="text"], textarea { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px; font-size: 14px; }
        input[type="date"]:focus, input[type="text"]:focus, textarea:focus { outline: none; border-color: #667eea; box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1); }
        .info { background-color: #e7f3ff; color: #0066cc; padding: 10px; border-radius: 4px; margin-bottom: 20px; }
        button { padding: 10px 20px; background-color: #667eea; color: white; border: none; border-radius: 4px; cursor: pointer; font-weight: bold; margin-right: 10px; }
        button:hover { background-color: #5568d3; }
        a { padding: 10px 20px; background-color: #ccc; color: #333; text-decoration: none; border-radius: 4px; display: inline-block; }
        a:hover { background-color: #bbb; }
        .alert { padding: 12px; margin-bottom: 20px; border-radius: 4px; }
        .alert-success { background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .alert-danger { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
    </style>
</head>
<body>
<%-- <jsp:include page="/WEB-INF/views/menu_bar.jsp" /> --%>
<div class="container">
    <h2>Nouvelle demande de congé</h2>

    <c:if test="${not empty succes}">
        <div class="alert alert-success">${succes}</div>
    </c:if>
    <c:if test="${not empty erreur}">
        <div class="alert alert-danger">${erreur}</div>
    </c:if>

    <!-- Informations du personnel connecté -->
    <div class="info" style="background-color: #f0f8ff; color: #003366; border-left: 4px solid #667eea;">
        <h3 style="margin: 0 0 10px 0; color: #003366;">👤 Informations personnelles</h3>
        <p><strong>ID Personnel :</strong> <span style="font-weight: bold; color: #667eea;">${personnel.id_personnel}</span></p>
        <c:if test="${personnel.candidat != null}">
            <p><strong>Nom :</strong> ${personnel.candidat.prenom} ${personnel.candidat.nom}</p>
            <p><strong>Email :</strong> ${personnel.candidat.email}</p>
        </c:if>
    </div>

    <div class="info">
        <strong>📊 Solde de congés</strong><br>
        Solde restant : <span style="font-size: 18px; font-weight: bold; color: #667eea;">${soldeRestant} jours</span>
    </div>

    <form action="${pageContext.request.contextPath}/personnel/conge/creer" method="post">
        <div class="form-group">
            <label for="dateDebut">Date de début <span style="color: red;">*</span></label>
            <input type="date" id="dateDebut" name="dateDebut" required />
        </div>
        
        <div class="form-group">
            <label for="dateFin">Date de fin <span style="color: red;">*</span></label>
            <input type="date" id="dateFin" name="dateFin" required />
        </div>
        
        <div class="form-group">
            <label for="motif">Motif de congé</label>
            <input type="text" id="motif" name="motif" maxlength="255" placeholder="Ex: Vacances, congé maladie, etc." />
        </div>
        
        <div class="form-group">
            <button type="submit">✅ Envoyer la demande</button>
            <a href="${pageContext.request.contextPath}/personnel/conge/mes-demandes">Annuler</a>
        </div>
    </form>
</div>
</body>
</html>