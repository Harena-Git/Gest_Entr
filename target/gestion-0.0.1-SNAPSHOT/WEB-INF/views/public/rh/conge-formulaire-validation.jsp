<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Validation d'une demande de congé - RH</title>
    <link rel="stylesheet" href="/css/styles.css" />
    <style>
        body { font-family: Arial, sans-serif; background-color: #f5f5f5; }
        .container { max-width: 700px; margin: 20px auto; background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        h2 { color: #333; margin-bottom: 20px; border-bottom: 3px solid #667eea; padding-bottom: 10px; }
        .info-box { background-color: #f0f8ff; color: #003366; padding: 15px; border-radius: 4px; margin-bottom: 20px; border-left: 4px solid #667eea; }
        .info-box h3 { margin: 0 0 10px 0; color: #003366; }
        .info-box p { margin: 5px 0; }
        .warning-box { background-color: #fff3cd; color: #856404; padding: 15px; border-radius: 4px; margin-bottom: 20px; border-left: 4px solid #ffc107; }
        .form-group { margin-bottom: 15px; }
        label { display: block; margin-bottom: 5px; color: #333; font-weight: bold; }
        textarea { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px; font-size: 14px; font-family: Arial, sans-serif; }
        textarea:focus { outline: none; border-color: #667eea; box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1); }
        .btn { padding: 10px 20px; background-color: #667eea; color: white; border: none; border-radius: 4px; cursor: pointer; font-weight: bold; margin-right: 10px; }
        .btn:hover { background-color: #5568d3; }
        .btn-danger { background-color: #dc3545; }
        .btn-danger:hover { background-color: #c82333; }
        .btn-secondary { background-color: #6c757d; color: white; text-decoration: none; display: inline-block; }
        .btn-secondary:hover { background-color: #5a6268; }
        .button-group { display: flex; gap: 10px; margin-top: 30px; }
        .badge { display: inline-block; padding: 4px 8px; border-radius: 4px; font-size: 12px; font-weight: bold; background-color: #fff3cd; color: #856404; }
    </style>
</head>
<body>
<div class="container">
    <h2>✓ Validation finale d'une demande de congé</h2>

    <div class="info-box">
        <h3>👤 Personnel demandeur</h3>
        <p><strong>Nom complet :</strong> ${personnel.candidat.prenom} ${personnel.candidat.nom}</p>
        <p><strong>Email :</strong> ${personnel.candidat.email}</p>
        <p><strong>Téléphone :</strong> ${personnel.candidat.telephone}</p>
        <p><strong>Date d'embauche :</strong> <fmt:formatDate value="${personnel.date_embauche}" pattern="dd/MM/yyyy"/></p>
        <p><strong>Statut :</strong> <span class="badge">${personnel.actif ? 'Actif' : 'Inactif'}</span></p>
        <c:if test="${personnel.candidat.date_naissance}">
            <p><strong>Date de naissance :</strong> <fmt:formatDate value="${personnel.candidat.date_naissance}" pattern="dd/MM/yyyy"/></p>
        </c:if>
    </div>

    <div class="info-box">
        <h3>🏢 Informations professionnelles</h3>
        <p><strong>Département :</strong> ${personnel.poste.departement.departement}</p>
        <p><strong>Poste :</strong> ${personnel.poste.libelle}</p>
        <p><strong>Salaire :</strong> ${personnel.poste.salaire} €</p>
        <c:if test="${personnel.candidat.annee_experience}">
            <p><strong>Années d'expérience :</strong> ${personnel.candidat.annee_experience}</p>
        </c:if>
        <c:if test="${personnel.candidat.adresse}">
            <p><strong>Adresse :</strong> ${personnel.candidat.adresse}</p>
        </c:if>
    </div>

    <div class="info-box">
        <h3>📅 Détails de la demande</h3>
        <p><strong>Date de demande :</strong> <fmt:formatDate value="${demande.date_demande}" pattern="dd/MM/yyyy à HH:mm"/></p>
        <p><strong>Date de début :</strong> <fmt:formatDate value="${demande.date_debut}" pattern="dd/MM/yyyy"/> (<strong>Jour :</strong> <fmt:formatDate value="${demande.date_debut}" pattern="EEEE"/>)</p>
        <p><strong>Date de fin :</strong> <fmt:formatDate value="${demande.date_fin}" pattern="dd/MM/yyyy"/> (<strong>Jour :</strong> <fmt:formatDate value="${demande.date_fin}" pattern="EEEE"/>)</p>
        <p><strong>Nombre de jours :</strong> <span class="badge">${demande.nombre_jours} jour(s)</span></p>
        <p><strong>Motif :</strong> ${demande.motif}</p>
        <p><strong>Statut actuel :</strong> <span class="badge">${demande.statutDemande.libelle}</span></p>
    </div>

    <div class="info-box">
        <h3>💰 Solde de congés</h3>
        <p><strong>Solde annuel :</strong> 25 jours</p>
        <p><strong>Solde actuel :</strong> <span style="color: #28a745; font-weight: bold;">${soldeRestant}</span> jours</p>
        <p><strong>Demandé :</strong> ${demande.nombre_jours} jour(s)</p>
        <p><strong>Après approbation :</strong> <span style="color: #007bff; font-weight: bold;">${soldeRestant - demande.nombre_jours}</span> jours</p>
    </div>

    <c:if test="${soldeRestant < demande.nombre_jours}">
        <div class="warning-box">
            ⚠️ <strong>Attention :</strong> Le solde du personnel est insuffisant pour cette demande !
        </div>
    </c:if>

    <form method="post">
        <div class="form-group">
            <label for="commentaire">Commentaire <small>(optionnel)</small></label>
            <textarea id="commentaire" name="commentaire" rows="4" placeholder="Ajoutez vos observations..."></textarea>
        </div>

        <input type="hidden" name="idDemande" value="${demande.id_demande_conge}" />
        <input type="hidden" name="idRH" value="${idRH}" />

        <div class="button-group">
            <button type="submit" formaction="/public/rh/conge/approuver" class="btn">✅ Approuver</button>
            <button type="submit" formaction="/public/rh/conge/rejeter" class="btn btn-danger">❌ Rejeter</button>
            <a href="/public/rh/conge/en-attente?idRH=${idRH}" class="btn btn-secondary">← Retour</a>
        </div>
    </form>
</div>
</body>
</html>
