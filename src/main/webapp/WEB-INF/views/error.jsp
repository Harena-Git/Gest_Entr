<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Erreur</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f5f5f5;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
        }
        .error-container {
            background: white;
            padding: 40px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            max-width: 600px;
            text-align: center;
        }
        h1 {
            color: #d32f2f;
            margin: 0 0 20px 0;
        }
        .error-code {
            font-size: 48px;
            color: #d32f2f;
            margin: 20px 0;
            font-weight: bold;
        }
        .error-message {
            color: #666;
            margin: 20px 0;
            font-size: 16px;
        }
        .error-details {
            background: #f9f9f9;
            border-left: 4px solid #d32f2f;
            padding: 15px;
            margin: 20px 0;
            text-align: left;
            overflow-x: auto;
        }
        a {
            display: inline-block;
            margin-top: 20px;
            padding: 10px 20px;
            background: #667eea;
            color: white;
            text-decoration: none;
            border-radius: 5px;
        }
        a:hover {
            background: #764ba2;
        }
    </style>
</head>
<body>
<div class="error-container">
    <h1>Une Erreur s'est Produite</h1>
    <div class="error-code">${status}</div>
    <div class="error-message">${message}</div>
    
    <% if (request.getAttribute("exception") != null) { %>
    <div class="error-details">
        <strong>Détails Techniques :</strong>
        <pre><%= request.getAttribute("exception") %></pre>
    </div>
    <% } %>
    
    <a href="/">Retourner à l'accueil</a>
</div>
</body>
</html>
