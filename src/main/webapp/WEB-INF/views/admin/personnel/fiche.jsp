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
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: #f5f5f5; }
        .container { max-width: 1400px; margin: 20px auto; padding: 20px; }
        .header { background: white; padding: 30px; border-radius: 10px; margin-bottom: 20px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .header h1 { color: #333; margin-bottom: 10px; }
        .btn { padding: 10px 20px; border: none; border-radius: 5px; cursor: pointer; text-decoration: none; display: inline-block; margin-right: 10px; }
        .btn-secondary { background: #6c757d; color: white; }
        .btn-primary { background: #007bff; color: white; }
        
        .employee-info { display: grid; grid-template-columns: 250px 1fr; gap: 30px; background: white; padding: 30px; border-radius: 10px; margin-bottom: 20px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .employee-photo { text-align: center; }
        .employee-photo img { width: 200px; height: 200px; border-radius: 50%; object-fit: cover; border: 5px solid #007bff; }
        .employee-photo .status { margin-top: 10px; padding: 10px; background: #28a745; color: white; border-radius: 5px; font-weight: bold; }
        .employee-details { }
        .detail-row { display: grid; grid-template-columns: 200px 1fr; padding: 12px 0; border-bottom: 1px solid #eee; }
        .detail-label { font-weight: 600; color: #666; }
        .detail-value { color: #333; }
        
        .section { background: white; padding: 30px; border-radius: 10px; margin-bottom: 20px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .section-title { font-size: 1.5em; color: #333; margin-bottom: 20px; padding-bottom: 10px; border-bottom: 3px solid #007bff; }
        
        table { width: 100%; border-collapse: collapse; margin-top: 15px; }
        table th, table td { padding: 12px; text-align: left; border: 1px solid #ddd; }
        table th { background: #f8f9fa; font-weight: 600; }
        table tr:hover { background: #f8f9fa; }
        
        .badge { padding: 5px 10px; border-radius: 3px; font-size: 0.85em; display: inline-block; }
        .badge-success { background: #28a745; color: white; }
        .badge-warning { background: #ffc107; color: #000; }
        .badge-info { background: #17a2b8; color: white; }
        .badge-secondary { background: #6c757d; color: white; }
        
        .timeline { position: relative; padding-left: 30px; }
        .timeline-item { position: relative; padding-bottom: 30px; }
        .timeline-item::before { content: ''; position: absolute; left: -22px; top: 0; width: 12px; height: 12px; border-radius: 50%; background: #007bff; }
        .timeline-item::after { content: ''; position: absolute; left: -17px; top: 12px; width: 2px; height: calc(100% - 12px); background: #ddd; }
        .timeline-item:last-child::after { display: none; }
        .timeline-content { background: #f8f9fa; padding: 15px; border-radius: 5px; border-left: 3px solid #007bff; }
        .timeline-date { font-weight: 600; color: #007bff; margin-bottom: 5px; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>📋 ${titre}</h1>
            <a href="<c:url value='/admin/dashboard'/>" class="btn btn-secondary">← Retour Dashboard</a>
            <a href="<c:url value='/personnel/list'/>" class="btn btn-secondary">Liste Personnel</a>
        </div>

        <!-- SECTION 1 : Informations Personnelles -->
        <div class="employee-info">
            <div class="employee-photo">
                <c:choose>
                    <c:when test="${not empty personnel.candidat.photo}">
                        <img src="${personnel.candidat.photo}" alt="Photo">
                    </c:when>
                    <c:otherwise>
                        <img src="https://via.placeholder.com/200?text=Photo" alt="Photo par défaut">
                    </c:otherwise>
                </c:choose>
                <div class="status">
                    ${personnel.actif ? '✓ ACTIF' : '✗ INACTIF'}
                </div>
            </div>
            
            <div class="employee-details">
                <h2 style="margin-bottom: 20px; color: #007bff;">${personnel.candidat.nom} ${personnel.candidat.prenom}</h2>
                
                <div class="detail-row">
                    <div class="detail-label">Genre:</div>
                    <div class="detail-value">${personnel.candidat.genre}</div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">Date de naissance:</div>
                    <div class="detail-value"><fmt:formatDate value="${personnel.candidat.date_naissance}" pattern="dd/MM/yyyy"/></div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">Téléphone:</div>
                    <div class="detail-value">${personnel.candidat.telephone}</div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">Email:</div>
                    <div class="detail-value">${personnel.candidat.email}</div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">Adresse:</div>
                    <div class="detail-value">${personnel.candidat.adresse}</div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">Poste actuel:</div>
                    <div class="detail-value"><strong>${personnel.poste.libelle}</strong></div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">Département:</div>
                    <div class="detail-value">${personnel.poste.departement.departement}</div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">Date d'embauche:</div>
                    <div class="detail-value"><fmt:formatDate value="${personnel.date_embauche}" pattern="dd/MM/yyyy"/></div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">Expérience:</div>
                    <div class="detail-value">${personnel.candidat.annee_experience} ans</div>
                </div>
            </div>
        </div>

        <!-- SECTION 2 : Contrats de Travail -->
        <div class="section">
            <h3 class="section-title">📝 Contrats de Travail</h3>
            <table>
                <thead>
                    <tr>
                        <th>Type</th>
                        <th>Début</th>
                        <th>Fin</th>
                        <th>Durée</th>
                        <th>Statut</th>
                        <th>Remarques</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${contrats}" var="contrat">
                        <tr>
                            <td>
                                <c:choose>
                                    <c:when test="${contrat.typeContrat.libelle == 'CDI'}">
                                        <span class="badge badge-success">${contrat.typeContrat.libelle}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-warning">${contrat.typeContrat.libelle}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td><fmt:formatDate value="${contrat.date_debut}" pattern="dd/MM/yyyy"/></td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty contrat.date_fin}">
                                        <fmt:formatDate value="${contrat.date_fin}" pattern="dd/MM/yyyy"/>
                                    </c:when>
                                    <c:otherwise>-</c:otherwise>
                                </c:choose>
                            </td>
                            <td>${contrat.duree_mois != null ? contrat.duree_mois : '-'} mois</td>
                            <td><span class="badge ${contrat.statut == 'Actif' ? 'badge-success' : 'badge-secondary'}">${contrat.statut}</span></td>
                            <td>${contrat.remarques}</td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty contrats}">
                        <tr><td colspan="6" style="text-align: center; color: #999;">Aucun contrat enregistré</td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>

        <!-- SECTION 3 : Historique Carrière -->
        <div class="section">
            <h3 class="section-title">📈 Historique des Postes et Promotions</h3>
            <div class="timeline">
                <c:forEach items="${historique}" var="hist">
                    <div class="timeline-item">
                        <div class="timeline-content">
                            <div class="timeline-date">
                                <fmt:formatDate value="${hist.date_debut}" pattern="dd/MM/yyyy"/> 
                                - 
                                <c:choose>
                                    <c:when test="${not empty hist.date_fin}">
                                        <fmt:formatDate value="${hist.date_fin}" pattern="dd/MM/yyyy"/>
                                    </c:when>
                                    <c:otherwise>Aujourd'hui</c:otherwise>
                                </c:choose>
                            </div>
                            <h4>${hist.poste.libelle} - ${hist.poste.departement.departement}</h4>
                            <p>
                                <strong>Type:</strong> 
                                <c:choose>
                                    <c:when test="${hist.type_mouvement == 'Promotion'}">
                                        <span class="badge badge-success">${hist.type_mouvement}</span>
                                    </c:when>
                                    <c:when test="${hist.type_mouvement == 'Mutation'}">
                                        <span class="badge badge-info">${hist.type_mouvement}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-secondary">${hist.type_mouvement}</span>
                                    </c:otherwise>
                                </c:choose>
                            </p>
                            <c:if test="${not empty hist.salaire}">
                                <p><strong>Salaire:</strong> <fmt:formatNumber value="${hist.salaire}" type="currency" currencySymbol="Ar"/></p>
                            </c:if>
                            <c:if test="${not empty hist.motif}">
                                <p><strong>Motif:</strong> ${hist.motif}</p>
                            </c:if>
                        </div>
                    </div>
                </c:forEach>
                <c:if test="${empty historique}">
                    <p style="color: #999;">Aucun historique disponible</p>
                </c:if>
            </div>
        </div>

        <!-- SECTION 4 : Documents RH -->
        <div class="section">
            <h3 class="section-title">📂 Documents RH</h3>
            <table>
                <thead>
                    <tr>
                        <th>Type</th>
                        <th>Nom Fichier</th>
                        <th>N° Document</th>
                        <th>Date Upload</th>
                        <th>Expiration</th>
                        <th>Remarques</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${documents}" var="doc">
                        <tr>
                            <td><span class="badge badge-info">${doc.typeDocument.libelle}</span></td>
                            <td>${doc.nom_fichier}</td>
                            <td>${doc.numero_document != null ? doc.numero_document : '-'}</td>
                            <td><fmt:formatDate value="${doc.date_upload}" pattern="dd/MM/yyyy"/></td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty doc.date_expiration}">
                                        <fmt:formatDate value="${doc.date_expiration}" pattern="dd/MM/yyyy"/>
                                    </c:when>
                                    <c:otherwise>-</c:otherwise>
                                </c:choose>
                            </td>
                            <td>${doc.remarques}</td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty documents}">
                        <tr><td colspan="6" style="text-align: center; color: #999;">Aucun document enregistré</td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
