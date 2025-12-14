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
</div>
