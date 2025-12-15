<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Connexion Admin</title>
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
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .login-container {
            width: 100%;
            max-width: 420px;
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }

        .login-header {
            background: #495057;
            color: white;
            padding: 40px 30px;
            text-align: center;
        }

        .login-icon {
            font-size: 3em;
            margin-bottom: 15px;
        }

        .login-header h2 {
            font-size: 1.8em;
            font-weight: 600;
            margin: 0;
        }

        .login-header p {
            margin-top: 8px;
            opacity: 0.9;
            font-size: 0.95em;
        }

        .login-form {
            padding: 40px 30px;
        }

        .form-group {
            margin-bottom: 25px;
        }

        label {
            display: block;
            margin-bottom: 8px;
            color: #495057;
            font-weight: 500;
            font-size: 0.95em;
        }

        .input-wrapper {
            position: relative;
        }

        .input-icon {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #6c757d;
            font-size: 1.1em;
        }

        input[type="text"], 
        input[type="password"] {
            width: 100%;
            padding: 12px 15px 12px 45px;
            border: 2px solid #dee2e6;
            border-radius: 8px;
            font-size: 1em;
            transition: all 0.3s ease;
            background: #f8f9fa;
        }

        input[type="text"]:focus, 
        input[type="password"]:focus {
            outline: none;
            border-color: #495057;
            background: white;
            box-shadow: 0 0 0 3px rgba(73, 80, 87, 0.1);
        }

        .error {
            background: #fee;
            color: #d00;
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 20px;
            text-align: center;
            border: 1px solid #fcc;
            font-size: 0.9em;
        }

        button {
            width: 100%;
            padding: 14px;
            background: #495057;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 1em;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        button:hover {
            background: #343a40;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(73, 80, 87, 0.3);
        }

        button:active {
            transform: translateY(0);
        }

        .forgot-password {
            text-align: center;
            margin-top: 20px;
        }

        .forgot-password a {
            color: #495057;
            text-decoration: none;
            font-size: 0.9em;
            transition: color 0.3s ease;
        }

        .forgot-password a:hover {
            color: #343a40;
            text-decoration: underline;
        }

        @media (max-width: 480px) {
            .login-header {
                padding: 30px 20px;
            }

            .login-header h2 {
                font-size: 1.5em;
            }

            .login-form {
                padding: 30px 20px;
            }
        }

        .login-options {
            text-align: center;
            margin-top: 20px;
            padding-top: 20px;
            border-top: 1px solid #dee2e6;
        }

        .login-options a {
            color: #495057;
            text-decoration: none;
            display: inline-block;
            margin: 5px 10px;
            padding: 8px 15px;
            border: 1px solid #dee2e6;
            border-radius: 5px;
            transition: all 0.3s;
        }

        .login-options a:hover {
            background: #f8f9fa;
            border-color: #495057;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="login-header">
            <div class="login-icon">🔐</div>
            <h2>Connexion Admin</h2>
            <p>Accédez à votre espace d'administration</p>
        </div>
        
        <div class="login-form">
            <form action="/admin/login" method="post">
                <div class="form-group">
                    <label for="username">Nom d'utilisateur</label>
                    <div class="input-wrapper">
                        <span class="input-icon">👤</span>
                        <input type="text" id="username" name="username" placeholder="Entrez votre nom d'utilisateur" required />
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="password">Mot de passe</label>
                    <div class="input-wrapper">
                        <span class="input-icon">🔒</span>
                        <input type="password" id="password" name="password" placeholder="Entrez votre mot de passe" required />
                    </div>
                </div>
                
                <c:if test="${not empty error}">
                    <div class="error">⚠️ ${error}</div>
                </c:if>
                
                <button type="submit">Se connecter</button>
                <div class="login-options">
                    <a href="/personnel/login">👤 Je suis Personnel</a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>