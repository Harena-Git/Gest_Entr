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
        
        <form action="<c:url value='/admin/contrats/enregistrer'/>" method="post">
            <input type="hidden" name="id_contrat_travail" value="${contrat.id_contrat_travail}">
            
            <div class="form-group">
                <label for="personnel">Employé *</label>
                <select name="personnelId" id="personnel" required>
                    <option value="">-- Sélectionner un employé --</option>
                    <c:forEach items="${personnels}" var="pers">
                        <option value="${pers.id_personnel}" ${contrat.personnel != null && contrat.personnel.id_personnel == pers.id_personnel ? 'selected' : ''}>
                            ${pers.candidat.nom} ${pers.candidat.prenom} - ${pers.poste.libelle}
                        </option>
                    </c:forEach>
                </select>
            </div>

            <div class="form-group">
                <label for="typeContrat">Type de Contrat *</label>
                <select name="typeContratId" id="typeContrat" required onchange="toggleDateFin()">
                    <option value="">-- Sélectionner un type --</option>
                    <c:forEach items="${typesContrat}" var="type">
                        <option value="${type.id_type_contrat}" ${contrat.typeContrat != null && contrat.typeContrat.id_type_contrat == type.id_type_contrat ? 'selected' : ''}>
                            ${type.libelle}
                        </option>
                    </c:forEach>
                </select>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="date_debut">Date de Début *</label>
                    <input type="date" name="date_debut" id="date_debut" required
                           value="<fmt:formatDate value='${contrat.date_debut}' pattern='yyyy-MM-dd'/>">
                </div>

                <div class="form-group" id="dateFin Group">
                    <label for="date_fin">Date de Fin</label>
                    <input type="date" name="date_fin" id="date_fin"
                           value="<fmt:formatDate value='${contrat.date_fin}' pattern='yyyy-MM-dd'/>">
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="duree_mois">Durée (mois)</label>
                    <input type="number" name="duree_mois" id="duree_mois" min="1"
                           value="${contrat.duree_mois}">
                </div>

                <div class="form-group">
                    <label for="date_fin_periode_essai">Fin Période d'Essai</label>
                    <input type="date" name="date_fin_periode_essai" id="date_fin_periode_essai"
                           value="<fmt:formatDate value='${contrat.date_fin_periode_essai}' pattern='yyyy-MM-dd'/>">
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="statut">Statut *</label>
                    <select name="statut" id="statut" required>
                        <option value="">-- Sélectionner un statut --</option>
                        <option value="Actif" ${contrat.statut == 'Actif' ? 'selected' : ''}>Actif</option>
                        <option value="Terminé" ${contrat.statut == 'Terminé' ? 'selected' : ''}>Terminé</option>
                        <option value="Renouvelé" ${contrat.statut == 'Renouvelé' ? 'selected' : ''}>Renouvelé</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="renouvele">
                        <input type="checkbox" name="renouvele" id="renouvele" value="true" ${contrat.renouvele ? 'checked' : ''}>
                        Contrat Renouvelé
                    </label>
                    <input type="hidden" name="_renouvele" value="on">
                </div>
            </div>

            <div class="form-group">
                <label for="remarques">Remarques</label>
                <textarea name="remarques" id="remarques">${contrat.remarques}</textarea>
            </div>

            <div class="form-group">
                <button type="submit" class="btn btn-primary">Enregistrer</button>
                <a href="<c:url value='/admin/contrats'/>" class="btn btn-secondary">Annuler</a>
            </div>
        </form>
    </div>

    <script>
        function toggleDateFin() {
            const typeSelect = document.getElementById('typeContrat');
            const selectedText = typeSelect.options[typeSelect.selectedIndex].text;
            const dateFinInput = document.getElementById('date_fin');
            
            if (selectedText === 'CDI') {
                dateFinInput.value = '';
                dateFinInput.disabled = true;
            } else {
                dateFinInput.disabled = false;
            }
        }
        
        // Appeler au chargement de la page
        window.onload = toggleDateFin;
    </script>
</body>
</html>
