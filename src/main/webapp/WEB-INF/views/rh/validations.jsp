<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<c:set var="pageTitle" value="Validations RH" />
<%@ include file="/WEB-INF/views/layout/header.jsp" %>

<div class="main-container">
    <c:if test="${not empty success}">
        <div class="alert alert-success">✅ ${success}</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-error">❌ ${error}</div>
    </c:if>
    
    <div class="card">
        <div class="card-header">
            <h2 class="card-title">✅ Validations en attente</h2>
            <div class="card-badge" style="background: #dc3545; color: white; padding: 8px 16px; border-radius: 20px; font-size: 0.9em;">
                ${validationsEnAttente.size()} décisions à valider
            </div>
        </div>
        
        <c:if test="${not empty validationsEnAttente}">
            <div class="table-container">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Personnel</th>
                            <th>Type</th>
                            <th>Date</th>
                            <th>Décision Chef</th>
                            <th>Justificatif</th>
                            <th>Actions RH</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="validation" items="${validationsEnAttente}" varStatus="status">
                            <tr>
                                <td>
                                    <strong>
                                        <c:choose>
                                            <c:when test="${validation.justificationAbsence != null}">
                                                ${validation.justificationAbsence.personnel.candidat.nom} ${validation.justificationAbsence.personnel.candidat.prenom}
                                            </c:when>
                                            <c:when test="${validation.justificationRetard != null}">
                                                ${validation.justificationRetard.personnel.candidat.nom} ${validation.justificationRetard.personnel.candidat.prenom}
                                            </c:when>
                                            <c:otherwise>
                                                ${validation.presenceAbsence.personnel.candidat.nom}
                                            </c:otherwise>
                                        </c:choose>
                                    </strong>
                                    <br>
                                    <small>
                                        <c:choose>
                                            <c:when test="${validation.justificationAbsence != null}">
                                                ${validation.justificationAbsence.personnel.poste.departement.departement}
                                            </c:when>
                                            <c:when test="${validation.justificationRetard != null}">
                                                ${validation.justificationRetard.personnel.poste.departement.departement}
                                            </c:when>
                                            <c:otherwise>
                                                Département ${validation.user.departement.departement}
                                            </c:otherwise>
                                        </c:choose>
                                    </small>
                                </td>
                                <td>
                                    <span class="status ${validation.justificationAbsence != null ? 'status-absent' : validation.justificationRetard != null ? 'status-pending' : 'status-present'}">
                                        <c:choose>
                                            <c:when test="${validation.justificationAbsence != null}">📄 Absence</c:when>
                                            <c:when test="${validation.justificationRetard != null}">⏰ Retard</c:when>
                                            <c:otherwise>📍 Présence</c:otherwise>
                                        </c:choose>
                                    </span>
                                </td>
                                <td>
                                    <fmt:parseDate value="${validation.dateValidation}" pattern="yyyy-MM-dd" var="parsedDate" type="date" />
                                    <fmt:formatDate value="${parsedDate}" pattern="dd/MM/yyyy" />
                                </td>
                                <td>
                                    <span class="status ${validation.decisionValidation.libelle == 'accepté' ? 'status-present' : 'status-absent'}">
                                        ${validation.decisionValidation.libelle}
                                    </span>
                                    <br>
                                    <small>Par ${validation.user.nom}</small>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${validation.justificationAbsence != null && not empty validation.justificationAbsence.fichierJustification}">
                                            <a href="${pageContext.request.contextPath}/static/${validation.justificationAbsence.fichierJustification}" 
                                               target="_blank" 
                                               class="btn btn-primary" style="padding: 6px 12px; font-size: 0.85em;">
                                                📄 Voir
                                            </a>
                                        </c:when>
                                        <c:when test="${validation.justificationRetard != null && not empty validation.justificationRetard.fichierJustification}">
                                            <a href="${pageContext.request.contextPath}/static/${validation.justificationRetard.fichierJustification}" 
                                               target="_blank" 
                                               class="btn btn-primary" style="padding: 6px 12px; font-size: 0.85em;">
                                                📄 Voir
                                            </a>
                                        </c:when>
                                        <c:otherwise>-</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <div style="display: flex; gap: 8px; flex-wrap: wrap;">
                                        <form action="${pageContext.request.contextPath}/rh/valider-presence" method="post" style="display: inline;">
                                            <input type="hidden" name="idValidationChef" value="${validation.idValidationAbsChef}" />
                                            <button type="submit" name="decision" value="accepté" 
                                                    class="btn btn-success" style="padding: 8px 16px; min-width: 90px;">
                                                ✅ Confirmer
                                            </button>
                                            <button type="submit" name="decision" value="refusé" 
                                                    class="btn btn-danger" style="padding: 8px 16px; min-width: 90px;">
                                                ❌ Rejeter
                                            </button>
                                        </form>
                                        <button class="btn btn-primary" style="padding: 8px 16px; min-width: 90px;"
                                                onclick="showDetails(${validation.idValidationAbsChef})">
                                            🔍 Détails
                                        </button>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:if>
        
        <c:if test="${empty validationsEnAttente}">
            <div style="text-align: center; padding: 60px;">
                <div style="font-size: 3em; margin-bottom: 20px; color: #28a745;">✅</div>
                <h3 style="color: #495057; margin-bottom: 15px;">Aucune validation en attente</h3>
                <p style="color: #6c757d; max-width: 500px; margin: 0 auto;">
                    Toutes les décisions des chefs ont été traitées par les RH.
                </p>
            </div>
        </c:if>
    </div>
    
    <!-- Statistiques de validation -->
    <div class="stats-grid">
        <div class="stat-card">
            <div class="stat-icon">📊</div>
            <div class="stat-number">${validationsEnAttente.size()}</div>
            <div class="stat-label">En attente</div>
        </div>
        
        <div class="stat-card">
            <div class="stat-icon">✅</div>
            <div class="stat-number">${statsRh.nombreValidations}</div>
            <div class="stat-label">Validées aujourd'hui</div>
        </div>
        
        <div class="stat-card">
            <div class="stat-icon">⏱️</div>
            <div class="stat-number">${statsRh.validationsAcceptees}</div>
            <div class="stat-label">Acceptées ce mois</div>
        </div>
        
        <div class="stat-card">
            <div class="stat-icon">⚠️</div>
            <div class="stat-number">${statsRh.validationsRefusees}</div>
            <div class="stat-label">Refusées ce mois</div>
        </div>
    </div>
    
    <!-- Filtres -->
    <div class="card">
        <div class="card-header">
            <h2 class="card-title">🔍 Filtres de recherche</h2>
        </div>
        
        <form action="${pageContext.request.contextPath}/rh/validations" method="get" 
              style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px;">
            <div class="form-group">
                <label for="filterType">Type</label>
                <select id="filterType" name="type" style="width: 100%; padding: 10px; border: 1px solid #dee2e6; border-radius: 4px;">
                    <option value="">Tous</option>
                    <option value="absence" ${param.type == 'absence' ? 'selected' : ''}>Absence</option>
                    <option value="retard" ${param.type == 'retard' ? 'selected' : ''}>Retard</option>
                    <option value="presence" ${param.type == 'presence' ? 'selected' : ''}>Présence</option>
                </select>
            </div>
            
            <div class="form-group">
                <label for="filterDepartement">Département</label>
                <select id="filterDepartement" name="departement" style="width: 100%; padding: 10px; border: 1px solid #dee2e6; border-radius: 4px;">
                    <option value="">Tous</option>
                    <c:forEach var="dept" items="${departements}">
                        <option value="${dept.id_departement}" ${param.departement == dept.id_departement ? 'selected' : ''}>
                            ${dept.departement}
                        </option>
                    </c:forEach>
                </select>
            </div>
            
            <div class="form-group">
                <label for="filterDateDebut">Date début</label>
                <input type="date" id="filterDateDebut" name="dateDebut" 
                       value="${param.dateDebut}" style="width: 100%; padding: 10px; border: 1px solid #dee2e6; border-radius: 4px;" />
            </div>
            
            <div class="form-group">
                <label for="filterDateFin">Date fin</label>
                <input type="date" id="filterDateFin" name="dateFin" 
                       value="${param.dateFin}" style="width: 100%; padding: 10px; border: 1px solid #dee2e6; border-radius: 4px;" />
            </div>
            
            <div class="form-group" style="align-self: end;">
                <button type="submit" class="btn btn-primary" style="width: 100%; padding: 12px 20px;">
                    🔍 Appliquer les filtres
                </button>
            </div>
        </form>
    </div>
</div>

<script>
function showDetails(validationId) {
    fetch('${pageContext.request.contextPath}/rh/validation-details?id=' + validationId)
        .then(response => response.json())
        .then(data => {
            const modalHtml = `
                <div style="position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: rgba(0,0,0,0.5); display: flex; align-items: center; justify-content: center; z-index: 2000;">
                    <div style="background: white; padding: 30px; border-radius: 12px; max-width: 600px; width: 90%; max-height: 80vh; overflow-y: auto;">
                        <h3 style="margin-bottom: 20px; color: #495057;">🔍 Détails de la validation</h3>
                        
                        <div style="margin-bottom: 20px;">
                            <p><strong>Personnel :</strong> \${data.personnelNom}</p>
                            <p><strong>Département :</strong> \${data.departement}</p>
                            <p><strong>Type :</strong> \${data.type}</p>
                            <p><strong>Date de l'événement :</strong> \${data.dateEvenement}</p>
                            <p><strong>Décision chef :</strong> \${data.decisionChef}</p>
                            <p><strong>Validateur chef :</strong> \${data.validateurChef}</p>
                            <p><strong>Date validation chef :</strong> \${data.dateValidationChef}</p>
                        </div>
                        
                        <div style="background: #f8f9fa; padding: 20px; border-radius: 8px; margin: 20px 0;">
                            <h4 style="margin-bottom: 10px; color: #495057;">📝 Décision RH</h4>
                            <form action="${pageContext.request.contextPath}/rh/valider-presence" method="post">
                                <input type="hidden" name="idValidationChef" value="\${validationId}" />
                                <div style="display: flex; gap: 10px; margin-bottom: 15px;">
                                    <button type="submit" name="decision" value="accepté" 
                                            class="btn btn-success" style="flex: 1; padding: 10px;">
                                        ✅ Confirmer la décision
                                    </button>
                                    <button type="submit" name="decision" value="refusé" 
                                            class="btn btn-danger" style="flex: 1; padding: 10px;">
                                        ❌ Rejeter la décision
                                    </button>
                                </div>
                                <textarea name="commentaire" placeholder="Commentaire (optionnel)" 
                                          style="width: 100%; padding: 10px; border: 1px solid #dee2e6; border-radius: 4px; margin-bottom: 10px;"></textarea>
                            </form>
                        </div>
                        
                        <div style="text-align: center; margin-top: 25px;">
                            <button onclick="this.parentElement.parentElement.parentElement.remove()" 
                                    class="btn btn-primary" style="padding: 10px 25px;">
                                Fermer
                            </button>
                        </div>
                    </div>
                </div>
            `;
            
            document.body.insertAdjacentHTML('beforeend', modalHtml);
        })
        .catch(error => {
            console.error('Erreur:', error);
            alert('Impossible de charger les détails');
        });
}
</script>

<%@ include file="/WEB-INF/views/layout/footer.jsp" %>