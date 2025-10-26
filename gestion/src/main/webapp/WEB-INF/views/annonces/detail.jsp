<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Detail annonce</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background: #f8f9fa; }
        .container { margin-top: 40px; max-width: 600px; background: #fff; border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.08); padding: 30px; }
        h1 { margin-bottom: 30px; }
        ul { list-style: none; padding: 0; }
        li { padding: 10px 0; border-bottom: 1px solid #eee; }
        li:last-child { border-bottom: none; }
        .btn { margin-top: 20px; }
    </style>
</head>
<body>
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card shadow-lg border-0 mt-4">
                    <div class="card-header bg-primary text-white d-flex align-items-center justify-content-between">
                        <span class="badge bg-warning text-dark fs-6">Fiche Annonce</span>
                        <span class="fs-5">Détail de l'annonce</span>
                    </div>
                    <div class="card-body">
                        <ul class="list-group list-group-flush">
                            <li class="list-group-item"><strong>Date annonce :</strong> ${annonce.date_annonce}</li>
                            <li class="list-group-item"><strong>Poste :</strong> ${annonce.poste.libelle}</li>
                            <li class="list-group-item"><strong>Departement :</strong> ${annonce.poste.departement.departement}</li>
                            <li class="list-group-item"><strong>responsabilite :</strong> ${annonce.responsabilite}</li>
                            <li class="list-group-item"><strong>Genre :</strong> ${annonce.profil.genre}</li>
                            <li class="list-group-item"><strong>Age :</strong> ${annonce.profil.age}</li>
                            <li class="list-group-item"><strong>Annee experience :</strong> ${annonce.profil.annee_experience}</li>
                            <li class="list-group-item"><strong>Lieu :</strong> ${annonce.profil.lieu.lieu}</li>
                            <li class="list-group-item"><strong>Niveau diplome :</strong> ${annonce.profil.diplome != null ? annonce.profil.diplome.niveau.libelle : ''}</li>
                            <li class="list-group-item"><strong>Date fin :</strong> ${annonce.date_fin}</li>
                        </ul>
                        <a href="/admin/annonces" class="btn btn-secondary w-100 mt-4">Retour a la liste</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
