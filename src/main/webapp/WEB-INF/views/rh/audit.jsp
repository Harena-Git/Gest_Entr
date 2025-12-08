<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<c:set var="pageTitle" value="Audit & Rapports" />
<%@ include file="/WEB-INF/views/layout/header.jsp" %>

<div class="main-container">
    <!-- Validations contradictoires -->
    <c:if test="${not empty validationsContradictoires && validationsContradictoires.size() > 0}">
        <div class="card" style="border-left: 5px solid #dc3545;">
            <div class="card-header">
                <h2 class="card-title">⚠️ Validations contradictoires</h2>
                <div class="card-badge" style="background: #dc3545; color: white; padding: 8px 16px; border-radius: 20px; font-size: 0.9em;">
                    ${validationsContradictoires.size()} contradictions
                </div>
            </div>
            
            <div class="table-container">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Personnel</th>
                            <th>Type</th>
                            <th>Décision Chef</th>
                            <th>Décision RH</th>
                            <th>Date</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="validation" items="${validationsContradictoires}" varStatus="status">
                            <tr>
                                <td>
                                    <strong>
                                        <c:choose>
                                            <c:when test="${validation.validationAbsChef.justificationAbsence != null}">
                                                ${validation.validationAbsChef.justificationAbsence.personnel.candidat.nom}
                                            </c:when>
                                            <c:when test="${validation.validationAbsChef.justificationRetard != null}">
                                                ${validation.validationAbsChef.justificationRetard.personnel.candidat.nom}
                                            </c:when>
                                            <c:otherwise>
                                                ${validation.validationAbsChef.presenceAbsence.personnel.candidat.nom}
                                            </c:otherwise>
                                        </c:choose>
                                    </strong>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${validation.validationAbsChef.justificationAbsence != null}">Absence</c:when>
                                        <c:when test="${validation.validationAbsChef.justificationRetard != null}">Retard</c:when>
                                        <c:otherwise>Présence</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <span class="status ${validation.validationAbsChef.decisionValidation.libelle == 'accepté' ? 'status-present' : 'status-absent'}">
                                        ${validation.validationAbsChef.decisionValidation.libelle}
                                    </span>
                                </td>
                                <td>
                                    <span class="status ${validation.decisionValidation.libelle == 'accepté' ? 'status-present' : 'status-absent'}">
                                        ${validation.decisionValidation.libelle}
                                    </span>
                                </td>
                                <td>
                                    <fmt:parseDate value="${validation.dateValidation}" pattern="yyyy-MM-dd" var="parsedDateContra" type="date" />
                                    <fmt:formatDate value="${parsedDateContra}" pattern="dd/MM/yyyy" />
                                </td>
                                <td>
                                    <form action="${pageContext.request.contextPath}/rh/resoudre-contradiction" method="post" style="display: inline;">
                                        <input type="hidden" name="idValidationRh" value="${validation.idValidationAbsRh}" />
                                        <button type="submit" name="resolution" value="valider_chef" 
                                                class="btn btn-success" style="padding: 6px 12px; font-size: 0.85em;">
                                            ✅ Valider chef
                                        </button>
                                        <button type="submit" name="resolution" value="valider_rh" 
                                                class="btn btn-danger" style="padding: 6px 12px; font-size: 0.85em;">
                                            ❌ Valider RH
                                        </button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </c:if>
    
    <!-- Historique complet des validations -->
    <div class="card">
        <div class="card-header">
            <h2 class="card-title">📋 Historique des validations</h2>
            <div class="card-actions">
                <form action="${pageContext.request.contextPath}/rh/exporter-audit-excel" method="post">
                    <button type="submit" class="btn btn-primary" style="padding: 10px 20px;">
                        📥 Exporter l'audit (Excel)
                    </button>
                </form>
            </div>
        </div>
        
        <!-- Filtres -->
        <div style="padding: 20px; border-bottom: 1px solid #e9ecef;">
            <form action="${pageContext.request.contextPath}/rh/audit" method="get" 
                  style="display: grid; grid-template-columns: repeat(auto-fit, minmax(180px, 1fr)); gap: 15px;">
                <div class="form-group">
                    <label style="font-size: 0.9em;">Date début</label>
                    <input type="date" name="dateDebut" 
                           value="${param.dateDebut}" 
                           style="padding: 10px; font-size: 0.9em; border: 1px solid #dee2e6; border-radius: 4px;" />
                </div>
                
                <div class="form-group">
                    <label style="font-size: 0.9em;">Date fin</label>
                    <input type="date" name="dateFin" 
                           value="${param.dateFin}" 
                           style="padding: 10px; font-size: 0.9em; border: 1px solid #dee2e6; border-radius: 4px;" />
                </div>
                
                <div class="form-group">
                    <label style="font-size: 0.9em;">Type</label>
                    <select name="type" style="padding: 10px; font-size: 0.9em; border: 1px solid #dee2e6; border-radius: 4px;">
                        <option value="">Tous</option>
                        <option value="absence" ${param.type == 'absence' ? 'selected' : ''}>Absence</option>
                        <option value="retard" ${param.type == 'retard' ? 'selected' : ''}>Retard</option>
                        <option value="presence" ${param.type == 'presence' ? 'selected' : ''}>Présence</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label style="font-size: 0.9em;">Département</label>
                    <select name="departement" style="padding: 10px; font-size: 0.9em; border: 1px solid #dee2e6; border-radius: 4px;">
                        <option value="">Tous</option>
                        <c:forEach var="dept" items="${departements}">
                            <option value="${dept.id_departement}" ${param.departement == dept.id_departement ? 'selected' : ''}>
                                ${dept.departement}
                            </option>
                        </c:forEach>
                    </select>
                </div>
                
                <div class="form-group" style="align-self: end;">
                    <button type="submit" class="btn btn-primary" style="padding: 10px 20px; font-size: 0.9em;">
                        🔍 Filtrer
                    </button>
                </div>
            </form>
        </div>
        
        <!-- Tableau d'historique -->
        <div class="table-container">
            <table class="data-table">
                <thead>
                    <tr>
                        <th>Date</th>
                        <th>Personnel</th>
                        <th>Type</th>
                        <th>Décision Chef</th>
                        <th>Décision RH</th>
                        <th>Validationné par</th>
                        <th>Statut</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="validation" items="${historiqueValidations}" varStatus="status">
                        <tr>
                            <td>
                                <fmt:parseDate value="${validation.dateValidation}" pattern="yyyy-MM-dd" var="parsedDateHist" type="date" />
                                <fmt:formatDate value="${parsedDateHist}" pattern="dd/MM/yyyy" />
                                <br>
                                <small>
                                    <fmt:parseDate value="${validation.dateValidation}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedDateTimeHist" type="both" />
                                    <fmt:formatDate value="${parsedDateTimeHist}" pattern="HH:mm" />
                                </small>
                            </td>
                            <td>
                                <strong>
                                    <c:choose>
                                        <c:when test="${validation.validationAbsChef.justificationAbsence != null}">
                                            ${validation.validationAbsChef.justificationAbsence.personnel.candidat.nom}
                                        </c:when>
                                        <c:when test="${validation.validationAbsChef.justificationRetard != null}">
                                            ${validation.validationAbsChef.justificationRetard.personnel.candidat.nom}
                                        </c:when>
                                        <c:otherwise>
                                            ${validation.validationAbsChef.presenceAbsence.personnel.candidat.nom}
                                        </c:otherwise>
                                    </c:choose>
                                </strong>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${validation.validationAbsChef.justificationAbsence != null}">
                                        <span class="status status-absent" style="font-size: 0.85em; padding: 4px 8px;">
                                            📄 Absence
                                        </span>
                                    </c:when>
                                    <c:when test="${validation.validationAbsChef.justificationRetard != null}">
                                        <span class="status status-pending" style="font-size: 0.85em; padding: 4px 8px;">
                                            ⏰ Retard
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status status-present" style="font-size: 0.85em; padding: 4px 8px;">
                                            📍 Présence
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <span class="status ${validation.validationAbsChef.decisionValidation.libelle == 'accepté' ? 'status-present' : 'status-absent'}">
                                    ${validation.validationAbsChef.decisionValidation.libelle}
                                </span>
                                <br>
                                <small>${validation.validationAbsChef.user.nom}</small>
                                <br>
                                <small>
                                    <fmt:parseDate value="${validation.validationAbsChef.dateValidation}" pattern="yyyy-MM-dd" var="parsedDateChef" type="date" />
                                    <fmt:formatDate value="${parsedDateChef}" pattern="dd/MM HH:mm" />
                                </small>
                            </td>
                            <td>
                                <span class="status ${validation.decisionValidation.libelle == 'accepté' ? 'status-present' : 'status-absent'}">
                                    ${validation.decisionValidation.libelle}
                                </span>
                                <br>
                                <small>${validation.user.nom}</small>
                            </td>
                            <td>
                                <div style="display: flex; align-items: center; gap: 8px;">
                                    <span style="width: 32px; height: 32px; background: #e9ecef; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 0.8em;">
                                        👤
                                    </span>
                                    <div>
                                        <div style="font-weight: 500;">${validation.user.nom}</div>
                                        <div style="font-size: 0.8em; color: #6c757d;">RH</div>
                                    </div>
                                </div>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${validation.validationAbsChef.decisionValidation.libelle == validation.decisionValidation.libelle}">
                                        <span class="status status-present" style="font-size: 0.85em; padding: 4px 8px;">
                                            ✅ Concordant
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status status-absent" style="font-size: 0.85em; padding: 4px 8px;">
                                            ⚠️ Contradiction
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty historiqueValidations}">
                        <tr>
                            <td colspan="7" style="text-align: center; padding: 60px;">
                                <div style="font-size: 3em; margin-bottom: 20px; color: #6c757d;">📊</div>
                                <h3 style="color: #495057; margin-bottom: 15px;">Aucun historique de validation</h3>
                                <p style="color: #6c757d; max-width: 500px; margin: 0 auto;">
                                    L'historique des validations apparaîtra ici après les premières opérations.
                                </p>
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
        
        <!-- Pagination -->
        <c:if test="${totalPages > 1}">
            <div style="padding: 20px; border-top: 1px solid #e9ecef; display: flex; justify-content: space-between; align-items: center;">
                <div style="color: #6c757d; font-size: 0.9em;">
                    Affichage ${(page-1)*size+1}-${Math.min(page*size, totalElements)} sur ${totalElements} validations
                </div>
                <div style="display: flex; gap: 5px;">
                    <c:if test="${page > 1}">
                        <a href="${pageContext.request.contextPath}/rh/audit?page=${page-1}&dateDebut=${param.dateDebut}&dateFin=${param.dateFin}&type=${param.type}&departement=${param.departement}" 
                           class="btn btn-primary" style="padding: 8px 12px; text-decoration: none;">«</a>
                    </c:if>
                    
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <c:choose>
                            <c:when test="${i == page}">
                                <span class="btn btn-primary" style="padding: 8px 12px;">${i}</span>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/rh/audit?page=${i}&dateDebut=${param.dateDebut}&dateFin=${param.dateFin}&type=${param.type}&departement=${param.departement}" 
                                   class="btn" style="padding: 8px 12px; background: #e9ecef; text-decoration: none;">${i}</a>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                    
                    <c:if test="${page < totalPages}">
                        <a href="${pageContext.request.contextPath}/rh/audit?page=${page+1}&dateDebut=${param.dateDebut}&dateFin=${param.dateFin}&type=${param.type}&departement=${param.departement}" 
                           class="btn btn-primary" style="padding: 8px 12px; text-decoration: none;">»</a>
                    </c:if>
                </div>
            </div>
        </c:if>
    </div>
    
    <!-- Statistiques d'audit -->
    <div class="stats-grid">
        <div class="stat-card">
            <div class="stat-icon">📅</div>
            <div class="stat-number">${statsAudit.validationsAujourdhui}</div>
            <div class="stat-label">Validations aujourd'hui</div>
        </div>
        
        <div class="stat-card">
            <div class="stat-icon">✅</div>
            <div class="stat-number">${statsAudit.tauxConcordance}%</div>
            <div class="stat-label">Taux concordance</div>
        </div>
        
        <div class="stat-card">
            <div class="stat-icon">⏱️</div>
            <div class="stat-number">${statsAudit.tempsMoyenValidation}</div>
            <div class="stat-label">Heures moy. traitement</div>
        </div>
        
        <div class="stat-card">
            <div class="stat-icon">👥</div>
            <div class="stat-number">${statsAudit.chefsActifs}</div>
            <div class="stat-label">Chefs actifs</div>
        </div>
    </div>
    
    <!-- Logs d'audit système -->
    <div class="card">
        <div class="card-header">
            <h2 class="card-title">📝 Logs système récents</h2>
        </div>
        
        <div class="table-container">
            <table class="data-table">
                <thead>
                    <tr>
                        <th>Date/Heure</th>
                        <th>Action</th>
                        <th>Utilisateur</th>
                        <th>Table</th>
                        <th>Détails</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="log" items="${logsAudit}" varStatus="status">
                        <tr>
                            <td>
                                <fmt:parseDate value="${log.timestamp}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedTimestamp" type="both" />
                                <fmt:formatDate value="${parsedTimestamp}" pattern="dd/MM/yyyy HH:mm:ss" />
                            </td>
                            <td>
                                <span class="status ${log.action.contains('CREATE') ? 'status-present' : log.action.contains('DELETE') ? 'status-absent' : 'status-pending'}">
                                    ${log.action}
                                </span>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${log.userType == 'USER'}">
                                        User #${log.userId}
                                    </c:when>
                                    <c:when test="${log.userType == 'PERSONNEL'}">
                                        Personnel #${log.userId}
                                    </c:when>
                                    <c:otherwise>
                                        ${log.userType}
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>${log.tableName}</td>
                            <td style="max-width: 300px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                                ${log.details}
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty logsAudit}">
                        <tr>
                            <td colspan="5" style="text-align: center; padding: 40px; color: #6c757d;">
                                📝 Aucun log système récent
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
        
        <div style="text-align: center; padding: 20px;">
            <a href="${pageContext.request.contextPath}/rh/logs-complets" class="btn btn-primary" style="padding: 10px 20px;">
                📋 Voir tous les logs
            </a>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/views/layout/footer.jsp" %>