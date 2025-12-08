<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Se connecter - Gestion Entreprise</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login-styles.css">
</head>
<body>
<div class="login-container">
    <h1>Gestion Entreprise</h1>
    <p>Connectez-vous pour accéder à votre compte</p>

    <c:if test="${param.error != null}">
        <div class="error-message">
            ⚠️ Identifiants invalides. Veuillez réessayer.
        </div>
    </c:if>

    <form method="post" action="${pageContext.request.contextPath}/login">
        <div class="form-group">
            <label for="username">Nom d'utilisateur</label>
            <input type="text" id="username" name="username" placeholder="Entrez votre identifiant" required autofocus>
        </div>

        <div class="form-group">
            <label for="password">Mot de passe</label>
            <input type="password" id="password" name="password" placeholder="Entrez votre mot de passe" required>
        </div>

        <button type="submit">Se connecter</button>
    </form>

    <div class="footer">
        <p>Mot de passe oublié ? Contactez votre administrateur.</p>
    </div>
</div>
</body>
</html>
