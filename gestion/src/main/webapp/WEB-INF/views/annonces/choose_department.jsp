<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <title>Choisir un departement</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <h2 class="mb-4">Selectionnez le departement pour l'annonce</h2>
        <form method="post" action="/admin/annonces/choose-department">
            <div class="mb-3">
                <label for="departementId" class="form-label">Département :</label>
                <select name="departementId" id="departementId" class="form-select" required>
                    <option value="">Choisir un departement</option>
                    <c:forEach var="dep" items="${departements}">
                        <option value="${dep.id_departement}">${dep.departement}</option>
                    </c:forEach>
                </select>
            </div>
            <button type="submit" class="btn btn-primary">Continuer</button>
        </form>
    </div>
</body>
</html>
