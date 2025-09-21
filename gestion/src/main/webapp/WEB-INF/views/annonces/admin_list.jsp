<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <title>Gestion des annonces (Admin)</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background: #f4f6fa; font-family: 'Segoe UI', Arial, sans-serif; }
        .container { margin-top: 40px; }
        h1 { margin-bottom: 30px; font-weight: 700; color: #222; }
        .table {
            background: #fff;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.07);
        }
        th, td { text-align: center; vertical-align: middle; }
        th {
            background: linear-gradient(90deg, #007bff 0%, #0056b3 100%);
            color: #fff;
            font-size: 1.05rem;
            letter-spacing: 0.5px;
            border: none;
        }
        td { font-size: 0.98rem; color: #333; border: none; }
        tr { border-bottom: 1px solid #e9ecef; }
        tr:last-child { border-bottom: none; }
        tr:hover { background: #f1f7ff; }
        .btn { margin: 0 2px; font-size: 0.95rem; }
        .table-responsive { border-radius: 12px; }
        .table thead th { border-bottom: 2px solid #dee2e6; }
        .mb-3.text-end { margin-bottom: 1.5rem !important; }
    </style>
    </style>
</head>
<body>
    <div class="container">
        <h1 class="text-center">Liste des annonces</h1>
        <div class="mb-3 text-end">
            <a href="/admin/annonces/choose-department" class="btn btn-success">Ajouter une annonce</a>
        </div>
        <div class="row g-4">
            <c:forEach var="annonce" items="${annonces}">
                <div class="col-12 col-md-6 col-lg-4">
                    <div class="card shadow-sm h-100">
                        <div class="card-header bg-primary text-white">
                            <strong>${annonce.poste.libelle}</strong> <span class="badge bg-light text-dark ms-2">${annonce.poste.departement.departement}</span>
                        </div>
                        <div class="card-body">
                            <p><strong>Date de l'annonce :</strong> ${annonce.date_annonce}</p>
                            <p><strong>Responsabilites :</strong> ${annonce.responsabilite}</p>
                            <p><strong>Genre recherche :</strong> ${annonce.profil.genre}</p>
                            <p><strong>Age requis :</strong> ${annonce.profil.age}</p>
                            <p><strong>Annees d'experience :</strong> ${annonce.profil.annee_experience}</p>
                            <p><strong>Lieu :</strong> ${annonce.profil.lieu.lieu}</p>
                            <p><strong>Niveau du diplome :</strong> ${annonce.profil.diplome != null ? annonce.profil.diplome.niveau.libelle : ''}</p>
                            <p><strong>Date de fin :</strong> ${annonce.date_fin}</p>
                        </div>
                        <div class="card-footer bg-white text-center">
                            <a href="/admin/annonces/edit/${annonce.id_annonce}" class="btn btn-warning btn-sm">Modifier</a>
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
