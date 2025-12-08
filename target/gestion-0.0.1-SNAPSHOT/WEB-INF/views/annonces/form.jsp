<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <title>Formulaire annonce</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: #f4f6fa;
            font-family: 'Segoe UI', Arial, sans-serif;
            padding: 20px;
        }
        .form-container {
            max-width: 800px;
            margin: 40px auto;
            background-color: #fff;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        h1 {
            text-align: center;
            margin-bottom: 30px;
            color: #495057;
            font-weight: 700;
        }
        label {
            font-weight: 600;
            color: #495057;
        }
        .form-control, .form-select, textarea {
            border-radius: 8px;
            border: 1px solid #ced4da;
        }
        textarea {
            min-height: 100px;
        }
        .btn-primary {
            background-color: #495057;
            border-color: #495057;
            font-weight: 600;
        }
        .btn-primary:hover {
            background-color: #343a40;
            border-color: #343a40;
        }
        .btn-secondary {
            background-color: #6c757d;
            border-color: #6c757d;
            color: #fff;
        }
        .btn-secondary:hover {
            background-color: #495057;
            border-color: #495057;
            color: #fff;
        }
        .text-center .btn {
            margin: 5px;
        }
        .alert-danger {
            border-radius: 8px;
        }
    </style>
</head>
<body>
    <div class="form-container">
        <h1>${annonce.id_annonce == null ? 'Ajouter' : 'Modifier'} une annonce</h1>

        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>

        <form method="post" action="${annonce.id_annonce == null ? '/admin/annonces' : '/admin/annonces/update/' += annonce.id_annonce}">
            <c:if test="${not empty departementId}">
                <input type="hidden" name="departementId" value="${departementId}" />
            </c:if>

            <div class="mb-3">
                <label for="posteId">Titre du poste :</label>
                <select name="posteId" id="posteId" class="form-select" required>
                    <option value="">Selectionnez un poste</option>
                    <c:forEach var="poste" items="${postes}">
                        <option value="${poste.id_poste}" ${annonce.poste != null && annonce.poste.id_poste == poste.id_poste ? 'selected' : ''}>${poste.libelle}</option>
                    </c:forEach>
                </select>
            </div>

            <div class="mb-3">
                <label for="responsabilite">Responsabilités :</label>
                <textarea name="responsabilite" id="responsabilite" class="form-control" required placeholder="Décrivez les responsabilités du poste">${annonce.responsabilite}</textarea>
            </div>

            <div class="row">
                <div class="mb-3 col-md-6">
                    <label for="genre">Genre :</label>
                    <select name="genre" id="genre" class="form-select" required>
                        <option value="">Sélectionnez un genre</option>
                        <option value="Homme" ${annonce.profil != null && annonce.profil.genre == 'Homme' ? 'selected' : ''}>Homme</option>
                        <option value="Femme" ${annonce.profil != null && annonce.profil.genre == 'Femme' ? 'selected' : ''}>Femme</option>
                        <option value="les deux">Indifférent</option>
                    </select>
                </div>
                <div class="mb-3 col-md-6">
                    <label for="age">Âge :</label>
                    <input type="number" name="age" id="age" class="form-control" value="${annonce.profil != null ? annonce.profil.age : ''}" required min="18" max="65" placeholder="Ex: 30"/>
                </div>
            </div>

            <div class="row">
                <div class="mb-3 col-md-6">
                    <label for="annee_experience">Années d'expérience :</label>
                    <input type="number" name="annee_experience" id="annee_experience" class="form-control" value="${annonce.profil != null ? annonce.profil.annee_experience : ''}" required placeholder="Ex: 5 ans"/>
                </div>
                <div class="mb-3 col-md-6">
                    <label for="lieuId">Lieu :</label>
                    <select name="lieuId" id="lieuId" class="form-select" required>
                        <option value="">Sélectionnez un lieu</option>
                        <c:forEach var="lieu" items="${lieux}">
                            <option value="${lieu.id_lieu}" ${annonce.profil != null && annonce.profil.lieu != null && annonce.profil.lieu.id_lieu == lieu.id_lieu ? 'selected' : ''}>${lieu.lieu}</option>
                        </c:forEach>
                    </select>
                </div>
            </div>

            <div class="row">
                <div class="mb-3 col-md-6">
                    <label for="niveauId">Niveau d'étude :</label>
                    <select name="niveauId" id="niveauId" class="form-select" required>
                        <option value="">Sélectionnez un niveau</option>
                        <c:forEach var="niveau" items="${niveaux}">
                            <option value="${niveau.id_niveau}" ${annonce.profil != null && annonce.profil.diplome != null && annonce.profil.diplome.niveau != null && annonce.profil.diplome.niveau.id_niveau == niveau.id_niveau ? 'selected' : ''}>${niveau.libelle}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="mb-3 col-md-6">
                    <label for="filiereId">Filière :</label>
                    <select class="form-select" id="filiereId" name="filiereId" required>
                        <option value="" disabled selected>Choisir une filière</option>
                        <c:forEach var="filiere" items="${filieres}">
                            <option value="${filiere.idFiliere}" ${annonce != null && annonce.profil != null && annonce.profil.diplome != null && annonce.profil.diplome.filiere != null && annonce.profil.diplome.filiere.idFiliere == filiere.idFiliere ? 'selected' : ''}>
                                ${filiere.libelle}
                            </option>
                        </c:forEach>
                    </select>
                </div>
            </div>

            <div class="mb-4">
                <label for="date_fin">Date de fin de validité :</label>
                <input type="date" name="date_fin" id="date_fin" class="form-control" value="${annonce.date_fin}" required/>
            </div>

            <div class="text-center">
                <button type="submit" class="btn btn-primary">Enregistrer</button>
                <a href="/admin/annonces" class="btn btn-secondary">Retour à la liste</a>
            </div>
        </form>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
