<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Détails demande - RH</title>
    <link rel="stylesheet" href="/css/style.css" />
</head>
<body>
<div class="container">
    <h2>Détails de la demande de congé</h2>
    
    <div class="card">
        <div class="card-body">
            <h5 class="card-title">Demande #${demande.id_demande_conge}</h5>
            
            <div class="row">
                <div class="col-md-6">
                    <p><strong>Demandeur :</strong></p>
                    <p><strong>Période :</strong></p>
                    <p><strong>Durée :</strong></p>
                    <p><strong>Motif :</strong></p>
                    <p><strong>Statut :</strong></p>
                </div>
                <div class="col-md-6">
                    <p>${demande.personnel.candidat.prenom} ${demande.personnel.candidat.nom}</p>
                    <p>
                        <fmt:formatDate value="${demande.date_debut}" pattern="dd/MM/yyyy"/>
                         au 
                        <fmt:formatDate value="${demande.date_fin}" pattern="dd/MM/yyyy"/>
                    </p>
                    <p>${demande.nombre_jours} jours</p>
                    <p>${demande.motif}</p>
                    <p><span class="badge bg-warning">${demande.statutDemande.libelle}</span></p>
                </div>
            </div>
            
            <%-- Section validation --%>
            <hr>
            <h5>Validation</h5>
            
            <c:if test="${not empty validationChef}">
                <div class="alert alert-info">
                    <p><strong>Validation du chef :</strong> ${validationChef.decisionValidation.libelle}</p>
                    <p><strong>Commentaire :</strong> ${validationChef.commentaire}</p>
                </div>
            </c:if>
            
            <%-- Formulaires d'action --%>
            <div class="row mt-4">
                <div class="col-md-6">
                    <div class="card border-success">
                        <div class="card-body">
                            <h5 class="card-title text-success">Approuver la demande</h5>
                            <form action="/rh/conge/approuver" method="post">
                                <input type="hidden" name="idDemande" value="${demande.id_demande_conge}" />
                                <div class="mb-3">
                                    <label for="commentaire" class="form-label">Commentaire (optionnel)</label>
                                    <textarea class="form-control" id="commentaire" name="commentaire" rows="2"></textarea>
                                </div>
                                <button type="submit" class="btn btn-success">Approuver</button>
                            </form>
                        </div>
                    </div>
                </div>
                
                <div class="col-md-6">
                    <div class="card border-danger">
                        <div class="card-body">
                            <h5 class="card-title text-danger">Rejeter la demande</h5>
                            <form action="/rh/conge/rejeter" method="post">
                                <input type="hidden" name="idDemande" value="${demande.id_demande_conge}" />
                                <div class="mb-3">
                                    <label for="commentaireRejet" class="form-label">Motif du rejet *</label>
                                    <textarea class="form-control" id="commentaireRejet" name="commentaire" rows="2" required></textarea>
                                </div>
                                <button type="submit" class="btn btn-danger">Rejeter</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="mt-3">
                <a href="/rh/conge/en-attente" class="btn btn-secondary">Retour à la liste</a>
            </div>
        </div>
    </div>
</div>
</body>
</html>