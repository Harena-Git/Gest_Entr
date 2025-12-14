<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${titre}</title>
    <style>
        .container { max-width: 800px; margin: 20px auto; padding: 20px; }
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: 600; }
        .form-group input, .form-group select, .form-group textarea {
            width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 5px;
        }
        .form-group textarea { min-height: 100px; }
        .btn { padding: 10px 20px; border: none; border-radius: 5px; cursor: pointer; text-decoration: none; display: inline-block; margin-right: 10px; }
        .btn-primary { background: #007bff; color: white; }
        .btn-secondary { background: #6c757d; color: white; }
        .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>${titre}</h1>
        
        <form action="<c:url value='/admin/historique-postes/enregistrer'/>" method="post">
            <input type="hidden" name="id_historique_poste" value="${historique.id_historique_poste}">
            
            <div class="form-group">
                <label for="personnel">Employé *</label>
                <select name="personnel.id_personnel" id="personnel" required>
                    <option value="">-- Sélectionner un employé --</option>
                    <c:forEach items="${personnels}" var="pers">
                        <option value="${pers.id_personnel}" ${historique.personnel.id_personnel == pers.id_personnel ? 'selected' : ''}>
                            ${pers.candidat.nom} ${pers.candidat.prenom} - ${pers.poste.libelle}
                        </option>
                    </c:forEach>
                </select>
            </div>

            <div class="form-group">
                <label for="poste">Nouveau Poste *</label>
                <select name="poste.id_poste" id="poste" required>
                    <option value="">-- Sélectionner un poste --</option>
                    <c:forEach items="${postes}" var="p">
                        <option value="${p.id_poste}" ${historique.poste.id_poste == p.id_poste ? 'selected' : ''}>
                            ${p.libelle} - ${p.departement.departement}
                        </option>
                    </c:forEach>
                </select>
            </div>

            <div class="form-group">
                <label for="type_mouvement">Type de Mouvement *</label>
                <select name="type_mouvement" id="type_mouvement" required>
                    <option value="">-- Sélectionner --</option>
                    <option value="Affectation initiale" ${historique.type_mouvement == 'Affectation initiale' ? 'selected' : ''}>Affectation initiale</option>
                    <option value="Promotion" ${historique.type_mouvement == 'Promotion' ? 'selected' : ''}>Promotion</option>
                    <option value="Mutation" ${historique.type_mouvement == 'Mutation' ? 'selected' : ''}>Mutation</option>
                    <option value="Rétrogradation" ${historique.type_mouvement == 'Rétrogradation' ? 'selected' : ''}>Rétrogradation</option>
                </select>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="date_debut">Date de Début *</label>
                    <input type="date" name="date_debut" id="date_debut" required
                           value="<fmt:formatDate value='${historique.date_debut}' pattern='yyyy-MM-dd'/>">
                </div>

                <div class="form-group">
                    <label for="date_fin">Date de Fin</label>
                    <input type="date" name="date_fin" id="date_fin"
                           value="<fmt:formatDate value='${historique.date_fin}' pattern='yyyy-MM-dd'/>">
                    <small>Laisser vide si poste actuel</small>
                </div>
            </div>

            <div class="form-group">
                <label for="salaire">Salaire (Ar)</label>
                <input type="number" name="salaire" id="salaire" step="0.01" min="0"
                       value="${historique.salaire}">
            </div>

            <div class="form-group">
                <label for="motif">Motif / Justification</label>
                <textarea name="motif" id="motif">${historique.motif}</textarea>
            </div>

            <div class="form-group">
                <button type="submit" class="btn btn-primary">Enregistrer</button>
                <a href="<c:url value='/admin/historique-postes'/>" class="btn btn-secondary">Annuler</a>
            </div>
        </form>
    </div>
</body>
</html>
