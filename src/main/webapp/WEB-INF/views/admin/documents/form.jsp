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
        .file-info { background: #f8f9fa; padding: 10px; border-radius: 5px; margin-top: 10px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>${titre}</h1>
        
        <form action="<c:url value='/admin/documents/enregistrer'/>" method="post" enctype="multipart/form-data">
            <input type="hidden" name="id_document" value="${document.id_document}">
            
            <div class="form-group">
                <label for="personnel">Employé *</label>
                <select name="personnel.id_personnel" id="personnel" required>
                    <option value="">-- Sélectionner un employé --</option>
                    <c:forEach items="${personnels}" var="pers">
                        <option value="${pers.id_personnel}" ${document.personnel.id_personnel == pers.id_personnel ? 'selected' : ''}>
                            ${pers.candidat.nom} ${pers.candidat.prenom} - ${pers.poste.libelle}
                        </option>
                    </c:forEach>
                </select>
            </div>

            <div class="form-group">
                <label for="typeDocument">Type de Document *</label>
                <select name="typeDocument.id_type_document" id="typeDocument" required>
                    <option value="">-- Sélectionner un type --</option>
                    <c:forEach items="${typesDocument}" var="type">
                        <option value="${type.id_type_document}" ${document.typeDocument.id_type_document == type.id_type_document ? 'selected' : ''}>
                            ${type.libelle}
                        </option>
                    </c:forEach>
                </select>
            </div>

            <div class="form-group">
                <label for="fichier">Fichier ${empty document.id_document ? '*' : ''}</label>
                <input type="file" name="fichier" id="fichier" ${empty document.id_document ? 'required' : ''}>
                <c:if test="${not empty document.nom_fichier}">
                    <div class="file-info">
                        <strong>Fichier actuel:</strong> ${document.nom_fichier}
                        <br><small>Téléverser un nouveau fichier pour le remplacer</small>
                    </div>
                </c:if>
            </div>

            <div class="form-group">
                <label for="numero_document">Numéro du Document</label>
                <input type="text" name="numero_document" id="numero_document" 
                       value="${document.numero_document}"
                       placeholder="Ex: CIN 101234567890">
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="date_delivrance">Date de Délivrance</label>
                    <input type="date" name="date_delivrance" id="date_delivrance"
                           value="<fmt:formatDate value='${document.date_delivrance}' pattern='yyyy-MM-dd'/>">
                </div>

                <div class="form-group">
                    <label for="date_expiration">Date d'Expiration</label>
                    <input type="date" name="date_expiration" id="date_expiration"
                           value="<fmt:formatDate value='${document.date_expiration}' pattern='yyyy-MM-dd'/>">
                </div>
            </div>

            <div class="form-group">
                <label for="remarques">Remarques</label>
                <textarea name="remarques" id="remarques">${document.remarques}</textarea>
            </div>

            <div class="form-group">
                <button type="submit" class="btn btn-primary">Enregistrer</button>
                <a href="<c:url value='/admin/documents'/>" class="btn btn-secondary">Annuler</a>
            </div>
        </form>
    </div>
</body>
</html>
