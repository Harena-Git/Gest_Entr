<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <title>Choisir un département</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: #f4f6fa;
            font-family: 'Segoe UI', Arial, sans-serif;
        }
        .container {
            max-width: 500px;
            margin-top: 80px;
            background: #fff;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        h2 {
            text-align: center;
            margin-bottom: 30px;
            font-weight: 700;
            color: #495057;
        }
        .form-label {
            font-weight: 600;
            color: #495057;
        }
        .form-select {
            border-radius: 8px;
            border: 1px solid #ced4da;
        }
        .btn-primary {
            background-color: #495057;
            border-color: #495057;
            width: 100%;
            font-weight: 600;
        }
        .btn-primary:hover {
            background-color: #343a40;
            border-color: #343a40;
        }
        .btn-back {
            background-color: #6c757d;
            color: #fff;
            margin-bottom: 20px;
        }
        .btn-back:hover {
            background-color: #495057;
            color: #fff;
        }
    </style>
</head>
<body>
    <div class="container">
        <a href="/admin/annonces" class="btn btn-back">← Retour</a>
        <h2>Selectionnez le département pour l'annonce</h2>
        <form method="post" action="/admin/annonces/choose-department">
            <div class="mb-4">
                <label for="departementId" class="form-label">Département :</label>
                <select name="departementId" id="departementId" class="form-select" required>
                    <option value="">Choisir un département</option>
                    <c:forEach var="dep" items="${departements}">
                        <option value="${dep.id_departement}">${dep.departement}</option>
                    </c:forEach>
                </select>
            </div>
            <button type="submit" class="btn btn-primary">Continuer</button>
        </form>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
