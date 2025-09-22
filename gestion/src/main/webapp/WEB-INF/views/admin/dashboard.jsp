<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Dashboard Admin</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
</head>
<body>
<div class="d-flex" style="min-height: 100vh;">
    <!-- Sidebar -->
    <nav class="bg-dark text-white p-3" style="width: 220px; min-height: 100vh;">
        <h4 class="mb-4">Admin</h4>
        <ul class="nav flex-column">
            <li class="nav-item mb-2"><a href="/admin/annonces" class="nav-link text-white">Annonces</a></li>
            <li class="nav-item mb-2"><a href="#candidatures" class="nav-link text-white">Candidatures</a></li>
            <li class="nav-item mb-2"><a href="#utilisateurs" class="nav-link text-white">Utilisateurs</a></li>
            <li class="nav-item mb-2"><a href="#statistiques" class="nav-link text-white">Statistiques</a></li>
        </ul>
    </nav>
    <!-- Main Content -->
    <div class="flex-grow-1 p-4">
        <h2 id="annonces">Tableau de bord - Annonces</h2>
        <div class="row">
            <c:forEach var="annonce" items="${annonces}">
                <div class="col-md-4 mb-3">
                    <div class="card">
                        <div class="card-body">
                            <h5 class="card-title">${annonce.poste.libelle}</h5>
                            <p class="card-text">${annonce.responsabilite}</p>
                            <p class="card-text"><strong>Profil recherché:</strong> ${annonce.profil.genre}</p>
                            <p class="card-text"><strong>Date de publication:</strong> ${annonce.date_annonce}</p>
                            <p class="card-text"><strong>Date de fin:</strong> ${annonce.date_fin}</p>
                            <a href="/admin/annonces/${annonce.id_annonce}" class="btn btn-primary btn-sm">Détails</a>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</div>
</body>
</html>