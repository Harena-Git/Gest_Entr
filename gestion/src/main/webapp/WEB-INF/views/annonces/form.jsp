<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <title>Formulaire annonce</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            padding: 20px;
            font-family: Arial, sans-serif;
        }
        .form-container {
            max-width: 800px;
            margin: 0 auto;
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        .form-group {
            margin-bottom: 15px;
        }
        label {
            font-weight: bold;
            margin-bottom: 5px;
            display: block;
        }
        textarea {
            min-height: 100px;
        }
    </style>
</head>
<body>
    <div class="form-container">
        <h1 class="text-center mb-4">${annonce.id_annonce == null ? 'Ajouter' : 'Modifier'} une annonce</h1>
        
        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>
        
        <form method="post" action="${annonce.id_annonce == null ? '/admin/annonces' : '/admin/annonces/update/' += annonce.id_annonce}">
            <c:if test="${not empty departementId}">
                <input type="hidden" name="departementId" value="${departementId}" />
            </c:if>
            
            <!-- Poste (titre du poste) -->
            <div class="form-group">
                <label for="posteId">Titre du poste :</label>
                <select name="posteId" id="posteId" class="form-control" required title="Selectionnez le poste">
                    <option value="">Selectionnez un poste</option>
                    <c:forEach var="poste" items="${postes}">
                        <option value="${poste.id_poste}" ${annonce.poste != null && annonce.poste.id_poste == poste.id_poste ? 'selected' : ''}>${poste.libelle}</option>
                    </c:forEach>
                </select>
            </div>

            <!-- Responsabilite -->
            <div class="form-group">
                <label for="responsabilite">Responsabilites :</label>
                <textarea name="responsabilite" id="responsabilite" class="form-control" required placeholder="Decrivez les responsabilites du poste" title="Responsabilites du poste">${annonce.responsabilite}</textarea>
            </div>

            <!-- Genre -->
            <div class="form-group">
                <label for="genre">Genre :</label>
                <select name="genre" id="genre" class="form-control" required title="Selectionnez le genre">
                    <option value="">Selectionnez un genre</option>
                    <option value="Homme" ${annonce.profil != null && annonce.profil.genre == 'Homme' ? 'selected' : ''}>Homme</option>
                    <option value="Femme" ${annonce.profil != null && annonce.profil.genre == 'Femme' ? 'selected' : ''}>Femme</option>
                    <option value="Indifferent" ${annonce.profil != null && annonce.profil.genre == 'Indifferent' ? 'selected' : ''}>Indifferent</option>
                </select>
            </div>

            <!-- Âge -->
            <div class="form-group">
                <label for="age">Age :</label>
                <input type="number" name="age" id="age" class="form-control" value="${annonce.profil != null ? annonce.profil.age : ''}" required placeholder="Ex: 30" title="Âge du candidat" min="18" max="65"/>
            </div>

            <!-- Annee d'experience -->
            <div class="form-group">
                <label for="annee_experience">Annees d'experience :</label>
                <input type="text" name="annee_experience" id="annee_experience" class="form-control" value="${annonce.profil != null ? annonce.profil.annee_experience : ''}" required placeholder="Ex: 5 ans" title="Annees d'experience"/>
            </div>

            <!-- Lieu -->
            <div class="form-group">
                <label for="lieuId">Lieu :</label>
                <select name="lieuId" id="lieuId" class="form-control" required title="Selectionnez le lieu">
                    <option value="">Selectionnez un lieu</option>
                    <c:forEach var="lieu" items="${lieux}">
                        <option value="${lieu.id_lieu}" ${annonce.profil != null && annonce.profil.lieu != null && annonce.profil.lieu.id_lieu == lieu.id_lieu ? 'selected' : ''}>${lieu.lieu}</option>
                    </c:forEach>
                </select>
            </div>

            <!-- Niveau d'etude -->
            <div class="form-group">
                <label for="niveauId">Niveau d'etude :</label>
                <select name="niveauId" id="niveauId" class="form-control" required title="Selectionnez le niveau d'etude">
                    <option value="">Selectionnez un niveau</option>
                    <c:forEach var="niveau" items="${niveaux}">
                        <option value="${niveau.id_niveau}" ${annonce.profil != null && annonce.profil.diplome != null && annonce.profil.diplome.niveau != null && annonce.profil.diplome.niveau.id_niveau == niveau.id_niveau ? 'selected' : ''}>${niveau.libelle}</option>
                    </c:forEach>
                </select>
            </div>

            <!-- Filière -->
            <div class="form-group">
                <label for="filiereId">Filiere :</label>
                    <select class="form-control" id="filiereId" name="filiereId" required>
                        <option value="" disabled selected>Choisir une filière</option>
                        <c:forEach var="filiere" items="${filieres}">
                            <option value="${filiere.idFiliere}" ${annonce != null && annonce.profil != null && annonce.profil.diplome != null && annonce.profil.diplome.filiere != null && annonce.profil.diplome.filiere.idFiliere == filiere.idFiliere ? 'selected' : ''}>
                                ${filiere.libelle}
                            </option>
                        </c:forEach>
                    </select>
            </div>

            <!-- Date fin -->
            <div class="form-group">
                <label for="date_fin">Date de fin de validite :</label>
                <input type="date" name="date_fin" id="date_fin" class="form-control" value="${annonce.date_fin}" required title="Date de fin de validite"/>
            </div>

            <div class="form-group text-center">
                <button type="submit" class="btn btn-primary">Enregistrer</button>
                <a href="/admin/annonces" class="btn btn-secondary">Retour à la liste</a>
            </div>
        </form>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>