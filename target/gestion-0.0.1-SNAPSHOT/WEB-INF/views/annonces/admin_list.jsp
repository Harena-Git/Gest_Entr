<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <title>Gestion des annonces (Admin)</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { 
            background: #f4f6fa; 
            font-family: 'Segoe UI', Arial, sans-serif; 
        }
        .container { margin-top: 40px; }
        h1 { margin-bottom: 30px; font-weight: 700; color: #222; }
        .card {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 6px 20px rgba(0,0,0,0.15);
        }
        .card-header {
            background-color: #495057; 
            color: #fff; 
            font-weight: 600;
            display: flex; 
            justify-content: space-between;
            align-items: center;
            font-size: 1rem;
        }
        .badge {
            background-color: #6c757d;
            color: #fff;
            font-size: 0.85rem;
        }
        .card-body p {
            margin-bottom: 0.5rem;
            color: #495057;
            font-size: 0.95rem;
        }
        .card-footer {
            background: #f8f9fa;
        }
        .btn {
            margin: 0 2px; 
            font-size: 0.9rem;
        }
        .btn-success { background-color: #495057; border-color: #495057; }
        .btn-success:hover { background-color: #343a40; border-color: #343a40; }
        .btn-warning { background-color: #ffc107; border-color: #ffc107; color: #212529; }
        .btn-danger { background-color: #dc3545; border-color: #dc3545; }
        .btn-back { background-color: #6c757d; color: #fff; margin-bottom: 20px; }
        .btn-back:hover { background-color: #495057; color: #fff; }
        .section-title { font-weight: 600; color: #495057; margin-top: 10px; margin-bottom: 5px; }
        .text-end a { text-decoration: none; }
    </style>
</head>
<body>
    <div class="container">
        <a href="/admin/dashboard" class="btn btn-back">← Retour</a>
        <h1 class="text-center">Liste des annonces</h1>
        <div class="mb-3 text-end">
            <a href="/admin/annonces/choose-department" class="btn btn-success">Ajouter une annonce</a>
        </div>
        <div class="row g-4">
            <c:forEach var="annonce" items="${annonces}">
                <div class="col-12 col-md-6 col-lg-4">
                    <div class="card h-100">
                        <div class="card-header">
                            <span>${annonce.poste.libelle}</span> 
                            <span class="badge">${annonce.poste.departement.departement}</span>
                        </div>
                        <div class="card-body">
                            <p class="section-title">Infos générales</p>
                            <p><strong>Date de l'annonce :</strong> ${annonce.date_annonce}</p>
                            <p><strong>Date de fin :</strong> ${annonce.date_fin}</p>
                            <p class="section-title">Profil recherché</p>
                            <p><strong>Responsabilites :</strong> ${annonce.responsabilite}</p>
                            <p><strong>Genre :</strong> ${annonce.profil.genre}</p>
                            <p><strong>Age :</strong> ${annonce.profil.age}</p>
                            <p><strong>Années d'expérience :</strong> ${annonce.profil.annee_experience}</p>
                            <p><strong>Lieu :</strong> ${annonce.profil.lieu.lieu}</p>
                            <p><strong>Niveau du diplome :</strong> ${annonce.profil.diplome != null ? annonce.profil.diplome.niveau.libelle : ''}</p>
                        </div>
                        <div class="card-footer text-center">
                            <a href="/admin/annonces/delete/${annonce.id_annonce}" class="btn btn-danger btn-sm" onclick="return confirm('Supprimer ?');">Supprimer</a>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
