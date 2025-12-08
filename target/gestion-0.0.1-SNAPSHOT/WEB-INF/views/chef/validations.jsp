<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<c:set var="pageTitle" value="Validations en attente" />
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.time.temporal.ChronoUnit" %>
<%@ include file="/WEB-INF/views/layout/header.jsp" %>

<div class="main-container">
        <!-- Messages -->
        <c:if test="${not empty success}">
            <div class="alert alert-success">✅ ${success}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-error">❌ ${error}</div>
        </c:if>
        
        <div class="card">
            <div class="card-header">
                <h2 class="card-title">📋 Justifications à valider</h2>
                <div class="card-badge">
                    ${justifsAbsence.size() + justifsRetard.size()} en attente
                </div>
            </div>
            
            <!-- Filtres actifs -->
            <div class="filter-badges">
                <c:if test="${param.type == 'absence'}">
                    <span class="badge badge-primary">Filtre: Absences uniquement</span>
                </c:if>
                <c:if test="${param.type == 'retard'}">
                    <span class="badge badge-warning">Filtre: Retards uniquement</span>
                </c:if>
                <c:if test="${param.personnel != null}">
                    <span class="badge badge-info">Personnel ID: ${param.personnel}</span>
                </c:if>
            </div>
            
            <!-- Section Absences -->
            <div style="padding: 20px;">
                <h3 style="margin: 0 0 20px 0; color: #495057; font-size: 18px; border-bottom: 2px solid #007bff; padding-bottom: 10px;">
                    Absences (${justifsAbsence.size()})
                </h3>
                
                <c:choose>
                    <c:when test="${not empty justifsAbsence}">
                        <div class="table-container">
                            <table class="data-table">
                                <thead>
                                    <tr>
                                        <th>Personnel</th>
                                        <th>Date absence</th>
                                        <th>Date demande</th>
                                        <th>Justificatif</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="justif" items="${justifsAbsence}">
                                        <tr>
                                            <td>
                                                <strong>${justif.personnel.candidat.nom} ${justif.personnel.candidat.prenom}</strong><br>
                                                <small>${justif.personnel.poste.libelle}</small>
                                            </td>
                                            <td>
                                                <c:if test="${not empty dateAbsFormatted[justif.idJustificationAbsence]}">
                                                    ${dateAbsFormatted[justif.idJustificationAbsence]}<br>
                                                    <small>${dateAbsDay[justif.idJustificationAbsence]}</small>
                                                </c:if>
                                            </td>
                                            <td>
                                                <c:if test="${not empty dateDemFormatted[justif.idJustificationAbsence]}">
                                                    ${dateDemFormatted[justif.idJustificationAbsence]}
                                                </c:if>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty justif.fichierJustification}">
                                                        <a href="${pageContext.request.contextPath}/static/${justif.fichierJustification}" 
                                                           target="_blank" class="btn btn-primary" style="padding: 5px 12px; font-size: 13px;">
                                                            📄 Voir
                                                        </a>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span style="color: #dc3545; font-size: 13px;">⚠️ Aucun justificatif</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <form class="form-group" action="${pageContext.request.contextPath}/chef/valider-absence" method="post">
                                                    <input type="hidden" name="idJustification" value="${justif.idJustificationAbsence}" />
                                                    <input type="hidden" name="idPresence" value="${justif.personnel.id_personnel}" />
                                                    <button type="submit" name="decision" value="accepté" class="btn btn-success">
                                                        ✅ Accepter
                                                    </button>
                                                    <button type="submit" name="decision" value="refusé" class="btn btn-danger">
                                                        ❌ Refuser
                                                    </button>
                                                </form>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <div class="empty-state-icon">✅</div>
                            <h4>Aucune justification d'absence en attente</h4>
                            <p>Toutes les justifications d'absence de votre département ont été traitées.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
            
            <!-- Section Retards -->
            <div style="padding: 20px; border-top: 1px solid #dee2e6;">
                <h3 style="margin: 0 0 20px 0; color: #495057; font-size: 18px; border-bottom: 2px solid #dc3545; padding-bottom: 10px;">
                    Retards (${justifsRetard.size()})
                </h3>
                
                <c:choose>
                    <c:when test="${not empty justifsRetard}">
                        <div class="table-container">
                            <table class="data-table">
                                <thead>
                                    <tr>
                                        <th>Personnel</th>
                                        <th>Date retard</th>
                                        <th>Minutes</th>
                                        <th>Justificatif</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="justif" items="${justifsRetard}">
                                        <tr>
                                            <td>
                                                <strong>${justif.personnel.candidat.nom} ${justif.personnel.candidat.prenom}</strong><br>
                                                <small>${justif.personnel.poste.libelle}</small>
                                            </td>
                                            <td>
                                                <c:if test="${not empty dateRetFormatted[justif.idJustificationRetard]}">
                                                    ${dateRetFormatted[justif.idJustificationRetard]}<br>
                                                    <small>${dateRetDay[justif.idJustificationRetard]}</small>
                                                </c:if>
                                            </td>
                                            <td>
                                                <span class="badge ${justif.minutesRetard >= 30 ? 'badge-danger' : 'badge-warning'}">
                                                    ${justif.minutesRetard} min
                                                    <c:if test="${justif.minutesRetard >= 30}"> ⚠️</c:if>
                                                </span>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty justif.fichierJustification}">
                                                        <a href="${pageContext.request.contextPath}/static/${justif.fichierJustification}" 
                                                           target="_blank" class="btn btn-primary" style="padding: 5px 12px; font-size: 13px;">
                                                            📄 Voir
                                                        </a>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span style="color: #dc3545; font-size: 13px;">⚠️ Aucun justificatif</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <form class="form-group" action="${pageContext.request.contextPath}/chef/valider-retard" method="post">
                                                    <input type="hidden" name="idJustification" value="${justif.idJustificationRetard}" />
                                                    <input type="hidden" name="idPresence" value="${justif.personnel.id_personnel}" />
                                                    <button type="submit" name="decision" value="accepté" class="btn btn-success">
                                                        ✅ Accepter
                                                    </button>
                                                    <button type="submit" name="decision" value="refusé" class="btn btn-danger">
                                                        ❌ Refuser
                                                    </button>
                                                </form>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <div class="empty-state-icon">⏰</div>
                            <h4>Aucune justification de retard en attente</h4>
                            <p>Toutes les justifications de retard de votre département ont été traitées.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>