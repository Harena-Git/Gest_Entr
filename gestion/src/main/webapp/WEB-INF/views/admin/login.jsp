<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Connexion Admin</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f5f5f5; }
        .login-container { width: 350px; margin: 80px auto; background: #fff; padding: 30px; border-radius: 8px; box-shadow: 0 2px 8px #ccc; }
        .login-container h2 { text-align: center; margin-bottom: 20px; }
        .form-group { margin-bottom: 15px; }
        label { display: block; margin-bottom: 5px; }
        input[type="text"], input[type="password"] { width: 100%; padding: 8px; border: 1px solid #ccc; border-radius: 4px; }
        .error { color: #d00; margin-bottom: 10px; text-align: center; }
        button { width: 100%; padding: 10px; background: #007bff; color: #fff; border: none; border-radius: 4px; font-size: 16px; }
        button:hover { background: #0056b3; }
    </style>
</head>
<body>
<div class="login-container">
    <h2>Connexion Admin</h2>
    <form action="/admin/login" method="post">
        <div class="form-group">
            <label for="username">Nom d'utilisateur</label>
            <input type="text" id="username" name="username" required />
        </div>
        <div class="form-group">
            <label for="password">Mot de passe</label>
            <input type="password" id="password" name="password" required />
        </div>
        <c:if test="${not empty error}">
            <div class="error">${error}</div>
        </c:if>
        <button type="submit">Se connecter</button>
    </form>
</div>
</body>
</html>