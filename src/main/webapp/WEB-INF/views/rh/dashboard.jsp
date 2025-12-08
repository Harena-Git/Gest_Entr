<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<c:set var="pageTitle" value="Tableau de bord RH" />
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.Locale" %>

<%
    LocalDate aujourdhuiLocal = LocalDate.now();
    DateTimeFormatter formatterDate = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    DateTimeFormatter formatterJour = DateTimeFormatter.ofPattern("EEEE", Locale.FRENCH);
    DateTimeFormatter formatterDateLong = DateTimeFormatter.ofPattern("EEEE dd MMMM yyyy", Locale.FRENCH);
    
    pageContext.setAttribute("aujourdhuiFormatted", aujourdhuiLocal.format(formatterDateLong));
%>
<%@ include file="/WEB-INF/views/layout/header.jsp" %>

<div class="main-container">
    <c:if test="${not empty success}">
        <div class="alert alert-success">✅ ${success}</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-error">❌ ${error}</div>
    </c:if>
    
    <!-- Statistiques globales -->
    <div class="stats-grid">
        <div class="stat-card">
            <div class="stat-icon">📊</div>
            <div class="stat-number">${stats.nombrePresences}</div>
            <div class="stat-label">Présences du jour</div>
        </div>
        
        <div class="stat-card">
            <div class="stat-icon">⚠️</div>
            <div class="stat-number">${stats.presencesEnAttenteChef}</div>
            <div class="stat-label">En attente chef</div>
        </div>
        
        <div class="stat-card">
            <div class="stat-icon">⏳</div>
            <div class="stat-number">${stats.presencesEnAttenteRh}</div>
            <div class="stat-label">En attente RH</div>
        </div>
        
        <div class="stat-card">
            <div class="stat-icon">📄</div>
            <div class="stat-number">${stats.justificationsAbsenceEnAttente + stats.justificationsRetardEnAttente}</div>
            <div class="stat-label">Justifications en attente</div>
        </div>
    </div>
    
    <!-- Validations en attente -->
    <div class="card">
        <div class="card-header">
            <h2 class="card-title">✅ Validations en attente</h2>
            <div class="card-badge" style="background: #dc3545; color: white; padding: 8px 16px; border-radius: 20px; font-size: 0.9em;">
                ${validationsEnAttente.size()} en attente
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
            
            <div style="text-align: center; margin-top: 20px;">
                <a href="${pageContext.request.contextPath}/rh/validations" class="btn btn-primary" style="padding: 12px 24px;">
                    📋 Voir toutes les validations
                </a>
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
    
    <!-- Justifications en attente de validation chef -->
    <div class="card">
        <div class="card-header">
            <h2 class="card-title">📋 Justifications en attente de validation chef</h2>
            <div class="card-badge" style="background: #ffc107; color: #212529; padding: 8px 16px; border-radius: 20px; font-size: 0.9em;">
                ${justifsAbsenceEnAttente.size() + justifsRetardEnAttente.size()} total
            </div>
        </div>
        
        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 30px;">
            <!-- Absences -->
            <div>
                <h3 style="margin-bottom: 15px; color: #495057;">Absences (${justifsAbsenceEnAttente.size()})</h3>
                <c:if test="${not empty justifsAbsenceEnAttente}">
                    <div style="max-height: 300px; overflow-y: auto;">
                        <c:forEach var="justif" items="${justifsAbsenceEnAttente}" varStatus="status">
                            <div style="padding: 15px; border-bottom: 1px solid #e9ecef; background: ${status.index % 2 == 0 ? '#f8f9fa' : 'white'};">
                                <strong>${justif.personnel.candidat.nom} ${justif.personnel.candidat.prenom}</strong><br>
                                <%
                                    JustificationAbsence justif = (JustificationAbsence) pageContext.getAttribute("justif");
                                    if (justif != null && justif.getDateAbsence() != null) {
                                        LocalDate dateAbsence = justif.getDateAbsence();
                                        out.print(dateAbsence.format(formatterDate));
                                    }
                                %>
                                <br/>
                                <small style="color: #6c757d; font-size: 12px;">
                                    <%
                                        if (justif != null && justif.getDateAbsence() != null) {
                                            LocalDate dateAbsence = justif.getDateAbsence();
                                            out.print(dateAbsence.format(formatterJour));
                                        }
                                    %>
                                </small><br>
                                <small>Département : ${justif.personnel.poste.departement.departement}</small>
                                <c:if test="${not empty justif.fichierJustification}">
                                    <div style="margin-top: 8px;">
                                        <a href="${pageContext.request.contextPath}/static/${justif.fichierJustification}" 
                                           target="_blank" 
                                           class="btn btn-primary" style="padding: 6px 12px; font-size: 0.85em;">
                                            📄 Voir justificatif
                                        </a>
                                    </div>
                                </c:if>
                            </div>
                        </c:forEach>
                    </div>
                </c:if>
                <c:if test="${empty justifsAbsenceEnAttente}">
                    <div style="text-align: center; padding: 40px; color: #6c757d;">
                        ✅ Aucune absence en attente
                    </div>
                </c:if>
            </div>
            
            <!-- Retards -->
            <div>
                <h3 style="margin-bottom: 15px; color: #495057;">Retards (${justifsRetardEnAttente.size()})</h3>
                <c:if test="${not empty justifsRetardEnAttente}">
                    <div style="max-height: 300px; overflow-y: auto;">
                        <c:forEach var="justif" items="${justifsRetardEnAttente}" varStatus="status">
                            <div style="padding: 15px; border-bottom: 1px solid #e9ecef; background: ${status.index % 2 == 0 ? '#f8f9fa' : 'white'};">
                                <strong>${justif.personnel.candidat.nom} ${justif.personnel.candidat.prenom}</strong><br>
                                <%
                                    JustificationAbsence justif = (JustificationAbsence) pageContext.getAttribute("justif");
                                    if (justif != null && justif.getDateAbsence() != null) {
                                        LocalDate dateAbsence = justif.getDateAbsence();
                                        out.print(dateAbsence.format(formatterDate));
                                    }
                                %>
                                <br/>
                                <small style="color: #6c757d; font-size: 12px;">
                                    <%
                                        if (justif != null && justif.getDateAbsence() != null) {
                                            LocalDate dateAbsence = justif.getDateAbsence();
                                            out.print(dateAbsence.format(formatterJour));
                                        }
                                    %>
                                </small><br>
                                <small>Retard : ${justif.minutesRetard} minutes</small><br>
                                <small>Département : ${justif.personnel.poste.departement.departement}</small>
                            </div>
                        </c:forEach>
                    </div>
                </c:if>
                <c:if test="${empty justifsRetardEnAttente}">
                    <div style="text-align: center; padding: 40px; color: #6c757d;">
                        ⏰ Aucun retard en attente
                    </div>
                </c:if>
            </div>
        </div>
    </div>
    
    <!-- Navigation rapide -->
    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; margin-top: 30px;">
        <a href="${pageContext.request.contextPath}/rh/validations" class="btn btn-primary" style="padding: 14px 24px; text-align: center;">
            ✅ Gérer les validations
        </a>
        <a href="${pageContext.request.contextPath}/rh/releves" class="btn btn-success" style="padding: 14px 24px; text-align: center;">
            📊 Générer des relevés
        </a>
        <a href="${pageContext.request.contextPath}/rh/paie" class="btn btn-info" style="padding: 14px 24px; text-align: center;">
            💰 Intégration paie
        </a>
        <a href="${pageContext.request.contextPath}/rh/audit" class="btn btn-secondary" style="padding: 14px 24px; text-align: center;">
            📋 Audit & Rapports
        </a>
    </div>
</div>

<%@ include file="/WEB-INF/views/layout/footer.jsp" %>